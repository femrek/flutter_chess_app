class LastMoveModel {
  final String from;
  final String to;

  LastMoveModel({
    this.from,
    this.to,
  });

 @override
  String toString() {
    return '$from/$to';
  }
}