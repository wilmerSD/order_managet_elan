import 'package:flutter/material.dart';
import 'package:order_manager/core/helpers/constant.dart';
import 'package:order_manager/core/theme/app_colors.dart';
import 'package:order_manager/core/theme/app_text_style.dart';

class AlertDialogComponent extends StatelessWidget {
  const AlertDialogComponent({
    super.key,
    this.isPrimaryBanner = false,
    this.imagePathBanner,
    this.headerTitle,
    this.title,
    this.content = "",
    this.textPrimaryButton = "Si",
    this.textSecondaryButton = "No",
    this.isOnlyPrimary = false,
    this.isPrimaryButton = true,
    this.isDismissibleDialog = true,
    this.widgetContent,
    required this.onTapButton,
    this.onTapButtonSecondary,
  });

  final bool isPrimaryBanner;
  final String? imagePathBanner;
  final String? headerTitle;
  final String? title;
  final String content;
  final String? textPrimaryButton;
  final String? textSecondaryButton;
  final bool isOnlyPrimary;
  final bool isPrimaryButton;
  final bool isDismissibleDialog;
  final Widget? widgetContent;
  final VoidCallback onTapButton;
  final VoidCallback? onTapButtonSecondary;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      //canPop: (isDismissibleDialog) ? null : () => Future.value(false),
      child: AlertDialog(
        backgroundColor: AppColors.backgroundColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusSmall),
        ),
        title:
            (headerTitle != null)
                ? Text(
                  headerTitle!,
                  style: AppTextStyle(
                    context,
                  ).bold14(color: AppColors.primary(context)),
                  textAlign: TextAlign.center,
                )
                : null,
        contentPadding: const EdgeInsets.all(15.0),
        content:
            (widgetContent != null)
                ? widgetContent
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (imagePathBanner != null)
                        ? Container(
                          height: 80.0,
                          width: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color:
                                (isPrimaryBanner) ? AppColors.blueCustom : null,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                          ),
                          child: Image.asset(
                            imagePathBanner!,
                            //color: (isPrimaryBanner) ? AppColorss.kIconWhiteColor : null,
                          ),
                        )
                        : Container(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        (title != null)
                            ? Text(
                              title!,
                              style: AppTextStyle(
                                context,
                              ).bold14(color: AppColors.textBasic(context)),
                            )
                            : Container(),
                        (title != null)
                            ? const SizedBox(height: 10.0)
                            : const SizedBox(),
                        Text(
                          content,
                          style: AppTextStyle(
                            context,
                          ).medium12(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
        actionsAlignment: isOnlyPrimary ? MainAxisAlignment.center : null,
        actions: [
          (isOnlyPrimary)
              ? const SizedBox()
              : SizedBox(
                height: 33.0,
                child: MaterialButton(
                  onPressed:
                      (onTapButtonSecondary != null)
                          ? onTapButtonSecondary
                          : () => Navigator.of(context).pop(),
                  elevation: 0.0,
                  // height: 40.0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.primary(context)),
                    borderRadius: BorderRadius.circular(kRadiusSmall),
                  ),
                  child: Text(
                    textSecondaryButton!,
                    style: AppTextStyle(
                      context,
                    ).medium12(color: AppColors.primary(context)),
                  ),
                ),
              ),
          Container(
            height: 34.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kRadiusSmall),
              gradient:
                  (isPrimaryButton)
                      ? LinearGradient(
                        colors: [
                          AppColors.primary(
                            context,
                          ), // Color de final del degradado
                          AppColors
                              .primaryConst, // Color de inicio del degradado
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.bottomRight,
                      )
                      : null,
            ),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadiusSmall),
              ),
              onPressed: onTapButton,
              child: Text(
                textPrimaryButton!,
                style: AppTextStyle(context).medium12(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
