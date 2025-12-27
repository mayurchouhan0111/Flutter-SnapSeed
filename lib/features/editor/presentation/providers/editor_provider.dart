import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/ai/ai_service.dart';
import '../../../../core/image/edit_operation.dart';
import '../../../../core/image/edit_state.dart';
import '../../../../core/image/image_processor.dart';

part 'editor_provider.g.dart';

@riverpod
class EditorViewModel extends _$EditorViewModel {
  final _processor = ImageProcessor();
  final _aiService = AiService();

  @override
  EditState build() {
    return const EditState();
  }

  Future<void> loadImage(String path) async {
    state = state.copyWith(isLoading: true, originalPath: path);

    try {
      final image = await _processor.loadPreviewImage(path);
      if (image != null) {
        final displayBytes = _processor.encodeForDisplay(image);
        state = state.copyWith(
          rawImage: image,
          displayBytes: displayBytes,
          originalPreviewBytes: displayBytes,
          isLoading: false,
          history: [],
        );
      } else {
        state = state.copyWith(isLoading: false, error: "Failed to decode image");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> applyEdit(EditOperation op) async {
    final newHistory = [...state.history];
    final existingIndex = newHistory.indexWhere((e) => e.id == op.id);
    if (existingIndex != -1) {
      newHistory[existingIndex] = op;
    } else {
      newHistory.add(op);
    }

    state = state.copyWith(history: newHistory, isLoading: true);

    if (state.rawImage != null) {
      final result = await _processor.applyOperations(state.rawImage!, newHistory);
      final display = _processor.encodeForDisplay(result.image);
      state = state.copyWith(displayBytes: display, histogram: result.histogram, isLoading: false);
    }
  }

  Future<void> undo() async {
    if (state.history.isEmpty) return;

    final newHistory = [...state.history];
    newHistory.removeLast();

    state = state.copyWith(history: newHistory, isLoading: true);
    await _reprocess(newHistory);
  }

  Future<void> deleteOperation(String id) async {
    final newHistory = state.history.where((op) => op.id != id).toList();
    state = state.copyWith(history: newHistory, isLoading: true);
    await _reprocess(newHistory);
  }

  Future<void> _reprocess(List<EditOperation> history) async {
    if (state.rawImage != null) {
      if (history.isEmpty) {
        final display = _processor.encodeForDisplay(state.rawImage!);
        state = state.copyWith(displayBytes: display, histogram: null, isLoading: false);
      } else {
        final result = await _processor.applyOperations(state.rawImage!, history);
        final display = _processor.encodeForDisplay(result.image);
        state = state.copyWith(displayBytes: display, histogram: result.histogram, isLoading: false);
      }
    }
  }

  void toggleCompare(bool showOriginal) {
    if (state.originalPreviewBytes == null) return;

    if (showOriginal) {
      if (state.cachedEditedBytes == null) {
        state = state.copyWith(
            cachedEditedBytes: state.displayBytes,
            displayBytes: state.originalPreviewBytes
        );
      }
    } else {
      if (state.cachedEditedBytes != null) {
        state = state.copyWith(
            displayBytes: state.cachedEditedBytes,
            cachedEditedBytes: null
        );
      }
    }
  }

  Future<bool> autoEnhance({String? prompt}) async {
    if (state.originalPath == null) return false;
    state = state.copyWith(isLoading: true);
    
    if (!_aiService.isConfigured) {
        state = state.copyWith(isLoading: false, error: "AI_KEY_MISSING");
        return false;
    }

    try {
       final adjustments = prompt == null 
           ? await _aiService.analyzeForEnhancement(File(state.originalPath!))
           : await _aiService.analyzeWithPrompt(File(state.originalPath!), prompt);

       if (adjustments.isNotEmpty) {
          final op = EditOperation(
             id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
             type: ToolType.tune,
             params: adjustments
          );
          await applyEdit(op);
          return true;
       } else {
         state = state.copyWith(isLoading: false);
         return false;
       }
    } catch (e) {
       state = state.copyWith(error: "AI Error: $e", isLoading: false);
       return false;
    }
  }

  Future<String?> exportImage() async {
    try {
      final highResBytes = await _processor.processHighRes(state.originalPath!, state.history);
      if (highResBytes != null) {
        final originalFile = File(state.originalPath!);
        final appDocs = await getApplicationDocumentsDirectory();
        final name = originalFile.uri.pathSegments.last;
        final extension = name.split('.').last;
        final nameWithoutExt = name.substring(0, name.lastIndexOf('.'));
        
        // Save to AppDocs for persistent Dashboard access
        final newPath = '${appDocs.path}/${nameWithoutExt}_edited.$extension';

        await File(newPath).writeAsBytes(highResBytes);
        try {
          await Gal.putImage(newPath);
        } catch (e) {
          debugPrint("Gallery failed: $e");
          throw e;
        }
        state = state.copyWith(isLoading: false);
        return newPath;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Export failed: $e");
    }
    state = state.copyWith(isLoading: false);
    return null;
  }
}