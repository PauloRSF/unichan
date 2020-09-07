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
      return TextStyle(color: Colors.lightGreen[300]);
    case 'rquote':
      return TextStyle(color: Colors.pink[200]);
    case 'spoiler':
      return TextStyle(color: Colors.grey);
    default:
      return TextStyle();
  }
}

List<Post> sortPostsList(List<Post> posts, SortMethod method) {
  var op = posts.removeAt(0);
  posts.sort((a, b) {
    switch(method) {
      case SortMethod.oldest:
        return a.no - b.no;
      case SortMethod.newest:
        return b.no - a.no;
    }
  });
  posts.insert(0, op);

  return posts;
}

List<Post> setPostsReplies(List<Post> posts) {
  var new_posts = List<Post>();

  for (var i = 0; i < posts.length; i++) {
    var post = posts[i];
    var replies = posts.where((p) => p.replyTo.contains(post.no));
    var ab = List<int>();

    for (var reply in replies) {
      ab.add(reply.no);
    }

    post.repliesNos = ab;
    new_posts.add(post);
  }

  return new_posts;
}
