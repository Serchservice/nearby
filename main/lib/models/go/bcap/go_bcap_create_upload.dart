import 'go_bcap_create.dart';

class GoBCapCreateUpload {
  final int id;
  final bool isLoading;
  final bool hasError;
  final GoBCapCreate create;

  GoBCapCreateUpload({
    required this.id,
    required this.isLoading,
    this.hasError = false,
    required this.create
  });

  GoBCapCreateUpload copyWith({
    int? id,
    bool? isLoading,
    bool? hasError,
    GoBCapCreate? create,
  }) {
    return GoBCapCreateUpload(
      id: id ?? this.id,
      isLoading: isLoading ?? this.isLoading,
      create: create ?? this.create,
      hasError: hasError ?? this.hasError,
    );
  }
}