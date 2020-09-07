import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoControlsOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  final Function onSave;

  const VideoControlsOverlay({
    this.controller,
    this.onSave
  });

  @override
  _VideoControlsOverlayState createState() => _VideoControlsOverlayState();
}

class _VideoControlsOverlayState extends State<VideoControlsOverlay> {
  var currentPosition = Duration();
  var update_video_timer;
  var overlay_show = true;

  @override
  Widget build(BuildContext context) {
    var controller = widget.controller;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if(!overlay_show) {
                Timer(
                  const Duration(seconds: 2),
                  () {
                    setState(() {
                      overlay_show = false;
                    });
                  },
                );
              }
              overlay_show = !overlay_show;
            });

          },
          child: AnimatedOpacity(
            opacity: overlay_show ? 1.0 : 0.0,
            duration: Duration(milliseconds: 250),
            child: Container(
              color: Color(0x44000000),
            ),
          )
        ),
        overlay_show ? Container(
          height: 110.0,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          color: Color(0x44000000),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${currentPosition.inMinutes}:${(currentPosition.inSeconds % 60).toString().padLeft(2, '0')}'),
                  Container(
                    width: 230,
                    child: VideoProgressIndicator(controller, allowScrubbing: true, padding: const EdgeInsets.all(0)),
                  ),
                  Text('${controller.value.duration.inMinutes}:${(controller.value.duration.inSeconds % 60).toString().padLeft(2, '0')}'),
                ]
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() { 
                        if(controller.value.volume == 0) {
                          controller.setVolume(1);
                        } else {
                          controller.setVolume(0);
                        }
                      });
                    },
                    child: controller.value.volume == 0 ?
                      Icon(
                        Icons.volume_off,
                        color: Colors.white,
                        size: 25.0
                      )
                      :
                      Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: 25.0
                      )
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.repeat,
                      color: Colors.white,
                      size: 25.0
                    )
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if(controller.value.isPlaying) {
                          update_video_timer?.cancel();
                          controller.pause();
                        } else {
                          update_video_timer = Timer.periodic(
                            const Duration(milliseconds: 500),
                            (Timer timer) async {
                              setState(() {
                                currentPosition = controller.value.position;
                              });
                            },
                          );
                          Timer(
                            const Duration(seconds: 2),
                            () {
                              setState(() {
                                overlay_show = false;
                              });
                            },
                          );
                          controller.play();
                        }
                      });
                    },
                    child: controller.value.isPlaying ?
                      Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 35.0
                      )
                      :
                      Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 35.0
                      ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.help_outline,
                      color: Colors.white,
                      size: 25.0
                    )
                  ),
                  GestureDetector(
                    onTap: widget.onSave,
                    child: Icon(
                      Icons.save_alt,
                      color: Colors.white,
                      size: 25.0
                    )
                  ),
                ]
              )
            ]
          ),
        ) : Container()
      ]
    );
  }

  @override
  void dispose() {
    super.dispose();
    update_video_timer?.cancel();
  }
}
