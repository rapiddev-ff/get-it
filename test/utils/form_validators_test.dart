import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/core/utils/form_validators.dart';

void main() {
  // ── containsProfanity ───────────────────────────────────────────────

  group('containsProfanity', () {
    test('returns false for clean text', () {
      expect(FormValidators.containsProfanity('hello'), false);
      expect(FormValidators.containsProfanity('get_it_user'), false);
      expect(FormValidators.containsProfanity('coolname123'), false);
    });

    test('detects direct profanity word', () {
      expect(FormValidators.containsProfanity('fuck'), true);
      expect(FormValidators.containsProfanity('shitpost'), true);
    });

    test('detects leet-speak substitution', () {
      expect(FormValidators.containsProfanity('f4ggot'), true);
      expect(FormValidators.containsProfanity('sh1t'), true);
      expect(FormValidators.containsProfanity('a55hole'), true);
    });

    test('ignores underscores and dashes in normalized text', () {
      expect(FormValidators.containsProfanity('f_u_c_k'), true);
      expect(FormValidators.containsProfanity('sh-it'), true);
    });

    test('is case insensitive', () {
      expect(FormValidators.containsProfanity('FUCK'), true);
      expect(FormValidators.containsProfanity('Shit'), true);
    });
  });

  // ── normalizeUsername ───────────────────────────────────────────────

  group('normalizeUsername', () {
    test('returns empty for null or blank', () {
      expect(FormValidators.normalizeUsername(null), '');
      expect(FormValidators.normalizeUsername(''), '');
      expect(FormValidators.normalizeUsername('   '), '');
    });

    test('strips @ prefix', () {
      expect(FormValidators.normalizeUsername('@john'), 'john');
    });

    test('trims whitespace', () {
      expect(FormValidators.normalizeUsername('  john  '), 'john');
    });

    test('preserves normal username', () {
      expect(FormValidators.normalizeUsername('john_doe'), 'john_doe');
    });
  });

  // ── usernameValidationResult ────────────────────────────────────────

  group('usernameValidationResult', () {
    test('returns valid for good usernames', () {
      expect(FormValidators.usernameValidationResult('john'), 'valid');
      expect(FormValidators.usernameValidationResult('user_123'), 'valid');
      expect(FormValidators.usernameValidationResult('a.b.c'), 'valid');
      expect(FormValidators.usernameValidationResult('@john'), 'valid');
    });

    test('returns required error for empty input', () {
      expect(FormValidators.usernameValidationResult(null),
          'Username is required');
      expect(
          FormValidators.usernameValidationResult(''), 'Username is required');
    });

    test('rejects @ anywhere other than start', () {
      expect(FormValidators.usernameValidationResult('jo@hn'),
          contains('"@" can only'));
    });

    test('rejects multiple @ signs', () {
      expect(FormValidators.usernameValidationResult('@@john'),
          contains('"@" can only'));
    });

    test('rejects username shorter than 3 chars', () {
      expect(FormValidators.usernameValidationResult('ab'),
          contains('at least 3'));
    });

    test('rejects username longer than 20 chars', () {
      expect(FormValidators.usernameValidationResult('a' * 21),
          contains('no longer than 20'));
    });

    test('rejects spaces in username', () {
      expect(FormValidators.usernameValidationResult('john doe'),
          contains('only letters'));
    });

    test('allows underscore and dot', () {
      expect(FormValidators.usernameValidationResult('john_doe.99'), 'valid');
    });

    test('@-prefixed username with 3+ chars after strip is valid', () {
      expect(FormValidators.usernameValidationResult('@abc'), 'valid');
    });

    test('@-prefixed username with <3 chars after strip is too short', () {
      expect(FormValidators.usernameValidationResult('@ab'),
          contains('at least 3'));
    });
  });

  // ── phoneValidationResult ──────────────────────────────────────────

  group('phoneValidationResult', () {
    test('returns null (valid) for 10-digit US number', () {
      expect(FormValidators.phoneValidationResult('2025551234'), isNull);
    });

    test('returns null for 11-digit number starting with 1', () {
      expect(FormValidators.phoneValidationResult('12025551234'), isNull);
    });

    test('returns null for 11-digit number starting with 7', () {
      expect(FormValidators.phoneValidationResult('79991234567'), isNull);
    });

    test('rejects 9-digit number as too short', () {
      expect(FormValidators.phoneValidationResult('123456789'),
          contains('too short'));
    });

    test('rejects 16-digit number as too long', () {
      expect(FormValidators.phoneValidationResult('1234567890123456'),
          contains('too long'));
    });

    test('strips formatting characters before counting digits', () {
      expect(FormValidators.phoneValidationResult('(202) 555-1234'), isNull);
      expect(FormValidators.phoneValidationResult('+1 202 555 1234'), isNull);
    });

    test('rejects 11-digit not starting with 1 or 7', () {
      expect(FormValidators.phoneValidationResult('52025551234'),
          contains('Invalid country code'));
    });

    test('returns required for null/empty', () {
      expect(FormValidators.phoneValidationResult(null), contains('required'));
      expect(FormValidators.phoneValidationResult(''), contains('required'));
    });

    test('accepts 12-15 digit international numbers', () {
      expect(FormValidators.phoneValidationResult('441234567890'), isNull);
      expect(FormValidators.phoneValidationResult('861234567890123'), isNull);
    });
  });

  // ── formatPhoneNumber ──────────────────────────────────────────────

  group('formatPhoneNumber', () {
    test('strips non-digits but keeps leading +', () {
      expect(FormValidators.formatPhoneNumber('+1 (202) 555-1234'),
          '+12025551234');
    });

    test('strips without + prefix', () {
      expect(FormValidators.formatPhoneNumber('(202) 555-1234'), '2025551234');
    });
  });

  // ── paymentValidator ───────────────────────────────────────────────

  group('paymentValidator', () {
    Map<String, dynamic> validate({
      String cardNumber = '4532015112830366',
      String expiryDate = '12/30',
      String cvc = '123',
      String cardholderName = 'John Doe',
      String email = 'john@example.com',
      String fullName = 'John Doe',
      String address = '123 Main St',
      String? apartment,
      String country = 'US',
      String state = 'CA',
      String city = 'LA',
      String? zipCode = '90210',
    }) {
      return FormValidators.paymentValidator(
        cardNumber,
        expiryDate,
        cvc,
        cardholderName,
        email,
        fullName,
        address,
        apartment,
        country,
        state,
        city,
        zipCode,
      );
    }

    test('returns success for all valid fields', () {
      final result = validate();
      expect(result['success'], true);
    });

    test('accepts valid Visa card number via Luhn check', () {
      final result = validate(cardNumber: '4532015112830366');
      expect(result['success'], true);
    });

    test('rejects card number failing Luhn check', () {
      final result = validate(cardNumber: '1234567890123456');
      expect(result['success'], false);
      expect(result['field'], 'cardNumber');
    });

    test('rejects card number shorter than 13 digits', () {
      final result = validate(cardNumber: '123456789012');
      expect(result['success'], false);
      expect(result['field'], 'cardNumber');
    });

    test('rejects empty card number', () {
      final result = validate(cardNumber: '');
      expect(result['success'], false);
      expect(result['message'], contains('required'));
    });

    test('accepts expiry date MM/YY in future', () {
      final result = validate(expiryDate: '12/30');
      expect(result['success'], true);
    });

    test('rejects expired expiry date', () {
      final result = validate(expiryDate: '01/20');
      expect(result['success'], false);
      expect(result['field'], 'expiryDate');
    });

    test('rejects month > 12', () {
      final result = validate(expiryDate: '13/30');
      expect(result['success'], false);
      expect(result['field'], 'expiryDate');
    });

    test('accepts 4-digit year format', () {
      final result = validate(expiryDate: '12/2030');
      expect(result['success'], true);
    });

    test('accepts 3-digit CVC', () {
      final result = validate(cvc: '123');
      expect(result['success'], true);
    });

    test('accepts 4-digit CVC', () {
      final result = validate(cvc: '1234');
      expect(result['success'], true);
    });

    test('rejects 5-digit CVC', () {
      final result = validate(cvc: '12345');
      expect(result['success'], false);
      expect(result['field'], 'cvc');
    });

    test('validates US ZIP as 5 digits', () {
      final result = validate(country: 'US', zipCode: '90210');
      expect(result['success'], true);
    });

    test('validates US ZIP+4', () {
      final result = validate(country: 'US', zipCode: '90210-1234');
      expect(result['success'], true);
    });

    test('rejects US ZIP with letters', () {
      final result = validate(country: 'US', zipCode: 'ABC12');
      expect(result['success'], false);
      expect(result['field'], 'zipCode');
    });

    test('validates Canadian postal code', () {
      final result = validate(country: 'CA', zipCode: 'K1A 0A9');
      expect(result['success'], true);
    });

    test('validates UK postcode', () {
      final result = validate(country: 'UK', zipCode: 'SW1A 1AA');
      expect(result['success'], true);
    });

    test('validates Australian postcode', () {
      final result = validate(country: 'AU', zipCode: '2000');
      expect(result['success'], true);
    });

    test('returns field name in error map for failed field', () {
      final result = validate(email: 'invalid');
      expect(result['success'], false);
      expect(result['field'], 'email');
      expect(result['message'], isNotEmpty);
    });

    test('rejects empty required fields', () {
      expect(validate(cardholderName: '')['field'], 'cardholderName');
      expect(validate(email: '')['field'], 'email');
      expect(validate(fullName: '')['field'], 'fullName');
      expect(validate(address: '')['field'], 'address');
      expect(validate(country: '')['field'], 'country');
      expect(validate(state: '')['field'], 'state');
      expect(validate(city: '')['field'], 'city');
      expect(validate(zipCode: null)['field'], 'zipCode');
    });

    test('rejects too short cardholder name', () {
      final result = validate(cardholderName: 'A');
      expect(result['success'], false);
      expect(result['message'], contains('too short'));
    });

    test('rejects too short address', () {
      final result = validate(address: '123');
      expect(result['success'], false);
      expect(result['message'], contains('too short'));
    });

    test('accepts card number with dots/spaces (stripped)', () {
      // Visa test number with spaces
      final result = validate(cardNumber: '4532 0151 1283 0366');
      expect(result['success'], true);
    });
  });
}
