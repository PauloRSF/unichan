import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'screens/Home.dart';
import 'theme/style.dart';
import 'models/Post.dart';
import 'reducers/posts_reducer.dart';
import 'states/posts_state.dart';

main() {
  final store = Store<PostsState>(postsReducer, initialState: PostsState.initial());

  runApp(ReduxApp(store: store));
}

class ReduxApp extends StatelessWidget {
	final Store<PostsState> store;

	ReduxApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<PostsState>(
      store: store,
      child: MaterialApp(
	      title: 'UniChan',
	      theme: appTheme(),
	      home: Home(),
	    ),
	  );
  }
}
