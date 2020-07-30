import 'package:flutter/material.dart';
import '../models/Post.dart';

enum MediaType {
  image,
  video,
  ytvideo
}

enum SortMethod {
  newest,
  oldest
}

MediaType getMediaType(String url) {
  if (url.contains('youtu')) {
    return MediaType.ytvideo;
  } else {
    switch(url.split('.').last) {
      case 'mp4':
      case 'webm':
        return MediaType.video;
    }
    return MediaType.image;
  }
}

TextStyle getSpanStyle(String tagClass) {
  switch(tagClass) {
    case 'heading':
      return TextStyle(fontWeight: FontWeight.bold, color: Colors.red);
    case 'quote':
      return TextStyle(color: Colors.green);
    case 'rquote':
      return TextStyle(color: Colors.pink);
    case 'spoiler':
      return TextStyle(color: Colors.grey);
    default:
      return TextStyle();
  }
}

List<Post> sortPostsList(List<Post> posts, SortMethod method) {
  posts.sort((a, b) {
    switch(method) {
      case SortMethod.oldest:
        return a.no - b.no;
      case SortMethod.newest:
        return b.no - a.no;
    }
  });

  return posts;
}
