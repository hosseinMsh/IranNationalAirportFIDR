import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:airport_fiids/main.dart';
import 'package:airport_fiids/models/flight.dart';
import 'package:airport_fiids/models/airport.dart';

void main() {
  testWidgets('FidsApp renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const FidsApp());
    expect(find.byType(FidsApp), findsOneWidget);
  });

  testWidgets('FidsApp uses Material 3 theme', (WidgetTester tester) async {
    await tester.pumpWidget(const FidsApp());
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.useMaterial3, isTrue);
  });

  group('Flight model', () {
    test('creates Flight with all required fields', () {
      final flight = Flight(
        dayTime: '12:30',
        airline: 'Iran Air',
        flightNumber: 'IR123',
        origin: 'IKA',
        status: 'on time',
        actualTime: '12:35',
        register: 'EP-ABC',
        aircraft: 'A310',
        date: '1403/01/15',
      );
      expect(flight.dayTime, '12:30');
      expect(flight.airline, 'Iran Air');
      expect(flight.flightNumber, 'IR123');
      expect(flight.origin, 'IKA');
      expect(flight.status, 'on time');
      expect(flight.actualTime, '12:35');
      expect(flight.register, 'EP-ABC');
      expect(flight.aircraft, 'A310');
      expect(flight.date, '1403/01/15');
    });

    test('airlineLogoUrl defaults to null', () {
      final flight = Flight(
        dayTime: '12:30',
        airline: 'Iran Air',
        flightNumber: 'IR123',
        origin: 'IKA',
        status: 'on time',
        actualTime: '',
        register: '',
        aircraft: '',
        date: '',
      );
      expect(flight.airlineLogoUrl, isNull);
    });

    test('airlineLogoUrl stores provided value', () {
      final flight = Flight(
        dayTime: '12:30',
        airline: 'Iran Air',
        flightNumber: 'IR123',
        origin: 'IKA',
        status: 'on time',
        actualTime: '',
        register: '',
        aircraft: '',
        date: '',
        airlineLogoUrl: 'https://example.com/logo.png',
      );
      expect(flight.airlineLogoUrl, 'https://example.com/logo.png');
    });
  });

  group('Airport model', () {
    test('Airport data is const and correct', () {
      const airport = Airport(
        id: 'OIII',
        name: 'فرودگاه بین‌المللی امام خمینی',
        nameEn: 'Imam Khomeini International Airport',
        latitude: 35.4167,
        longitude: 51.1522,
        url: '/home/airportInfo?airportCode=OIII',
      );
      expect(airport.id, 'OIII');
      expect(airport.nameEn, contains('Imam Khomeini'));
    });
  });
}
