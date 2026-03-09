import 'package:flutter/material.dart';

class FollowUser {
  final String userId;
  final String username;
  final String? avatarUrl;
  final String? firstName;
  final String? lastName;
  final DateTime? followedAt;

  FollowUser({
    required this.userId,
    required this.username,
    this.avatarUrl,
    this.firstName,
    this.lastName,
    this.followedAt,
  });

  factory FollowUser.fromJson(Map<String, dynamic> json) {
    return FollowUser(
      userId: json['user_id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      followedAt: json['followed_at'] != null
          ? DateTime.tryParse(json['followed_at'].toString())
          : null,
    );
  }
}

class SettingsMyProfileFollowersModel {
  String state = 'Followers';

  // Search controllers
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;

  // Followers state
  List<FollowUser> followers = [];
  int followersTotalCount = 0;
  bool isLoadingFollowers = false;
  bool hasMoreFollowers = true;

  // Following state
  List<FollowUser> following = [];
  int followingTotalCount = 0;
  bool isLoadingFollowing = false;
  bool hasMoreFollowing = true;

  static const int pageSize = 20;

  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();
    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
