class LastMoveModel {
  final String from;
  final String to;

  LastMoveModel({
    required this.from,
    required this.to,
  });

 @override
  String toString() {
    return '$from/$to';
  }
}