import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/live_flight.dart';

class LiveRadarService {
  static const String _baseUrl = 'https://asemanjoo.ir/api/flights';

  /// دریافت زنده موقعیت پروازهای در حال پرواز بر فراز ایران
  /// پهنه جغرافیایی ایران: جنوب ۲۴.۵ تا شمال ۴۰.۵، غرب ۴۳.۵ تا شرق ۶۴.۵
  static Future<List<LiveFlight>> fetchLiveFlights({
    double south = 24.5,
    double north = 40.5,
    double west = 43.5,
    double east = 64.5,
    int limit = 350,
  }) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl?south=$south&north=$north&west=$west&east=$east&limit=$limit',
      );
      final response = await http
          .get(uri, headers: {
            'User-Agent': 'Mozilla/5.0 (Linux; Android 14) AirportFIDS/1.1',
            'Accept': 'application/json',
          })
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic>? rawFlights = data['flights'];
        if (rawFlights == null) return [];

        return rawFlights
            .map((item) {
              if (item is List) {
                return LiveFlight.fromList(item);
              }
              return null;
            })
            .whereType<LiveFlight>()
            .where((f) => f.lat != 0.0 && f.lon != 0.0)
            .toList();
      } else {
        debugPrint('Radar API returned status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Failed to fetch live radar flights: $e');
      return [];
    }
  }
}
