import 'package:equatable/equatable.dart';

abstract class VerifyPasswordEvent extends Equatable {
  const VerifyPasswordEvent();

  @override
  List<Object> get props => [];
}

class VerifyPasswordCodeChanged extends VerifyPasswordEvent {
  final String code;
  const VerifyPasswordCodeChanged({required this.code});
  @override
  List<Object> get props => [code];
}

class VerifyPasswordSubmitted extends VerifyPasswordEvent {
  final String email;
  final String code;
  const VerifyPasswordSubmitted({required this.email, required this.code});
  @override
  List<Object> get props => [email, code];
}

class VerifyPasswordResendCode extends VerifyPasswordEvent {
  final String email;
  const VerifyPasswordResendCode({required this.email});
  @override
  List<Object> get props => [email];
}
