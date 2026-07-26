import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/data/mock_data.dart';
import '../../core/data/models.dart';
import '../../core/providers/mock_providers.dart';
import '../../core/theme/app_style.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/labels.dart';
import 'providers/resources_providers.dart';
import 'resource_detail_screen.dart';

class ResourcesScreen extends ConsumerStatefulWidget {
  const ResourcesScreen({super.key});

  @override
  ConsumerState<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends ConsumerState<ResourcesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final checklist = ref.watch(checklistProvider);
    final filteredServices = ref.watch(filteredResourcesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final favorites = ref.watch(favoritesProvider);
    final recentlyContacted = ref.watch(recentlyContactedProvider);

    final allServices = ref.watch(emergencyServicesProvider);
    final favoriteServices = allServices
        .where((s) => favorites.contains(s.id))
        .toList();
    final recentServices = ref
        .read(resourcesRepositoryProvider)
        .getByIds(recentlyContacted);

    final checklistItems = isDark
        ? MockData.darkChecklistItems
        : MockData.lightChecklistItems;

    return Scaffold(
      appBar: const AppTopBar(),
      floatingActionButton: isDark
          ? FloatingActionButton.extended(
              backgroundColor: Colors.red.shade700,
              onPressed: () => _callEmergency(context, style),
              label: const Text('SOS',
                  style: TextStyle(fontWeight: FontWeight.w800)),
            )
          : null,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            // ── Header banner ──────────────────────────────────────────────
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
                        foreground: Colors.black87,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isDark
                        ? 'Executing utility grid lookup... All services '
                            'operational. Select primary directive for '
                            'immediate assistance.'
                        : 'Immediate access to essential legal and emergency '
                            'services. Search, filter, or browse all categories '
                            'below. Tap any card for details.',
                    style: TextStyle(
                        fontSize: 12.5,
                        color: style.inkMutedColor,
                        height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Search bar (light mode shows it inline, dark hides it) ─────
            if (!isDark) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: style.cardBackground,
                  border: Border.all(
                      color: style.borderColor, width: style.borderWidth),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (q) =>
                      ref.read(resourceSearchQueryProvider.notifier).state = q,
                  style: TextStyle(color: style.inkColor, fontSize: 13),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search by name, keyword or number...',
                    hintStyle: TextStyle(color: style.inkMutedColor),
                    prefixIcon:
                        Icon(Icons.search, color: style.inkMutedColor),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: style.inkMutedColor),
                            onPressed: () {
                              _searchController.clear();
                              ref
                                  .read(resourceSearchQueryProvider.notifier)
                                  .state = '';
                            },
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // ── Category filter chips ─────────────────────────────────────
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _FilterChip(
                      label: 'All',
                      selected: selectedCategory == null,
                      style: style,
                      onTap: () => ref
                          .read(selectedCategoryProvider.notifier)
                          .state = null,
                    ),
                    ...MockData.resourceCategories.map((cat) => _FilterChip(
                          label: cat,
                          selected: selectedCategory == cat,
                          style: style,
                          onTap: () => ref
                              .read(selectedCategoryProvider.notifier)
                              .state = selectedCategory == cat ? null : cat,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Resource cards ─────────────────────────────────────────────
            if (filteredServices.isEmpty)
              _EmptyState(style: style)
            else
              for (final service in isDark
                  ? filteredServices.take(3).toList()
                  : filteredServices) ...[
                _EmergencyCard(service: service),
                const SizedBox(height: 14),
              ],

            // ── Nearby Services ────────────────────────────────────────────
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
                          Text('LOCAL_MAP_PING: ACTIVE',
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
                          size: 40,
                          color: style.inkMutedColor.withValues(alpha: 0.5)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NEAREST SERVICES',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  color: style.accentColor)),
                          const SizedBox(height: 10),
                          ...nearbyServiceTypes.map((svc) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _NearbyServiceButton(
                                    service: svc, style: style),
                              )),
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
                              Text('NEARBY SERVICES',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      color: style.inkColor)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...nearbyServiceTypes.map((svc) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _NearbyServiceButton(
                                    service: svc, style: style),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),

            // ── Emergency checklist ────────────────────────────────────────
            AppCard(
              borderColor: isDark ? style.accentColor : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isDark
                            ? 'CRITICAL STATUS VERIFICATION'
                            : 'EMERGENCY CHECKLIST',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, color: style.inkColor),
                      ),
                      GestureDetector(
                        onTap: () =>
                            ref.read(checklistProvider.notifier).resetAll(),
                        child: Text(
                          'RESET',
                          style: TextStyle(
                              fontSize: 10,
                              color: style.accentColor,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  for (var i = 0; i < checklistItems.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: checklist[i] ?? false,
                            activeColor: style.accentColor,
                            onChanged: (v) => ref
                                .read(checklistProvider.notifier)
                                .toggle(i, v ?? false),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                checklistItems[i],
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: (checklist[i] ?? false)
                                      ? style.inkMutedColor
                                      : style.inkColor,
                                  decoration: (checklist[i] ?? false)
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 6),
                  // Progress indicator
                  Builder(builder: (context) {
                    final done =
                        checklist.values.where((v) => v).length.toDouble();
                    final total = checklistItems.length.toDouble();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: total == 0 ? 0 : done / total,
                            minHeight: 5,
                            backgroundColor:
                                style.borderColor.withValues(alpha: 0.25),
                            valueColor:
                                AlwaysStoppedAnimation(style.accentColor),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${done.toInt()} of ${total.toInt()} completed',
                          style: TextStyle(
                              fontSize: 10, color: style.inkMutedColor),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),

            // ── Favourites ─────────────────────────────────────────────────
            if (favoriteServices.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'FAVOURITES',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: style.inkMutedColor),
              ),
              const SizedBox(height: 10),
              for (final s in favoriteServices) ...[
                _EmergencyCard(service: s),
                const SizedBox(height: 14),
              ],
            ],

            // ── Recently Contacted ─────────────────────────────────────────
            if (recentServices.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'RECENTLY CONTACTED',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: style.inkMutedColor),
              ),
              const SizedBox(height: 10),
              for (final s in recentServices) ...[
                _EmergencyCard(service: s),
                const SizedBox(height: 14),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _callEmergency(BuildContext context, AppStyle style) async {
    final uri = Uri(scheme: 'tel', path: '112');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not launch call to 112'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }
}

// ── Nearby service button ──────────────────────────────────────────────────────

class _NearbyServiceButton extends StatefulWidget {
  const _NearbyServiceButton({required this.service, required this.style});
  final NearbyServiceType service;
  final AppStyle style;

  @override
  State<_NearbyServiceButton> createState() => _NearbyServiceButtonState();
}

class _NearbyServiceButtonState extends State<_NearbyServiceButton> {
  bool _loading = false;

  Future<void> _open() async {
    setState(() => _loading = true);
    final result = await getCurrentLocation();
    if (!mounted) return;
    setState(() => _loading = false);

    switch (result) {
      case LocationSuccess(:final position):
        final lat = position.latitude;
        final lng = position.longitude;
        final query = Uri.encodeComponent(
            '${widget.service.mapsQuery} near $lat,$lng');
        final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) _showErr('Could not open Google Maps.');
        }
      case LocationDenied(:final message):
        _showErr(message);
      case LocationUnavailable(:final message):
        _showErr(message);
    }
  }

  void _showErr(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red.shade400),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    return InkWell(
      onTap: _loading ? null : _open,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: style.borderColor, width: style.borderWidth),
          borderRadius: BorderRadius.circular(style.cardRadius),
        ),
        child: Row(
          children: [
            Text(widget.service.icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Find nearest ${widget.service.label}',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: style.inkColor),
              ),
            ),
            if (_loading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: style.accentColor),
              )
            else
              Icon(Icons.open_in_new, size: 14, color: style.inkMutedColor),
          ],
        ),
      ),
    );
  }
}

