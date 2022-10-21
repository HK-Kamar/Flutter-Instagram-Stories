/*
 * Created by Hüveyscan Kamar on 21.10.2022
 * Copyright (c) 2022. All rights reserved.
 */
import '/models/user_model.dart';
import 'stories_data.dart';

final List<User> users = [
  User(
      username: 'huveyscan',
      profileImageUrl:
          'https://cdn.dribbble.com/users/1956538/screenshots/11286853/media/0eede3588461f79fef441e1cdca98101.jpg?compress=1&resize=400x300&vertical=top',
      stories: storiesOfUsers[0],
      lastViewedStoryIndex: 0),
  User(
      username: 'kamar',
      profileImageUrl:
          'https://t3.ftcdn.net/jpg/04/06/91/92/360_F_406919209_O9Sy4SKu3dVx0mE3RqYfCH5hqMwVWbOk.jpg',
      stories: storiesOfUsers[1],
      lastViewedStoryIndex: 0),
  User(
      username: 'huveyscankamar',
      profileImageUrl:
          'https://st4.depositphotos.com/41285240/41718/v/600/depositphotos_417184840-stock-illustration-h-k-letter-logo-abstract.jpg',
      stories: storiesOfUsers[2],
      lastViewedStoryIndex: 0)
];
