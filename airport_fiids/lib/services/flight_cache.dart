import 'dart:collection';
import '../models/flight.dart';

class FlightCache {
  static final FlightCache _instance = FlightCache._();
  factory FlightCache() => _instance;
  FlightCache._();

  final _cache = HashMap<String, CacheEntry>();
  static const _maxAge = Duration(minutes: 2);

  Map<String, List<Flight>>? get(String airportId) {
    final entry = _cache[airportId];
    if (entry == null) return null;
    if (DateTime.now().difference(entry.timestamp) > _maxAge) {
      _cache.remove(airportId);
      return null;
    }
    return entry.data;
  }

  void set(String airportId, Map<String, List<Flight>> data) {
    _cache[airportId] = CacheEntry(data: data, timestamp: DateTime.now());
  }

  void clear() => _cache.clear();

  void remove(String airportId) => _cache.remove(airportId);
}

class CacheEntry {
  final Map<String, List<Flight>> data;
  final DateTime timestamp;

  CacheEntry({required this.data, required this.timestamp});
}
