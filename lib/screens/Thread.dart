import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/API.dart';
import '../models/Post.dart';
import '../components/PostCard.dart';
import '../utils/post_utils.dart'; 

class Thread extends StatefulWidget {
  int no;

  Thread(this.no);

  @override
  _ThreadState createState() => _ThreadState();
}

class _ThreadState extends State<Thread> {
  int no;
  SortMethod sortMethod = SortMethod.oldest;
  List<Post> posts;
  Map<String, SortMethod> sortMethods = {
    'Novos': SortMethod.newest,
    'Antigos': SortMethod.oldest
  };

  @override
  void initState() {
    super.initState();
    setPostList();
    //setState(() {
    //  no = widget.no;
    //});
  }

  Future<List<Post>> getThreadPosts() async {
    var thread = await API().getFullThread(no);
    var op = thread.removeAt(0);
    thread = sortPostsList(thread, sortMethod);
    thread.insert(0, op);
    return Future(() => thread);
  }

  Future<List<Post>> setPostList() async {
    var threadFuture = getThreadPosts();
    var thread = await threadFuture;
    setState(() {
      posts = thread;
    });

    return threadFuture;
  }

  @override
  Widget build(BuildContext context) {
    no = widget.no;
    return Scaffold(
      appBar: AppBar(
        title: Text('Thread #${no}'),
        backgroundColor: Colors.teal[300],
      ),
      body: FutureBuilder(
        future: getThreadPosts(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () => setPostList(),
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    if (index == 0){
                      return Column(
                        children: <Widget>[
                          PostCard(post: snapshot.data[index]),
                          _commentsOptions(snapshot.data.length),
                        ],
                      );
                    }
                    return PostCard(post: snapshot.data[index]);
                  }
                ),
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

  Widget _commentsOptions(int postCount) {
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
              var sort = await _sortMethodDialog();
              if(sort != null) {
                setState(() {
                  sortMethod = sort;
                });
              }
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

  Future<SortMethod> _sortMethodDialog() {
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
                  setState(() {
                    Navigator.of(context).pop(value);
                  });
                },
              ),
            ),
          ),
        ),
      )
    );
  }
  
}
