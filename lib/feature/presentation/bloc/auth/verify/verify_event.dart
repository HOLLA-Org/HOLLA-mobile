import 'package:equatable/equatable.dart';

abstract class VerifyEvent extends Equatable {
  const VerifyEvent();

  @override
  List<Object> get props => [];
}

class VerifyCodeChanged extends VerifyEvent {
  final String code;
  const VerifyCodeChanged({required this.code});
  @override
  List<Object> get props => [code];
}

class VerifySubmitted extends VerifyEvent {
  final String email;
  final String code;
  const VerifySubmitted({required this.email, required this.code});
  @override
  List<Object> get props => [email, code];
}

class VerifyResendCode extends VerifyEvent {
  final String email;
  const VerifyResendCode({required this.email});
  @override
  List<Object> get props => [email];
}
