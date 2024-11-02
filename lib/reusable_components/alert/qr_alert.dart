import 'package:flutter/cupertino.dart';
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
    required this.title,
    required this.onClose,
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
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: onClose,
                        icon: Icon(
                          CupertinoIcons.xmark_circle_fill,
                          color: Colors.black,
                          size: 32,
                          weight: 40,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: BarcodeWidget(
                          height: context.screenHeight * 0.3,
                          barcode: Barcode.qrCode(),
                          data: visitorId.toString(),
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.all(24),
                width: context.screenWidth * 0.9,
                height: context.screenWidth * 0.2,
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: context.bg2)),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Text(title,
                        style: TextStyle(
                          fontSize: context.titleSmall.fontSize,
                          fontWeight: context.titleSmall.fontWeight,
                          color: Colors.black,
                        )),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
