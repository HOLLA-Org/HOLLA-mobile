import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class ResetPasswordFormChanged extends ResetPasswordEvent {
  final String password;
  final String confirmPassword;

  const ResetPasswordFormChanged({
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [password, confirmPassword];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String token;

  const ResetPasswordSubmitted({required this.token});
  @override
  List<Object> get props => [token];
}
