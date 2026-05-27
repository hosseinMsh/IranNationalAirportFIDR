import 'package:flutter/material.dart';
import '../models/flight.dart';

class FlightCard extends StatelessWidget {
  final Flight flight;
  const FlightCard({super.key, required this.flight});

  Color _statusColor(String status) {
    if (status.contains('نشست') || status.contains('پروازکرد')) return const Color(0xFF2E7D32);
    if (status.contains('تاخیر') || status.contains('لغو')) return const Color(0xFFC62828);
    if (status.contains('طبق برنامه')) return const Color(0xFF1565C0);
    if (status.contains('پذیرش') || status.contains('در حال')) return const Color(0xFFEF6C00);
    return const Color(0xFF757575);
  }

  IconData _statusIcon(String status) {
    if (status.contains('نشست')) return Icons.touch_app;
    if (status.contains('پروازکرد')) return Icons.flight_takeoff;
    if (status.contains('تاخیر')) return Icons.schedule;
    if (status.contains('لغو')) return Icons.cancel;
    if (status.contains('طبق برنامه')) return Icons.check_circle;
    if (status.contains('پذیرش')) return Icons.assignment_turned_in;
    if (status.contains('در حال')) return Icons.hourglass_top;
    return Icons.help_outline;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(flight.status);
    final statusIcon = _statusIcon(flight.status);

    return Card(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${flight.airline} • ${flight.flightNumber}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: statusColor.withAlpha(80)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, size: 14, color: statusColor),
                              const SizedBox(width: 4),
                              Text(
                                flight.status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _infoChip(context, Icons.flight, flight.origin),
                        const SizedBox(width: 16),
                        _infoChip(context, Icons.access_time, flight.dayTime),
                        if (flight.actualTime.isNotEmpty) ...[
                          const SizedBox(width: 16),
                          _infoChip(context, Icons.schedule, flight.actualTime),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (flight.aircraft.isNotEmpty)
                          _infoChip(context, Icons.airplanemode_active, flight.aircraft),
                        if (flight.register.isNotEmpty) ...[
                          const SizedBox(width: 16),
                          _infoChip(context, Icons.qr_code, '${flight.register}'),
                        ],
                      ],
                    ),
                    if (flight.date.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            flight.date,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: theme.colorScheme.primary.withAlpha(180)),
        const SizedBox(width: 4),
        Text(text, style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.5)),
      ],
    );
  }
}
