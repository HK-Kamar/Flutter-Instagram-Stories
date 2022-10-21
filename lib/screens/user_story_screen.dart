/*
 * Created by Hüveyscan Kamar on 21.10.2022
 * Copyright (c) 2022. All rights reserved.
 */
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../bloc/story_screen_bloc.dart';
import '../constants.dart';
import '../models/story_model.dart';
import '../models/user_model.dart';
import '../widgets/animated_bar.dart';
import '../widgets/user_info_field.dart';

class UserStoryScreen extends StatefulWidget {
  final User owner;

  const UserStoryScreen({super.key, required this.owner});

  @override
  State<UserStoryScreen> createState() => _UserStoryScreenState();
}

class _UserStoryScreenState extends State<UserStoryScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Timer _timer;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: widget.owner.lastViewedStoryIndex);
    _animationController = AnimationController(vsync: this);

    _loadStory(
        story: widget.owner.stories[widget.owner.lastViewedStoryIndex],
        animateToPage: false);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _animationController.reset();
        if (mounted) {
          setState(() {
            if (widget.owner.lastViewedStoryIndex + 1 <
                widget.owner.stories.length) {
              widget.owner.lastViewedStoryIndex++;
              _loadStory(
                  story:
                      widget.owner.stories[widget.owner.lastViewedStoryIndex]);
            } else {
              context.read<StoryScreenBloc>().add(LoadStoryOfNextUser());
            }
          });
        }
      }
    });
    for (var i = 0; i < widget.owner.stories.length; i++) {
      if (widget.owner.stories[i].contentType == StoryContentType.video) {
        _videoPlayerController =
            VideoPlayerController.network(widget.owner.stories[i].url)
              ..initialize().then((value) {
                if (mounted) {
                  setState(() {});
                }
              });
        _videoPlayerController?.play();
        break;
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Story currentStory =
        widget.owner.stories[widget.owner.lastViewedStoryIndex];
    return BlocBuilder<StoryScreenBloc, StoryScreenState>(
      builder: (context, state) {
        if (state is StoryScreenInitial || state is StoryScreenLoaded) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: GestureDetector(
              onTapDown: (details) => _onTapDown(details, currentStory),
              onTapUp: (details) => _onTapUp(context, details, currentStory),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.owner.stories.length,
                    itemBuilder: (context, index) {
                      final Story currentStory = widget.owner.stories[index];
                      switch (currentStory.contentType) {
                        case StoryContentType.image:
                          return CachedNetworkImage(
                              imageUrl: currentStory.url, fit: BoxFit.cover);
                        case StoryContentType.video:
                          if (_videoPlayerController != null &&
                              _videoPlayerController!.value.isInitialized) {
                            return FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                  width:
                                      _videoPlayerController!.value.size.width,
                                  height:
                                      _videoPlayerController!.value.size.height,
                                  child: VideoPlayer(_videoPlayerController!)),
                            );
                          }
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  Positioned(
                    top: 8.0,
                    left: 4.0,
                    right: 4.0,
                    child: Column(
                      children: [
                        Row(
                            children: widget.owner.stories
                                .asMap()
                                .map((key, value) {
                                  return MapEntry(
                                      key,
                                      AnimatedBar(
                                        animationController:
                                            _animationController,
                                        position: key,
                                        currentIndex:
                                            widget.owner.lastViewedStoryIndex,
                                      ));
                                })
                                .values
                                .toList()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 1.5,
                            vertical: 10.0,
                          ),
                          child: UserInfoField(user: widget.owner),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Text("Oops! Something went wrong!");
        }
      },
    );
  }

  void _onTapDown(TapDownDetails details, Story story) {
    _timer = Timer(
        const Duration(
            milliseconds: DEFAULT_DURATION_OF_LONG_PRESS_IN_MILLISECONDS), () {
      _onLongPressStart(story);
    });
  }

  void _onTapUp(BuildContext blocContext, TapUpDetails details, Story story) {
    _timer.cancel();
    if (!_animationController.isAnimating) {
      // Long Press
      _onLongPressEnd(story);
      return;
    }

    // Tap
    final double screenWidth = MediaQuery.of(context).size.width;
    final double tapPointX = details.globalPosition.dx;
    if (tapPointX < screenWidth / 3) {
      if (mounted) {
        setState(() {
          if (widget.owner.lastViewedStoryIndex - 1 >= 0) {
            widget.owner.lastViewedStoryIndex--;
            _loadStory(
                story: widget.owner.stories[widget.owner.lastViewedStoryIndex]);
          } else {
            blocContext.read<StoryScreenBloc>().add(LoadStoryOfPreviousUser());
          }
        });
      }
    } else if (tapPointX > 2 * screenWidth / 3) {
      if (mounted) {
        setState(() {
          if (widget.owner.lastViewedStoryIndex + 1 <
              widget.owner.stories.length) {
            widget.owner.lastViewedStoryIndex++;
          } else {
            blocContext.read<StoryScreenBloc>().add(LoadStoryOfNextUser());
          }
          _loadStory(
              story: widget.owner.stories[widget.owner.lastViewedStoryIndex]);
        });
      }
    }
  }

  void _onLongPressStart(Story story) {
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
    if (story.contentType == StoryContentType.video) {
      if (_videoPlayerController != null &&
          _videoPlayerController!.value.isInitialized) {
        _videoPlayerController?.pause();
      }
    }
  }

  void _onLongPressEnd(Story story) {
    if (story.contentType == StoryContentType.video) {
      if (_videoPlayerController != null &&
          !_videoPlayerController!.value.isPlaying) {
        _videoPlayerController?.play();
        _animationController.duration = _videoPlayerController!.value.duration;
      }
    } else {
      _animationController.duration = DEFAULT_DURATION_OF_IMAGE_STORIES;
    }
    _animationController.forward();
  }

  void _loadStory({required Story story, bool animateToPage = true}) {
    _animationController.stop();
    _animationController.reset();
    switch (story.contentType) {
      case StoryContentType.image:
        _animationController.duration = DEFAULT_DURATION_OF_IMAGE_STORIES;
        _animationController.forward();
        break;
      case StoryContentType.video:
        _videoPlayerController = null;
        _videoPlayerController?.dispose();
        _videoPlayerController = VideoPlayerController.network(story.url)
          ..initialize().then((_) {
            if (mounted) {
              setState(() {
                if (_videoPlayerController!.value.isInitialized) {
                  _animationController.duration =
                      _videoPlayerController!.value.duration;
                  _videoPlayerController?.play();
                  _animationController.forward();
                }
              });
            }
          });
        break;
    }
    if (animateToPage) {
      _pageController.animateToPage(widget.owner.lastViewedStoryIndex,
          duration: const Duration(milliseconds: 1), curve: Curves.easeInOut);
    }
  }
}
