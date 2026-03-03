/// Shared form validation utilities used across profile pages.

class FormValidators {
  FormValidators._();

  // ── Profanity check ──────────────────────────────────────────────────

  static bool containsProfanity(String text) {
    final normalized = text
        .toLowerCase()
        .replaceAll('0', 'o')
        .replaceAll('1', 'i')
        .replaceAll('3', 'e')
        .replaceAll('4', 'a')
        .replaceAll('5', 's')
        .replaceAll('7', 't')
        .replaceAll('8', 'b')
        .replaceAll('\$', 's')
        .replaceAll('_', '')
        .replaceAll('-', '')
        .replaceAll('.', '');

    const blockedWords = [
      'fuck',
      'shit',
      'ass',
      'bitch',
      'cunt',
      'dick',
      'porn',
      'xxx',
      'asshole',
      'bastard',
      'slut',
      'whore',
      'faggot',
      'nigger',
      'nigga',
      'cock',
      'pussy',
      'penis',
      'vagina',
      'boob',
      'tits',
      'anal',
      'sex',
      'rape',
      'molest',
      'pedo',
      'nazi',
      'hitler',
      'retard',
      'fag',
    ];

    for (final word in blockedWords) {
      if (normalized.contains(word)) return true;
    }
    return false;
  }

  // ── Username ─────────────────────────────────────────────────────────

  static String normalizeUsername(String? username) {
    if (username == null || username.trim().isEmpty) return '';
    String cleaned = username.trim();
    if (cleaned.startsWith('@')) cleaned = cleaned.substring(1);
    return cleaned;
  }

  /// Returns 'valid' when the username passes all checks, otherwise an
  /// error message string.
  static String usernameValidationResult(String? username) {
    if (username == null || username.trim().isEmpty) {
      return 'Username is required';
    }

    String cleaned = username.trim();
    int atCount = '@'.allMatches(cleaned).length;
    bool startsWithAt = cleaned.startsWith('@');

    if (atCount > 1 || (atCount == 1 && !startsWithAt)) {
      return '"@" can only be used at the beginning of the username.';
    }

    String normalized = startsWithAt ? cleaned.substring(1) : cleaned;

    if (normalized.isEmpty) return 'Username is required';
    if (normalized.length < 3) {
      return 'Username must be at least 3 characters long.';
    }
    if (normalized.length > 20) {
      return 'Username must be no longer than 20 characters.';
    }
    if (!RegExp(r'^[a-zA-Z0-9_\.]+$').hasMatch(normalized)) {
      return 'Username can contain only letters, numbers, "_" and "."';
    }

    return 'valid';
  }

  // ── Phone ────────────────────────────────────────────────────────────

  /// Returns null when valid, or an error message string.
  static String? phoneValidationResult(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      return 'Phone number is required';
    }

