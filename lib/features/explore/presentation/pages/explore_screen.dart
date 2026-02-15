import 'package:community/features/profile/presentation/pages/profile_screen.dart' as profile;
import 'package:flutter/material.dart';
import 'package:community/core/widgets/app_bottom_nav_bar.dart';
import 'package:community/features/feed/presentation/pages/feed_screen.dart';
import 'package:community/features/feed/data/local/post_store.dart';
import 'package:community/features/feed/domain/entities/community_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community/features/explore/domain/entities/explore_community_entity.dart';
import 'package:community/features/explore/presentation/providers/explore_provider.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(exploreProvider.notifier).fetchCommunities();
    });
  }

  void _searchCommunity(String query) {
    setState(() {});
  }

  ImageProvider _communityImage(String? image) {
    if (image == null || image.isEmpty) {
      return const AssetImage('assets/icons/profile.png');
    }
    if (image.startsWith('http')) {
      return NetworkImage(image);
    }
    return AssetImage(image);
  }

  Widget _communityCard(ExploreCommunityEntity community) {
    final communityId = community.id;
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
            color: Colors.black.withValues(alpha: 0.05),
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
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
                child: Image(
                  image: _communityImage(community.image),
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
                  community.title ?? 'Community',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () async {
                    if (communityId == null) {
                      return;
                    }
                    final success = await ref
                      .read(exploreProvider.notifier)
                      .joinCommunity(communityId);
                    if (!mounted) {
                      return;
                    }
                    if (success) {
                      Navigator.pop(context, true);
                    } else {
                      final message = ref.read(exploreProvider).errorMessage;
                      if (message != null) {
                        if (message.toLowerCase().contains('already joined')) {
                          // Show dialog for already joined
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Already Joined'),
                              content: Text(message),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Show snackbar for other errors
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 5,
                    shadowColor: Colors.blue.withValues(alpha: 0.4),
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
    final communityState = ref.watch(exploreProvider);
    final query = _searchController.text.trim().toLowerCase();
    final allCommunities = communityState.communities;
    final filteredCommunities = query.isEmpty
        ? allCommunities
        : allCommunities
            .where((c) => (c.title ?? '').toLowerCase().contains(query))
            .toList();

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
                    color: Colors.black.withValues(alpha: 0.05),
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
              child: communityState.isLoading && allCommunities.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
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
