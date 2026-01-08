import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginFormChanged extends LoginEvent {
  final String emailOrUsername;
  final String password;

  const LoginFormChanged({
    required this.emailOrUsername,
    required this.password,
  });

  @override
  List<Object> get props => [emailOrUsername, password];
}

class LoginSubmitted extends LoginEvent {
  final String emailOrUsername;
  final String password;

  const LoginSubmitted({required this.emailOrUsername, required this.password});

  @override
  List<Object> get props => [emailOrUsername, password];
}
