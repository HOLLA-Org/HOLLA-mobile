import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/bloc/setting/setting_event.dart';
import 'package:holla/bloc/setting/setting_state.dart';
import 'package:holla/repository/auth_repo.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final AuthRepository _authRepository;

  SettingBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(SettingInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<SettingState> emit,
  ) async {
    emit(SettingLoading());
    try {
      await _authRepository.logout();

      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }
}
