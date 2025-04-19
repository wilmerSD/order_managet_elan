import 'package:flutter/material.dart';
import 'package:order_manager/core/theme/app_colors.dart';

class AppTextStyle {
  AppTextStyle(this.context);
  final BuildContext context;

  TextStyle titleAppBar({
    Color color = AppColors.grayLight,
  }) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(
          color: color, fontWeight: FontWeight.bold, fontFamily: 'Montserrat');

  TextStyle bold26({Color color = AppColors.grayDark}) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 26.0,
          fontFamily: 'Montserrat');

  TextStyle bold24({Color color = AppColors.grayDark}) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 24.0,
          fontFamily: 'Montserrat');

    TextStyle bold18(
          {Color? color = AppColors.grayDark,
          FontWeight fontWeight = FontWeight.w700}) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: color,
          fontWeight: fontWeight,
          fontSize: 18.0,
          fontFamily: 'Montserrat');

  TextStyle bold17(
          {Color? color = AppColors.grayDark,
          FontWeight fontWeight = FontWeight.w700}) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: color,
          fontWeight: fontWeight,
          fontSize: 17.0,
          fontFamily: 'Montserrat');

  TextStyle bold16({Color? color = AppColors.grayDark}) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
          fontFamily: 'Montserrat');

  TextStyle bold15(
          {Color? color = AppColors.grayDark,
          FontWeight fontWeight = FontWeight.w700}) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: color,
          fontWeight: fontWeight,
          fontSize: 15.0,
          fontFamily: 'Montserrat');

  TextStyle bold14(
          {Color? color = AppColors.grayDark,
          FontWeight fontWeight = FontWeight.w500}) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: color,
          fontWeight: fontWeight,
          fontSize: 14.0,
          fontFamily: 'Montserrat');

  TextStyle bold13(
          {Color? color = AppColors.grayDark,
          FontWeight fontWeight = FontWeight.w500}) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: color,
          fontWeight: fontWeight,
          fontSize: 13.0,
          fontFamily: 'Montserrat');

  TextStyle bold12(
          {Color? color = AppColors.grayDark,
          FontWeight fontWeight = FontWeight.w500}) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: color,
          fontWeight: fontWeight,
          fontSize: 12.0,
          fontFamily: 'Montserrat');

  TextStyle bold11(
          {Color? color = AppColors.grayDark,
          FontWeight fontWeight = FontWeight.w500}) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: color,
          fontWeight: fontWeight,
          fontSize: 11.0,
          fontFamily: 'Montserrat');

  TextStyle bold10(
          {Color? color = AppColors.grayDark,
          FontWeight fontWeight = FontWeight.w500}) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: color,
          fontWeight: fontWeight,
          fontSize: 10.0,
          fontFamily: 'Montserrat');
  //-----------------------------

  TextStyle normal12({
    Color color = AppColors.grayLight,
  }) =>
      Theme.of(context)
          .textTheme
          .bodySmall!
          .copyWith(color: color, fontSize: 12.0, fontFamily: 'Montserrat');

  TextStyle semi12({
    Color color = AppColors.grayLight,
  }) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 12.0,
          fontFamily: 'Montserrat');

  TextStyle semi16({Color color = AppColors.grayLight}) =>
      Theme.of(context).textTheme.titleMedium!.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
          fontFamily: 'Montserrat');
          
  TextStyle semi14({
    Color color = AppColors.grayLight,
  }) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
          fontFamily: 'Montserrat');

  TextStyle medium14({
    Color color = AppColors.grayLight,
  }) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: color,
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          fontFamily: 'Montserrat');

  TextStyle medium12({
    Color color = AppColors.grayLight,
  }) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: color,
          fontWeight: FontWeight.w400,
          fontSize: 12.0,
          fontFamily: 'Montserrat');
}
