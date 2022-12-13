import 'dart:convert';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';
import 'package:status_maker/providers/AdsProvider.dart';
import 'package:status_maker/providers/MakerProvider.dart';
import 'package:status_maker/providers/StatusProvider.dart';
import 'package:status_maker/widgets/IsLoadingWidget.dart';
import 'package:video_player/video_player.dart';

class StatusWidget extends StatefulWidget {
  final FileSystemEntity file;
  final bool isAd;

  const StatusWidget({Key key, this.file, this.isAd = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StatusWidgetState();
  }
}

class StatusWidgetState extends State<StatusWidget> {
  bool isSupported = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: statusBody(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.isAd ? Container() : iconsBar(),
    );
  }

  Widget statusBody() {
    if (widget.isAd) {
      return Provider.of<AdsProvider>(context, listen: false)
          .getBanner(size: AdmobBannerSize.MEDIUM_RECTANGLE);
    }

    var type = widget.file.path.split(".").last;

    switch (type) {
      case "jpg":
        return Image.file(widget.file);
      case "mp4":
        return VideoStatus(
          file: widget.file,
        );
      default:
        isSupported = false;
        return Text("نوع الملف غير مدعوم : $type");
    }
  }

  Widget iconsBar() {
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FloatingActionButton(
            child: Icon(FontAwesome.download),
            onPressed: () {
              Provider.of<AdsProvider>(context, listen: false).getReward();
              Provider.of<StatusProvider>(context, listen: false)
                  .saveStatus(widget.file)
                  .then((value) {
                if (value != null) {
                  EasyLoading.showSuccess("تم بنجاح");
                } else {
                  EasyLoading.showSuccess("حدث خطأ ما");
                }
              });
            }),
        SizedBox(
          width: 10,
        ),
        FloatingActionButton(
            child: Icon(Icons.share),
            onPressed: () {
              SocialShare.shareOptions(
                  "https://play.google.com/store/apps/details?id=com.alalfy.status_maker",
                  imagePath: widget.file.path);
            }),
      ],
    );
  }
}

class VideoStatus extends StatefulWidget {
  final FileSystemEntity file;

  const VideoStatus({Key key, this.file}) : super(key: key);

  @override
  _VideoStatusState createState() => _VideoStatusState();
}

class _VideoStatusState extends State<VideoStatus> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file);
    _controller.initialize().then((_) {
      setState(() {
        print(_controller.value.duration);
        _controller.play();
      });
    });
    _controller.addListener(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.initialized) {
      return IsLoadingWidget();
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: InkWell(
        onTap: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            VideoPlayer(_controller),
            _controller.value.isPlaying
                ? Container()
                : Icon(
                    Icons.play_circle_fill_outlined,
                    size: 70,
                    color: Colors.white,
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.pause();
    super.dispose();
  }
}
