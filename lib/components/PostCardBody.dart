import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:html/dom.dart' as dom;
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../screens/PostDetail.dart';
import '../notifiers/ThreadsNotifier.dart';
import '../utils/post_utils.dart';
import '../states/posts_state.dart';

class PostCardBody extends StatelessWidget {
  final String com;
  final bool isOp;
  final int replies;
  final int images;

  PostCardBody(this.com, this.isOp, this.replies, this.images);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        com == null ? Container() : Container(
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: _htmlRenderedBody(),
        ),
        !isOp ? Container() : Container(
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 8.0
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.comment,
                size: 18.0,
              ),
              Text(
                ' ${replies}  ',
                textScaleFactor: 1.1,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.image,
                size: 18.0,
              ),
              Text(
                ' ${images}',
                textScaleFactor: 1.1,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ]
    );
  }

  Widget _htmlRenderedBody() {
    return StoreConnector<PostsState, Store<PostsState>>(
      converter: (store) => store,
      builder: (context, store) {
        return Html(
          data: com,
          onLinkTap: (url) async {
            RegExp abc = RegExp(r'^\/[a-z]+\/[a-z]+\/[0-9]+\.html#([0-9]+)$');
            if (abc.hasMatch(url)) {
              var post = store.state.thread.firstWhere((p) => 
                p.no.toString() == abc.firstMatch(url).group(1)
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetail(post),
                ),
              );
            } else if (await canLaunch(url)) {
              await launch(url);
            }
          },
          customRender: {
            'span': (RenderContext ctx, Widget child, attributes, dom.Element element) {
              if(attributes != null){
                return Text(
                  element.text,
                  style: getSpanStyle(attributes['class']),
                  textScaleFactor: (attributes['class'] == 'heading' ? 1.3 : 1)
                );
              }
            },
            'strong': (RenderContext ctx, Widget child, attributes, dom.Element element) {
              return Text(
                element.text,
                style: TextStyle(fontWeight: FontWeight.bold),
              );
            },
            'em': (RenderContext ctx, Widget child, attributes, dom.Element element) {
              return Text(
                element.text,
                style: TextStyle(fontStyle: FontStyle.italic),
              );
            },
          },
        );
      }
    );
  }
}
