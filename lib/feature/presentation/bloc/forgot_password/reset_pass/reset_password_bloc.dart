import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/feature/data/repository/forgot_password_repo.dart';
import 'package:holla/core/utils/validation_auth.dart';

import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ForgotPasswordRepository _forgotPasswordRepository;

  ResetPasswordBloc({
    required ForgotPasswordRepository forgotPasswordRepository,
  }) : _forgotPasswordRepository = forgotPasswordRepository,

       super(const ResetPasswordInitial()) {
    on<ResetPasswordFormChanged>(_onFormChanged);
    on<ResetPasswordSubmitted>(_onSubmitted);
  }

  void _onFormChanged(
    ResetPasswordFormChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    final invalidFields = <String>{};

    if (event.password.isNotEmpty &&
        !ValidationAuth.isStrongPassword(event.password)) {
      invalidFields.add('password');
    }
    if (event.password.isNotEmpty &&
        !ValidationAuth.isStrongPassword(event.confirmPassword)) {
      invalidFields.add('confirmPassword');
    }

    final passwordsMatch = event.password == event.confirmPassword;

    final isFormValid = invalidFields.isEmpty && passwordsMatch;

    emit(
      ResetPasswordInitial(
        password: event.password,
        invalidFields: invalidFields,
        passwordsMatch: passwordsMatch,
        isFormValid: isFormValid,
      ),
    );
  }

  Future<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    final currentState = state;
    if (currentState is ResetPasswordInitial && currentState.isFormValid) {
      emit(ResetPasswordLoading());
      try {
        await _forgotPasswordRepository.resetPassword(
          token: event.token,
          newPassword: currentState.password,
        );
        emit(ResetPasswordSuccess());
      } catch (e) {
        final translatedError = _translateError(e.toString());
        emit(ResetPasswordFailure(translatedError));
      }
    }
  }

  String _translateError(String errorMessage) {
    final error = errorMessage.replaceFirst('Exception: ', '').trim();
    switch (error) {
      case 'Invalid or expired token!':
        return 'Token không hợp lệ hoặc đã hết hạn. Vui lòng thử lại từ đầu!';
      case 'User does not exist!':
        return 'Người dùng không tồn tại. Vui lòng thử lại từ đầu!';
      case 'Failed to connect to the server. Please check your connection.':
        return 'Không thể kết nối đến máy chủ! Vui lòng kiểm tra lại kết nối mạng.';
      default:
        return 'Đã có lỗi không xác định xảy ra! Vui lòng thử lại sau.';
    }
  }
}
