class UpdateLogView{
  /// The header of the update.
  final String header;

  /// The contents in the update.
  final List<String> content;

  /// Date the update was made.
  final String date;

  /// The index of the update.
  final int index;

  UpdateLogView({
    required this.header,
    required this.content,
    required this.date,
    required this.index
  });
}