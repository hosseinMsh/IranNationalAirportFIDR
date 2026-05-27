import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import '../models/flight.dart';
import '../models/airport.dart';

class FidsService {
  static const String baseUrl = 'https://fids.airport.ir';

  static const List<Airport> airports = [];

  Future<Map<String, List<Flight>>> fetchFlights(Airport airport) async {
    return {'arrivals': [], 'departures': []};
  }
}
