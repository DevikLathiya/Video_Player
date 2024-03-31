import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/video_player_next_previous_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api_factory/api.dart';
import '../../core/api_factory/api_end_points.dart';
import '../../core/api_factory/prefs/pref_keys.dart';
import '../../core/api_factory/prefs/pref_utils.dart';
import 'model/download_model.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class VideoPlayerView extends StatefulWidget {
  Map<String, String>? urls;
  String movieName;
  final bool isFromNetwork;
  final bool isFromMoive;
  final String? filePath;
  final bool? isMovie;
  String? sid;
  String? movieId;
  final Duration? seekTo;
  int? amountGiven;
  final List<Download>? movies;
  final int? currentDownloadedMovieIndex;
  final Function(int?)? onVideoDuration;
  final int? previousId;
  final int? nextId;
  final GestureTapCallback? onPrevious;
  final GestureTapCallback? onNext;
  final Stream<VideoPlayerNextPreviousModel>? stream;

  VideoPlayerView({Key? key,
    this.urls,
    this.movieName = "",
    required this.isFromNetwork,
    this.filePath,
    this.isMovie,
    this.sid,
    this.movieId,
    this.seekTo,
    this.isFromMoive = false,
    this.onVideoDuration,
    this.amountGiven,
    this.movies,
    this.currentDownloadedMovieIndex,
    this.onPrevious,
    this.onNext,
    this.stream,
    this.nextId,
    this.previousId})
      : super(key: key);

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> with WidgetsBindingObserver {
  late BetterPlayerController _betterPlayerController;
  late int totalSeconds;
  late SharedPreferences pref;
  final ValueNotifier<bool> _isInitiVideo = ValueNotifier(false);
  final ValueNotifier<bool> _autoPlay = ValueNotifier(false);
  final ValueNotifier<String> _movieName = ValueNotifier('');
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);
  final ValueNotifier<int> _previousIndex = ValueNotifier(-1);
  final ValueNotifier<int> _nextIndex = ValueNotifier(1);

  int get currentIndex => _currentIndex.value;

  set currentIndex(int value) => _currentIndex.value = value;

  int get previousIndex => _previousIndex.value;

  set previousIndex(int value) => _previousIndex.value = value;

  int get nextIndex => _nextIndex.value;

  set nextIndex(int value) => _nextIndex.value = value;

  GlobalKey globalKey = GlobalKey();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _betterPlayerController.enablePictureInPicture(globalKey);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initVideoPlayer(); // Kishor
    _movieName.value = widget.movieName;
    if (widget.isFromNetwork) {
      previousIndex = widget.previousId ?? -1;
      nextIndex = widget.nextId ?? -1;
      if (widget.stream != null) {
        widget.stream!.listen((event) async {
          _isInitiVideo.value = true;
          _movieName.value = event.movieName;
          widget.urls = event.urls;
          widget.movieId = event.movieId;
          widget.sid = event.sid;
          previousIndex = event.previousMovieId == null
              ? -1 : int.parse(event.previousMovieId!);
          nextIndex = event.nextMovieId == null ? -1 : int.parse(event.nextMovieId!);
          print('called moin is null $nextIndex');
          widget.amountGiven = event.amountGiven;
          final pref = await SharedPreferences.getInstance();
          final videoQuality = pref.getString(PrefKeys.playVideoQuality);
          String? defaultUrl = event.urls.values.first;

          if (videoQuality != "") {
            defaultUrl = event.urls[videoQuality];
          }
          final dataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            defaultUrl!, resolutions: event.urls,
          );
          await _betterPlayerController.setupDataSource(dataSource).then((value) {
            _betterPlayerController.seekTo(Duration(seconds: int.parse(event.seekTo ?? "0")));

            totalSeconds = _betterPlayerController.videoPlayerController!.value.duration!.inSeconds;
          });
          _isInitiVideo.value = true;
          setState(() {});
        });
      }
    }
    super.initState();
  }

  void _updatePreviousNextIndices() {
    previousIndex = currentIndex > 0 ? currentIndex - 1 : -1;
    nextIndex = currentIndex < widget.movies!.length - 1 ? currentIndex + 1 : -1;
    _movieName.value = widget.movies![currentIndex].movieName!;
  }

  // Kishor
  void initVideoPlayer() async {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);

    BetterPlayerDataSource dataSource;
    BetterPlayerConfiguration betterPlayerConfiguration =
    const BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      autoPlay: true,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enablePlayPause: false,
        progressBarBufferedColor: Colors.white70,
        progressBarHandleColor: Colors.yellow,
        progressBarPlayedColor: Colors.yellow,
        progressBarBackgroundColor: Colors.white54,
        forwardSkipTimeInMilliseconds: 15000,
        enableMute: false,
        backwardSkipTimeInMilliseconds: 15000,
      ),
    );
    pref = await SharedPreferences.getInstance();
    _autoPlay.value = pref.getBool(PrefKeys.autoPlay) ?? false;
    if (widget.isFromNetwork) {
      final videoQuality = pref.getString(PrefKeys.playVideoQuality);

      String? defaultUrl = widget.urls!.values.first;
      if (videoQuality != "") {
        defaultUrl = widget.urls![videoQuality];
      }

      dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        defaultUrl!,
        resolutions: widget.urls,
      );
    } else {
      currentIndex = widget.currentDownloadedMovieIndex!;
      _updatePreviousNextIndices();

      dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        widget.movies![currentIndex].fileName ?? "",
      );
    }

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource).then((value) {
      _betterPlayerController.seekTo(widget.seekTo ?? Duration.zero);
      _betterPlayerController.toggleFullScreen();
      totalSeconds = _betterPlayerController
          .videoPlayerController!.value.duration!.inSeconds;
    });
    _isInitiVideo.value = true;
  }

  Future<void> _updateController() async {
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file, widget.movies![currentIndex].fileName ?? "",);
    await _betterPlayerController.setupDataSource(dataSource);
    await _betterPlayerController.play();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    final Duration duration =
        _betterPlayerController.videoPlayerController!.value.position;
    if (widget.isFromMoive && widget.isFromNetwork) {
      PrefUtils.getToken().then((value) {
        Api.request(
            method: HttpMethod.post,
            path: ApiEndPoints.watchVideoDuration,
            params: {
              'type': widget.isMovie! ? 'movie' : 'trailer',
              'movieId': widget.movieId,
              'videoSecond': duration.inSeconds,
              'totalVideoSecond': totalSeconds
            },
            token: value ?? "",
            isAuthorization: true,
            isCustomResponse: true,
            isLoading: false,
            context: Get.context!,
            onResponse: (response) async {
              widget.onVideoDuration!.call(duration.inSeconds);
            });
      });
    }

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemChrome.setPreferredOrientations(

            [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          body: ValueListenableBuilder(
              valueListenable: _isInitiVideo,
              builder: (context, isInit, _) {
                return isInit
                    ? BetterPlayer(
                    key: globalKey,
                    controller: _betterPlayerController,
                    movieName: _movieName,
                    amountGiven: widget.amountGiven,
                    previousIndex: _previousIndex,
                    nextIndex: _nextIndex,
                    autoPlay: _autoPlay,
                    onChanged: (value) {
                      pref.setBool(PrefKeys.autoPlay, value);
                      _autoPlay.value = !_autoPlay.value;
                      showSuccessSnackbar(
                          'Auto Play is ${_autoPlay.value ? "on" : "off"}',
                          context);
                    },
                    onPrevious: widget.isFromNetwork
                        ? () {
                      _isInitiVideo.value = true;
                      widget.onPrevious!.call();
                    }
                        : () {
                      setState(() {
                        currentIndex = previousIndex;
                        _updatePreviousNextIndices();
                        _updateController();
                      });
                    },
                    onNext: widget.isFromNetwork
                        ? () {
                      _isInitiVideo.value = true;
                      widget.onNext!.call();
                    }
                        : () {
                      setState(() {
                        currentIndex = nextIndex;
                        _updatePreviousNextIndices();
                        _updateController();
                      });
                    },
                    onTap: () {
                      if (widget.isFromNetwork) {
                        PrefUtils.getToken().then((value) async {
                          Api.request(
                              method: HttpMethod.post,
                              path: ApiEndPoints.saveEarnings,
                              params: {
                                "vid": widget.movieId,
                                "type": "Movies",
                                "sid": widget.sid,
                                "coins": 0,
                                "avg_run_time": formatDuration(
                                    await _betterPlayerController.videoPlayerController!.position),
                              },
                              token: value ?? "",
                              isAuthorization: true,
                              isCustomResponse: true,
                              isLoading: false,
                              context: Get.context!,
                              onResponse: (response) async {
                                Navigator.pop(context);
                              });
                        });
                      } else {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    })
                    : const SizedBox();
              }),
        ),
      ),
    );
  }

  String formatDuration(Duration? duration) {
    String hours = duration!.inHours.toString().padLeft(0, '2');
    String minutes =
    duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
    duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }
}
