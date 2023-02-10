class LocalIp {
  final String address;
  final int maskLength;

  LocalIp({
    required this.address,
    required this.maskLength,
  });

  factory LocalIp.fromMap(Map<String, dynamic> map) {
    return LocalIp(
      address: map['ipAddress'],
      maskLength: int.parse(map['maskLength']),
    );
  }
}