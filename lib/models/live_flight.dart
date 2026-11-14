class LiveFlight {
  final int id;
  final double lat;
  final double lon;
  final int altitude; // فوت
  final int speed; // نات
  final double heading; // زاویه جهت از ۰ تا ۳۶۰ درجه
  final int verticalRate; // فوت در دقیقه
  final bool onGround;
  final String callsign;
  final String flightNumber;
  final String registration;
  final String aircraftType;
  final String originIata;
  final String destIata;
  final int timestamp;
  final String source;
  final String category;

  const LiveFlight({
    required this.id,
    required this.lat,
    required this.lon,
    required this.altitude,
    required this.speed,
    required this.heading,
    required this.verticalRate,
    required this.onGround,
    required this.callsign,
    required this.flightNumber,
    required this.registration,
    required this.aircraftType,
    required this.originIata,
    required this.destIata,
    required this.timestamp,
    required this.source,
    required this.category,
  });

  String get displayFlightNumber {
    if (flightNumber.isNotEmpty) return flightNumber;
    if (callsign.isNotEmpty) return callsign;
    if (registration.isNotEmpty) return registration;
    return 'IR-$id';
  }

  String get routeDisplay {
    if (originIata.isNotEmpty && destIata.isNotEmpty) {
      return '$originIata ➔ $destIata';
    }
    if (originIata.isNotEmpty) return 'از $originIata';
    if (destIata.isNotEmpty) return 'به $destIata';
    return '';
  }

  int get speedKmh => (speed * 1.852).round();
  int get altitudeMeters => (altitude * 0.3048).round();

  factory LiveFlight.fromList(List<dynamic> list) {
    return LiveFlight(
      id: list.isNotEmpty ? (list[0] as num?)?.toInt() ?? 0 : 0,
      lat: list.length > 1 ? (list[1] as num?)?.toDouble() ?? 0.0 : 0.0,
      lon: list.length > 2 ? (list[2] as num?)?.toDouble() ?? 0.0 : 0.0,
      altitude: list.length > 3 ? (list[3] as num?)?.toInt() ?? 0 : 0,
      speed: list.length > 4 ? (list[4] as num?)?.toInt() ?? 0 : 0,
      heading: list.length > 5 ? (list[5] as num?)?.toDouble() ?? 0.0 : 0.0,
      verticalRate: list.length > 6 ? (list[6] as num?)?.toInt() ?? 0 : 0,
      onGround: list.length > 7 ? (list[7] == 1) : false,
      callsign: list.length > 8 ? (list[8]?.toString() ?? '') : '',
      flightNumber: list.length > 9 ? (list[9]?.toString() ?? '') : '',
      registration: list.length > 10 ? (list[10]?.toString() ?? '') : '',
      aircraftType: list.length > 11 ? (list[11]?.toString() ?? '') : '',
      originIata: list.length > 12 ? (list[12]?.toString() ?? '') : '',
      destIata: list.length > 13 ? (list[13]?.toString() ?? '') : '',
      timestamp: list.length > 14 ? (list[14] as num?)?.toInt() ?? 0 : 0,
      source: list.length > 16 ? (list[16]?.toString() ?? '') : '',
      category: list.length > 19 ? (list[19]?.toString() ?? '') : '',
    );
  }
}
