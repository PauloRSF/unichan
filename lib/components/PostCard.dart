import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:html/dom.dart' as dom;
import '../components/PostCardMedia.dart';
import '../components/PostCardBody.dart';
import '../models/Post.dart';
import '../screens/MediaViewer.dart';
import '../screens/Thread.dart';

class PostCard extends StatelessWidget {
  final controller = PageController(
    initialPage: 0,
  );
  final Post post;

  PostCard({this.post});

  String getPostTime() {
    var time = DateTime.fromMillisecondsSinceEpoch(post.time*1000);
    return time.toString().replaceAll(new RegExp(r'\-'), '/').split('.')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        color: Color(0xff303030),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      margin: const EdgeInsets.only(bottom: 2.0),
      child: Column(
        children: <Widget>[
          post.thumbs.isEmpty ? Container() : Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 200,
            child: PageView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              children: List<Widget>.generate(post.files.length, (i) =>
                PostCardMedia(post.files[i], post.thumbs[i])
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xff404040),
              borderRadius: BorderRadius.all(Radius.circular(4.0))
            ),
          ),
          post.thumbs.length < 2 ?
            Container(padding: const EdgeInsets.only(top: 8.0))
            :
            Container(
              padding: const EdgeInsets.only(top: 8.0),
              child: DotsIndicator(
                dotsCount: post.files.length,
                position: 0,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'ANÔNIMO',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent[300]
                        ),
                      ),
                      TextSpan(
                        text: ' | ${getPostTime()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey
                        ),
                      ),
                    ]
                  ),
                ),
                RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    text: '#${post.no}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey
                    ),
                  ),
                ),
              ]
            ),
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
          )
        ]
      ),
    );
  }
}