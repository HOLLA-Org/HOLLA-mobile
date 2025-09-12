import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/feature/data/repository/forgot_password_repo.dart';

import 'verify_password_event.dart';
import 'verify_password_state.dart';

class VerifyPasswordBloc
    extends Bloc<VerifyPasswordEvent, VerifyPasswordState> {
  final ForgotPasswordRepository _forgotPasswordRepository;

  VerifyPasswordBloc({
    required ForgotPasswordRepository forgotPasswordRepository,
  }) : _forgotPasswordRepository = forgotPasswordRepository,
       super(const VerifyPasswordInitial(isFormValid: false)) {
    on<VerifyPasswordCodeChanged>(_onCodeChanged);
    on<VerifyPasswordSubmitted>(_onSubmitted);
    on<VerifyPasswordResendCode>(_onResendCode);
  }

  void _onCodeChanged(
    VerifyPasswordCodeChanged event,
    Emitter<VerifyPasswordState> emit,
  ) {
    emit(VerifyPasswordInitial(isFormValid: event.code.length == 6));
  }

  Future<void> _onSubmitted(
    VerifyPasswordSubmitted event,
    Emitter<VerifyPasswordState> emit,
  ) async {
    emit(const VerifyPasswordLoading(isFormValid: true));
    try {
      final token = await _forgotPasswordRepository.verifyPassword(
        email: event.email,
        code: event.code,
      );
      emit(VerifyPasswordSuccess(token: token));
    } catch (e) {
      final translatedError = _translateError(e.toString());
      emit(VerifyPasswordFailure(error: translatedError, isFormValid: true));
    }
  }

  Future<void> _onResendCode(
    VerifyPasswordResendCode event,
    Emitter<VerifyPasswordState> emit,
  ) async {
    final currentFormValidity = state.isFormValid;
    emit(VerifyPasswordLoading(isFormValid: currentFormValidity));
    try {
      await _forgotPasswordRepository.resendCode(email: event.email);
      emit(const VerifyPasswordCodeResent(isFormValid: false));
    } catch (e) {
      final translatedError = _translateError(e.toString());
      emit(
        VerifyPasswordFailure(
          error: translatedError,
          isFormValid: currentFormValidity,
        ),
      );
    }
  }

  String _translateError(String errorMessage) {
    final error = errorMessage.replaceFirst('Exception: ', '').trim();

    switch (error) {
      case 'Invalid or expired code!':
        return 'Mã xác minh không hợp lệ hoặc đã hết hạn!';
      case 'Token was not provided by the server.':
        return 'Token không được cung cấp từ server!';
      default:
        return 'Đã xảy ra lỗi, vui lòng thử lại!';
    }
  }
}
