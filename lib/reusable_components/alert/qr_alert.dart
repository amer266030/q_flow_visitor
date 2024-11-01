import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/extensions/screen_size.dart';
import 'package:q_flow/managers/data_mgr.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import 'package:barcode_widget/barcode_widget.dart';

class QRAlert extends StatelessWidget {
  final String title;
  final Function()? onClose;

  const QRAlert({
    Key? key,
    required this.title, required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var visitorId = GetIt.I.get<DataMgr>().visitor?.id;
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                      color: context.bg1,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: onClose,
                        child: Icon(
                          Icons.close_rounded,
                        ),
                      ),
                      BarcodeWidget(
                        height: context.screenHeight * 0.3,
                        barcode: Barcode.qrCode(),
                        data: visitorId.toString(),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.all(24),
                width: context.screenWidth * 0.9,
                height: context.screenWidth * 0.2,
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: context.bg2)),
                    color: context.bg1,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(title,
                    style: TextStyle(
                        fontSize: context.titleSmall.fontSize,
                        fontWeight: context.titleSmall.fontWeight)),
              )
            ],
          )),
    );
  }
}
