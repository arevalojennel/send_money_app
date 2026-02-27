import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:send_money_app/presentation/theme/app_colors.dart';

class SnackBarUtils {
  static void showSnackBar({
    required String message,
    required Color backgroundColor,
    Color textColor = AppColors.onPrimary,
    String title = "Success",
    SnackPosition? snackPosition = SnackPosition.BOTTOM,
  }) {
    Get.snackbar(
      title,
      " ${message.toString()}",
      colorText: textColor,
      backgroundColor: backgroundColor,
      snackPosition: snackPosition,
      borderWidth: double.infinity,
      margin: const EdgeInsets.all(0),
      borderRadius: 0,
      duration: const Duration(milliseconds: 1500),
    );
  }

  static void showSuccessMessage({
    required String message,
    String? title,
    SnackPosition? snackPosition,
  }) {
    showSnackBar(
      message: message,
      backgroundColor: AppColors.primary,
      title: title ?? "Success!",
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
    );
  }

  static void showErrorMessage({
    required String message,
    String? title,
    SnackPosition? snackPosition,
  }) {
    showSnackBar(
      message: message,
      backgroundColor: AppColors.error,
      title: title ?? "Error!",
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
    );
  }

  static void showNoticeMessage({
    required String message,
    String? title,
    SnackPosition? snackPosition,
  }) {
    showSnackBar(
      message: message,
      backgroundColor: AppColors.onBackground,
      title: title ?? "Notice!",
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
    );
  }
}
