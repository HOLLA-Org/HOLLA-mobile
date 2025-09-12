import 'package:equatable/equatable.dart';

// The base abstract class for all send mail states.
abstract class SendMailState extends Equatable {
  const SendMailState();

  @override
  List<Object> get props => [];
}

// Represents the initial state of the form before submission.
class SendMailInitial extends SendMailState {
  final String email;
  final bool isFormValid;
  final Set<String> invalidFields;

  const SendMailInitial({
    this.email = '',
    this.isFormValid = false,
    this.invalidFields = const {},
  });

  SendMailInitial copyWith({
    String? email,
    bool? isFormValid,
    Set<String>? invalidFields,
  }) {
    return SendMailInitial(
      email: email ?? this.email,
      isFormValid: isFormValid ?? this.isFormValid,
      invalidFields: invalidFields ?? this.invalidFields,
    );
  }

  @override
  List<Object> get props => [email, isFormValid, invalidFields];
}

// Represents the state when the app is processing the send mail request.
class SendMailLoading extends SendMailState {}

// Represents a successful request, where the email has been sent.
class SendMailSuccess extends SendMailState {
  final String email;

  const SendMailSuccess({required this.email});

  @override
  List<Object> get props => [email];
}

// Represents a failed request, carrying the error message.
class SendMailFailure extends SendMailState {
  final String error;

  const SendMailFailure(this.error);

  @override
  List<Object> get props => [error];
}
