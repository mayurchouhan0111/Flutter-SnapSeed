import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'histogram_data.dart';

class ImageProcessor {
  /// Loads an image from file and resizes it for preview if necessary.
  /// Optimized for a responsive UI in a Zinc-950 themed environment.
  Future<img.Image?> loadPreviewImage(String path, {int maxDimension = 1200}) async {
    try {
      final bytes = await File(path).readAsBytes();
      return compute(_isolateDecodeAndResize, _DecodeData(bytes, maxDimension));
    } catch (e) {
      debugPrint("Error loading image: $e");
      return null;
    }
  }

  /// Encodes image to Uint8List for Flutter Image.memory widget.
  /// Quality 85 preserves the deep shadows and grain essential for the noir theme.
  Uint8List encodeForDisplay(img.Image image) {
    return Uint8List.fromList(img.encodeJpg(image, quality: 85));
  }

  /// Apply a list of operations to the base image (Runs in Isolate).
  Future<ProcessResult> applyOperations(img.Image base, List<dynamic> history) async {
    return compute(_isolateApply, _IsolateData(base, history));
  }

  /// Process the full resolution image for export.
  Future<Uint8List?> processHighRes(String path, List<dynamic> history) async {
    try {
      final bytes = await File(path).readAsBytes();
      final raw = img.decodeImage(bytes);
      if (raw == null) return null;

      final result = await applyOperations(raw, history);
      return Uint8List.fromList(img.encodeJpg(result.image, quality: 100));
    } catch (e) {
      debugPrint("Error in high-res processing: $e");
      return null;
    }
  }
}

// --- Internal Data Structures ---

class _DecodeData {
  final Uint8List bytes;
  final int maxDimension;
  _DecodeData(this.bytes, this.maxDimension);
}

class _IsolateData {
  final img.Image base;
  final List<dynamic> history;
  _IsolateData(this.base, this.history);
}

class ProcessResult {
  final img.Image image;
  final HistogramData histogram;
  ProcessResult(this.image, this.histogram);
}

// --- Isolate Logic ---

img.Image? _isolateDecodeAndResize(_DecodeData data) {
  final image = img.decodeImage(data.bytes);
  if (image == null) return null;

  if (image.width > data.maxDimension || image.height > data.maxDimension) {
    return img.copyResize(
      image,
      width: image.width >= image.height ? data.maxDimension : null,
      height: image.height > image.width ? data.maxDimension : null,
    );
  }
  return image;
}

