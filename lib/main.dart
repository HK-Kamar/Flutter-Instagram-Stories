/*
 * Created by Hüveyscan Kamar on 21.10.2022
 * Copyright (c) 2022. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';

import 'bloc/story_screen_bloc.dart';
import 'data/user_data.dart';
import 'models/user_model.dart';
import 'screens/user_story_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return MaterialApp(
      title: 'Instagram Stories',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StoryScreen(users: users),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StoryScreen extends StatefulWidget {
  final List<User> users;

  const StoryScreen({super.key, required this.users});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  late CarouselSliderController _carouselSliderController;

  @override
  void initState() {
    super.initState();
    _carouselSliderController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StoryScreenBloc()
            ..add(LoadStoryOfFirstUser(
                carouselSliderController: _carouselSliderController)),
        ),
      ],
      child: Scaffold(
          backgroundColor: Colors.black,
          body: CarouselSlider(
              slideTransform: const CubeTransform(),
              controller: _carouselSliderController,
              unlimitedMode: true,
              children: users.map((user) {
                return Builder(
                  builder: (BuildContext context) {
                    return UserStoryScreen(owner: user);
                  },
                );
              }).toList())),
    );
  }
}
