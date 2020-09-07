import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:html/dom.dart' as dom;
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../components/PostCardMedia.dart';
import '../components/PostCardBody.dart';
import '../models/Post.dart';
import '../screens/MediaViewer.dart';
import '../screens/Thread.dart';
import '../screens/PostDetail.dart';
import '../states/posts_state.dart';

class PostCard extends StatefulWidget {
  final Post post;

  PostCard({this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final controller = PageController(initialPage: 0);
  double currentMediaPage = 0;
  Post post;

  String getPostTime() {
    var time = DateTime.fromMillisecondsSinceEpoch(post.time*1000);
    return time.toString().replaceAll(new RegExp(r'\-'), '/').split('.')[0];
  }

  List<Widget> getPostReplies(Function openFunc) {
    var containers = List<Widget>();

      for (var reply in post.repliesNos) {
        containers.add(
          GestureDetector(
            onTap: () { openFunc(reply); },
            child: Container(
              child: Text(
                reply.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xAA000000)
                )
              ),
              margin: const EdgeInsets.only(right: 4.0, bottom: 4.0),
              padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 1.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple[200],
                borderRadius: BorderRadius.all(Radius.circular(4.0))
              ),
            )
          ),
        );
      }

    return containers;
  }

  @override
  Widget build(BuildContext context) {
    post = widget.post;
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        color: Color(0xff18151E),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Column(
        children: <Widget>[
          post.thumbs.isEmpty ? Container() : Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 200,
            child: PageView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              onPageChanged: (page) {
                setState(() {
                  currentMediaPage = page * 1.0;
                });
              },
              children: List<Widget>.generate(post.files.length, (i) =>
                PostCardMedia(post.files[i], post.thumbs[i])
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xff222028),
              borderRadius: BorderRadius.all(Radius.circular(0.0))
            ),
          ),
          post.thumbs.length < 2 ?
            Container(padding: const EdgeInsets.only(top: 8.0))
            :
            Container(
              padding: const EdgeInsets.only(top: 8.0),
              child: DotsIndicator(
                dotsCount: post.files.length,
                position: currentMediaPage,
                decorator: DotsDecorator(
                  activeColor: Colors.cyan[100],
                )
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ANÔNIMO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[200]
                  ),
                ),
                Text(
                  '#${post.no}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Color(0xff68666C)
                  ),
                ),
              ]
            ),
          ),
          post.repliesNos.length != 0 ?
            StoreConnector<PostsState, Store<PostsState>>(
              converter: (store) => store,
              builder: (context, store) {
                return Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Wrap(
                    children: getPostReplies(
                      (no) {
                        var reppost = store.state.thread.firstWhere((p) => 
                          p.no == no
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetail(reppost)
                          ),
                        );
                      }
                    ),
                  ),
                );
              }
            ) : Container(),
          SizedBox(
            height: 1,
            child: Container(
              color: Color(0xff46444A),
              margin: const EdgeInsets.symmetric(horizontal: 8.0)
            )
          ),
          GestureDetector(
            onTap: () {
              if(post.isOp) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Thread(post.no)
                  ),
                );
              }
            },
            child: PostCardBody(
              post.com,
              post.isOp,
              post.replies,
              post.images
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getPostTime(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff68666C)
                  ),
                ),
                Icon(
                  Icons.more_horiz,
                  size: 24.0,
                  color: Color(0xffE5E5E5)
                )
              ]
            ),
          ),
        ]
      ),
    );
  }
}