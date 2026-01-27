import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/presentation/widget/notification/notification_action_sheet.dart';
import 'package:holla/presentation/widget/notification_dialog.dart';

import '../../../core/config/themes/app_colors.dart';
import '../../bloc/notification/notification_bloc.dart';
import '../../bloc/notification/notification_event.dart';
import '../../bloc/notification/notification_state.dart';
import '../../widget/header_with_back.dart';
import '../../widget/empty_list.dart';
import '../../widget/notification/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    _getNotifications();
  }

  /// Get notifications
  void _getNotifications() {
    context.read<NotificationBloc>().add(GetNotifications());
  }

  /// Show bottom sheet actions
  void _onMore(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) {
        return NotificationActionSheet(
          showDeleteAll: true,
          onDeleteAll: () {
            context.pop();
            _deleteNotifications();
          },
        );
      },
    );
  }

  /// Delete notification
  void _deleteNotification(String id) {
    context.read<NotificationBloc>().add(DeleteNotification(id));
  }

  /// Delete all notifications
  void _deleteNotifications() {
    context.read<NotificationBloc>().add(DeleteAllNotifications());
  }

  /// Back to previous screen
  void _onBack(BuildContext context) {
    context.pop();
  }

  /// Show success
  void showNotificationDeleteSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('notification.delete_success'.tr()),
        backgroundColor: const Color(0xFF008080),
      ),
    );
  }

  /// Show all notification delete success
  void showNotificationDeleteAllSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('notification.delete_all_success'.tr()),
        backgroundColor: const Color(0xFF008080),
      ),
    );
  }

  /// Show failure
  void showFailure(BuildContext context, String error) {
    if (context.mounted) {
      notificationDialog(
        context: context,
        title: 'notification.failure'.tr(),
        message: error,
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationFailure) {
          showFailure(context, state.error);
        }
        if (state is NotificationDeleteSuccess) {
          showNotificationDeleteSuccess(context);
        }
        if (state is NotificationDeleteAllSuccess) {
          showNotificationDeleteAllSuccess(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.hover.withOpacity(0.9),
        appBar: HeaderWithBack(
          title: 'notification.title'.tr(),
          onBack: () => _onBack(context),
          showMore: true,
          onMore: () => _onMore(context),
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            /// LOADING
            if (state is NotificationLoading || state is NotificationInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            /// SUCCESS
            if (state is GetNotificationsSuccess) {
              if (state.notifications.isEmpty) {
                return EmptyList(
                  title: 'notification.empty_title'.tr(),
                  subtitle: 'notification.empty_subtitle'.tr(),
                  imagePath: 'assets/images/search/not_found_hotel.png',
                );
              }

              return ListView.separated(
                itemCount: state.notifications.length,
                separatorBuilder: (_, __) => const SizedBox(),
                itemBuilder: (context, index) {
                  final item = state.notifications[index];

                  return NotificationItem(
                    id: item.id,
                    title: item.title,
                    content: item.content,
                    createdAt: item.createdAt,
                    onDelete: () => _deleteNotification(item.id),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