    String cleaned = phoneNumber.trim();
    String digitsOnly = cleaned.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10) return 'Phone number is too short';
    if (digitsOnly.length > 15) return 'Phone number is too long';

    if (digitsOnly.length == 10) return null;

    if (digitsOnly.length == 11) {
      if (!digitsOnly.startsWith('1') && !digitsOnly.startsWith('7')) {
        return 'Invalid country code';
      }
      return null;
    }

    if (digitsOnly.length >= 12 && digitsOnly.length <= 15) return null;

    return 'Invalid phone number format';
  }

  /// Strips non-digit characters (keeping leading +).
  static String formatPhoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (phone.startsWith('+') && !cleaned.startsWith('+')) {
      cleaned = '+$cleaned';
    }
    return cleaned;
  }

  // ── Payment ──────────────────────────────────────────────────────────

  /// Splits "MM/YY" into {'month': ..., 'year': ...}.
  static Map<String, String> parseMonthYear(String value) {
    final parts = value.split('/');
    return {
      'month': parts[0],
      'year': parts[1],
    };
  }

  /// Validates all payment form fields. Returns a map with 'success' (bool)
  /// and 'message' (String). On success: {'success': true, 'message': ...}.
  static Map<String, dynamic> paymentValidator(
    String cardNumber,
    String expiryDate,
    String cvc,
    String cardholderName,
    String email,
    String fullName,
    String address,
    String? apartment,
    String country,
    String state,
    String city,
    String? zipCode,
  ) {
    // -- helpers --
    bool isValidCardNumber(String cn) {
      String c = cn.replaceAll(RegExp(r'[\s\.\•]'), '');
      if (c.length < 13 || c.length > 19) return false;
      if (!RegExp(r'^\d+$').hasMatch(c)) return false;
      int sum = 0;
      bool alt = false;
      for (int i = c.length - 1; i >= 0; i--) {
        int d = int.parse(c[i]);
        if (alt) {
          d *= 2;
          if (d > 9) d -= 9;
        }
        sum += d;
        alt = !alt;
      }
      return sum % 10 == 0;
    }

    bool isValidExpiryDate(String ed) {
      if (ed.isEmpty) return false;
      final parts = ed.split('/');
      if (parts.length != 2) return false;
      final month = int.tryParse(parts[0].trim());
      final yearStr = parts[1].trim();
      if (month == null || month < 1 || month > 12) return false;
      int? year;
      if (yearStr.length == 2) {
        final twoDigit = int.tryParse(yearStr);
        if (twoDigit == null) return false;
        year = 2000 + twoDigit;
      } else if (yearStr.length == 4) {
        year = int.tryParse(yearStr);
        if (year == null) return false;
      } else {
        return false;
      }
      final expiry = DateTime(year, month + 1, 0);
      return expiry.isAfter(DateTime.now());
    }

    bool isValidCVC(String v) =>
        v.isNotEmpty && RegExp(r'^\d{3,4}$').hasMatch(v);

    bool isValidEmail(String e) =>
        e.isNotEmpty &&
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(e);

    bool isValidZipCode(String zc, String cc) {
      if (zc.isEmpty) return false;
      switch (cc.toUpperCase()) {
        case 'US':
        case 'USA':
          return RegExp(r'^\d{5}(-\d{4})?$').hasMatch(zc);
        case 'CA':
        case 'CANADA':
          return RegExp(r'^[A-Za-z]\d[A-Za-z] ?\d[A-Za-z]\d$').hasMatch(zc);
        case 'GB':
        case 'UK':
        case 'UNITED KINGDOM':
          return RegExp(r'^[A-Z]{1,2}\d{1,2}[A-Z]?\s?\d[A-Z]{2}$',
                  caseSensitive: false)
              .hasMatch(zc);
        case 'AU':
        case 'AUSTRALIA':
          return RegExp(r'^\d{4}$').hasMatch(zc);
        default:
          return zc.trim().isNotEmpty;
      }
    }

    Map<String, dynamic> err(String msg, String field) =>
        {'success': false, 'message': msg, 'field': field};

    if (cardNumber.isEmpty) return err('Card number is required', 'cardNumber');
    if (!isValidCardNumber(cardNumber)) {
      return err('Invalid card number', 'cardNumber');
    }
    if (expiryDate.isEmpty) {
      return err('Expiry date is required', 'expiryDate');
    }
    if (!isValidExpiryDate(expiryDate)) {
      return err('Invalid or expired date', 'expiryDate');
    }
    if (cvc.isEmpty) return err('CVC is required', 'cvc');
    if (!isValidCVC(cvc)) return err('Invalid CVC code', 'cvc');
    if (cardholderName.trim().isEmpty) {
      return err('Cardholder name is required', 'cardholderName');
    }
    if (cardholderName.trim().length < 2) {
      return err('Cardholder name is too short', 'cardholderName');
    }
    if (email.isEmpty) return err('Email is required', 'email');
    if (!isValidEmail(email)) return err('Invalid email address', 'email');
    if (fullName.trim().isEmpty) {
      return err('Full name is required', 'fullName');
    }
    if (fullName.trim().length < 2) {
      return err('Full name is too short', 'fullName');
    }
    if (address.trim().isEmpty) return err('Address is required', 'address');
    if (address.trim().length < 5) {
      return err('Address is too short', 'address');
    }
    if (country.trim().isEmpty) return err('Country is required', 'country');
    if (state.trim().isEmpty) return err('State is required', 'state');
    if (city.trim().isEmpty) return err('City is required', 'city');
    if (zipCode == null || zipCode.trim().isEmpty) {
      return err('Zip code is required', 'zipCode');
    }
    if (!isValidZipCode(zipCode, country)) {
      return err('Invalid zip code format', 'zipCode');
    }

    return {'success': true, 'message': 'Validation successful'};
  }
}
