/*
 * Created by Hüveyscan Kamar on 21.10.2022
 * Copyright (c) 2022. All rights reserved.
 */
part of 'story_screen_bloc.dart';

abstract class StoryScreenState extends Equatable {
  const StoryScreenState();

  @override
  List<Object> get props => [];
}

class StoryScreenInitial extends StoryScreenState {}

class StoryScreenLoaded extends StoryScreenState {
  final CarouselSliderController carouselSliderController;

  const StoryScreenLoaded({required this.carouselSliderController});

  @override
  List<Object> get props => [carouselSliderController];
}
