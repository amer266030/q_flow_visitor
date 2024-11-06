import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../buttons/primary_btn.dart';

AwesomeDialog showErrorDialog(BuildContext context, String msg) {
  return AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      padding: EdgeInsets.all(24),
      dialogBorderRadius: BorderRadius.circular(24),
      dialogBackgroundColor: context.bg1,
      barrierColor: context.bg3.withOpacity(0.4),
      title: 'ERROR'.tr(),
      titleTextStyle: context.titleMedium,
      animType: AnimType.scale,
      desc: msg,
      descTextStyle: context.bodyMedium,
      btnOk:
          PrimaryBtn(callback: () => Navigator.of(context).pop(), title: 'OK'.tr()))
    ..show();
}
