enum Gender {
  male,
  female,
}

extension GenderParsing on Gender {
  String get label => toString().split('.').last;
  static Gender? fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        return null;
    }
  }
}