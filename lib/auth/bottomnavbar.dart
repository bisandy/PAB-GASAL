import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
Widget build(BuildContext context) {
  return BottomNavigationBar(
    currentIndex: currentIndex,
    onTap: (index) {
      if (index != currentIndex) {
        onTap(index);
      }
    },
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle_rounded),
        label: 'Dosen',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle_rounded),
        label: 'Mahasiswa',
      ),
    ],
  );
}
}