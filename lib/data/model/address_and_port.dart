class AddressAndPort {
  final String address;
  final int port;

  AddressAndPort({
    required this.address,
    required this.port,
  });

  @override
  String toString() {
    return '$address:$port';
  }
}