import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/bloc/forgot_password/send_mail/send_mail_event.dart';
import 'package:holla/bloc/forgot_password/send_mail/send_mail_state.dart';
import 'package:holla/repository/forgot_password_repo.dart';
import 'package:holla/utils/validation_auth.dart';

class SendMailBloc extends Bloc<SendMailEvent, SendMailState> {
  final ForgotPasswordRepository _forgotPasswordRepository;

  SendMailBloc({required ForgotPasswordRepository forgotPasswordRepository})
    : _forgotPasswordRepository = forgotPasswordRepository,
      super(const SendMailInitial()) {
    on<SendMailEmailChanged>(_onEmailChanged);
    on<SendMailSubmitted>(_onSubmitted);
  }

  /// Handles changes to the email input field and validates its content.
  void _onEmailChanged(
    SendMailEmailChanged event,
    Emitter<SendMailState> emit,
  ) {
    final invalidFields = <String>{};

    if (event.email.isNotEmpty && !ValidationAuth.isValidEmail(event.email)) {
      invalidFields.add('email');
    }

    final isFormValid = event.email.isNotEmpty && invalidFields.isEmpty;

    emit(
      SendMailInitial(
        email: event.email,
        isFormValid: isFormValid,
        invalidFields: invalidFields,
      ),
    );
  }

  /// Handles the form submission event.
  Future<void> _onSubmitted(
    SendMailSubmitted event,
    Emitter<SendMailState> emit,
  ) async {
    final currentState = state;
    // Only proceed if the form is in the initial state and is valid.
    if (currentState is SendMailInitial && currentState.isFormValid) {
      emit(SendMailLoading());
      try {
        await _forgotPasswordRepository.sendMail(email: event.email);
        emit(SendMailSuccess(email: event.email));
      } catch (e) {
        final translatedError = _translateError(e.toString());
        emit(SendMailFailure(translatedError));
      }
    }
  }

  /// Translates backend error messages into user-friendly Vietnamese text.
  String _translateError(String errorMessage) {
    final error = errorMessage.replaceFirst('Exception: ', '').trim();

    switch (error) {
      case 'User with this email does not exist!':
        return 'Email không được đăng ký cho bất kỳ tài khoản nào!';
      case 'Failed to connect to the server.':
        return 'Không thể kết nối đến máy chủ! Vui lòng kiểm tra lại kết nối mạng.';
      default:
        return 'Đã có lỗi không xác định xảy ra! Vui lòng thử lại sau.';
    }
  }
}
