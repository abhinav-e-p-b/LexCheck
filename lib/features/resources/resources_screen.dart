import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/theme/app_style.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/labels.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final Map<int, bool> _checklist = {0: false, 1: false, 2: true, 3: false};

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final checklistItems = isDark
        ? const [
            'Contacted Primary Guardians',
            'Shared Current Geo-Location',
            'Enabled Low Power Mode',
            'Secured Physical Perimeter',
          ]
        : const [
            'State your location clearly to the dispatcher.',
            'Keep the phone line open and accessible.',
            'Identify immediate hazards around you.',
            'Maintain visual of the entrance/exit.',
          ];

    return Scaffold(
      appBar: const AppTopBar(),
      floatingActionButton: isDark
          ? FloatingActionButton.extended(
              backgroundColor: Colors.red.shade700,
              onPressed: () {},
              label: const Text('SOS',
                  style: TextStyle(fontWeight: FontWeight.w800)),
            )
          : null,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            AppCard(
              alt: !isDark,
              borderColor: isDark ? style.accentColor : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      BadgeChip(
                        text: isDark
                            ? 'EMERGENCY_RESOURCES_PROTOCOL'
                            : 'LIVE STATUS: ACTIVE',
                        background: style.accentColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isDark
                        ? 'Executing utility grid lookup... All services '
                            'operational. Select primary directive for '
                            'immediate assistance.'
                        : 'Immediate access to essential services. If you '
                            'are in immediate danger, use the rapid-dial '
                            'icons or locate your required department below.',
                    style: TextStyle(
                        fontSize: 12.5, color: style.inkMutedColor, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (!isDark) ...[
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: style.cardBackground,
                        border: Border.all(
                            color: style.borderColor, width: style.borderWidth),
                      ),
                      child: TextField(
                        style: TextStyle(color: style.inkColor, fontSize: 13),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search resource_id...',
                          hintStyle: TextStyle(color: style.inkMutedColor),
                          prefixIcon:
                              Icon(Icons.search, color: style.inkMutedColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: style.borderColor, width: style.borderWidth),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.filter_list, size: 16, color: style.inkColor),
                    const SizedBox(width: 8),
                    Text('FILTERS',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: style.inkColor)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            for (final service in isDark
                ? MockData.emergencyServices.take(3).toList()
                : MockData.emergencyServices) ...[
              _EmergencyCard(service: service),
              const SizedBox(height: 14),
            ],
            if (isDark) ...[
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 14, color: style.accentColor),
                          const SizedBox(width: 6),
                          Text('LOCAL_MAP_PING: 0.04MS',
                              style: TextStyle(
                                  fontSize: 11, color: style.inkMutedColor)),
                        ],
                      ),
                    ),
                    Container(
                      height: 110,
                      width: double.infinity,
                      color: style.cardBackgroundAlt,
                      child: Icon(Icons.map_outlined,
                          size: 40, color: style.inkMutedColor.withValues(alpha: 0.5)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NEAREST POLICE STATION',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  color: style.accentColor)),
                          const SizedBox(height: 4),
                          Text('Sector 12 Control Room - 0.4km away',
                              style: TextStyle(
                                  fontSize: 12, color: style.inkMutedColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 110,
                      width: double.infinity,
                      color: style.cardBackgroundAlt,
                      child: Icon(Icons.map_outlined,
                          size: 40, color: style.inkMutedColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 14, color: style.inkColor),
                              const SizedBox(width: 6),
                              Text('NEAREST POLICE STATION',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      color: style.inkColor)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Central District Precinct #42',
                              style: TextStyle(
                                  fontSize: 12, color: style.inkColor)),
                          Text('1288 Digital Avenue, Suite 101',
                              style: TextStyle(
                                  fontSize: 11, color: style.inkMutedColor)),
                          const SizedBox(height: 6),
                          Text('GET_DIRECTIONS.EXE',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: style.accentColor,
                                  decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            AppCard(
              borderColor: isDark ? style.accentColor : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDark ? 'CRITICAL STATUS VERIFICATION' : 'EMERGENCY CHECKLIST',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: style.inkColor),
                  ),
                  const SizedBox(height: 10),
                  for (var i = 0; i < checklistItems.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _checklist[i] ?? false,
                            activeColor: style.accentColor,
                            onChanged: (v) =>
                                setState(() => _checklist[i] = v ?? false),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(checklistItems[i],
                                  style: TextStyle(
                                      fontSize: 12.5, color: style.inkColor)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (isDark) ...[
                    const SizedBox(height: 8),
                    Center(
                      child: Text('WIPE_SESSION_LOGS',
                          style: TextStyle(
                              fontSize: 11,
                              color: style.accentColor,
                              decoration: TextDecoration.underline)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  const _EmergencyCard({required this.service});
  final EmergencyService service;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: style.cardBackgroundAlt,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(_iconFor(service.title),
                    color: style.inkColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDark)
                      Text('SERVICE_TYPE: ${_typeFor(service.title)}',
                          style: TextStyle(
                              fontSize: 10, color: style.inkMutedColor))
                    else
                      Text('ID: ${service.id}',
                          style: TextStyle(
                              fontSize: 10, color: style.inkMutedColor)),
                    Text(service.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: style.inkColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(service.description,
              style: TextStyle(fontSize: 12, color: style.inkMutedColor)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: style.accentColor,
                    borderRadius: BorderRadius.circular(style.cardRadius),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.call, size: 15, color: Colors.black87),
                      const SizedBox(width: 6),
                      Text('CALL ${service.number}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: Colors.black87)),
                    ],
                  ),
                ),
              ),
              if (!isDark) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: style.borderColor),
                  ),
                  child: Icon(Icons.ios_share, size: 16, color: style.inkColor),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String title) {
    switch (title) {
      case 'National Emergency':
        return Icons.local_police_outlined;
      case 'Women Helpline':
        return Icons.support_agent;
      case 'Cyber Crime':
        return Icons.security;
      case 'Child Helpline':
        return Icons.child_care;
      case 'Disaster Response':
        return Icons.warning_amber_rounded;
      default:
        return Icons.gavel;
    }
  }

  String _typeFor(String title) {
    switch (title) {
      case 'National Emergency':
        return 'UNIVERSAL';
      case 'Women Helpline':
        return 'PROTECTION';
      case 'Cyber Crime':
        return 'DIGITAL';
      default:
        return 'GENERAL';
    }
  }
}
