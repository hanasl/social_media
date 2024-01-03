import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../home.dart';
import 'chat_screen.dart';
import 'post_screen.dart';
import 'profil_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);
    List<Widget> _buildScreens() {
      return [
        HomeScreen(),
        PostScreen(),
        ChatScreen(),
        ProfilScreen(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
          title: ("Home"),
          activeColorPrimary: Color(0xffB81736),
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          iconSize: 28,
          icon: Icon(Icons.add),
          title: ("Ajouter Boutique "),
          activeColorPrimary: Color(0xffB81736),
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          iconSize: 28,
          icon: Icon(Icons.message),
          title: ("Chat"),
          activeColorPrimary: Color(0xffB81736),
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          iconSize: 28,
          icon: Icon(Icons.person),
          title: ("Profil"),
          activeColorPrimary: Color(0xffB81736),
          inactiveColorPrimary: Colors.grey,
        ),
      ];
    }

    return Scaffold(
        body: PersistentTabView(
      context,
      navBarHeight: 55,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.grey.shade50,
      //Color.fromARGB(255, 219, 216, 231),
      // Color.fromARGB(255, 159, 139, 167),
      //, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25), topLeft: Radius.circular(25)),
        colorBehindNavBar: Colors.red,
        //border: Border.all(color: Colors.black26)
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style14, // Choose the nav bar style with this property.
    ));
  }
}
