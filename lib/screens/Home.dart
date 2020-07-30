import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../notifiers/ThreadsNotifier.dart';
import '../services/API.dart';
import '../models/Post.dart';
import '../components/PostCard.dart';

class Home extends StatelessWidget {

  Future<List<Post>> getAllThreads() async {
    return API().getThreadsOps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('55Chan'),
        backgroundColor: Colors.teal[300],
      ),
      body: FutureBuilder(
        future: getAllThreads(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData) {
            return ChangeNotifierProvider(
                create: (context) => ThreadsNotifier(),
                child: Consumer<ThreadsNotifier>(
                    builder: (context, thread, child) {
                      if(thread.posts.isEmpty) {
                        thread.addAll(snapshot.data);
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          thread.removeAll();
                          return thread.addAll(await getAllThreads());
                        },
                        child: ListView.builder(
                          itemCount: thread.posts.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return PostCard(post: thread.posts[index]);
                          }
                        ),
                      );
                    },
                ),
            );
          } else {
            return SpinKitThreeBounce(
              color: Colors.white,
              size: 20.0,
            );
          }
        },
      ),
    );
  }
}
