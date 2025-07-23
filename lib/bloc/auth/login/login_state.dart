import 'package:equatable/equatable.dart';
import 'package:holla/models/auth_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  final Set<String> invalidFields;
  final bool isFormValid;

  const LoginInitial({this.invalidFields = const {}, this.isFormValid = false});

  @override
  List<Object> get props => [invalidFields, isFormValid];
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final AuthModel auth;

  const LoginSuccess(this.auth);

  @override
  List<Object> get props => [auth];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}
