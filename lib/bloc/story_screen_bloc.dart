/*
 * Created by Hüveyscan Kamar on 21.10.2022
 * Copyright (c) 2022. All rights reserved.
 */
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

import '../constants.dart';

part 'story_screen_event.dart';
part 'story_screen_state.dart';

class StoryScreenBloc extends Bloc<StoryScreenEvent, StoryScreenState> {
  StoryScreenBloc() : super(StoryScreenInitial()) {
    on<LoadStoryOfFirstUser>((event, emit) {
      emit(StoryScreenLoaded(
          carouselSliderController: event.carouselSliderController));
    });
    on<LoadStoryOfPreviousUser>((event, emit) {
      final state = this.state as StoryScreenLoaded;
      state.carouselSliderController.previousPage(const Duration(
          milliseconds:
              DEFAULT_DURATION_OF_CUBIC_TRANSFORM_ANIMATION_IN_MILLISECONDS));
      emit(state);
    });
    on<LoadStoryOfNextUser>((event, emit) {
      final state = this.state as StoryScreenLoaded;
      state.carouselSliderController.nextPage(const Duration(
          milliseconds:
              DEFAULT_DURATION_OF_CUBIC_TRANSFORM_ANIMATION_IN_MILLISECONDS));
      emit(state);
    });
  }
}
