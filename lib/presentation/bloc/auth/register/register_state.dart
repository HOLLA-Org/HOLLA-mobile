import 'package:equatable/equatable.dart';
import 'package:holla/models/auth_model.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {
  final bool passwordsMatch;
  final Set<String> invalidFields;
  final bool isFormValid;

  const RegisterInitial({
    this.passwordsMatch = true,
    this.invalidFields = const {},
    this.isFormValid = false,
  });

  RegisterInitial copyWith({
    bool? passwordsMatch,
    Set<String>? invalidFields,
    bool? isFormValid,
  }) {
    return RegisterInitial(
      passwordsMatch: passwordsMatch ?? this.passwordsMatch,
      invalidFields: invalidFields ?? this.invalidFields,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object> get props => [passwordsMatch, invalidFields];
}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final AuthModel auth;

  const RegisterSuccess(this.auth);

  @override
  List<Object> get props => [auth];
}

class RegisterFailure extends RegisterState {
  final String error;

  const RegisterFailure(this.error);

  @override
  List<Object> get props => [error];
}
