import 'package:community/features/feed/data/local/feed_dummy_data.dart';
import 'package:community/features/feed/domain/entities/community_model.dart';
import 'package:flutter/foundation.dart';

final ValueNotifier<CommunityModel> selectedCommunityStore =
    ValueNotifier<CommunityModel>(getDefaultCommunity());

void setSelectedCommunity(CommunityModel community) {
  selectedCommunityStore.value = community;
}
