import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:community/screens/explore_screen.dart';
import 'package:community/screens/addpost_screen.dart';
import 'package:community/widgets/app_bottom_nav_bar.dart';

const Color kTopBarColor = Color(0xFF9BB7FF);
const Color kPageBgColor = Color(0xFFEFF3FF);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Kept for future use
  List<Map<String, String>> communities = [
    {'title': 'Global Football', 'image': 'assets/icons/football.jpg'},
    {'title': 'Politics', 'image': 'assets/icons/politics.png'},
  ];

  void addCommunity(Map<String, String> newCommunity) {
    setState(() {
      if (!communities.any((c) => c['title'] == newCommunity['title'])) {
        communities.add(newCommunity);
      }
    });
  }

  void removeCommunity(int index) {
    setState(() {
      communities.removeAt(index);
    });
  }

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
            "HOME",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        body: const SizedBox.shrink(), // empty for now

        bottomNavigationBar: AppBottomNavBar(
          onBack: null,
          onHome: () {},
          onCommunities: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExploreScreen(
                  onJoin: addCommunity,
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
          onProfile: () {},
        ),
      ),
    );
  }
}