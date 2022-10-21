/*
 * Created by Hüveyscan Kamar on 21.10.2022
 * Copyright (c) 2022. All rights reserved.
 */
part of 'story_screen_bloc.dart';

abstract class StoryScreenEvent extends Equatable {
  const StoryScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadStoryOfFirstUser extends StoryScreenEvent {
  final CarouselSliderController carouselSliderController;

  const LoadStoryOfFirstUser({required this.carouselSliderController});

  @override
  List<Object> get props => [carouselSliderController];
}

class LoadStoryOfPreviousUser extends StoryScreenEvent {}

class LoadStoryOfNextUser extends StoryScreenEvent {}
