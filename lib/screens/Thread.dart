import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../notifiers/ThreadsNotifier.dart';
import '../services/API.dart';
import '../models/Post.dart';
import '../components/PostCard.dart';
import '../utils/post_utils.dart';
import '../actions/actions.dart';
import '../states/posts_state.dart';

class Thread extends StatelessWidget {
  int no;
  SortMethod sortMethod = SortMethod.oldest;
  List<Post> posts;
  Map<String, SortMethod> sortMethods = {
    'Novos': SortMethod.newest,
    'Antigos': SortMethod.oldest
  };

  Thread(this.no);

  Future<List<Post>> getThreadPosts() async {
    var thread = await API().getFullThread(no);
    var op = thread.removeAt(0);
    thread = sortPostsList(thread, sortMethod);
    thread.insert(0, op);
    return Future(() => thread);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thread #${no}')
      ),
      body: FutureBuilder(
        future: getThreadPosts(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData) {
            return StoreConnector<PostsState, Store<PostsState>>(
              converter: (store) => store,
              builder: (context, store) {
                if(store.state.thread.length == 0 || store.state.thread[0].no != snapshot.data[0].no) {
                  store.dispatch(AddThreadPostsAction(snapshot.data));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    store.dispatch(AddThreadPostsAction(await getThreadPosts()));
                  },
                  child: Scrollbar(
                    child: ListView.separated(
                      itemCount: store.state.thread.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        if (index == 0) {
                          return Column(
                            children: <Widget>[
                              PostCard(post: store.state.thread[index]),
                              _commentsOptions(context, null, store.state.thread.length),
                            ],
                          );
                        }
                        return PostCard(post: store.state.thread[index]);
                      }, 
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.black,
                          thickness: 4.0
                        );
                      },
                    ),
                  ),
                );
              }
            );
          } else {
            return SpinKitRing(
              color: Colors.deepPurple[200],
              size: 50.0,
            );
          }
        }
      ),
    );
  }

  Widget _commentsOptions(BuildContext context, ThreadsNotifier thread, int postCount) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '${postCount-1} comentários',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[400]
            ),
          ),
          GestureDetector(
            onTap: () async {
              var sort = await _sortMethodDialog(context);
              thread.sort(sort);
            },
            child: Icon(
              Icons.sort,
              size: 24.0
            ),
          ),
        ],
      ),
    );
  }

  Future<SortMethod> _sortMethodDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text(
          "Filtrar por",
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List<ListTile>.generate(sortMethods.length, (int i) =>
            ListTile(
              title: Text(sortMethods.keys.elementAt(i)),
              leading: Radio(
                value: sortMethods.values.elementAt(i),
                groupValue: sortMethod,
                onChanged: (SortMethod value) {
                  Navigator.of(context).pop(value);
                },
              ),
            ),
          ),
        ),
      )
    );
  }
  
}
