import 'package:flutter/material.dart';
import '../../theme/juice_theme.dart';

/// Shared helper methods and widgets for result displays.
/// 
/// These were extracted from result_display_builder.dart to avoid
/// duplication across display modules.
/// 
/// Usage:
/// ```dart
/// import 'base_display_helpers.dart';
/// 
/// Widget buildMyDisplay(MyResult result, ThemeData theme) {
///   return Column(
///     children: [
///       buildSectionHeader('Details', theme),
///       buildLabeledValue('Type', result.type, theme, roll: result.roll),
///       buildDivider(),
///     ],
///   );
/// }
/// ```

/// Build a section header with optional subtitle.
Widget buildSectionHeader(
  String title, 
  ThemeData theme, {
  String? subtitle,
  IconData? icon,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 4),
    child: Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: JuiceTheme.gold),
          const SizedBox(width: 6),
        ],
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: JuiceTheme.gold,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(width: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: JuiceTheme.parchmentDark.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    ),
  );
}

/// Build a labeled value row with optional roll display.
Widget buildLabeledValue(
  String label,
  String value,
  ThemeData theme, {
  int? roll,
  bool highlight = false,
  double labelWidth = 90,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: JuiceTheme.parchmentDark.withValues(alpha: 0.8),
            ),
          ),
        ),
        if (roll != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: JuiceTheme.inkDark,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              '$roll',
              style: theme.textTheme.bodySmall?.copyWith(
                color: JuiceTheme.parchmentDark.withValues(alpha: 0.6),
                fontFamily: JuiceTheme.fontFamilyMono,
                fontSize: 10,
              ),
            ),
          ),
        ],
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: highlight ? JuiceTheme.gold : JuiceTheme.parchment,
              fontWeight: highlight ? FontWeight.w600 : null,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Build a compact die result display box.
Widget buildDieBox(
  int value, 
  ThemeData theme, {
  Color? color,
  bool large = false,
}) {
  return Container(
    width: large ? 36 : 28,
    height: large ? 36 : 28,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color ?? JuiceTheme.inkDark,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(
        color: JuiceTheme.parchmentDark.withValues(alpha: 0.3),
      ),
    ),
    child: Text(
      '$value',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: JuiceTheme.parchment,
        fontFamily: JuiceTheme.fontFamilyMono,
        fontWeight: FontWeight.bold,
        fontSize: large ? 16 : 12,
      ),
    ),
  );
}

/// Build an Ironsworn-style die box with color coding.
Widget buildIronswornDieBox(
  int value,
  ThemeData theme, {
  required bool isActionDie,
  bool isChallenge1 = false,
  bool isChallenge2 = false,
}) {
  Color bgColor;
  Color textColor = JuiceTheme.parchment;
  
  if (isActionDie) {
    bgColor = JuiceTheme.mystic;
  } else if (isChallenge1) {
    bgColor = JuiceTheme.danger.withValues(alpha: 0.8);
  } else {
    bgColor = JuiceTheme.rust;
  }
  
  return Container(
    width: 32,
    height: 32,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      '$value',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
        fontFamily: JuiceTheme.fontFamilyMono,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

/// Get outcome color for Ironsworn/challenge results.
Color getChallengeColor(String outcome) {
  switch (outcome.toLowerCase()) {
    case 'strong hit':
      return JuiceTheme.success;
    case 'weak hit':
      return JuiceTheme.gold;
    case 'miss':
      return JuiceTheme.danger;
    default:
      return JuiceTheme.parchment;
  }
}

/// Build a standard divider line.
Widget buildDivider() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Divider(
      color: JuiceTheme.parchmentDark.withValues(alpha: 0.2),
      height: 1,
    ),
  );
}

/// Build a highlighted phrase (for key results).
Widget buildHighlightedPhrase(
  String text, 
  ThemeData theme, {
  TextAlign align = TextAlign.start,
  bool large = false,
}) {
  return Text(
    text,
    textAlign: align,
    style: (large ? theme.textTheme.titleLarge : theme.textTheme.titleMedium)?.copyWith(
      color: JuiceTheme.parchment,
      fontWeight: FontWeight.w600,
    ),
  );
}

/// Build a roll indicator tag.
Widget buildRollTag(
  int roll,
  ThemeData theme, {
  String? prefix,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: JuiceTheme.inkDark,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      prefix != null ? '$prefix: $roll' : '$roll',
      style: theme.textTheme.bodySmall?.copyWith(
        color: JuiceTheme.parchmentDark.withValues(alpha: 0.7),
        fontFamily: JuiceTheme.fontFamilyMono,
        fontSize: 11,
      ),
    ),
  );
}

/// Build a special outcome badge (for yes/no, match, etc.).
Widget buildOutcomeBadge(
  String text,
  ThemeData theme, {
  Color? color,
  bool filled = true,
}) {
  final badgeColor = color ?? JuiceTheme.gold;
  
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: filled ? badgeColor.withValues(alpha: 0.2) : Colors.transparent,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: badgeColor),
    ),
    child: Text(
      text.toUpperCase(),
      style: theme.textTheme.labelMedium?.copyWith(
        color: badgeColor,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    ),
  );
}
