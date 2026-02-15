import 'package:flutter/foundation.dart';

enum ReactionType {
  none,
  like,
  dislike,
}

class ReactionState {
  final int likes;
  final int dislikes;
  final ReactionType userReaction;

  const ReactionState({
    this.likes = 0,
    this.dislikes = 0,
    this.userReaction = ReactionType.none,
  });

  ReactionState copyWith({
    int? likes,
    int? dislikes,
    ReactionType? userReaction,
  }) {
    return ReactionState(
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      userReaction: userReaction ?? this.userReaction,
    );
  }
}

final ValueNotifier<Map<String, ReactionState>> reactionStore =
    ValueNotifier<Map<String, ReactionState>>({});

ReactionState getReactionState(String postId) {
  return reactionStore.value[postId] ?? const ReactionState();
}

void toggleLike(String postId) {
  final current = getReactionState(postId);
  ReactionState next;
  if (current.userReaction == ReactionType.like) {
    next = current.copyWith(
      likes: (current.likes - 1).clamp(0, 1 << 30),
      userReaction: ReactionType.none,
    );
  } else if (current.userReaction == ReactionType.dislike) {
    next = current.copyWith(
      likes: current.likes + 1,
      dislikes: (current.dislikes - 1).clamp(0, 1 << 30),
      userReaction: ReactionType.like,
    );
  } else {
    next = current.copyWith(
      likes: current.likes + 1,
      userReaction: ReactionType.like,
    );
  }

  final updated = Map<String, ReactionState>.from(reactionStore.value);
  updated[postId] = next;
  reactionStore.value = updated;
}

void toggleDislike(String postId) {
  final current = getReactionState(postId);
  ReactionState next;
  if (current.userReaction == ReactionType.dislike) {
    next = current.copyWith(
      dislikes: (current.dislikes - 1).clamp(0, 1 << 30),
      userReaction: ReactionType.none,
    );
  } else if (current.userReaction == ReactionType.like) {
    next = current.copyWith(
      dislikes: current.dislikes + 1,
      likes: (current.likes - 1).clamp(0, 1 << 30),
      userReaction: ReactionType.dislike,
    );
  } else {
    next = current.copyWith(
      dislikes: current.dislikes + 1,
      userReaction: ReactionType.dislike,
    );
  }

  final updated = Map<String, ReactionState>.from(reactionStore.value);
  updated[postId] = next;
  reactionStore.value = updated;
}
