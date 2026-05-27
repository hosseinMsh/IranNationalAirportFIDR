class Flight {
  final String dayTime;
  final String airline;
  final String flightNumber;
  final String origin;
  final String status;
  final String actualTime;
  final String register;
  final String aircraft;
  final String date;
  final String? airlineLogoUrl;

  Flight({
    required this.dayTime,
    required this.airline,
    required this.flightNumber,
    required this.origin,
    required this.status,
    required this.actualTime,
    required this.register,
    required this.aircraft,
    required this.date,
    this.airlineLogoUrl,
  });
}
