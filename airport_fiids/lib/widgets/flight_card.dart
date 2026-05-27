import 'package:flutter/material.dart';
import '../models/flight.dart';

class FlightCard extends StatelessWidget {
  final Flight flight;
  final int index;

  const FlightCard({super.key, required this.flight, this.index = 0});

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: statusColor.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      statusColor.withAlpha(200),
                      statusColor.withAlpha(80),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  flight.airline,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                    color: Colors.grey.shade800,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary
                                            .withAlpha(12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        flight.flightNumber,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.primary,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.flight,
                                        size: 12,
                                        color: Colors.grey.shade400),
                                    const SizedBox(width: 3),
                                    Text(
                                      flight.origin,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: statusColor.withAlpha(18),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: statusColor.withAlpha(60)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(statusIcon,
                                    size: 13, color: statusColor),
                                const SizedBox(width: 4),
                                Text(
                                  flight.status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            _infoDot(context, Icons.access_time,
                                '${flight.dayTime}${flight.actualTime.isNotEmpty ? ' → ${flight.actualTime}' : ''}',
                                theme),
                            const SizedBox(width: 14),
                            if (flight.aircraft.isNotEmpty)
                              _infoDot(context, Icons.airplanemode_active,
                                  flight.aircraft, theme),
                            const Spacer(),
                            if (flight.register.isNotEmpty)
                              _infoDot(context, Icons.qr_code,
                                  flight.register, theme),
                          ],
                        ),
                      ),
                      if (flight.date.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 11, color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text(
                              flight.date,
                              style: TextStyle(
                                fontSize: 10.5,
                                color: Colors.grey.shade400,
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
      ),
    );
  }

  Widget _infoDot(
      BuildContext context, IconData icon, String text, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: theme.colorScheme.primary.withAlpha(150)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
