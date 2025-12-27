import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image/image.dart' as img;
import 'edit_operation.dart';
import 'histogram_data.dart';

part 'edit_state.freezed.dart';

@freezed
class EditState with _$EditState {
  const EditState._();

  const factory EditState({
    /// Path to the original file on disk
    String? originalPath,

    /// Decoded low-res image for preview processing
    /// We keep this in memory for fast operations
    @JsonKey(includeFromJson: false, includeToJson: false)
    img.Image? rawImage,

    /// Encoded JPG/PNG bytes of `rawImage` for UI display (Image.memory)
    @JsonKey(includeFromJson: false, includeToJson: false)
    Uint8List? displayBytes,

    @JsonKey(includeFromJson: false, includeToJson: false)
    HistogramData? histogram,

    /// Cached bytes of the original raw image for comparison
    @JsonKey(includeFromJson: false, includeToJson: false)
    Uint8List? originalPreviewBytes,

    /// Helper to store edited bytes during comparison
    @JsonKey(includeFromJson: false, includeToJson: false)
    Uint8List? cachedEditedBytes,

    /// Stack of applied edits
    @Default([]) List<EditOperation> history,
    
    /// Current loading state
    @Default(false) bool isLoading,
    
    /// Error message if any
    String? error,
  }) = _EditState;
}
