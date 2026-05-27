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
    Airport(id: '107', name: 'یزد', nameEn: 'Yazd', latitude: 31.9049, longitude: 54.2785, urlPath: '/107/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%8A%D8%B2%D8%AF'),
    Airport(id: '111', name: 'کرمانشاه', nameEn: 'Kermanshah', latitude: 34.3459, longitude: 47.1581, urlPath: '/111/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%DA%A9%D8%B1%D9%85%D8%A7%D9%86%D8%B4%D8%A7%D9%87'),
    Airport(id: '110', name: 'ارومیه', nameEn: 'Urmia', latitude: 37.6681, longitude: 45.0687, urlPath: '/110/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A7%D8%B1%D9%88%D9%85%D9%8A%D9%87'),
    Airport(id: '203', name: 'رشت', nameEn: 'Rasht', latitude: 37.3253, longitude: 49.6058, urlPath: '/203/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B1%D8%B4%D8%AA'),
    Airport(id: '109', name: 'زاهدان', nameEn: 'Zahedan', latitude: 29.4757, longitude: 60.9062, urlPath: '/109/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B2%D8%A7%D9%87%D8%AF%D8%A7%D9%86'),
    Airport(id: '301', name: 'آبادان', nameEn: 'Abadan', latitude: 30.3711, longitude: 48.2283, urlPath: '/301/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A2%D8%A8%D8%A7%D8%AF%D8%A7%D9%86'),
    Airport(id: '202', name: 'گرگان', nameEn: 'Gorgan', latitude: 36.9094, longitude: 54.4019, urlPath: '/202/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%DA%AF%D8%B1%DA%AF%D8%A7%D9%86'),
    Airport(id: '112', name: 'همدان', nameEn: 'Hamedan', latitude: 34.8692, longitude: 48.5525, urlPath: '/112/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%87%D9%85%D8%AF%D8%A7%D9%86'),
    Airport(id: '113', name: 'اردبیل', nameEn: 'Ardabil', latitude: 38.3257, longitude: 48.4244, urlPath: '/113/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A7%D8%B1%D8%AF%D8%A8%D9%8A%D9%84'),
    Airport(id: '105', name: 'ایلام', nameEn: 'Ilam', latitude: 33.5866, longitude: 46.4048, urlPath: '/105/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A7%D9%8A%D9%84%D8%A7%D9%85'),
    Airport(id: '204', name: 'بیرجند', nameEn: 'Birjand', latitude: 32.8981, longitude: 59.2661, urlPath: '/204/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A8%D9%8A%D8%B1%D8%AC%D9%86%D8%AF'),
    Airport(id: '402', name: 'سنندج', nameEn: 'Sanandaj', latitude: 35.2458, longitude: 47.0092, urlPath: '/402/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B3%D9%86%D9%86%D8%AF%D8%AC'),
    Airport(id: '108', name: 'شهرکرد', nameEn: 'Shahrekord', latitude: 32.2972, longitude: 50.8422, urlPath: '/108/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B4%D9%87%D8%B1%DA%A9%D8%B1%D8%AF'),
    Airport(id: '901', name: 'بجنورد', nameEn: 'Bojnord', latitude: 37.4930, longitude: 57.3088, urlPath: '/901/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A8%D8%AC%D9%86%D9%88%D8%B1%D8%AF'),
    Airport(id: '501', name: 'لارستان', nameEn: 'Larestan', latitude: 27.6747, longitude: 54.3833, urlPath: '/501/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%84%D8%A7%D8%B1%D8%B3%D8%AA%D8%A7%D9%86'),
    Airport(id: '302', name: 'خرم‌آباد', nameEn: 'Khorramabad', latitude: 33.4354, longitude: 48.2889, urlPath: '/302/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%AE%D8%B1%D9%85-%D8%A2%D8%A8%D8%A7%D8%AF'),
    Airport(id: '206', name: 'نوشهر', nameEn: 'Noshahr', latitude: 36.6633, longitude: 51.4647, urlPath: '/206/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%86%D9%88%D8%B4%D9%87%D8%B1'),
    Airport(id: '207', name: 'شاهرود', nameEn: 'Shahroud', latitude: 36.4250, longitude: 55.1042, urlPath: '/207/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B4%D8%A7%D9%87%D8%B1%D9%88%D8%AF'),
    Airport(id: '208', name: 'یاسوج', nameEn: 'Yasuj', latitude: 30.7006, longitude: 51.5450, urlPath: '/208/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%8A%D8%A7%D8%B3%D9%88%D8%AC'),
    Airport(id: '209', name: 'زنجان', nameEn: 'Zanjan', latitude: 36.7737, longitude: 48.3594, urlPath: '/209/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B2%D9%86%D8%AC%D8%A7%D9%86'),
    Airport(id: '210', name: 'اراک', nameEn: 'Arak', latitude: 34.1381, longitude: 49.8267, urlPath: '/210/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%A7%D8%B1%D8%A7%DA%A9'),
    Airport(id: '211', name: 'زابل', nameEn: 'Zabol', latitude: 31.0983, longitude: 61.5439, urlPath: '/211/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B2%D8%A7%D8%A8%D9%84'),
    Airport(id: '205', name: 'سمنان', nameEn: 'Semnan', latitude: 35.5910, longitude: 53.4954, urlPath: '/205/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D8%B3%D9%85%D9%86%D8%A7%D9%86'),
    Airport(id: '502', name: 'پارس‌آباد', nameEn: 'Parsabad', latitude: 39.6036, longitude: 47.8815, urlPath: '/502/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA-%D9%BE%D8%B1%D9%88%D8%A7%D8%B2-%D9%81%D8%B1%D9%88%D8%AF%DA%AF%D8%A7%D9%87-%D9%BE%D8%A7%D8%B1%D8%B3-%D8%A2%D8%A8%D8%A7%D8%AF%D9%85%D8%BA%D8%A7%D9%86'),
  ];

  Future<Map<String, List<Flight>>> fetchFlights(Airport airport) async {
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

      return {'arrivals': arrivals, 'departures': departures};
    } finally {
      client.close();
    }
  }

  List<Flight> _parseFlights(dom.Element? tabContent) {
    final flights = <Flight>[];
    if (tabContent == null) return flights;

    final table = tabContent.querySelector('table');
    if (table == null) return flights;

    final rows = table.querySelectorAll('tbody tr');
    for (final row in rows) {
      final cells = row.querySelectorAll('td');
      if (cells.length < 9) continue;

      final airlineCell = cells[1];
      final imgElement = airlineCell.querySelector('img');
      final airlineLogoUrl = imgElement?.attributes['src'];

      flights.add(Flight(
        dayTime: cells[0].text.trim(),
        airline: airlineCell.text.trim(),
        flightNumber: cells[2].text.trim(),
        origin: cells[3].text.trim(),
        status: cells[4].text.trim(),
        actualTime: cells[6].text.trim(),
        register: cells[7].text.trim(),
        aircraft: cells[8].text.trim(),
        date: cells[9].text.trim(),
        airlineLogoUrl: airlineLogoUrl != null ? '$baseUrl$airlineLogoUrl' : null,
      ));
    }
    return flights;
  }
}