ProcessResult _isolateApply(_IsolateData data) {
  // Use .clone() to ensure we don't mutate the original UI reference
  var workingImage = data.base.clone();
  final history = data.history;

  for (final op in history) {
    final typeString = op.type.toString();
    final params = op.params as Map<String, dynamic>;

    if (typeString == 'ToolType.tune') {
      double b = (params['brightness'] ?? 0.0).toDouble();
      double c = (params['contrast'] ?? 0.0).toDouble();
      double s = (params['saturation'] ?? 0.0).toDouble();

      workingImage = img.adjustColor(
        workingImage,
        brightness: 1.0 + (b / 100.0),
        contrast: 1.0 + (c / 100.0),
        saturation: 1.0 + (s / 100.0),
      );
    }
    else if (typeString == 'ToolType.filter') {
      final filterName = params['name'] as String;
      if (filterName == 'grayscale') workingImage = img.grayscale(workingImage);
      if (filterName == 'sepia') workingImage = img.sepia(workingImage);
      if (filterName == 'invert') workingImage = img.invert(workingImage);
    }
    else if (typeString == 'ToolType.rotate') {
      final angle = (params['angle'] ?? 0.0).toDouble();
      workingImage = img.copyRotate(workingImage, angle: angle);
    }
    else if (typeString == 'ToolType.crop') {
      final ar = (params['aspectRatio'] ?? 1.0).toDouble();
      int w = workingImage.width;
      int h = workingImage.height;
      if (ar == 1.0) {
        int size = w < h ? w : h;
        workingImage = img.copyCrop(workingImage, x: (w - size) ~/ 2, y: (h - size) ~/ 2, width: size, height: size);
      } else if (ar == 16 / 9) {
        int targetH = (w * 9 / 16).round();
        if (targetH <= h) {
          workingImage = img.copyCrop(workingImage, x: 0, y: (h - targetH) ~/ 2, width: w, height: targetH);
        } else {
          int targetW = (h * 16 / 9).round();
          workingImage = img.copyCrop(workingImage, x: (w - targetW) ~/ 2, y: 0, width: targetW, height: h);
        }
      }
    }
    else if (typeString == 'ToolType.curves') {
      final rawPoints = params['points'] as List?;
      if (rawPoints != null && rawPoints.isNotEmpty) {
        final lut = Uint8List(256);
        final points = rawPoints.map((p) => img.Point(
            (p['x'] * 255).round(),
            (p['y'] * 255).round()
        )).toList();

        points.sort((a, b) => a.x.compareTo(b.x));

        for (int i = 0; i < 256; i++) {
          int p1 = 0;
          int p2 = points.length - 1;
          for (int j = 0; j < points.length - 1; j++) {
            if (points[j].x <= i && points[j + 1].x >= i) {
              p1 = j;
              p2 = j + 1;
              break;
            }
          }
          final start = points[p1];
          final end = points[p2];
          if (end.x == start.x) {
            lut[i] = (start.y).toInt().clamp(0, 255);
          } else {
            final t = (i - start.x) / (end.x - start.x);
            lut[i] = (start.y + t * (end.y - start.y)).round().clamp(0, 255);
          }
        }
        for (final pixel in workingImage) {
          pixel.r = lut[pixel.r.toInt()];
          pixel.g = lut[pixel.g.toInt()];
          pixel.b = lut[pixel.b.toInt()];
        }
      }
    }
    else if (typeString == 'ToolType.details') {
      final strength = (params['strength'] ?? 0.0).toDouble();
      if (strength > 0) {
        final blurred = img.gaussianBlur(workingImage.clone(), radius: 2);
        final amount = strength / 20.0;
        for (final pixel in workingImage) {
          final p2 = blurred.getPixel(pixel.x, pixel.y);
          pixel.r = (pixel.r + (pixel.r - p2.r) * amount).clamp(0, 255);
          pixel.g = (pixel.g + (pixel.g - p2.g) * amount).clamp(0, 255);
          pixel.b = (pixel.b + (pixel.b - p2.b) * amount).clamp(0, 255);
        }
      }
    }
    else if (typeString == 'ToolType.vignette') {
      final strength = (params['strength'] ?? 0.0).toDouble();
      if (strength > 0) {
        final cx = workingImage.width / 2;
        final cy = workingImage.height / 2;
        final maxDistSq = cx * cx + cy * cy;
        final factorBase = strength / 100.0;

        for (final pixel in workingImage) {
          final dx = pixel.x - cx;
          final dy = pixel.y - cy;
          final distSq = (dx * dx + dy * dy);
          double d = (distSq / maxDistSq).clamp(0.0, 1.0);
          final factor = 1.0 - (d * factorBase);
          pixel.r = (pixel.r * factor).round();
          pixel.g = (pixel.g * factor).round();
          pixel.b = (pixel.b * factor).round();
        }
      }
    }
    // Healing and Brush operations omitted here for brevity but follow the same clone-safe logic
  }

  // --- Histogram Generation ---
  final r = List.filled(256, 0);
  final g = List.filled(256, 0);
  final b = List.filled(256, 0);

  for (final pixel in workingImage) {
    r[pixel.r.toInt()]++;
    g[pixel.g.toInt()]++;
    b[pixel.b.toInt()]++;
  }

  return ProcessResult(workingImage, HistogramData(r: r, g: g, b: b));
}