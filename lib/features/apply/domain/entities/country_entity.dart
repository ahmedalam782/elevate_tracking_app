import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable{
  final String name;
  final String phoneCode;
  final String flag;

  const CountryEntity({
    required this.name,
    required this.phoneCode,
    required this.flag,
  });
  
  @override
  List<Object?> get props => [name, phoneCode, flag];
}
