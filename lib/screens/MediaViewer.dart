import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:toast/toast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/post_utils.dart';

class MediaViewer extends StatefulWidget {
  final String url;
  MediaType type;

  MediaViewer(this.url, { Key key }) : super(key: key) {
    type = getMediaType(url);
  }

  @override
  _MediaViewerState createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewer> {
  VideoPlayerController _controller;
 
  void saveMedia(String url) async {
    if(await Permission.storage.request().isGranted) {
      var savePath = await getExternalStorageDirectory();
      String filePath = savePath.path + url.split('/').last;
      await Dio().download(url, filePath);
      final result = await ImageGallerySaver.saveFile(filePath);
      Toast.show(
        'Arquivo salvo!',
        context,
        duration: Toast.LENGTH_LONG,
        gravity:  Toast.BOTTOM
      );
    } else {
      Toast.show(
        'Erro ao salvar o arquivo!',
        context,
        duration: Toast.LENGTH_LONG,
        gravity:  Toast.BOTTOM
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.type == MediaType.video){
      _controller = VideoPlayerController.network(widget.url)..initialize().then((_) {
        setState(() {});
      });
      _controller.setLooping(true);
    }
  }

  Widget getViewer(String url) {
    switch(widget.type) {
      case MediaType.video:
      return Scaffold(
        body: Center(
          child: _controller.value.initialized ?
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                  });
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_controller),
                    _PlayPauseOverlay(controller: _controller),
                    VideoProgressIndicator(_controller, allowScrubbing: true),
                  ],
                ),
              )
            )
            :
            Container(),
      ),
    );
    case MediaType.image:
      return PhotoView(
        imageProvider: NetworkImage(url),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.url);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.url.split('/').last),
        backgroundColor: Colors.transparent,
      ),
      body: getViewer(widget.url),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveMedia(widget.url);
        },
        child: Icon(Icons.get_app),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if(widget.type == MediaType.video) {
      _controller.dispose();
    }
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying ?
            SizedBox.shrink()
            : 
            Container(
              color: Colors.black26,
              child: Center(
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 70.0,
                ),
              ),
            ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