// ── Resource card ──────────────────────────────────────────────────────────────

class _EmergencyCard extends ConsumerWidget {
  const _EmergencyCard({required this.service});
  final EmergencyService service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFav = ref.watch(
        favoritesProvider.select((set) => set.contains(service.id)));

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ResourceDetailScreen(service: service),
          ),
        );
      },
      child: AppCard(
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
                  child: Icon(_iconFor(service.category),
                      color: style.inkColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isDark)
                        Text(
                            'SERVICE_TYPE: ${_typeFor(service.category)}',
                            style: TextStyle(
                                fontSize: 10, color: style.inkMutedColor))
                      else
                        Text(service.category,
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
                GestureDetector(
                  onTap: () =>
                      ref.read(favoritesProvider.notifier).toggle(service.id),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: isFav ? Colors.red.shade400 : style.inkMutedColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(service.description,
                style: TextStyle(fontSize: 12, color: style.inkMutedColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _call(context, ref, service, style),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: style.accentColor,
                        borderRadius: BorderRadius.circular(style.cardRadius),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.call,
                              size: 15, color: Colors.black87),
                          const SizedBox(width: 6),
                          Text(
                            'CALL ${service.number}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isDark) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _share(service),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: style.borderColor),
                      ),
                      child:
                          Icon(Icons.ios_share, size: 16, color: style.inkColor),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _call(BuildContext context, WidgetRef ref,
      EmergencyService service, AppStyle style) async {
    ref.read(recentlyContactedProvider.notifier).add(service.id);
    final uri = Uri(scheme: 'tel', path: service.number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not call ${service.number}'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  void _share(EmergencyService service) {
    Share.share(
      '${service.title}\nPhone: ${service.number}\n'
      '${service.website ?? ''}\n\n${service.description}\n'
      '\nShared via LexCheck – Legal Awareness App',
    );
  }

  IconData _iconFor(String category) {
    switch (category) {
      case 'Emergency':
        return Icons.local_police_outlined;
      case 'Women Safety':
        return Icons.support_agent;
      case 'Child Protection':
        return Icons.child_care;
      case 'Cyber Crime':
        return Icons.security;
      case 'Legal Aid':
        return Icons.gavel;
      case 'Consumer Rights':
        return Icons.shopping_bag_outlined;
      case 'Mental Health':
        return Icons.psychology_outlined;
      case 'Disaster Management':
        return Icons.warning_amber_rounded;
      case 'Road Safety':
        return Icons.directions_car_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String _typeFor(String category) {
    switch (category) {
      case 'Emergency':
        return 'UNIVERSAL';
      case 'Women Safety':
        return 'PROTECTION';
      case 'Cyber Crime':
        return 'DIGITAL';
      case 'Child Protection':
        return 'CHILD_CARE';
      case 'Legal Aid':
        return 'LEGAL';
      case 'Consumer Rights':
        return 'CONSUMER';
      case 'Mental Health':
        return 'HEALTH';
      case 'Disaster Management':
        return 'DISASTER';
      case 'Road Safety':
        return 'ROAD';
      default:
        return 'GENERAL';
    }
  }
}

// ── Filter chip ────────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.style,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final AppStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? style.accentColor : style.cardBackground,
          border: Border.all(
            color: selected ? style.accentColor : style.borderColor,
            width: style.borderWidth,
          ),
          borderRadius: BorderRadius.circular(style.cardRadius),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.black87 : style.inkColor,
          ),
        ),
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.style});
  final AppStyle style;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Icon(Icons.search_off, size: 36, color: style.inkMutedColor),
          const SizedBox(height: 10),
          Text(
            'No resources found.',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: style.inkColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Try a different keyword or clear the filter.',
            style: TextStyle(fontSize: 12, color: style.inkMutedColor),
          ),
        ],
      ),
    );
  }
}
