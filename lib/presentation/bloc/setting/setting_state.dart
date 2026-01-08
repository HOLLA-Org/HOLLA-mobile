import 'package:equatable/equatable.dart';
import '../../../models/user_model.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object?> get props => [];
}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

class GetUserProfileSuccess extends SettingState {
  final UserModel user;

  const GetUserProfileSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateProfileSuccess extends SettingState {
  final UserModel user;

  const UpdateProfileSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateAvatarSuccess extends SettingState {
  final UserModel user;

  const UpdateAvatarSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class LogoutSuccess extends SettingState {}

class GetUserProfileFailure extends SettingState {
  final String error;
  const GetUserProfileFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class UpdateProfileFailure extends SettingState {
  final String error;
  const UpdateProfileFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class UpdateAvatarFailure extends SettingState {
  final String error;
  const UpdateAvatarFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class LogoutFailure extends SettingState {
  final String error;
  const LogoutFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ChangePasswordSuccess extends SettingState {}

class ChangePasswordFailure extends SettingState {
  final String error;
  const ChangePasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}
