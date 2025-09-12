import 'package:equatable/equatable.dart';

abstract class VerifyPasswordState extends Equatable {
  final bool isFormValid;
  const VerifyPasswordState({this.isFormValid = false});

  @override
  List<Object> get props => [isFormValid];
}

class VerifyPasswordInitial extends VerifyPasswordState {
  const VerifyPasswordInitial({required super.isFormValid});
}

class VerifyPasswordLoading extends VerifyPasswordState {
  const VerifyPasswordLoading({required super.isFormValid});
}

class VerifyPasswordSuccess extends VerifyPasswordState {
  final String token;

  const VerifyPasswordSuccess({required this.token}) : super(isFormValid: true);

  @override
  List<Object> get props => [token, isFormValid];
}

class VerifyPasswordFailure extends VerifyPasswordState {
  final String error;
  const VerifyPasswordFailure({
    required this.error,
    required super.isFormValid,
  });
  @override
  List<Object> get props => [error, isFormValid];
}

class VerifyPasswordCodeResent extends VerifyPasswordState {
  const VerifyPasswordCodeResent({required super.isFormValid});
}
