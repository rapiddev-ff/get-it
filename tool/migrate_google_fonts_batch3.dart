// ignore_for_file: avoid_print
import 'dart:io';

/// Batch 3: Replace more GoogleFonts.inter patterns with theme textTheme
void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('Run from project root');
    exit(1);
  }

  final replacements = <String, String>{
    // 14x: 12/textSecondary
    r'GoogleFonts\.inter\(\s*fontSize:\s*12\.0,\s*color:\s*AppColors\.textSecondary,?\s*\)':
        'Theme.of(context).textTheme.labelSmall!',

    // 10x: w500/17/white
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*17\.0,\s*color:\s*Colors\.white,?\s*\)':
        'Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500, fontSize: 17.0, color: Colors.white)',

    // 5x: w500/white/17 (reversed order)
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*color:\s*Colors\.white,\s*fontSize:\s*17\.0,?\s*\)':
        'Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500, fontSize: 17.0, color: Colors.white)',

    // 9x: empty
    r'GoogleFonts\.inter\(\s*\)':
        'Theme.of(context).textTheme.bodyMedium!',

    // 7x: 14/textSecondary
    r'GoogleFonts\.inter\(\s*fontSize:\s*14\.0,\s*color:\s*AppColors\.textSecondary,?\s*\)':
        'Theme.of(context).textTheme.labelMedium!',

    // 7x: white/18/w500/height:1.5
    r'GoogleFonts\.inter\(\s*color:\s*Colors\.white,\s*fontSize:\s*18\.0,\s*fontWeight:\s*FontWeight\.w500,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, color: Colors.white, height: 1.5)',

    // 5x: white/18/w500 (no height)
    r'GoogleFonts\.inter\(\s*color:\s*Colors\.white,\s*fontSize:\s*18\.0,\s*fontWeight:\s*FontWeight\.w500,?\s*\)':
        'Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, color: Colors.white)',

    // 6x: textSecondary only (comma variant)
    r'GoogleFonts\.inter\(\s*color:\s*AppColors\.textSecondary,\s*\)':
        'Theme.of(context).textTheme.labelMedium!',

    // 5x: textSecondary/14 (reversed)
    r'GoogleFonts\.inter\(\s*color:\s*AppColors\.textSecondary,\s*fontSize:\s*14\.0,?\s*\)':
        'Theme.of(context).textTheme.labelMedium!',

    // 6x: w600/16/white
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w600,\s*fontSize:\s*16\.0,\s*color:\s*Colors\.white,?\s*\)':
        'Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white)',

    // 5x: 15.0 only
    r'GoogleFonts\.inter\(\s*fontSize:\s*15\.0,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0)',

    // 5x: w600 only
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w600,?\s*\)':
        'Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14.0)',

    // 4x: 14/textPrimary (int, not double)
    r'GoogleFonts\.inter\(\s*fontSize:\s*14,\s*color:\s*AppColors\.textPrimary\s*\)':
        'Theme.of(context).textTheme.bodyMedium!',

    // 4x: normal/textSecondary
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.normal,\s*color:\s*AppColors\.textSecondary,?\s*\)':
        'Theme.of(context).textTheme.labelMedium!',

    // 4x: w500/14/secondary
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*14\.0,\s*color:\s*AppColors\.secondary,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, color: AppColors.secondary)',

    // 4x: bold/20/textPrimary
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.bold,\s*fontSize:\s*20\.0,\s*color:\s*AppColors\.textPrimary,?\s*\)':
        'Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)',

    // 4x: 14/textSecondary/height:1.5
    r'GoogleFonts\.inter\(\s*fontSize:\s*14\.0,\s*color:\s*AppColors\.textSecondary,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.labelMedium!.copyWith(height: 1.5)',

    // 4x: 14/height:1.5
    r'GoogleFonts\.inter\(\s*fontSize:\s*14\.0,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(height: 1.5)',

    // 4x: w500/16/height:1.5
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*16\.0,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500, height: 1.5)',

    // 3x: white only
    r'GoogleFonts\.inter\(\s*color:\s*Colors\.white,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)',

    // 3x: w500/textPrimary/height:1.5
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*color:\s*AppColors\.textPrimary,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, height: 1.5)',

    // 3x: w600/16/textPrimary/height:1.5
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w600,\s*fontSize:\s*16\.0,\s*color:\s*AppColors\.textPrimary,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.titleSmall!.copyWith(height: 1.5)',

    // 3x: textSecondary/14/height:1.5
    r'GoogleFonts\.inter\(\s*color:\s*AppColors\.textSecondary,\s*fontSize:\s*14\.0,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.labelMedium!.copyWith(height: 1.5)',

    // 3x: w500/24/textPrimary/height:1.5
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*24\.0,\s*color:\s*AppColors\.textPrimary,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500, height: 1.5)',

    // 3x: 15/textSecondary
    r'GoogleFonts\.inter\(\s*fontSize:\s*15\.0,\s*color:\s*AppColors\.textSecondary,?\s*\)':
        'Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15.0)',

    // 3x: w500/12/textPrimary
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*12\.0,\s*color:\s*AppColors\.textPrimary,?\s*\)':
        'Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)',

    // 3x: w500/28/textPrimary/height:1.5
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*28\.0,\s*color:\s*AppColors\.textPrimary,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500, height: 1.5)',

    // 3x: 16/white
    r'GoogleFonts\.inter\(\s*fontSize:\s*16\.0,\s*color:\s*Colors\.white,?\s*\)':
        'Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white)',

    // 4x: w500/24/height:1.5
    r'GoogleFonts\.inter\(\s*fontWeight:\s*FontWeight\.w500,\s*fontSize:\s*24\.0,\s*height:\s*1\.5,?\s*\)':
        'Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500, height: 1.5)',
  };

  int totalFiles = 0;
  int totalReplacements = 0;
  final changedFiles = <String>[];

  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File) continue;
    final path = entity.path;
    if (!path.endsWith('.dart')) continue;
    if (path.endsWith('.freezed.dart') || path.endsWith('.g.dart')) continue;
    if (path.contains('app_theme.dart')) continue;
    if (path.contains('migrate_')) continue;

    var content = entity.readAsStringSync();
    var original = content;
    int fileReplacements = 0;

    for (final entry in replacements.entries) {
      final regex = RegExp(entry.key, dotAll: true);
      final matches = regex.allMatches(content);
      if (matches.isNotEmpty) {
        fileReplacements += matches.length;
        content = content.replaceAll(regex, entry.value);
      }
    }

    if (content != original) {
      if (!content.contains('GoogleFonts.')) {
        content = content.replaceAll(
          RegExp(r"import 'package:google_fonts/google_fonts\.dart';\n"),
          '',
        );
      }
      entity.writeAsStringSync(content);
      totalFiles++;
      totalReplacements += fileReplacements;
      changedFiles.add('  $path ($fileReplacements replacements)');
    }
  }

  print('Batch 3 GoogleFonts.inter migration complete:');
  print('  $totalReplacements replacements across $totalFiles files');
  for (final f in changedFiles) {
    print(f);
  }
}
