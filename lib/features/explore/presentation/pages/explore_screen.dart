import 'package:community/features/profile/presentation/pages/profile_screen.dart' as profile;
import 'package:flutter/material.dart';
import 'package:community/core/widgets/app_bottom_nav_bar.dart';
import 'package:community/features/feed/presentation/pages/feed_screen.dart';

class ExploreScreen extends StatefulWidget {
  final Function(Map<String, String>) onJoin;

  const ExploreScreen({super.key, required this.onJoin});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> allCommunities = [
    {
      'title': 'Global Football',
      'image': 'assets/icons/football.jpg',
      'members': '40M+ Users'
    },
    {
      'title': 'Politics',
      'image': 'assets/icons/politics.png',
      'members': '15M+ Users'
    },
    {
      'title': 'Science & Technology',
      'image': 'assets/icons/science.png',
      'members': '25M+ Users'
    },
  ];

  List<Map<String, String>> filteredCommunities = [];

  @override
  void initState() {
    super.initState();
    filteredCommunities = allCommunities;
  }

  void _searchCommunity(String query) {
    setState(() {
      filteredCommunities = allCommunities
          .where((c) =>
              c['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget _communityCard(Map<String, String> community) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF2F6FF)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                community['image']!,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  community['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  community['members']!,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () {
                    widget.onJoin({
                      'title': community['title']!,
                      'image': community['image']!,
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 5,
                    shadowColor: Colors.blue.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 10),
                  ),
                  child: const Text(
                    "Join Community",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FF),

      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF9BB7FF),
        title: const Text(
          "Find a Community",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔍 MODERN SEARCH BAR
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _searchCommunity,
                decoration: InputDecoration(
                  hintText: "Search communities",
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// 📜 COMMUNITY LIST
            Expanded(
              child: ListView(
                children:
                    filteredCommunities.map(_communityCard).toList(),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: 3,
        onFeed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FeedScreen(),
            ),
          );
        },
        onHome: () =>
            Navigator.popUntil(context, (route) => route.isFirst),
        onCommunities: null,
        onAdd: () {},
        onProfile: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const profile.ProfileScreen(),
            ),
          );
        },
      ),
    );
  }
}
