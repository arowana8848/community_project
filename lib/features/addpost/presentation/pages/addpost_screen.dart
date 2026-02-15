import 'package:community/features/profile/presentation/pages/profile_screen.dart' as profile;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:community/features/explore/presentation/pages/explore_screen.dart';
import 'package:community/core/widgets/app_bottom_nav_bar.dart';
import 'package:community/features/feed/data/local/post_store.dart';
import 'package:community/features/feed/domain/entities/community_model.dart';
import 'package:community/features/feed/presentation/pages/feed_screen.dart';
import 'package:community/features/community/presentation/provider/community_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community/features/feed/presentation/providers/feed_provider.dart';

const Color kTopBarColor = Color(0xFF9BB7FF);
const Color kPageBgColor = Color(0xFFEFF3FF);

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  final TextEditingController _postController = TextEditingController();
  String? _selectedCommunityId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(communityProvider.notifier).fetchMyCommunities();
    });
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Widget _mediaButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.shade50],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
              )
            ],
          ),
          child: Icon(icon, size: 26, color: Colors.blue),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final communityState = ref.watch(communityProvider);
    final joinedCommunities = communityState.myCommunities;
    final dropdownItems = joinedCommunities
        .where((community) => community.id != null && community.id!.isNotEmpty)
        .map(
          (community) => DropdownMenuItem<String>(
            value: community.id,
            child: Text(community.title ?? 'Community'),
          ),
        )
        .toList();

    final selectedValue = dropdownItems
            .any((item) => item.value == _selectedCommunityId)
        ? _selectedCommunityId
        : null;
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
            'Add Post',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                /// 🔵 SELECT COMMUNITY DROPDOWN
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6A9CFF), Color(0xFF9BB7FF)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedValue,
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.white,
                      hint: Text(
                        dropdownItems.isEmpty
                            ? 'Join a community first'
                            : 'Select a community',
                        style: const TextStyle(color: Colors.white),
                      ),
                      items: dropdownItems,
                      onChanged: dropdownItems.isEmpty
                          ? null
                          : (value) {
                              setState(() {
                                _selectedCommunityId = value;
                              });
                            },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                /// ✨ POST CARD
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// 👤 USER INFO
                        Row(
                          children: const [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Arowan Gd",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// ✏️ TEXT FIELD
                        Expanded(
                          child: TextField(
                            controller: _postController,
                            maxLines: null,
                            expands: true,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              hintText: "What's on your mind?",
                              hintStyle: TextStyle(
                                fontSize: 22,
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// 🖼️ MEDIA BUTTONS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _mediaButton(Icons.image, "Add Image"),
                            _mediaButton(Icons.videocam, "Add Video"),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// 🚀 POST BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final message = _postController.text.trim();
                              if (_selectedCommunityId == null ||
                                  _selectedCommunityId!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please select a community.'),
                                  ),
                                );
                                return;
                              }
                              if (message.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Post cannot be empty.'),
                                  ),
                                );
                                return;
                              }

                              ref
                                  .read(feedProvider.notifier)
                                  .createPost(
                                    communityId: _selectedCommunityId!,
                                    text: message,
                                  )
                                  .then((_) async {
                                await ref
                                    .read(feedProvider.notifier)
                                    .fetchPosts(_selectedCommunityId!);
                                if (!mounted) {
                                  return;
                                }
                                Navigator.pop(context);
                              }).catchError((error) {
                                if (!mounted) {
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error.toString())),
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              elevation: 6,
                              shadowColor: Colors.blue.withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              "Post",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        bottomNavigationBar: AppBottomNavBar(
          selectedIndex: 2,
          onFeed: () {
            final CommunityModel defaultCommunity =
                selectedCommunityStore.value;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FeedScreen(
                  communityId: defaultCommunity.id,
                  communityName: defaultCommunity.name,
                ),
              ),
            );
          },
          onHome: () => Navigator.popUntil(context, (route) => route.isFirst),
          onCommunities: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ExploreScreen(),
              ),
            );
          },
          onAdd: null,
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
