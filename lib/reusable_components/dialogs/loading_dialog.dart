import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:q_flow/extensions/img_ext.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

AwesomeDialog showLoadingDialog(BuildContext context) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.noHeader,
    padding: EdgeInsets.symmetric(vertical: 24),
    dialogBorderRadius: BorderRadius.circular(24),
    dialogBackgroundColor: context.bg1,
    barrierColor: context.textColor1.withOpacity(0.4),
    dismissOnTouchOutside: false,
    animType: AnimType.scale,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(
          image: Img.loading,
        ),
        SizedBox(height: 16),
        Text('PleaseWait'.tr(), style: context.bodyMedium),
      ],
    ),
  )..show();
}
