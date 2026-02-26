import 'package:elevate_tracking_app/features/apply/domain/entities/country_entity.dart';

class Country {
  final String? isoCode;
  final String? name;
  final String? phoneCode;
  final String? flag;
  final String? currency;
  final String? latitude;
  final String? longitude;
  final List<Timezone>? timezones;

  Country({
    this.isoCode,
    this.name,
    this.phoneCode,
    this.flag,
    this.currency,
    this.latitude,
    this.longitude,
    this.timezones,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      isoCode: json['isoCode'],
      name: json['name'],
      phoneCode: json['phoneCode'],
      flag: json['flag'],
      currency: json['currency'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      timezones: (json['timezones'] as List)
          .map((tz) => Timezone.fromJson(tz))
          .toList(),
    );
  }
}

class Timezone {
  final String zoneName;
  final int gmtOffset;
  final String gmtOffsetName;
  final String abbreviation;
  final String tzName;

  Timezone({
    required this.zoneName,
    required this.gmtOffset,
    required this.gmtOffsetName,
    required this.abbreviation,
    required this.tzName,
  });

  factory Timezone.fromJson(Map<String, dynamic> json) {
    return Timezone(
      zoneName: json['zoneName'],
      gmtOffset: json['gmtOffset'],
      gmtOffsetName: json['gmtOffsetName'],
      abbreviation: json['abbreviation'],
      tzName: json['tzName'],
    );
  }
}

extension CountryMapper on Country {
  CountryEntity toEntity() => CountryEntity(
    name: name ?? "",
    flag: flag ?? "",
    phoneCode: phoneCode ?? "",
  );
}
