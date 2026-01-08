import 'package:equatable/equatable.dart';

abstract class VerifyState extends Equatable {
  final bool isFormValid;
  const VerifyState({this.isFormValid = false});

  @override
  List<Object> get props => [isFormValid];
}

class VerifyInitial extends VerifyState {
  const VerifyInitial({required super.isFormValid});
}

class VerifyLoading extends VerifyState {
  const VerifyLoading({required super.isFormValid});
}

class VerifySuccess extends VerifyState {
  const VerifySuccess() : super(isFormValid: true);
}

class VerifyFailure extends VerifyState {
  final String error;
  const VerifyFailure({required this.error, required super.isFormValid});
  @override
  List<Object> get props => [error, isFormValid];
}

class VerifyCodeResent extends VerifyState {
  const VerifyCodeResent({required super.isFormValid});
}
