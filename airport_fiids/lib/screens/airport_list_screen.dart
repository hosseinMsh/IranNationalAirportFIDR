import 'package:flutter/material.dart';
import '../services/fids_service.dart';
import '../services/translations.dart';
import 'flights_screen.dart';
import 'airport_map_screen.dart';

class AirportListScreen extends StatelessWidget {
  const AirportListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = TranslationService.instance;
    return Directionality(
      textDirection: t.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.tr('airportsTitle')),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 6),
          itemCount: FidsService.airports.length,
          itemBuilder: (context, index) {
            final airport = FidsService.airports[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withAlpha(25),
                  child: Icon(Icons.flight_takeoff, color: theme.colorScheme.primary),
                ),
                title: Text(airport.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                subtitle: Text(airport.nameEn, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FlightsScreen(airport: airport),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
