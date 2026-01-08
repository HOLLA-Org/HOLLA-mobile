import 'package:equatable/equatable.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object?> get props => [];
}

class GetUserProfile extends SettingEvent {}

class UpdateProfileSubmitted extends SettingEvent {
  final String? username;
  final String? phone;
  final String? gender;
  final DateTime? dateOfBirth;

  const UpdateProfileSubmitted({
    this.username,
    this.phone,
    this.gender,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [username, phone, gender, dateOfBirth];
}

class UpdateAvatarSubmitted extends SettingEvent {
  final String avatarUrl;

  const UpdateAvatarSubmitted({required this.avatarUrl});

  @override
  List<Object?> get props => [avatarUrl];
}

class LogoutRequested extends SettingEvent {}
