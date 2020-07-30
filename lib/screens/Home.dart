import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/API.dart';
import '../models/Post.dart';
import '../components/PostCard.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Post> posts;

  @override
  void initState() {
    super.initState();
    setPostList();
  }

  Future<List<Post>> getAllThreads() async {
    return API().getThreadsOps();
  }

  Future<List<Post>> setPostList() async {
    var threadsFuture = getAllThreads();
    var threads = await threadsFuture;
    setState(() {
      posts = threads;
    });

    return threadsFuture;
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
            return RefreshIndicator(
              onRefresh: () => setPostList(),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return PostCard(post: snapshot.data[index]);
                }
              ),
            );
          } else {
            return SpinKitThreeBounce(
              color: Colors.white,
              size: 20.0,
            );
          }
        }
      ),
    );
  }
}
