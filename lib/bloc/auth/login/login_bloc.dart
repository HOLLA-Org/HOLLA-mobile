import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/bloc/auth/login/login_event.dart';
import 'package:holla/bloc/auth/login/login_state.dart';
import 'package:holla/repository/auth_repo.dart';
import 'package:holla/utils/validation_auth.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const LoginInitial()) {
    on<LoginFormChanged>(_onFormChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onFormChanged(LoginFormChanged event, Emitter<LoginState> emit) {
    final invalidFields = <String>{};

    if (event.emailOrUsername.isNotEmpty &&
        !ValidationAuth.isUsernameOrEmailValid(event.emailOrUsername)) {
      invalidFields.add('emailOrUsername');
    }
    if (event.password.isNotEmpty &&
        !ValidationAuth.isStrongPassword(event.password)) {
      invalidFields.add('password');
    }

    final isFormValid =
        event.emailOrUsername.isNotEmpty &&
        event.password.isNotEmpty &&
        invalidFields.isEmpty;

    emit(LoginInitial(isFormValid: isFormValid, invalidFields: invalidFields));
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final currentState = state;
    if (currentState is LoginInitial && currentState.isFormValid) {
      emit(LoginLoading());
      try {
        final user = await _authRepository.login(
          emailOrUsername: event.emailOrUsername,
          password: event.password,
        );
        emit(LoginSuccess(user));
      } catch (e) {
        final translatedError = _translateError(e.toString());
        emit(LoginFailure(translatedError));
      }
    }
  }

  String _translateError(String errorMessage) {
    // Loại bỏ tiền tố "Exception: " để lấy thông báo lỗi gốc
    final error = errorMessage.replaceFirst('Exception: ', '').trim();

    switch (error) {
      case 'user not found!':
        return 'Tài khoản không tồn tại! Vui lòng kiểm tra lại tên đăng nhập hoặc email.';
      case 'Invalid password!':
        return 'Mật khẩu không chính xác! Vui lòng thử lại.';
      case 'Failed to connect to the server.':
        return 'Không thể kết nối đến máy chủ! Vui lòng kiểm tra lại kết nối mạng.';
      default:
        return 'Đã có lỗi không xác định xảy ra! Vui lòng thử lại sau.';
    }
  }
}
