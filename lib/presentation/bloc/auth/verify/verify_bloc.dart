import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/presentation/bloc/auth/verify/verify_event.dart';
import 'package:holla/presentation/bloc/auth/verify/verify_state.dart';
import 'package:holla/repository/auth_repo.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  final AuthRepository _authRepository;

  VerifyBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const VerifyInitial(isFormValid: false)) {
    on<VerifyCodeChanged>(_onCodeChanged);
    on<VerifySubmitted>(_onSubmitted);
    on<VerifyResendCode>(_onResendCode);
  }

  void _onCodeChanged(VerifyCodeChanged event, Emitter<VerifyState> emit) {
    emit(VerifyInitial(isFormValid: event.code.length == 6));
  }

  Future<void> _onSubmitted(
    VerifySubmitted event,
    Emitter<VerifyState> emit,
  ) async {
    emit(const VerifyLoading(isFormValid: true));
    try {
      await _authRepository.verifyCode(event.email, event.code);
      emit(const VerifySuccess());
    } catch (e) {
      final translatedError = _translateError(e.toString());
      emit(VerifyFailure(error: translatedError, isFormValid: true));
    }
  }

  Future<void> _onResendCode(
    VerifyResendCode event,
    Emitter<VerifyState> emit,
  ) async {
    final currentFormValidity = state.isFormValid;
    emit(VerifyLoading(isFormValid: currentFormValidity));
    try {
      await _authRepository.resendCode(event.email);
      emit(const VerifyCodeResent(isFormValid: false));
    } catch (e) {
      final translatedError = _translateError(e.toString());
      emit(
        VerifyFailure(error: translatedError, isFormValid: currentFormValidity),
      );
    }
  }

  String _translateError(String errorMessage) {
    final error = errorMessage.replaceFirst('Exception: ', '').trim();

    switch (error) {
      case 'Account not found!':
        return 'Tài khoản không tồn tại!';
      case 'The code invalid or expried!':
        return 'Mã xác minh không hợp lệ hoặc đã hết hạn!';
      default:
        return 'Đã xảy ra lỗi, vui lòng thử lại!';
    }
  }
}
