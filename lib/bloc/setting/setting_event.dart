import 'package:equatable/equatable.dart';

class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

final class LogoutRequested extends SettingEvent {}
