import 'package:equatable/equatable.dart';

class LoginResponseEntity extends Equatable {
  final String message;
  final String token;

  const LoginResponseEntity({required this.message, required this.token});

  @override
  List<Object?> get props => [message, token];
}