import 'package:quizsong/core/constants/string.dart';
import 'package:quizsong/ui/Pantallas/bottom_navigation/bottom_navigation_viewmodel.dart';
import 'package:quizsong/ui/Pantallas/bottom_navigation/chats_list/ListaChats.dart';
import 'package:quizsong/ui/Pantallas/bottom_navigation/Ajustes/Pantalla_Ajustes.dart';
import 'package:quizsong/ui/Pantallas/other/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  static final List<Widget> _screens = [
    const Center(child: Text("Pantalla del juego... ")),
    const ChatsListScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;

    const items = [
      BottomNavigationBarItem(
          label: "", icon: BottomNavButton(iconPath: homeIcon)),
      BottomNavigationBarItem(
          label: "", icon: BottomNavButton(iconPath: chatsIcon)),
      BottomNavigationBarItem(
          label: "", icon: BottomNavButton(iconPath: profileIcon)),
    ];
    return ChangeNotifierProvider(
      create: (context) => BottomNavigationViewmodel(),
      child: Consumer<BottomNavigationViewmodel>(builder: (context, model, _) {
        return currentUser == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                body: BottomNavigationScreen._screens[model.currentIndex],
                bottomNavigationBar: CustomNavBar(
                  onTap: model.setIndex,
                  items: items,
                ));
      }),
    );
  }
}

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key, this.onTap, required this.items});

  final void Function(int)? onTap;
  final List<BottomNavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(
      topLeft: Radius.circular(30.0),
      topRight: Radius.circular(30.0),
    );

    return Container(
        decoration: const BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BottomNavigationBar(
            onTap: onTap,
            items: items,
          ),
        ));
  }
}

class BottomNavButton extends StatelessWidget {
  const BottomNavButton({super.key, required this.iconPath});
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Image.asset(
        iconPath,
        height: 35,
        width: 35,
      ),
    );
  }
}
