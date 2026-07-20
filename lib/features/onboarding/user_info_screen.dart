import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/theme/app_style.dart';
import '../../core/widgets/app_button.dart';
import '../shell/main_shell.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  String _ageGroup = '13-15';
  String _selectedState = 'Kerala';
  final _searchController = TextEditingController();

  static const _ageGroups = ['13-15', '16-18', '18-21'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final states = MockData.indianStates
        .where((s) =>
            s.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final active = i == 0;
                  return Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: active ? style.accentColor : Colors.transparent,
                      border: Border.all(color: style.inkMutedColor),
                      borderRadius:
                          BorderRadius.circular(isDark ? 20 : 0),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Text(
                'Tell us a bit about you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: style.inkColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'This helps us tailor the legal information for your specific '
                'region and context.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: style.inkMutedColor),
              ),
              const SizedBox(height: 28),
              Text(
                'How old are you?',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: style.inkColor,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: _ageGroups.map((age) {
                  final selected = age == _ageGroup;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _ageGroup = age),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: selected
                              ? style.accentColor
                              : style.cardBackground,
                          borderRadius:
                              BorderRadius.circular(isDark ? 24 : 0),
                          border: Border.all(
                            color: selected
                                ? style.accentColor
                                : style.borderColor,
                            width: style.borderWidth,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            age,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? (isDark
                                      ? style.scaffoldBackground
                                      : style.inkColor)
                                  : style.inkColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text(
                'Where are you located?',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: style.inkColor,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: style.cardBackground,
                  borderRadius: BorderRadius.circular(style.cardRadius),
                  border: Border.all(
                      color: style.borderColor, width: style.borderWidth),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 4),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        style: TextStyle(color: style.inkColor),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon:
                              Icon(Icons.search, color: style.inkMutedColor),
                          hintText: isDark
                              ? 'Search Indian states...'
                              : 'SEARCH STATE...',
                          hintStyle: TextStyle(color: style.inkMutedColor),
                        ),
                      ),
                    ),
                    Divider(height: 1, color: style.borderColor),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 220),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: states.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 1, color: style.borderColor),
                        itemBuilder: (context, i) {
                          final state = states[i];
                          final selected = state == _selectedState;
                          return ListTile(
                            onTap: () =>
                                setState(() => _selectedState = state),
                            tileColor: selected
                                ? style.cardBackgroundAlt
                                : Colors.transparent,
                            title: Text(
                              state,
                              style: TextStyle(
                                color: selected
                                    ? style.accentColor
                                    : style.inkColor,
                                fontStyle: selected
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            ),
                            trailing: selected
                                ? Icon(Icons.check_circle,
                                    color: style.accentColor, size: 20)
                                : null,
                          );
                        },
                      ),
                    ),
                    if (!isDark)
                      Container(
                        width: double.infinity,
                        color: style.inkColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('SCROLL FOR MORE',
                                style: TextStyle(
                                    color: style.scaffoldBackground,
                                    fontSize: 10)),
                            Text('V1.0.4-BETA',
                                style: TextStyle(
                                    color: style.scaffoldBackground,
                                    fontSize: 10)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              AppButton(
                label: 'CONTINUE',
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MainShell()),
                  (route) => false,
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MainShell()),
                    (route) => false,
                  ),
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      color: style.inkMutedColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
