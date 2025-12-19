import 'package:community/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:community/screens/explore_screen.dart';
import 'package:community/screens/addpost_screen.dart';
import 'package:community/widgets/app_bottom_nav_bar.dart';

const Color kTopBarColor = Color(0xFF9BB7FF);
const Color kPageBgColor = Color(0xFFF5F7FF);
const Color kCardBgColor = Colors.white;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> communities = [
    {'title': 'Global Football', 'image': 'assets/icons/football.jpg'},
    {'title': 'Politics', 'image': 'assets/icons/politics.png'},
    {'title': 'Science & Technology', 'image': 'assets/icons/science.png'},
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
              fontFamily: 'Open sans Bold',
              fontSize: 22,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Profile Section =====
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kCardBgColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/icons/profile.png'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome, User!',
                            style: TextStyle(
                              fontFamily: 'Open sans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kTopBarColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileScreen()),
                              );
                            },
                            child: const Text(
                              'View Profile',
                              style: TextStyle(
                                fontFamily: 'Open sans',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== Your Communities Header (No Add Button) =====
              const Text(
                'Your Communities',
                style: TextStyle(
                  fontFamily: 'Open sans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // ===== Communities List =====
              Column(
                children: communities.map((community) {
                  int index = communities.indexOf(community);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kCardBgColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(community['image']!),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                community['title']!,
                                style: const TextStyle(
                                  fontFamily: 'Open sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Latest discussions and posts here',
                                style: TextStyle(
                                  fontFamily: 'Open sans',
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => removeCommunity(index),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(
          selectedIndex: 1,
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
          onProfile: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
