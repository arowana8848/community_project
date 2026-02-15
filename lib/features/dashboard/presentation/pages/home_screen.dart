import 'package:community/features/auth/presentation/state/auth_state.dart';
import 'package:community/features/profile/presentation/pages/profile_screen.dart' as profile;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:community/features/explore/presentation/pages/explore_screen.dart';
import 'package:community/features/addpost/presentation/pages/addpost_screen.dart';
import 'package:community/core/widgets/app_bottom_nav_bar.dart';
import 'package:community/features/feed/presentation/pages/feed_screen.dart';
import 'package:community/features/feed/data/local/post_store.dart';
import 'package:community/features/feed/domain/entities/community_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community/features/auth/presentation/provider/auth_provider.dart';
import 'package:community/features/auth/presentation/pages/login_screen.dart';
import 'package:community/features/community/presentation/provider/community_provider.dart';

const Color kTopBarColor = Color(0xFF9BB7FF);
const Color kPageBgColor = Color(0xFFF5F7FF);
const Color kCardBgColor = Colors.white;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(communityProvider.notifier).fetchMyCommunities();
    });
  }

  Future<void> _leaveCommunity(String communityId) async {
    await ref.read(communityProvider.notifier).leaveCommunity(communityId);
  }

  void _openCommunityFeed(String communityId, String communityName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedScreen(
          communityId: communityId,
          communityName: communityName,
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final communityState = ref.watch(communityProvider);
    final user = authState.user;

    // Redirect to login if unauthenticated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.status == AuthStatus.unauthenticated) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    });


    // Error and loading state handling
    final isLoading =
      authState.status == AuthStatus.loading || communityState.isLoading;
    final isError = (authState.status == AuthStatus.error &&
        authState.errorMessage != null) ||
      communityState.errorMessage != null;
    final errorMessage = authState.errorMessage ?? communityState.errorMessage;

    final communities = communityState.myCommunities;

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
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9BB7FF), Color(0xFFBBD0FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            "HOME",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 22,
              letterSpacing: 1,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              tooltip: 'Logout',
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF5F7FF), Color(0xFFE8EEFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 👤 PROFILE CARD
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: kCardBgColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 42,
                            backgroundImage: AssetImage('assets/icons/profile.png'),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome back 👋',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.fullName ?? 'User',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kTopBarColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const profile.ProfileScreen()),
                                    );
                                  },
                                  child: const Text("View Profile"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isError && errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                    const Text(
                      'Your Communities',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 🌍 COMMUNITY CARDS
                    Column(
                      children: communities.asMap().entries.map((entry) {
                        final index = entry.key;
                        final community = entry.value;
                        final rawCommunityId = community.id;
                        final communityName = community.title ?? 'Community';
                        final communityId =
                            rawCommunityId ?? 'community-$index';
                        return InkWell(
                          onTap: () => _openCommunityFeed(
                            communityId,
                            communityName,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundImage: _communityImage(community.image),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        communityName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Latest discussions and posts here',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: rawCommunityId == null
                                      ? null
                                      : () => _leaveCommunity(rawCommunityId),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
        // 🔻 BOTTOM NAV (UNCHANGED LOGIC)
        bottomNavigationBar: AppBottomNavBar(
          selectedIndex: 1,
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
          onHome: () {},
          onCommunities: () async {
            final didJoin = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ExploreScreen(),
              ),
            );
            if (!context.mounted) {
              return;
            }
            if (didJoin == true) {
              ref.read(communityProvider.notifier).fetchMyCommunities();
            }
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