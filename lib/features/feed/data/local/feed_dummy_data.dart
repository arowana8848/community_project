import 'package:community/features/feed/domain/entities/community_model.dart';
import 'package:community/features/feed/domain/entities/post_model.dart';

const CommunityModel fallbackCommunity = CommunityModel(
  id: 'general',
  name: 'General',
  imageUrl: 'assets/icons/profile.png',
);

const List<CommunityModel> dummyCommunities = [
  CommunityModel(
    id: 'science-tech',
    name: 'Science & Technology',
    imageUrl: 'assets/icons/profile.png',
  ),
  CommunityModel(
    id: 'politics',
    name: 'Politics',
    imageUrl: 'assets/icons/profile.png',
  ),
  CommunityModel(
    id: 'sports',
    name: 'Sports',
    imageUrl: 'assets/icons/profile.png',
  ),
  CommunityModel(
    id: 'arts',
    name: 'Arts & Culture',
    imageUrl: 'assets/icons/profile.png',
  ),
];

final List<PostModel> dummyPosts = [
  PostModel(
    id: 'p1',
    userId: 'local-user',
    text: 'Welcome to Science & Technology!',
    communityId: 'science-tech',
    createdAt: DateTime(2026, 2, 1, 10, 0),
  ),
  PostModel(
    id: 'p2',
    userId: 'local-user',
    text: 'Discussing current events in Politics.',
    communityId: 'politics',
    createdAt: DateTime(2026, 2, 3, 9, 30),
  ),
];

CommunityModel getDefaultCommunity() {
  return dummyCommunities.isNotEmpty
      ? dummyCommunities.first
      : fallbackCommunity;
}
