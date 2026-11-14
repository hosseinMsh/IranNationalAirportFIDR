import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import '../models/flight.dart';
import '../models/airport.dart';
import 'flight_cache.dart';

class FidsService {
  static const String baseUrl = 'https://fids.airport.ir';

  static const List<Airport> airports = [
    Airport(id: '2', name: 'مهرآباد تهران', nameEn: 'Tehran Mehrabad', iataCode: 'THR', latitude: 35.6892, longitude: 51.3134, phone: '02161021', urlPath: '/2/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%85%D9%87%D8%B1%D8%A2%D8%A8%D8%A7%D8%AF'),
    Airport(id: '102', name: 'مشهد', nameEn: 'Mashhad', iataCode: 'MHD', latitude: 36.2352, longitude: 59.6439, phone: '05133400001', urlPath: '/102/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%85%D8%B4%D9%87%D8%AF'),
    Airport(id: '1', name: 'شیراز', nameEn: 'Shiraz', iataCode: 'SYZ', latitude: 29.5392, longitude: 52.5898, phone: '07137115000', urlPath: '/1/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B4%D9%8A%D8%B1%D8%A7%D8%B2'),
    Airport(id: '103', name: 'تبریز', nameEn: 'Tabriz', iataCode: 'TBZ', latitude: 38.1339, longitude: 46.2350, phone: '04135260405', urlPath: '/103/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%AA%D8%A8%D8%B1%D9%8A%D8%B2'),
    Airport(id: '114', name: 'اصفهان', nameEn: 'Isfahan', iataCode: 'IFN', latitude: 32.7508, longitude: 51.8613, phone: '03135275050', urlPath: '/114/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A7%D8%B5%D9%81%D9%87%D8%A7%D9%86'),
    Airport(id: '401', name: 'اهواز', nameEn: 'Ahvaz', iataCode: 'AWZ', latitude: 31.3374, longitude: 48.7626, phone: '06134434601', urlPath: '/401/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A7%D9%87%D9%88%D8%A7%D8%B2'),
    Airport(id: '104', name: 'بوشهر', nameEn: 'Bushehr', iataCode: 'BUZ', latitude: 28.9448, longitude: 50.8346, phone: '07733333333', urlPath: '/104/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A8%D9%88%D8%B4%D9%87%D8%B1'),
    Airport(id: '201', name: 'کرمان', nameEn: 'Kerman', iataCode: 'KER', latitude: 30.2744, longitude: 56.9517, phone: '03432110113', urlPath: '/201/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%DA%A9%D8%B1%D9%85%D8%A7%D9%86'),
    Airport(id: '117', name: 'بندرعباس', nameEn: 'Bandar Abbas', iataCode: 'BND', latitude: 27.2183, longitude: 56.3778, phone: '07633611011', urlPath: '/117/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A8%D9%86%D8%AF%D8%B1%D8%B9%D8%A8%D8%A7%D8%B3'),
    Airport(id: '106', name: 'ساری', nameEn: 'Sari', iataCode: 'SRY', latitude: 36.6283, longitude: 53.1936, phone: '01133718000', urlPath: '/106/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B3%D8%A7%D8%B1%D9%8A'),
    Airport(id: '107', name: 'یزد', nameEn: 'Yazd', iataCode: 'AZD', latitude: 31.9049, longitude: 54.2785, phone: '03531010', urlPath: '/107/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%8A%D8%B2%D8%AF'),
    Airport(id: '111', name: 'کرمانشاه', nameEn: 'Kermanshah', iataCode: 'KSH', latitude: 34.3459, longitude: 47.1581, phone: '08334326611', urlPath: '/111/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%DA%A9%D8%B1%D9%85%D8%A7%D9%86%D8%B4%D8%A7%D9%87'),
    Airport(id: '110', name: 'ارومیه', nameEn: 'Urmia', iataCode: 'OMH', latitude: 37.6681, longitude: 45.0687, phone: '04432777766', urlPath: '/110/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A7%D8%B1%D9%88%D9%85%D9%8A%D9%87'),
    Airport(id: '203', name: 'رشت', nameEn: 'Rasht', iataCode: 'RAS', latitude: 37.3253, longitude: 49.6058, phone: '01334888888', urlPath: '/203/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B1%D8%B4%D8%AA'),
    Airport(id: '109', name: 'زاهدان', nameEn: 'Zahedan', iataCode: 'ZAH', latitude: 29.4757, longitude: 60.9062, phone: '05432227700', urlPath: '/109/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B2%D8%A7%D9%87%D8%AF%D8%A7%D9%86'),
    Airport(id: '301', name: 'آبادان', nameEn: 'Abadan', iataCode: 'ABD', latitude: 30.3711, longitude: 48.2283, phone: '06153265000', urlPath: '/301/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A2%D8%A8%D8%A7%D8%AF%D8%A7%D9%86'),
    Airport(id: '202', name: 'گرگان', nameEn: 'Gorgan', iataCode: 'GBT', latitude: 36.9094, longitude: 54.4019, phone: '01731220199', urlPath: '/202/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%DA%AF%D8%B1%DA%AF%D8%A7%D9%86'),
    Airport(id: '112', name: 'همدان', nameEn: 'Hamedan', iataCode: 'HDM', latitude: 34.8692, longitude: 48.5525, phone: '08132569011', urlPath: '/112/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%87%D9%85%D8%AF%D8%A7%D9%86'),
    Airport(id: '113', name: 'اردبیل', nameEn: 'Ardabil', iataCode: 'ADU', latitude: 38.3257, longitude: 48.4244, phone: '04531458888', urlPath: '/113/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A7%D8%B1%D8%AF%D8%A8%D9%8A%D9%84'),
    Airport(id: '105', name: 'ایلام', nameEn: 'Ilam', iataCode: 'IIL', latitude: 33.5866, longitude: 46.4048, phone: '08432236800', urlPath: '/105/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A7%D9%8A%D9%84%D8%A7%D9%85'),
    Airport(id: '204', name: 'بیرجند', nameEn: 'Birjand', iataCode: 'XBJ', latitude: 32.8981, longitude: 59.2661, phone: '05632389000', urlPath: '/204/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A8%D9%8A%D8%B1%D8%AC%D9%86%D8%AF'),
    Airport(id: '402', name: 'سنندج', nameEn: 'Sanandaj', iataCode: 'SDG', latitude: 35.2458, longitude: 47.0092, phone: '08733774051', urlPath: '/402/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B3%D9%86%D9%86%D8%AF%D8%AC'),
    Airport(id: '108', name: 'شهرکرد', nameEn: 'Shahrekord', iataCode: 'CQD', latitude: 32.2972, longitude: 50.8422, phone: '03832274040', urlPath: '/108/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B4%D9%87%D8%B1%DA%A9%D8%B1%D8%AF'),
    Airport(id: '901', name: 'بجنورد', nameEn: 'Bojnord', iataCode: 'BJB', latitude: 37.4930, longitude: 57.3088, phone: '05832236000', urlPath: '/901/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A8%D8%AC%D9%86%D9%88%D8%B1%D8%AF'),
    Airport(id: '501', name: 'لارستان', nameEn: 'Larestan', iataCode: 'LRR', latitude: 27.6747, longitude: 54.3833, phone: '07152338401', urlPath: '/501/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%84%D8%A7%D8%B1%D8%B3%D8%AA%D8%A7%D9%86'),
    Airport(id: '302', name: 'خرم‌آباد', nameEn: 'Khorramabad', iataCode: 'KHD', latitude: 33.4354, longitude: 48.2889, phone: '06633439901', urlPath: '/302/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%AE%D8%B1%D9%85-%D8%A2%D8%A8%D8%A7%D8%AF'),
    Airport(id: '206', name: 'نوشهر', nameEn: 'Noshahr', iataCode: 'NSH', latitude: 36.6633, longitude: 51.4647, phone: '01152353000', urlPath: '/206/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%86%D9%88%D8%B4%D9%87%D8%B1'),
    Airport(id: '207', name: 'شاهرود', nameEn: 'Shahroud', iataCode: 'RUD', latitude: 36.4250, longitude: 55.1042, phone: '02332300000', urlPath: '/207/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B4%D8%A7%D9%87%D8%B1%D9%88%D8%AF'),
    Airport(id: '208', name: 'یاسوج', nameEn: 'Yasuj', iataCode: 'YES', latitude: 30.7006, longitude: 51.5450, phone: '07433312000', urlPath: '/208/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%8A%D8%A7%D8%B3%D9%88%D8%AC'),
    Airport(id: '209', name: 'زنجان', nameEn: 'Zanjan', iataCode: 'JWN', latitude: 36.7737, longitude: 48.3594, phone: '02433360000', urlPath: '/209/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B2%D9%86%D8%AC%D8%A7%D9%86'),
    Airport(id: '210', name: 'اراک', nameEn: 'Arak', iataCode: 'AJK', latitude: 34.1381, longitude: 49.8267, phone: '08638868000', urlPath: '/210/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A7%D8%B1%D8%A7%DA%A9'),
    Airport(id: '211', name: 'زابل', nameEn: 'Zabol', iataCode: 'ACZ', latitude: 31.0983, longitude: 61.5439, phone: '05432223000', urlPath: '/211/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B2%D8%A7%D8%A8%D9%84'),
    Airport(id: '205', name: 'سمنان', nameEn: 'Semnan', iataCode: 'SNX', latitude: 35.5910, longitude: 53.4954, phone: '02333650000', urlPath: '/205/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B3%D9%85%D9%86%D8%A7%D9%86'),
    Airport(id: '502', name: 'پارس‌آباد', nameEn: 'Parsabad', iataCode: 'PFQ', latitude: 39.6036, longitude: 47.8815, phone: '04532724000', urlPath: '/502/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%BE%D8%A7%D8%B1%D8%B3-%D8%A2%D8%A8%D8%A7%D8%AF%D9%85%D8%BA%D8%A7%D9%86'),
  ];

