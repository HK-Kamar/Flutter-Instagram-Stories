/*
 * Created by Hüveyscan Kamar on 21.10.2022
 * Copyright (c) 2022. All rights reserved.
 */
import 'package:equatable/equatable.dart';

import 'story_model.dart';

class User extends Equatable {
  final String username;
  final String profileImageUrl;
  final List<Story> stories;
  int lastViewedStoryIndex;

  User(
      {required this.username,
      required this.profileImageUrl,
      required this.stories,
      required this.lastViewedStoryIndex});

  @override
  List<Object?> get props =>
      [username, profileImageUrl, stories, lastViewedStoryIndex];

  static List<User> users = users;
}

enum UserChangeDirection { forward, backward }
