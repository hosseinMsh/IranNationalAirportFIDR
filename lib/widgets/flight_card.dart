import 'package:flutter/material.dart';
import '../models/flight.dart';
import '../services/translations.dart';

class FlightCard extends StatelessWidget {
  final Flight flight;
  final int index;
  final VoidCallback? onTap;

  const FlightCard({
    super.key,
    required this.flight,
    this.index = 0,
    this.onTap,
  });

  Color _statusColor(String status) {
    if (status.contains('نشست') || status.contains('پروازکرد')) return const Color(0xFF2E7D32);
    if (status.contains('تاخیر') || status.contains('لغو')) return const Color(0xFFC62828);
    if (status.contains('طبق برنامه')) return const Color(0xFF1565C0);
    if (status.contains('پذیرش') || status.contains('در حال')) return const Color(0xFFEF6C00);
    return const Color(0xFF757575);
  }

  IconData _statusIcon(String status) {
    if (status.contains('نشست')) return Icons.flight_land_rounded;
    if (status.contains('پروازکرد')) return Icons.flight_takeoff_rounded;
    if (status.contains('تاخیر')) return Icons.schedule_rounded;
    if (status.contains('لغو')) return Icons.cancel_rounded;
    if (status.contains('طبق برنامه')) return Icons.check_circle_rounded;
    if (status.contains('پذیرش')) return Icons.assignment_turned_in_rounded;
    if (status.contains('در حال')) return Icons.hourglass_top_rounded;
    return Icons.help_outline_rounded;
  }

  String _localizedStatus(String status) {
    final t = TranslationService.instance;
    if (status.contains('نشست')) return t.tr('statusLanded');
    if (status.contains('پروازکرد')) return t.tr('statusDeparted');
    if (status.contains('تاخیر')) return t.tr('statusDelayed');
    if (status.contains('لغو')) return t.tr('statusCancelled');
    if (status.contains('طبق برنامه')) return t.tr('statusOnSchedule');
    if (status.contains('پذیرش')) return t.tr('statusCheckIn');
    if (status.contains('در حال')) return t.tr('statusInProgress');
    return status;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(flight.status);
    final statusIcon = _statusIcon(flight.status);
    final statusText = _localizedStatus(flight.status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200, width: 0.6),
            boxShadow: [
              BoxShadow(
                color: statusColor.withAlpha(12),
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
                                  Row(
                                    children: [
                                      if (flight.airlineLogoUrl != null)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 6),
                                          child: Image.network(
                                            flight.airlineLogoUrl!,
                                            width: 20,
                                            height: 20,
                                            errorBuilder: (_, __, ___) =>
                                                const SizedBox(width: 20, height: 20),
                                          ),
                                        ),
                                      Expanded(
                                        child: Text(
                                          flight.airline.isNotEmpty
                                              ? flight.airline
                                              : '---',
                                          style: theme.textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.5,
                                            color: Colors.grey.shade900,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary
                                              .withAlpha(12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          flight.flightNumber,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: theme.colorScheme.primary,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(Icons.flight,
                                          size: 13,
                                          color: Colors.grey.shade400),
                                      const SizedBox(width: 4),
                                      Text(
                                        flight.origin,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w500,
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
                                color: statusColor.withAlpha(16),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: statusColor.withAlpha(60),
                                    width: 0.8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(statusIcon,
                                      size: 13, color: statusColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    statusText,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 11,
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
                              horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200, width: 0.5),
                          ),
                          child: Row(
                            children: [
                              _infoDot(
                                context,
                                Icons.access_time_rounded,
                                '${flight.dayTime}${flight.actualTime.isNotEmpty ? '  →  ${flight.actualTime}' : ''}',
                                theme,
                              ),
                              if (flight.aircraft.isNotEmpty) ...[
                                const SizedBox(width: 14),
                                _infoDot(context, Icons.airplanemode_active,
                                    flight.aircraft, theme),
                              ],
                              const Spacer(),
                              Icon(Icons.chevron_left_rounded,
                                  size: 18, color: Colors.grey.shade400),
                            ],
                          ),
                        ),
                        if (flight.date.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.calendar_today_rounded,
                                  size: 11, color: Colors.grey.shade400),
                              const SizedBox(width: 4),
                              Text(
                                flight.date,
                                style: TextStyle(
                                  fontSize: 10.5,
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
        ),
      ),
    );
  }

  Widget _infoDot(
      BuildContext context, IconData icon, String text, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: theme.colorScheme.primary.withAlpha(160)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
