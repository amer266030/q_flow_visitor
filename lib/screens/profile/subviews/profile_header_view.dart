import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:q_flow/managers/alert_manger.dart';

import '../../../extensions/img_ext.dart';
import '../../../model/user/visitor.dart';

class ProfileHeaderView extends StatelessWidget {
  const ProfileHeaderView({super.key, required this.visitor});

  final Visitor? visitor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                width: 140,
                height: 140,
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    elevation: 5,
                    child: ClipOval(
                      child: visitor?.avatarUrl == null
                          ? Image(image: Img.avatar, fit: BoxFit.cover)
                          : FadeInImage(
                      placeholder: Img.avatar, 
                      image: NetworkImage(visitor!.avatarUrl!),
                      fit: BoxFit.contain,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image(image: Img.avatar, fit: BoxFit.contain);
                      },
                    ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () => {
                      AlertManager().showQRAlert(
                        context: context,
                        title:
                            "${visitor?.fName ?? ''} ${visitor?.lName ?? ''}",
                      )
                    },
                icon: Icon(CupertinoIcons.qrcode, size: 45)))
      ],
    );
  }
}
