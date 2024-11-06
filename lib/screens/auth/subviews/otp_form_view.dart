import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:q_flow/reusable_components/buttons/primary_btn.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../../reusable_components/page_header_view.dart';

class OtpFormView extends StatelessWidget {
  const OtpFormView({
    super.key,
    required this.email,
    required this.goBack,
    required this.verifyOTP,
  });
  final String email;
  final VoidCallback goBack;
  final Function(int) verifyOTP;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      textStyle: TextStyle(
          fontSize: 24, color: context.textColor1, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: context.bg1,
        border: Border.all(color: context.bg3, width: 0.5),
        borderRadius: BorderRadius.circular(50),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
          color: context.bg3,
          width: 2,
          strokeAlign: BorderSide.strokeAlignCenter),
      borderRadius: BorderRadius.circular(50),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
          color: context.primary,
          width: 2,
          strokeAlign: BorderSide.strokeAlignCenter),
      borderRadius: BorderRadius.circular(50),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeaderView(title: 'VerifyYourEmail'.tr()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Text('Verification',
                    style: context.bodyLarge).tr(),
                Text(email, style: context.bodyMedium)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text('OTP', style: context.bodyMedium).tr()
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 7,
                  child: Pinput(
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      length: 6,
                      showCursor: true,
                      onCompleted: (pin) {
                        // Call verifyOTP only if pin is not empty
                        if (pin.isNotEmpty) {
                          verifyOTP(int.tryParse(pin) ?? -1);
                        } else {
                          // Show error message if OTP is empty
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter the OTP.')),
                          );
                        }
                      }
                      // onCompleted: (pin) => verifyOTP(int.tryParse(pin) ?? -1),
                      ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              TextButton(
                onPressed: goBack,
                child: Text(
                  'Cancel',
                  style: TextStyle(color: context.primary),
                ).tr(),
              )
            ]),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                  child: PrimaryBtn(
                      title: 'Verify'.tr(), callback: () => verifyOTP(-1))),
            ],
          )
        ],
      ),
    );
  }
}
