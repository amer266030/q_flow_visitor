import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/screens/bottom_nav/bottom_nav_cubit.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import 'bottom_nav_items.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<BottomNavCubit>();
        return BlocBuilder<BottomNavCubit, BottomNavState>(
          builder: (context, state) {
            return Scaffold(
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: BarItems(context)
                    .bottomBarPages[cubit.currentIndex], // Switch between pages
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(bottom: 32, left: 56, right: 56),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.bg2,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: context.bg3, width: 3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: BarItems(context).bottomBarIcons.map((icon) {
                      int index =
                          BarItems(context).bottomBarIcons.indexOf(icon);
                      bool isSelected = cubit.currentIndex == index;

                      return InkWell(
                        onTap: () => cubit.updateIndex(index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        context.primary,
                                        context.primary.withOpacity(0.5),
                                        context.primary.withOpacity(0.3),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )
                                  : null, // No gradient when not selected
                              color: isSelected
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                icon,
                                color: isSelected
                                    ? Colors.white
                                    : context.textColor2,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
