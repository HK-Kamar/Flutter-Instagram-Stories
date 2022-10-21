/*
 * Created by Hüveyscan Kamar on 21.10.2022
 * Copyright (c) 2022. All rights reserved.
 */
enum MediaType {
  image,
  video,
}

class Story {
  final StoryContentType contentType;
  final String url;

  const Story({required this.contentType, required this.url});
}

enum StoryContentType { image, video }
