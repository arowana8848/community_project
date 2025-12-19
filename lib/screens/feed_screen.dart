import 'package:community/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:community/screens/addpost_screen.dart';
import 'package:community/screens/explore_screen.dart';
import 'package:community/widgets/app_bottom_nav_bar.dart';

const Color kTopBarColor = Color(0xFF9BB7FF);
const Color kPageBgColor = Color(0xFFEFF3FF);

class FeedScreen extends StatefulWidget {
  final String communityName;
  final String imagePath;

  const FeedScreen({
    super.key,
    required this.communityName,
    required this.imagePath,
  });

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<String> _posts = []; 

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
          title: Text(
            widget.communityName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        body: const SizedBox.shrink(), 

        bottomNavigationBar: AppBottomNavBar(
          selectedIndex: 1, // Home (or change to another index if Feed is separate)
          onBack: () => Navigator.pop(context),
          onHome: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          onCommunities: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExploreScreen(
                  onJoin: (community) {},
                ),
              ),
            );
          },
          onAdd: () async {
            final result = await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPostScreen(),
              ),
            );
            if (result != null && result.trim().isNotEmpty) {
              setState(() {
                _posts.add(result.trim());
              });
            }
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