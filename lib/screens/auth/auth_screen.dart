import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/reusable_components/custom_text_field.dart';
import 'package:q_flow/reusable_components/buttons/primary_btn.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';
import 'package:q_flow/utils/validations.dart';

import '../../reusable_components/page_header_view.dart';
import 'auth_cubit.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<AuthCubit>();
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeaderView(title: 'Login'),
                  Expanded(
                    child: ListView(
                      children: [
                        _FormView(cubit: cubit),
                      ],
                    ),
                  ),
                  _ResetBtnView(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _FormView extends StatelessWidget {
  const _FormView({required this.cubit});
  final AuthCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextField(
            hintText: 'Email',
            controller: TextEditingController(),
            validation: Validations.email),
        CustomTextField(
            hintText: 'Password',
            controller: TextEditingController(),
            isObscure: true,
            validation: Validations.password),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
                child: PrimaryBtn(
                    callback: () => cubit.navigate(context), title: 'Start'))
          ],
        ),
      ],
    );
  }
}

class _ResetBtnView extends StatelessWidget {
  const _ResetBtnView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Forgot password?', style: context.bodyMedium),
            TextButton(
              onPressed: () => (),
              child: Text('Reset',
                  style: TextStyle(
                      color: context.primary,
                      fontWeight: context.titleSmall.fontWeight)),
            )
          ],
        ),
      ],
    );
  }
}
