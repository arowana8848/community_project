import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:community/screens/explore_screen.dart';
import 'package:community/widgets/app_bottom_nav_bar.dart';

const Color kTopBarColor = Color(0xFF9BB7FF);
const Color kPageBgColor = Color(0xFFEFF3FF);

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _postController = TextEditingController();

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
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
            'Add a Post',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        body: const SizedBox.shrink(), // empty for now

        bottomNavigationBar: AppBottomNavBar(
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
          onAdd: null, // already on AddPost
          onProfile: () {},
        ),
      ),
    );
  }
}