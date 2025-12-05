import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onHome;
  final VoidCallback? onCommunities;
  final VoidCallback? onAdd;
  final VoidCallback? onProfile;

  const AppBottomNavBar({
    super.key,
    this.onBack,
    this.onHome,
    this.onCommunities,
    this.onAdd,
    this.onProfile,
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
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
          ),
          IconButton(
            onPressed: onHome,
            icon: const Icon(Icons.home, size: 30, color: Colors.white),
          ),
             CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 30, color: Colors.blue),
            ),
          ),
          IconButton(
            onPressed: onCommunities,
            icon: const Icon(Icons.groups, size: 30, color: Colors.white),
          ),
       
          IconButton(
            onPressed: onProfile,
            icon: const Icon(Icons.person, size: 30, color: Colors.white),
          ),
        ],
      ),
    );
  }
}