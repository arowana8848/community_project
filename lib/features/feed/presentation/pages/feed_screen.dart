import 'package:community/features/profile/presentation/pages/profile_screen.dart' as profile;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community/features/explore/presentation/pages/explore_screen.dart';
import 'package:community/features/addpost/presentation/pages/addpost_screen.dart';
import 'package:community/core/widgets/app_bottom_nav_bar.dart';

const Color kTopBarColor = Color(0xFF9BB7FF);
const Color kPageBgColor = Color(0xFFEFF3FF);

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kTopBarColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kPageBgColor,
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
          backgroundColor: kTopBarColor,
          title: const Text(
            'Feed',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ...existing code...
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(
          selectedIndex: 0,
          onFeed: null,
          onHome: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
          onCommunities: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ExploreScreen(),
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
                builder: (context) => const profile.ProfileScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
