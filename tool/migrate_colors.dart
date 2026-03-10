// ignore_for_file: avoid_print
import 'dart:io';

/// Replace hardcoded Color(0x...) values with AppColors constants.
void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('Run from project root');
    exit(1);
  }

  // Mapping: literal string -> replacement
  // Only replace exact matches (with optional const prefix)
  final colorMap = <String, String>{
    // 69x: textSecondary
    '0xFFAFAFB4': 'AppColors.textSecondary',
    // 53x: surfaceDark (dividers, borders)
    '0xFF363636': 'AppColors.surfaceDark',
    // 44x: brandBlue
    '0xFF6187F1': 'AppColors.brandBlue',
    // 38x: brandPurple
    '0xFF7D56FF': 'AppColors.brandPurple',
    // 22x: neutral700 (already exists)
    '0xFF545454': 'AppColors.neutral800', // close to 676767, but 545454 needs its own
    // 19x: neutral700 (7B7B7B already defined)
    '0xFF7B7B7B': 'AppColors.neutral700',
    // 12x: statusYellow
    '0xFFFACC15': 'AppColors.statusYellow',
    // 7x: statusSuccess
    '0xFF4ADE80': 'AppColors.statusSuccess',
    // 7x: brandPurpleLight
    '0xFF9B85FF': 'AppColors.brandPurpleLight',
    // 6x: 111111 — near black
    '0xFF111111': 'AppColors.backgroundPrimary', // close enough to black
    // 5x: statusWarning
    '0xFFD97706': 'AppColors.statusWarning',
    // 5x: destructive500
    '0xFFEF4444': 'AppColors.destructive500',
    // 4x: backgroundSecondary (252525 already defined)
    '0xFF252525': 'AppColors.backgroundSecondary',
    // 4x: primary (8E6CFF already defined)
    '0xFF8E6CFF': 'AppColors.primary',
    // 4x: green success
    '0xFF22C55E': 'AppColors.statusSuccess', // close enough
  };

  int totalFiles = 0;
  int totalReplacements = 0;
  final changedFiles = <String>[];

  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File) continue;
    final path = entity.path;
    if (!path.endsWith('.dart')) continue;
    if (path.endsWith('.freezed.dart') || path.endsWith('.g.dart')) continue;
    if (path.contains('app_colors.dart') || path.contains('app_theme.dart')) continue;
    if (path.contains('migrate_')) continue;

    var content = entity.readAsStringSync();
    var original = content;
    int fileReplacements = 0;

    for (final entry in colorMap.entries) {
      final hex = entry.key;
      final replacement = entry.value;

      // Match Color(0xHEX) with optional const and whitespace
      final pattern = RegExp('(?:const\\s+)?Color\\(\\s*$hex\\s*\\)');
      final matches = pattern.allMatches(content);
      if (matches.isNotEmpty) {
        fileReplacements += matches.length;
        content = content.replaceAll(pattern, replacement);
      }
    }

    if (content != original) {
      // Ensure AppColors import exists
      if (!content.contains("import '/core/theme/app_colors.dart'") &&
          !content.contains("import 'package:get_it/core/theme/app_colors.dart'")) {
        // Add import after first import line
        content = content.replaceFirst(
          RegExp(r"(import '[^']+';)\n"),
          "\$1\nimport '/core/theme/app_colors.dart';\n",
        );
      }

      entity.writeAsStringSync(content);
      totalFiles++;
      totalReplacements += fileReplacements;
      changedFiles.add('  $path ($fileReplacements replacements)');
    }
  }

  print('Color migration complete:');
  print('  $totalReplacements replacements across $totalFiles files');
  print('');
  for (final f in changedFiles) {
    print(f);
  }
}
