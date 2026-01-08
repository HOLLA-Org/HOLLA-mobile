import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/presentation/bloc/setting/setting_event.dart';
import 'package:holla/presentation/bloc/setting/setting_state.dart';
import 'package:holla/repository/auth_repo.dart';
import 'package:holla/repository/setting_repo.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final AuthRepository _authRepository;
  final SettingRepository _settingRepository;

  SettingBloc({
    required AuthRepository authRepository,
    required SettingRepository settingRepository,
  }) : _authRepository = authRepository,
       _settingRepository = settingRepository,
       super(SettingInitial()) {
    on<GetUserProfile>(_onGetUserProfile);
    on<UpdateProfileSubmitted>(_onUpdateProfileSubmitted);
    on<UpdateAvatarSubmitted>(_onUpdateAvatarSubmitted);
    on<ChangePasswordSubmitted>(_onChangePasswordSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onGetUserProfile(
    GetUserProfile event,
    Emitter<SettingState> emit,
  ) async {
    emit(SettingLoading());
    try {
      final user = await _settingRepository.getUserProfile();
      emit(GetUserProfileSuccess(user));
    } catch (e) {
      final error = _translateError(e.toString());
      emit(GetUserProfileFailure(error));
    }
  }

  Future<void> _onUpdateProfileSubmitted(
    UpdateProfileSubmitted event,
    Emitter<SettingState> emit,
  ) async {
    try {
      final updatedUser = await _settingRepository.updateProfile(
        username: event.username,
        phone: event.phone,
        gender: event.gender,
        dateOfBirth: event.dateOfBirth,
      );

      emit(UpdateProfileSuccess(updatedUser));
    } catch (e) {
      final error = _translateError(e.toString());
      emit(UpdateProfileFailure(error));
    }
  }

  Future<void> _onUpdateAvatarSubmitted(
    UpdateAvatarSubmitted event,
    Emitter<SettingState> emit,
  ) async {
    try {
      final updatedUser = await _settingRepository.updateAvatar(event.filePath);
      emit(UpdateAvatarSuccess(updatedUser));
    } catch (e) {
      final error = _translateError(e.toString());
      emit(UpdateAvatarFailure(error));
    }
  }

  Future<void> _onChangePasswordSubmitted(
    ChangePasswordSubmitted event,
    Emitter<SettingState> emit,
  ) async {
    emit(SettingLoading());
    try {
      await _settingRepository.changepassword(
        event.currentPassword,
        event.newPassword,
      );
      emit(ChangePasswordSuccess());
    } catch (e) {
      final error = _translateError(e.toString());
      emit(ChangePasswordFailure(error));
    }
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
      final error = _translateError(e.toString());
      emit(LogoutFailure(error));
    }
  }

  String _translateError(String errorMessage) {
    final error = errorMessage.replaceFirst('Exception: ', '').trim();

    return error;
  }
}
