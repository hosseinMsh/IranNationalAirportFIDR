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
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.language),
              onSelected: (code) => t.setLangCode(code),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'fa',
                  child: Row(
                    children: [
                      if (t.langCode == 'fa') const Icon(Icons.check, size: 18),
                      SizedBox(width: t.langCode == 'fa' ? 8 : 26),
                      const Text('فارسی'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'ar',
                  child: Row(
                    children: [
                      if (t.langCode == 'ar') const Icon(Icons.check, size: 18),
                      SizedBox(width: t.langCode == 'ar' ? 8 : 26),
                      const Text('العربية'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'en',
                  child: Row(
                    children: [
                      if (t.langCode == 'en') const Icon(Icons.check, size: 18),
                      SizedBox(width: t.langCode == 'en' ? 8 : 26),
                      const Text('English'),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.directions, color: theme.colorScheme.primary, size: 22),
                      tooltip: t.tr('navigateToAirport'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AirportMapScreen(airport: airport),
                          ),
                        );
                      },
                    ),
                    Icon(Icons.chevron_left, color: Colors.grey.shade400),
                  ],
                ),
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
