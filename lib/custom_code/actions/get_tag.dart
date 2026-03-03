Future<String?> getTag(String? text) async {
  // Add your function code here!
  if (text == null || text.isEmpty) return null;

  if (text.contains(' ') || text.contains(',')) {
    return text.replaceAll(' ', '').replaceAll(',', '');
  }

  return null;
}
