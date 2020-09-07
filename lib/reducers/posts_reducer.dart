import 'package:redux/redux.dart';
import '../actions/actions.dart';
import '../models/Post.dart';
import '../states/posts_state.dart';

final postsReducer = combineReducers<PostsState>([
  TypedReducer<PostsState, AddPostsAction>(_addPosts),
  TypedReducer<PostsState, DeletePostsAction>(_deletePosts),
  TypedReducer<PostsState, AddThreadPostsAction>(_addThreadPosts),
  TypedReducer<PostsState, DeleteThreadPostsAction>(_deleteThreadPosts)
]);

PostsState _addPosts(PostsState prevState, AddPostsAction action) {
  final payload = action.posts;
  return prevState.copyWith(posts: payload);
}

PostsState _deletePosts(PostsState prevState, DeletePostsAction action) {
  final no = action.no;
  return prevState.copyWith(posts: prevState.posts.where((post) => post.no != no).toList());
}

PostsState _addThreadPosts(PostsState prevState, AddThreadPostsAction action) {
  final payload = action.thread;
  return prevState.copyWith(thread: payload);
}

PostsState _deleteThreadPosts(PostsState prevState, DeleteThreadPostsAction action) {
  final no = action.no;
  return prevState.copyWith(thread: prevState.thread.where((post) => post.no != no).toList());
}
