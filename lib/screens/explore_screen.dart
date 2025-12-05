import 'package:flutter/material.dart';
import 'package:community/widgets/app_bottom_nav_bar.dart';

class ExploreScreen extends StatelessWidget {
  final Function(Map<String, String>) onJoin;

  const ExploreScreen({super.key, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FF),

      // TOP BAR (covers full width + status bar, darker color)
      appBar: AppBar(
        automaticallyImplyLeading: false, // no back icon here, you use bottom nav
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF9BB7FF), // darker than page bg
        title: const Text(
          "Explore Communities",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // EMPTY BODY FOR NOW
      body: const SizedBox.shrink(),

      // BOTTOM NAV BAR
      bottomNavigationBar: AppBottomNavBar(
        onBack: () => Navigator.pop(context),
        onHome: () => Navigator.popUntil(context, (route) => route.isFirst),
        onCommunities: null, // already here
        onAdd: () {},
        onProfile: () {},
      ),
    );
  }
}