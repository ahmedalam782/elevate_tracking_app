import 'dart:convert';

import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/core/utils/constants/app_strings.dart';
import 'package:elevate_tracking_app/features/apply/data/datasources/country_data_source_contract.dart';
import 'package:elevate_tracking_app/features/apply/data/models/country_model.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CountryDataSourceContract)
class CountryDataSourceImpl implements CountryDataSourceContract {
  @override
  Future<Result<List<Country>>> loadCountries() async {
    try {
      final String response = await rootBundle.loadString(
        AppStrings.countriesJsonPath,
      );
      final List<dynamic> data = json.decode(response);

      return Success<List<Country>>(
        data: data.map((e) => Country.fromJson(e)).toList(),
      );
    } catch (e) {
      return Error<List<Country>>(exception: e as Exception);
    }
  }
}
