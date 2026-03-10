// ignore_for_file: avoid_print
import 'dart:io';

/// Batch 2: Replace common GoogleFonts.inter patterns with theme textTheme
/// equivalents or .copyWith() variants.
void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('Run from project root');
    exit(1);
  }

  // Patterns: regex -> replacement
  // Theme mapping:
  //   bodySmall:    12.0/normal/textPrimary
  //   bodyMedium:   14.0/normal/textPrimary
  //   bodyLarge:    16.0/normal/textPrimary
  //   labelSmall:   12.0/normal/textSecondary
  //   labelMedium:  14.0/normal/textSecondary
  //   labelLarge:   16.0/normal/textSecondary
  //   titleSmall:   16.0/w600/textPrimary
  //   titleMedium:  18.0/w600/textPrimary
  //   titleLarge:   20.0/w600/textPrimary
  //   headlineSmall: 24.0/w600/textPrimary
  //   headlineMedium: 28.0/bold/textPrimary

  // Simple exact replacements (no height/extra props)
  final simpleReplacements = <String, String>{
    // 29x: error 12.0
    r'GoogleFonts\.inter\(\s*color:\s*AppColors\.error,\s*fontSize:\s*12\.0,?\s*\)':
        'Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.error)',

    // 20x: w500/14/textPrimary
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*14\.0,\s*color:\s*AppColors\.textPrimary,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)',

    // 19x: w500/16/textPrimary
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*16\.0,\s*color:\s*AppColors\.textPrimary,?\s*\)':
        'Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500)',

    // 13x: 15/textPrimary (no trailing comma variant)
    r'GoogleFonts\.inter\(\s*fontSize:\s*15\.0,\s*color:\s*AppColors\.textPrimary\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0)',

    // 10x: 15/textPrimary (trailing comma variant)
    r'GoogleFonts\.inter\(\s*fontSize:\s*15\.0,\s*color:\s*AppColors\.textPrimary,\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0)',

    // 11x: w500/18/textPrimary
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*18\.0,\s*color:\s*AppColors\.textPrimary,?\s*\)':
        'Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500)',

    // 10x: w500/18 (no color — defaults to textPrimary)
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*18\.0,?\s*\)':
        'Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500)',

    // 8x: bold/24 (no color)
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.bold,\s*fontSize:\s*24\.0,?\s*\)':
        'Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)',

    // 5x: bold/24/textPrimary
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.bold,\s*fontSize:\s*24\.0,\s*color:\s*AppColors\.textPrimary,?\s*\)':
        'Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)',

    // 8x: w500/16 (no color)
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*16\.0,?\s*\)':
        'Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500)',

    // 8x: w500/15/textPrimary
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*15\.0,\s*color:\s*AppColors\.textPrimary,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 15.0)',

    // 6x: w600/18 (no color — titleMedium is w600/18 already)
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w600,\s*fontSize:\s*18\.0,?\s*\)':
        'Theme.of(context).textTheme.titleMedium!',

    // 6x: w600/16 (no color — titleSmall is w600/16)
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w600,\s*fontSize:\s*16\.0,?\s*\)':
        'Theme.of(context).textTheme.titleSmall!',

    // 5x: w500/14 (no color)
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*14\.0,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)',

    // 5x: normal/14 (no color)
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.normal,\s*fontSize:\s*14\.0,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!',

    // 5x: 14/textPrimary (no trailing comma)
    r'GoogleFonts\.inter\(\s*fontSize:\s*14\.0,\s*color:\s*AppColors\.textPrimary\s*\)':
        'Theme.of(context).textTheme.bodyMedium!',

    // 5x: 16/textPrimary (no trailing comma)
    r'GoogleFonts\.inter\(\s*fontSize:\s*16\.0,\s*color:\s*AppColors\.textPrimary\s*\)':
        'Theme.of(context).textTheme.bodyLarge!',

    // 5x: normal/15/textSecondary
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.normal,\s*fontSize:\s*15\.0,\s*color:\s*AppColors\.textSecondary,?\s*\)':
        'Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15.0)',

    // 5x: textSecondary only
    r'GoogleFonts\.inter\(\s*color:\s*AppColors\.textSecondary\s*\)':
        'Theme.of(context).textTheme.labelMedium!',

    // 9x: textPrimary only
    r'GoogleFonts\.inter\(\s*color:\s*AppColors\.textPrimary,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!',

    // 13x: 14.0 only
    r'GoogleFonts\.inter\(\s*fontSize:\s*14\.0\s*\)':
        'Theme.of(context).textTheme.bodyMedium!',

    // 5x: 14.0 only (trailing comma)
    r'GoogleFonts\.inter\(\s*fontSize:\s*14\.0,\s*\)':
        'Theme.of(context).textTheme.bodyMedium!',
  };

  // Patterns with height (need copyWith with height)
  final heightReplacements = <String, String>{
    // 14x: 15/textPrimary/height:1.5
    r'GoogleFonts\.inter\(\s*fontSize:\s*15\.0,\s*color:\s*AppColors\.textPrimary,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0, height: 1.5)',

    // 12x: w500/textPrimary/height:1.4
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*color:\s*AppColors\.textPrimary,\s*height:\s*1\.4,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, height: 1.4)',

    // 9x: w500/18/textPrimary/height:1.5
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*18\.0,\s*color:\s*AppColors\.textPrimary,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, height: 1.5)',

    // 9x: textSecondary/12/height:1.5
    r'GoogleFonts\.inter\(\s*color:\s*AppColors\.textSecondary,\s*fontSize:\s*12\.0,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.labelSmall!.copyWith(height: 1.5)',

    // 7x: w500/14/textPrimary/height:1.5
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*14\.0,\s*color:\s*AppColors\.textPrimary,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, height: 1.5)',

    // 6x: normal/14/textSecondary/height:1.5
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.normal,\s*fontSize:\s*14\.0,\s*color:\s*AppColors\.textSecondary,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.labelMedium!.copyWith(height: 1.5)',

    // 6x: textSecondary/height:1.4
    r'GoogleFonts\.inter\(\s*color:\s*AppColors\.textSecondary,\s*height:\s*1\.4,?\s*\)':
        'Theme.of(context).textTheme.labelMedium!.copyWith(height: 1.4)',

    // 5x: normal/14/textPrimary/height:1.5
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.normal,\s*fontSize:\s*14\.0,\s*color:\s*AppColors\.textPrimary,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(height: 1.5)',

    // 5x: w500/15/textPrimary/height:1.5
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*15\.0,\s*color:\s*AppColors\.textPrimary,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 15.0, height: 1.5)',

    // 5x: 14/textPrimary/height:1.5
    r'GoogleFonts\.inter\(\s*fontSize:\s*14\.0,\s*color:\s*AppColors\.textPrimary,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(height: 1.5)',
  };

  final allReplacements = {...simpleReplacements, ...heightReplacements};

  int totalFiles = 0;
  int totalReplacements = 0;
  final changedFiles = <String>[];

  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File) continue;
    final path = entity.path;
    if (!path.endsWith('.dart')) continue;
    if (path.endsWith('.freezed.dart') || path.endsWith('.g.dart')) continue;
    if (path.contains('app_theme.dart')) continue;
    if (path.contains('migrate_google_fonts')) continue;

    var content = entity.readAsStringSync();
    var original = content;
    int fileReplacements = 0;

    for (final entry in allReplacements.entries) {
      final regex = RegExp(entry.key, dotAll: true);
      final matches = regex.allMatches(content);
      if (matches.isNotEmpty) {
        fileReplacements += matches.length;
        content = content.replaceAll(regex, entry.value);
      }
    }

    if (content != original) {
      // Remove unused google_fonts import if no GoogleFonts references remain
      if (!content.contains('GoogleFonts.')) {
        content = content.replaceAll(
          RegExp(r"import 'package:google_fonts/google_fonts\.dart';\n"),
          '',
        );
      }
      // Remove unused app_colors import if no AppColors references remain
      // (unlikely but check)

      entity.writeAsStringSync(content);
      totalFiles++;
      totalReplacements += fileReplacements;
      changedFiles.add('  $path ($fileReplacements replacements)');
    }
  }

  print('Batch 2 GoogleFonts.inter migration complete:');
  print('  $totalReplacements replacements across $totalFiles files');
  print('');
  for (final f in changedFiles) {
    print(f);
  }
}
