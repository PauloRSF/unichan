import 'package:meta/meta.dart';
import '../models/Post.dart';

@immutable
class PostsState {
  final List<Post> posts;
  final List<Post> thread;

  PostsState({this.posts, this.thread});

  factory PostsState.initial() => PostsState(posts: [], thread: []);

  PostsState copyWith({
    List<Post> posts,
    List<Post> thread,
  }) {
    return PostsState(
      posts: posts ?? this.posts,
      thread: thread ?? this.thread,
    );
  }
}
