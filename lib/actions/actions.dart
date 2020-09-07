import '../models/Post.dart';

class DeletePostsAction {
  final int no;

  DeletePostsAction(this.no);

  @override
  String toString() {
    return 'DeletePostsAction{no: $no}';
  }
}

class AddPostsAction {
  final List<Post> posts;

  AddPostsAction(this.posts);

  @override
  String toString() {
    return 'AddPostsAction{posts: ${posts.length}';
  }
}

class DeleteThreadPostsAction {
  final int no;

  DeleteThreadPostsAction(this.no);

  @override
  String toString() {
    return 'DeleteThreadPostsAction{no: $no}';
  }
}

class AddThreadPostsAction {
  final List<Post> thread;

  AddThreadPostsAction(this.thread);

  @override
  String toString() {
    return 'AddThreadPostsAction{thread: ${thread.length}';
  }
}
