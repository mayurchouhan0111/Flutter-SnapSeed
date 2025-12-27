import 'package:image/image.dart' as img;

enum ToolType {
  none,
  tune,
  crop,
  rotate,
  filter,
  curves,
  details,
  vignette,
  text,
  brush,
  healing,
}

class EditOperation {
  final String id;
  final ToolType type;
  final Map<String, dynamic> params;

  // Cache key could be added here for optimization

  const EditOperation({
    required this.id,
    required this.type,
    required this.params,
  });

  // copyWith pattern
  EditOperation copyWith({
    String? id,
    ToolType? type,
    Map<String, dynamic>? params,
  }) {
    return EditOperation(
      id: id ?? this.id,
      type: type ?? this.type,
      params: params ?? this.params,
    );
  }
}
