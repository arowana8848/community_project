import 'package:community/core/services/storage/user_session_service.dart';
import 'package:community/features/profile/presentation/pages/profile_screen.dart' as profile;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:community/features/addpost/presentation/pages/addpost_screen.dart';
import 'package:community/core/widgets/app_bottom_nav_bar.dart';
import 'package:community/features/explore/presentation/pages/explore_screen.dart';
import 'package:community/features/feed/data/local/feed_dummy_data.dart';
import 'package:community/features/feed/data/local/post_store.dart';
import 'package:community/features/feed/domain/entities/community_model.dart';
import 'package:community/features/feed/domain/entities/post_model.dart';
import 'package:community/features/feed/presentation/providers/feed_provider.dart';
import 'package:community/features/community/domain/entities/community_entity.dart';
import 'package:community/features/community/presentation/provider/community_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color kTopBarColor = Color(0xFF9BB7FF);
const Color kPageBgColor = Color(0xFFEFF3FF);

class FeedScreen extends ConsumerStatefulWidget {
  final String communityId;
  final String communityName;
  final String? communityImageUrl;

  const FeedScreen({
    super.key,
    required this.communityId,
    required this.communityName,
    this.communityImageUrl,
  });

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  late final VoidCallback _selectedCommunityListener;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(communityProvider.notifier).fetchMyCommunities();
      ref.read(feedProvider.notifier).fetchPosts(widget.communityId);
    });
    setSelectedCommunity(
      CommunityModel(
        id: widget.communityId,
        name: widget.communityName,
        imageUrl: widget.communityImageUrl ?? fallbackCommunity.imageUrl,
      ),
    );
    _selectedCommunityListener = () {
      final selected = selectedCommunityStore.value;
      ref.read(feedProvider.notifier).fetchPosts(selected.id);
    };
    selectedCommunityStore.addListener(_selectedCommunityListener);
  }

  @override
  void dispose() {
    selectedCommunityStore.removeListener(_selectedCommunityListener);
    super.dispose();
  }

  List<CommunityModel> _mapJoinedCommunities(List<CommunityEntity> joined) {
    return joined
        .where((community) => community.id != null && community.id!.isNotEmpty)
        .map(
          (community) => CommunityModel(
            id: community.id!,
            name: community.title ?? 'Community',
            imageUrl: community.image ?? fallbackCommunity.imageUrl,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final communityState = ref.watch(communityProvider);
    final joinedCommunities = _mapJoinedCommunities(communityState.myCommunities);
    final feedState = ref.watch(feedProvider);
    String? currentUserId;
    String? currentUserName;
    try {
      final userSession = ref.read(userSessionServiceProvider);
      currentUserId = userSession.getCurrentUserId();
      currentUserName = userSession.getCurrentUserFullName();
    } catch (_) {
      currentUserId = null;
      currentUserName = null;
    }
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
          title: ValueListenableBuilder<CommunityModel>(
            valueListenable: selectedCommunityStore,
            builder: (context, selectedCommunity, _) {
              return Text(
                selectedCommunity.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              );
            },
          ),
        ),
        body: ValueListenableBuilder<CommunityModel>(
          valueListenable: selectedCommunityStore,
          builder: (context, selectedCommunity, _) {
            final options = <CommunityModel>[
              selectedCommunity,
              ...joinedCommunities,
            ];
            final uniqueOptions = <String, CommunityModel>{};
            for (final option in options) {
              uniqueOptions[option.id] = option;
            }
            final dropdownItems = uniqueOptions.values.toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: DropdownButtonFormField<String>(
                    value: selectedCommunity.id,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: dropdownItems
                        .map(
                          (community) => DropdownMenuItem<String>(
                            value: community.id,
                            child: Text(community.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      final match = dropdownItems
                          .firstWhere((community) => community.id == value);
                      setSelectedCommunity(match);
                    },
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (feedState.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (feedState.errorMessage != null) {
                        return Center(
                          child: Text(
                            feedState.errorMessage!,
                            style: const TextStyle(color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      final posts = feedState.posts
                          .where((post) => post.communityId == selectedCommunity.id)
                          .toList();
                      if (posts.isEmpty) {
                        return const Center(
                          child: Text(
                            'No posts yet for this community.',
                            style: TextStyle(color: Colors.black54),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          final authorName = post.userName ??
                              (post.userId.isNotEmpty &&
                                      post.userId == currentUserId
                                  ? (currentUserName ?? 'You')
                                  : 'Community member');
                          return _PostCard(
                            post: post,
                            authorName: authorName,
                            onReact: (reaction) async {
                              await ref
                                  .read(feedProvider.notifier)
                                  .reactToPost(
                                    postId: post.id,
                                    reaction: reaction,
                                  );
                            },
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: posts.length,
                      );
                    },
                  ),
                ),
              ],
            );
          },
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

class _PostCard extends StatelessWidget {
  final PostModel post;
  final String authorName;
  final ValueChanged<String> onReact;

  const _PostCard({
    required this.post,
    required this.authorName,
    required this.onReact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/icons/profile.png'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  authorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post.text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatTimestamp(post.createdAt),
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Row(
                children: [
                  Tooltip(
                    message: post.userReaction == 'like' ? 'Unlike' : 'Like',
                    child: IconButton(
                      onPressed: () => onReact('like'),
                      icon: Icon(
                        post.userReaction == 'like'
                            ? Icons.thumb_up_alt
                            : Icons.thumb_up_alt_outlined,
                        color: post.userReaction == 'like'
                            ? const Color(0xFF2563EB)
                            : Colors.black54,
                        size: 22,
                      ),
                    ),
                  ),
                  Text(
                    '${post.likeCount}',
                    style: TextStyle(
                      color: post.userReaction == 'like'
                          ? const Color(0xFF2563EB)
                          : Colors.black54,
                      fontWeight: post.userReaction == 'like'
                          ? FontWeight.w700
                          : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Tooltip(
                    message: post.userReaction == 'dislike' ? 'Remove dislike' : 'Dislike',
                    child: IconButton(
                      onPressed: () => onReact('dislike'),
                      icon: Icon(
                        post.userReaction == 'dislike'
                            ? Icons.thumb_down_alt
                            : Icons.thumb_down_alt_outlined,
                        color: post.userReaction == 'dislike'
                            ? const Color(0xFFDC2626)
                            : Colors.black54,
                        size: 22,
                      ),
                    ),
                  ),
                  Text(
                    '${post.dislikeCount}',
                    style: TextStyle(
                      color: post.userReaction == 'dislike'
                          ? const Color(0xFFDC2626)
                          : Colors.black54,
                      fontWeight: post.userReaction == 'dislike'
                          ? FontWeight.w700
                          : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    final date = dateTime.toLocal();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.year}-$month-$day $hour:$minute';
  }
}
