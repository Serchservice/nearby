import 'go_create.dart';

class GoCreateUpload {
  final int id;
  final bool isLoading;
  final bool hasError;
  final GoCreate create;

  GoCreateUpload({
    required this.id,
    required this.isLoading,
    this.hasError = false,
    required this.create
  });

  GoCreateUpload copyWith({
    int? id,
    bool? isLoading,
    bool? hasError,
    GoCreate? create,
  }) {
    return GoCreateUpload(
      id: id ?? this.id,
      isLoading: isLoading ?? this.isLoading,
      create: create ?? this.create,
      hasError: hasError ?? this.hasError,
    );
  }
}