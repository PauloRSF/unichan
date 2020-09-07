import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../notifiers/ThreadsNotifier.dart';
import '../services/API.dart';
import '../models/Post.dart';
import '../components/PostCard.dart';
import '../actions/actions.dart';
import '../states/posts_state.dart';

class Home extends StatelessWidget {

  Future<List<Post>> getAllThreads() async {
    return API().getThreadsOps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('55Chan')
      ),
      body: FutureBuilder(
        future: getAllThreads(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData) {
            return StoreConnector<PostsState, Store<PostsState>>(
              converter: (store) => store,
              builder: (context, store) {
                if(store.state.posts.length == 0) {
                  store.dispatch(AddPostsAction(snapshot.data));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    store.dispatch(AddPostsAction(await getAllThreads()));
                  },
                  child: ListView.separated(
                    itemCount: store.state.posts.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return PostCard(post: store.state.posts[index]);
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.black,
                        thickness: 4.0
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return SpinKitRing(
              color: Colors.deepPurple[200],
              size: 50.0,
            );
          }
        },
      ),
    );
  }
}
