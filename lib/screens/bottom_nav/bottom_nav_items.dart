import 'package:flutter/cupertino.dart';
import 'package:q_flow/screens/bookmarks/bookmarks_screen.dart';

import 'package:q_flow/screens/home/home_screen.dart';
import 'package:q_flow/screens/profile_screen.dart';
import 'package:q_flow/screens/tickets_screen.dart';

class BarItems {
  final BuildContext context;

  BarItems(this.context);

  // Now these are instance properties, so context is accessible
  List<Widget> bottomBarPages = [
    const HomeScreen(),
    const BookmarksScreen(),
    const TicketsScreen(),
    const ProfileScreen(),
  ];

  List<IconData> get bottomBarIcons {
    return [
      CupertinoIcons.home,
      CupertinoIcons.bookmark,
      CupertinoIcons.ticket,
      CupertinoIcons.person
    ];
  }
}
