import 'package:equatable/equatable.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {
  final String password;
  final bool isFormValid;
  final bool passwordsMatch;
  final Set<String> invalidFields;

  const ResetPasswordInitial({
    this.password = '',
    this.passwordsMatch = true,
    this.isFormValid = false,
    this.invalidFields = const {},
  });

  ResetPasswordInitial copyWith({
    String? password,
    bool? passwordsMatch,
    bool? isFormValid,
    Set<String>? invalidFields,
  }) {
    return ResetPasswordInitial(
      password: password ?? this.password,
      passwordsMatch: passwordsMatch ?? this.passwordsMatch,
      isFormValid: isFormValid ?? this.isFormValid,
      invalidFields: invalidFields ?? this.invalidFields,
    );
  }

  @override
  List<Object> get props => [
    password,
    passwordsMatch,
    isFormValid,
    invalidFields,
  ];
}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordFailure extends ResetPasswordState {
  final String error;

  const ResetPasswordFailure(this.error);

  @override
  List<Object> get props => [error];
}
