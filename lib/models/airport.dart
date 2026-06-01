class Airport {
  final String id;
  final String name;
  final String nameEn;
  final String urlPath;
  final double latitude;
  final double longitude;

  const Airport({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.urlPath,
    required this.latitude,
    required this.longitude,
  });

  String get fullUrl => 'https://fids.airport.ir$urlPath';
}
