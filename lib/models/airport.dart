class Airport {
  final String id;
  final String name;
  final String nameEn;
  final String iataCode;
  final String urlPath;
  final double latitude;
  final double longitude;
  final String phone;

  const Airport({
    required this.id,
    required this.name,
    required this.nameEn,
    this.iataCode = '',
    required this.urlPath,
    required this.latitude,
    required this.longitude,
    this.phone = '199',
  });

  String get fullUrl => 'https://fids.airport.ir$urlPath';
}
