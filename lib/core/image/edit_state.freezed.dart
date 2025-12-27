// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EditState {
  /// Path to the original file on disk
  String? get originalPath => throw _privateConstructorUsedError;

  /// Decoded low-res image for preview processing
  /// We keep this in memory for fast operations
  @JsonKey(includeFromJson: false, includeToJson: false)
  img.Image? get rawImage => throw _privateConstructorUsedError;

  /// Encoded JPG/PNG bytes of `rawImage` for UI display (Image.memory)
  @JsonKey(includeFromJson: false, includeToJson: false)
  Uint8List? get displayBytes => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  HistogramData? get histogram => throw _privateConstructorUsedError;

  /// Cached bytes of the original raw image for comparison
  @JsonKey(includeFromJson: false, includeToJson: false)
  Uint8List? get originalPreviewBytes => throw _privateConstructorUsedError;

  /// Helper to store edited bytes during comparison
  @JsonKey(includeFromJson: false, includeToJson: false)
  Uint8List? get cachedEditedBytes => throw _privateConstructorUsedError;

  /// Stack of applied edits
  List<EditOperation> get history => throw _privateConstructorUsedError;

  /// Current loading state
  bool get isLoading => throw _privateConstructorUsedError;

  /// Error message if any
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of EditState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EditStateCopyWith<EditState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditStateCopyWith<$Res> {
  factory $EditStateCopyWith(EditState value, $Res Function(EditState) then) =
      _$EditStateCopyWithImpl<$Res, EditState>;
  @useResult
  $Res call(
      {String? originalPath,
      @JsonKey(includeFromJson: false, includeToJson: false)
      img.Image? rawImage,
      @JsonKey(includeFromJson: false, includeToJson: false)
      Uint8List? displayBytes,
      @JsonKey(includeFromJson: false, includeToJson: false)
      HistogramData? histogram,
      @JsonKey(includeFromJson: false, includeToJson: false)
      Uint8List? originalPreviewBytes,
      @JsonKey(includeFromJson: false, includeToJson: false)
      Uint8List? cachedEditedBytes,
      List<EditOperation> history,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$EditStateCopyWithImpl<$Res, $Val extends EditState>
    implements $EditStateCopyWith<$Res> {
  _$EditStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EditState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalPath = freezed,
    Object? rawImage = freezed,
    Object? displayBytes = freezed,
    Object? histogram = freezed,
    Object? originalPreviewBytes = freezed,
    Object? cachedEditedBytes = freezed,
    Object? history = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      originalPath: freezed == originalPath
          ? _value.originalPath
          : originalPath // ignore: cast_nullable_to_non_nullable
              as String?,
      rawImage: freezed == rawImage
          ? _value.rawImage
          : rawImage // ignore: cast_nullable_to_non_nullable
              as img.Image?,
      displayBytes: freezed == displayBytes
          ? _value.displayBytes
          : displayBytes // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      histogram: freezed == histogram
          ? _value.histogram
          : histogram // ignore: cast_nullable_to_non_nullable
              as HistogramData?,
      originalPreviewBytes: freezed == originalPreviewBytes
          ? _value.originalPreviewBytes
          : originalPreviewBytes // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      cachedEditedBytes: freezed == cachedEditedBytes
          ? _value.cachedEditedBytes
          : cachedEditedBytes // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<EditOperation>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EditStateImplCopyWith<$Res>
    implements $EditStateCopyWith<$Res> {
  factory _$$EditStateImplCopyWith(
          _$EditStateImpl value, $Res Function(_$EditStateImpl) then) =
      __$$EditStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? originalPath,
      @JsonKey(includeFromJson: false, includeToJson: false)
      img.Image? rawImage,
      @JsonKey(includeFromJson: false, includeToJson: false)
      Uint8List? displayBytes,
      @JsonKey(includeFromJson: false, includeToJson: false)
      HistogramData? histogram,
      @JsonKey(includeFromJson: false, includeToJson: false)
      Uint8List? originalPreviewBytes,
      @JsonKey(includeFromJson: false, includeToJson: false)
      Uint8List? cachedEditedBytes,
      List<EditOperation> history,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$EditStateImplCopyWithImpl<$Res>
    extends _$EditStateCopyWithImpl<$Res, _$EditStateImpl>
    implements _$$EditStateImplCopyWith<$Res> {
  __$$EditStateImplCopyWithImpl(
      _$EditStateImpl _value, $Res Function(_$EditStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of EditState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalPath = freezed,
    Object? rawImage = freezed,
    Object? displayBytes = freezed,
    Object? histogram = freezed,
    Object? originalPreviewBytes = freezed,
    Object? cachedEditedBytes = freezed,
    Object? history = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$EditStateImpl(
      originalPath: freezed == originalPath
          ? _value.originalPath
          : originalPath // ignore: cast_nullable_to_non_nullable
              as String?,
      rawImage: freezed == rawImage
          ? _value.rawImage
          : rawImage // ignore: cast_nullable_to_non_nullable
              as img.Image?,
      displayBytes: freezed == displayBytes
          ? _value.displayBytes
          : displayBytes // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      histogram: freezed == histogram
          ? _value.histogram
          : histogram // ignore: cast_nullable_to_non_nullable
              as HistogramData?,
      originalPreviewBytes: freezed == originalPreviewBytes
          ? _value.originalPreviewBytes
          : originalPreviewBytes // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      cachedEditedBytes: freezed == cachedEditedBytes
          ? _value.cachedEditedBytes
          : cachedEditedBytes // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      history: null == history
          ? _value._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<EditOperation>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$EditStateImpl extends _EditState {
  const _$EditStateImpl(
      {this.originalPath,
      @JsonKey(includeFromJson: false, includeToJson: false) this.rawImage,
      @JsonKey(includeFromJson: false, includeToJson: false) this.displayBytes,
      @JsonKey(includeFromJson: false, includeToJson: false) this.histogram,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.originalPreviewBytes,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.cachedEditedBytes,
      final List<EditOperation> history = const [],
      this.isLoading = false,
      this.error})
      : _history = history,
        super._();

  /// Path to the original file on disk
  @override
  final String? originalPath;

  /// Decoded low-res image for preview processing
  /// We keep this in memory for fast operations
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final img.Image? rawImage;

  /// Encoded JPG/PNG bytes of `rawImage` for UI display (Image.memory)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Uint8List? displayBytes;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final HistogramData? histogram;

  /// Cached bytes of the original raw image for comparison
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Uint8List? originalPreviewBytes;

  /// Helper to store edited bytes during comparison
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Uint8List? cachedEditedBytes;

  /// Stack of applied edits
  final List<EditOperation> _history;

  /// Stack of applied edits
  @override
  @JsonKey()
  List<EditOperation> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  /// Current loading state
  @override
  @JsonKey()
  final bool isLoading;

  /// Error message if any
  @override
  final String? error;

  @override
  String toString() {
    return 'EditState(originalPath: $originalPath, rawImage: $rawImage, displayBytes: $displayBytes, histogram: $histogram, originalPreviewBytes: $originalPreviewBytes, cachedEditedBytes: $cachedEditedBytes, history: $history, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditStateImpl &&
            (identical(other.originalPath, originalPath) ||
                other.originalPath == originalPath) &&
            const DeepCollectionEquality().equals(other.rawImage, rawImage) &&
            const DeepCollectionEquality()
                .equals(other.displayBytes, displayBytes) &&
            (identical(other.histogram, histogram) ||
                other.histogram == histogram) &&
            const DeepCollectionEquality()
                .equals(other.originalPreviewBytes, originalPreviewBytes) &&
            const DeepCollectionEquality()
                .equals(other.cachedEditedBytes, cachedEditedBytes) &&
            const DeepCollectionEquality().equals(other._history, _history) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      originalPath,
      const DeepCollectionEquality().hash(rawImage),
      const DeepCollectionEquality().hash(displayBytes),
      histogram,
      const DeepCollectionEquality().hash(originalPreviewBytes),
      const DeepCollectionEquality().hash(cachedEditedBytes),
      const DeepCollectionEquality().hash(_history),
      isLoading,
      error);

  /// Create a copy of EditState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EditStateImplCopyWith<_$EditStateImpl> get copyWith =>
      __$$EditStateImplCopyWithImpl<_$EditStateImpl>(this, _$identity);
}

abstract class _EditState extends EditState {
  const factory _EditState(
      {final String? originalPath,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final img.Image? rawImage,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final Uint8List? displayBytes,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final HistogramData? histogram,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final Uint8List? originalPreviewBytes,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final Uint8List? cachedEditedBytes,
      final List<EditOperation> history,
      final bool isLoading,
      final String? error}) = _$EditStateImpl;
  const _EditState._() : super._();

  /// Path to the original file on disk
  @override
  String? get originalPath;

  /// Decoded low-res image for preview processing
  /// We keep this in memory for fast operations
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  img.Image? get rawImage;

  /// Encoded JPG/PNG bytes of `rawImage` for UI display (Image.memory)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  Uint8List? get displayBytes;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  HistogramData? get histogram;

  /// Cached bytes of the original raw image for comparison
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  Uint8List? get originalPreviewBytes;

  /// Helper to store edited bytes during comparison
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  Uint8List? get cachedEditedBytes;

  /// Stack of applied edits
  @override
  List<EditOperation> get history;

  /// Current loading state
  @override
  bool get isLoading;

  /// Error message if any
  @override
  String? get error;

  /// Create a copy of EditState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EditStateImplCopyWith<_$EditStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
