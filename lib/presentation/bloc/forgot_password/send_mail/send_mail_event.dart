import 'package:equatable/equatable.dart';

abstract class SendMailEvent extends Equatable {
  const SendMailEvent();

  @override
  List<Object> get props => [];
}

/// Event dispatched when the email input field changes.
class SendMailEmailChanged extends SendMailEvent {
  final String email;

  const SendMailEmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

/// Event dispatched when the user submits the form.
class SendMailSubmitted extends SendMailEvent {
  final String email;

  const SendMailSubmitted({required this.email});

  @override
  List<Object> get props => [email];
}
