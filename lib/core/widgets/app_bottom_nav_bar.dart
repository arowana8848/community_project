import 'package:flutter/material.dart';


class AppBottomNavBar extends StatelessWidget {
  final VoidCallback? onFeed;
  final VoidCallback? onHome;
  final VoidCallback? onCommunities;
  final VoidCallback? onAdd;
  final VoidCallback? onProfile;
  final int selectedIndex;

  const AppBottomNavBar({
    super.key,
    this.onFeed,
    this.onHome,
    this.onCommunities,
    this.onAdd,
    this.onProfile,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: const BoxDecoration(
        color: Color(0xFF7CB5FF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: onFeed,
            icon: Icon(
              Icons.dynamic_feed,
              size: 30,
              color: selectedIndex == 0 ? Colors.black : Colors.white,
            ),
          ),
          IconButton(
            onPressed: onHome,
            icon: Icon(
              Icons.home,
              size: 30,
              color: selectedIndex == 1 ? Colors.black : Colors.white,
            ),
          ),
          CircleAvatar(
            radius: 28,
            backgroundColor: selectedIndex == 2 ? Colors.black : Colors.white,
            child: IconButton(
              onPressed: onAdd,
              icon: Icon(
                Icons.add,
                size: 30,
                color: selectedIndex == 2 ? Colors.white : Colors.blue,
              ),
            ),
          ),
          IconButton(
            onPressed: onCommunities,
            icon: Icon(
              Icons.groups,
              size: 30,
              color: selectedIndex == 3 ? Colors.black : Colors.white,
            ),
          ),
          IconButton(
            onPressed: onProfile,
            icon: Icon(
              Icons.person,
              size: 30,
              color: selectedIndex == 4 ? Colors.black : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}