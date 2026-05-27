import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import '../models/flight.dart';
import '../models/airport.dart';

class FidsService {
  static const String baseUrl = 'https://fids.airport.ir';

  static const List<Airport> airports = [
    Airport(id: '2', name: 'مهرآباد', nameEn: 'Mehrabad', latitude: 35.6892, longitude: 51.3134, urlPath: '/2/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%85%D9%87%D8%B1%D8%A2%D8%A8%D8%A7%D8%AF'),
    Airport(id: '102', name: 'مشهد', nameEn: 'Mashhad', latitude: 36.2352, longitude: 59.6439, urlPath: '/102/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%85%D8%B4%D9%87%D8%AF'),
    Airport(id: '1', name: 'شیراز', nameEn: 'Shiraz', latitude: 29.5392, longitude: 52.5898, urlPath: '/1/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B4%D9%8A%D8%B1%D8%A7%D8%B2'),
    Airport(id: '103', name: 'تبریز', nameEn: 'Tabriz', latitude: 38.1339, longitude: 46.2350, urlPath: '/103/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%AA%D8%A8%D8%B1%D9%8A%D8%B2'),
    Airport(id: '114', name: 'اصفهان', nameEn: 'Isfahan', latitude: 32.7508, longitude: 51.8613, urlPath: '/114/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A7%D8%B5%D9%81%D9%87%D8%A7%D9%86'),
    Airport(id: '401', name: 'اهواز', nameEn: 'Ahvaz', latitude: 31.3374, longitude: 48.7626, urlPath: '/401/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A7%D9%87%D9%88%D8%A7%D8%B2'),
    Airport(id: '104', name: 'بوشهر', nameEn: 'Bushehr', latitude: 28.9448, longitude: 50.8346, urlPath: '/104/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A8%D9%88%D8%B4%D9%87%D8%B1'),
    Airport(id: '201', name: 'کرمان', nameEn: 'Kerman', latitude: 30.2744, longitude: 56.9517, urlPath: '/201/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%DA%A9%D8%B1%D9%85%D8%A7%D9%86'),
    Airport(id: '117', name: 'بندرعباس', nameEn: 'Bandar Abbas', latitude: 27.2183, longitude: 56.3778, urlPath: '/117/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A8%D9%86%D8%AF%D8%B1%D8%B9%D8%A8%D8%A7%D8%B3'),
    Airport(id: '106', name: 'ساری', nameEn: 'Sari', latitude: 36.6283, longitude: 53.1936, urlPath: '/106/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B3%D8%A7%D8%B1%D9%8A'),
  ];

  Future<Map<String, List<Flight>>> fetchFlights(Airport airport) async {
    return {'arrivals': [], 'departures': []};
  }
}
