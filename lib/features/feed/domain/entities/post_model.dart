class PostModel {
  final String id;
  final String userId;
  final String? userName;
  final String text;
  final String communityId;
  final DateTime createdAt;
  final int likeCount;
  final int dislikeCount;
  final String? userReaction;

  const PostModel({
    required this.id,
    required this.userId,
    this.userName,
    required this.text,
    required this.communityId,
    required this.createdAt,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.userReaction,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final rawUser = json['userId'];
    String userIdValue = '';
    String? userNameValue;
    if (rawUser is Map<String, dynamic>) {
      userIdValue = (rawUser['_id'] ?? rawUser['id'] ?? '').toString();
      userNameValue = rawUser['name']?.toString();
    } else {
      userIdValue = (rawUser ?? '').toString();
    }

    return PostModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      userId: userIdValue,
      userName: userNameValue ?? json['userName']?.toString(),
      text: json['text']?.toString() ?? '',
      communityId: (json['communityId'] ?? '').toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      likeCount: _toInt(json['likeCount']),
      dislikeCount: _toInt(json['dislikeCount']),
      userReaction: json['userReaction']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'communityId': communityId,
      'createdAt': createdAt.toIso8601String(),
      'likeCount': likeCount,
      'dislikeCount': dislikeCount,
      'userReaction': userReaction,
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
