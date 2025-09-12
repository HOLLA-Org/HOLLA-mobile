import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/feature/presentation/bloc/auth/register/register_event.dart';
import 'package:holla/feature/presentation/bloc/auth/register/register_state.dart';
import 'package:holla/feature/data/repository/auth_repo.dart';
import 'package:holla/core/utils/validation_auth.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;

  RegisterBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const RegisterInitial()) {
    on<RegisterFormChanged>(_onFormChanged);
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  void _onFormChanged(RegisterFormChanged event, Emitter<RegisterState> emit) {
    final invalidFields = <String>{};

    if (event.username.isNotEmpty &&
        !ValidationAuth.isUsernameValid(event.username)) {
      invalidFields.add('username');
    }
    if (event.email.isNotEmpty && !ValidationAuth.isValidEmail(event.email)) {
      invalidFields.add('email');
    }
    if (event.password.isNotEmpty &&
        !ValidationAuth.isStrongPassword(event.password)) {
      invalidFields.add('password');
    }
    if (event.password.isNotEmpty &&
        !ValidationAuth.isStrongPassword(event.confirmPassword)) {
      invalidFields.add('confirmPassword');
    }

    final passwordsMatch = event.password == event.confirmPassword;

    final isFormValid =
        event.username.isNotEmpty &&
        event.email.isNotEmpty &&
        event.password.isNotEmpty &&
        event.confirmPassword.isNotEmpty &&
        invalidFields.isEmpty &&
        passwordsMatch;

    emit(
      RegisterInitial(
        invalidFields: invalidFields,
        passwordsMatch: passwordsMatch,
        isFormValid: isFormValid,
      ),
    );
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    final currentState = state as RegisterInitial;
    if (!currentState.isFormValid) return;

    emit(RegisterLoading());

    try {
      final user = await _authRepository.register(
        username: event.username,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );
      emit(RegisterSuccess(user));
    } catch (e) {
      final translatedError = _translateError(e.toString());
      emit(RegisterFailure(translatedError));
    }
  }

  String _translateError(String errorMessage) {
    final coreMessage = errorMessage.replaceFirst('Exception: ', '').trim();

    switch (coreMessage) {
      case 'Email already exists! Please use another email':
        return 'Email này đã được sử dụng! Vui lòng dùng email khác';
      case 'Username already exists! Please use another username':
        return 'Tên đăng nhập này đã tồn tại! Vui lòng dùng tên khác';
      case 'Failed to connect to the server.':
        return 'Không thể kết nối đến máy chủ! Vui lòng kiểm tra lại mạng';
      default:
        return 'Đã có lỗi không xác định xảy ra!';
    }
  }
}