  Future<Map<String, List<Flight>>> fetchFlights(Airport airport, {bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = FlightCache().get(airport.id);
      if (cached != null) return cached;
    }

    final client = http.Client();
    try {
      final uri = Uri.parse('$baseUrl${airport.urlPath}');
      final response = await client
          .get(uri, headers: {
            'User-Agent': 'Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            'Accept-Language': 'fa-IR,fa;q=0.9,en;q=0.8',
          })
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('خطا در دریافت اطلاعات (کد ${response.statusCode})');
      }

      final body = utf8.decode(response.bodyBytes);
      final document = html_parser.parse(body);

      final arrivals = _parseFlights(document.getElementById('input'));
      final departures = _parseFlights(document.getElementById('output'));

      final result = {'arrivals': arrivals, 'departures': departures};
      FlightCache().set(airport.id, result);
      return result;
    } finally {
      client.close();
    }
  }

  String _cellText(List<dom.Element> cells, int index) {
    if (index >= 0 && index < cells.length) {
      return cells[index].text.trim();
    }
    return '';
  }

  List<Flight> _parseFlights(dom.Element? tabContent) {
    final flights = <Flight>[];
    if (tabContent == null) return flights;

    final table = tabContent.querySelector('table');
    if (table == null) return flights;

    final rows = table.querySelectorAll('tbody tr');
    for (final row in rows) {
      final cells = row.querySelectorAll('td');
      // Table requires at least basic flight info
      if (cells.length < 5) continue;

      final airlineCell = cells.length > 1 ? cells[1] : null;
      final imgElement = airlineCell?.querySelector('img');
      final airlineLogoUrl = imgElement?.attributes['src'];

      flights.add(Flight(
        dayTime: _cellText(cells, 0),
        airline: airlineCell?.text.trim() ?? '',
        flightNumber: _cellText(cells, 2),
        origin: _cellText(cells, 3),
        status: _cellText(cells, 4),
        actualTime: _cellText(cells, 6),
        register: _cellText(cells, 7),
        aircraft: _cellText(cells, 8),
        date: _cellText(cells, 9),
        airlineLogoUrl: airlineLogoUrl != null ? '$baseUrl$airlineLogoUrl' : null,
      ));
    }
    return flights;
  }
}
