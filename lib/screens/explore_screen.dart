import 'package:community/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:community/widgets/app_bottom_nav_bar.dart';

class ExploreScreen extends StatelessWidget {
  final Function(Map<String, String>) onJoin;

  const ExploreScreen({super.key, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FF),


      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF9BB7FF),
        title: const Text(
          "Explore Communities",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),


      body: const SizedBox.shrink(),


      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: 3, // Communities
        onBack: () => Navigator.pop(context),
        onHome: () => Navigator.popUntil(context, (route) => route.isFirst),
        onCommunities: null, // already here
        onAdd: () {},
        onProfile: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
            ),
          );
        },
      ),
    );
  }
}