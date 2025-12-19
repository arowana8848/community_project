import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:community/screens/explore_screen.dart';
import 'package:community/screens/addpost_screen.dart';
import 'package:community/widgets/app_bottom_nav_bar.dart';

const Color kTopBarColor = Color(0xFF9BB7FF);
const Color kPageBgColor = Color(0xFFEFF3FF);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kTopBarColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kPageBgColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          backgroundColor: kTopBarColor,
          title: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: const Center(
          child: Text(
            'Profile-screen',
            style: TextStyle(fontSize: 20, color: Colors.black54),
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(
          selectedIndex: 4, 
          onBack: () => Navigator.pop(context),
          onHome: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          onCommunities: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExploreScreen(
                  onJoin: (c) {},
                ),
              ),
            );
          },
          onAdd: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPostScreen(),
              ),
            );
          },
          onProfile: null, 
        ),
      ),
    );
  }
}
