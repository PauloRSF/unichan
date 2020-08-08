import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/MediaViewer.dart';
import '../utils/post_utils.dart';

class PostCardMedia extends StatelessWidget {
  final String url;
  final String thumbUrl;

  PostCardMedia(this.url, this.thumbUrl);

  @override
  Widget build(BuildContext context) {

    Widget getThumbnailWidget() {
      return CachedNetworkImage(
        placeholder: (context, thumbUrl) => SpinKitPulse(color: Colors.white, size: 40.0),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.contain,
            ),
          ),
        ),
        errorWidget: (context, thumbUrl, error) => Icon(Icons.cancel, size: 40.0),
        imageUrl: thumbUrl
      );
    }

    Widget getMediaWidget() {
      MediaType type = getMediaType(url);
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          getThumbnailWidget(),
          type == MediaType.video || type == MediaType.ytvideo ?
            Icon(
              Icons.play_circle_filled,
              size: 70.0,
              color: (type == MediaType.ytvideo ? Colors.red : Colors.white))
            :
            Container()
        ],
      );
    }

    return GestureDetector(
      onTap: () async {
        var type = getMediaType(url);
        if(type == MediaType.ytvideo) {
          if (await canLaunch(url)) {
            await launch(url);
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MediaViewer(url)
            ),
          );
        }
      },
      child: getMediaWidget(),
    );
  }
}
