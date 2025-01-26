import 'package:animestream/ui/models/playerUtils.dart';
import 'package:av_media_player/player.dart';
import 'package:av_media_player/widget.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class Watchpageutil {}

class Player extends StatelessWidget {
  late final VideoController controller;
  Player(VideoController controller) {
    this.controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return controller.getWidget();
  }
}

abstract class VideoController {
  // play and pause
  Future<void> play();
  Future<void> pause();

  // initiate a source
  Future<void> initiateVideo(String url, {Map<String, String>? headers = null});

  Widget getWidget();

  // seek
  Future<void> seekTo(Duration duration);

  Future<void> setSpeed(double speed);

  void dispose();

  void addListener(VoidCallback cb);

  bool? get isPlaying;

  bool? get isBuffering;

  int? get position;

  int? get duration;
}

class BetterPlayerWrapper implements VideoController {
  final BetterPlayerController controller = BetterPlayerController(
    BetterPlayerConfiguration(
      controlsConfiguration: BetterPlayerControlsConfiguration(
        showControls: false,
      ),
    ),
  );

  @override
  Future<void> initiateVideo(String url, {Map<String, String>? headers}) async {
    await controller.setupDataSource(dataSourceConfig(url, headers: headers));
  }

  @override
  bool? get isBuffering => controller.isBuffering();

  @override
  bool? get isPlaying => controller.isPlaying();

  @override
  int? get position => controller.videoPlayerController?.value.position.inMilliseconds;

  @override
  int? get duration => controller.videoPlayerController?.value.duration?.inMilliseconds;

  @override
  Future<void> pause() {
    return controller.pause();
  }

  @override
  Future<void> play() {
    return controller.play();
  }

  @override
  Future<void> seekTo(Duration duration) {
    return controller.seekTo(duration);
  }

  @override
  Future<void> setSpeed(double speed) async {
    controller.setSpeed(speed);
  }

  @override
  void dispose() {
    return controller.dispose();
  }

  @override
  Widget getWidget() {
    return BetterPlayer(controller: controller);
  }
  
  @override
  void addListener(VoidCallback cb) {
    controller.videoPlayerController?.addListener(cb);
  }
}

class AvPlayerWrapper implements VideoController {
  final AvMediaPlayer controller = AvMediaPlayer();

  @override
  Future<void> initiateVideo(String url, {Map<String, String>? headers = null}) async {
    return controller.open(url);
  }

  @override
  bool? get isBuffering => controller.loading.value;

  @override
  bool? get isPlaying => controller.playbackState.value == PlaybackState.playing;

  @override
  int? get position => controller.position.value;

  @override
  int? get duration => controller.mediaInfo.value?.duration;

  @override
  Future<void> pause() async {
    controller.pause();
  }

  @override
  Future<void> play() async {
    controller.play();
  }

  @override
  Future<void> seekTo(Duration duration) async {
    controller.seekTo(duration.inMilliseconds);
  }

  @override
  Future<void> setSpeed(double speed) async {
    controller.setSpeed(speed);
  }

  @override
  void dispose() {
    return controller.dispose();
  }

  @override
  Widget getWidget() {
    return AvMediaView(initPlayer: controller, initAutoPlay: true,);
  }
  
  @override
  void addListener(VoidCallback cb) {
    controller.loading.addListener(cb);
  }
}
