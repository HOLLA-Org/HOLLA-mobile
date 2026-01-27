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
  final String? address;
  final String? locationName;
  final double? latitude;
  final double? longitude;

  const UpdateProfileSubmitted({
    this.username,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.locationName,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
    username,
    phone,
    gender,
    dateOfBirth,
    address,
    locationName,
    latitude,
    longitude,
  ];
}

class UpdateAvatarSubmitted extends SettingEvent {
  final String filePath;

  const UpdateAvatarSubmitted({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

class ChangePasswordSubmitted extends SettingEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordSubmitted({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class LogoutRequested extends SettingEvent {}
