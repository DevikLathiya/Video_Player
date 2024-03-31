import 'package:better_player/better_player.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/home/movies_list_view.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstorage/localstorage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api_factory/api.dart';
import '../../core/api_factory/api_end_points.dart';
import '../../core/api_factory/prefs/pref_keys.dart';
import '../../core/api_factory/prefs/pref_utils.dart';
import '../../models/movie_detail_model.dart';
import 'download_controller.dart';
import 'model/download_model.dart';

class MusicVideoDetailView extends ConsumerStatefulWidget {
  final String movieId;

  const MusicVideoDetailView({Key? key, required this.movieId})
      : super(key: key);

  @override
  ConsumerState<MusicVideoDetailView> createState() => _MoviesDetailViewState();
}

class _MoviesDetailViewState extends ConsumerState<MusicVideoDetailView>
    with WidgetsBindingObserver {
  late BetterPlayerController _betterPlayerController;
  ValueNotifier<bool> isVideoPlay = ValueNotifier(false);
  ValueNotifier<String> movieName = ValueNotifier("");
  final ValueNotifier<bool> _autoPlay = ValueNotifier(false);
  final ValueNotifier<int> _prviousIndex = ValueNotifier(-1);
  final ValueNotifier<int> _nextIndex = ValueNotifier(-1);

  DownloadController downloadController = Get.find<DownloadController>();
  final LocalStorage storage = LocalStorage('movies');

  List<MovieVideo> getMovies() {
    if (ref
                .watch(musicVideoDetailProvider)
                .musicVideoDetailModel!
                .musicDtails!
                .movieVideos !=
            null ||
        ref
            .watch(musicVideoDetailProvider)
            .musicVideoDetailModel!
            .musicDtails!
            .movieVideos!
            .isNotEmpty) {
      final movies = ref
          .watch(musicVideoDetailProvider)
          .musicVideoDetailModel!
          .musicDtails!
          .movieVideos!
          .where(((element) => element.type == QtyType.MOVIE))
          .toList();

      movies.sort((a, b) => int.parse(a.qty!).compareTo(int.parse(b.qty!)));
      return movies;
    } else {
      return [];
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    downloadController.currentMovieId = widget.movieId;
    ref
        .read(musicVideoDetailProvider)
        .musicVideoDetailsAPI(context: context, Id: widget.movieId)
        .then((value) async {
      await Future.delayed(const Duration(seconds: 1));
      _nextIndex.value = ref
              .watch(musicVideoDetailProvider)
              .musicVideoDetailModel!
              .nextrecordId ??
          -1;
      _prviousIndex.value = ref
              .watch(musicVideoDetailProvider)
              .musicVideoDetailModel!
              .preciousrecordId ??
          -1;

      movieName.value = ref
          .watch(musicVideoDetailProvider)
          .musicVideoDetailModel!
          .musicDtails!
          .name!;
      Map<String, String> urls = {};
      getMovies().forEach((element) {
        urls[element.qty!] = element.fileName!;
      });
      BetterPlayerDataSource dataSource;
      BetterPlayerConfiguration betterPlayerConfiguration =
          const BetterPlayerConfiguration(
              fit: BoxFit.contain,
              autoPlay: false,
              aspectRatio: 1.2,
              autoDetectFullscreenAspectRatio: true,
              controlsConfiguration: BetterPlayerControlsConfiguration(
                  enablePlayPause: false,
                  progressBarBufferedColor: Colors.white70,
                  progressBarHandleColor: Colors.yellow,
                  progressBarPlayedColor: Colors.yellow,
                  progressBarBackgroundColor: Colors.white54,
                  forwardSkipTimeInMilliseconds: 15000,
                  enableMute: false,
                  backwardSkipTimeInMilliseconds: 15000));
      dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network, urls.entries.first.value,
          resolutions: urls);

      _betterPlayerController =
          BetterPlayerController(betterPlayerConfiguration);
      await _betterPlayerController.setupDataSource(dataSource);
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitDown,
  //     DeviceOrientation.portraitUp,
  //   ]);
  // }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }
      else
      {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitDown,
          DeviceOrientation.portraitUp,
        ]);
      }
    });
  }

  GlobalKey globalKey = GlobalKey();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _betterPlayerController.enablePictureInPicture(globalKey);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: ref.watch(musicVideoDetailProvider).musicVideoDetailModel !=
                  null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ValueListenableBuilder<bool>(
                            valueListenable: isVideoPlay,
                            builder: (context, value, _) {
                              return value
                                  ? AspectRatio(
                                      aspectRatio: 1.2,
                                      child: BetterPlayer(
                                          key: globalKey,
                                          controller: _betterPlayerController,
                                          isPortrait: true,
                                          autoPlay: _autoPlay,
                                          previousIndex: _prviousIndex,
                                          nextIndex: _nextIndex,
                                          onChanged: (value) async {
                                            final pref = await SharedPreferences
                                                .getInstance();
                                            pref.setBool(
                                                PrefKeys.autoPlay, value);
                                            _autoPlay.value = !_autoPlay.value;
                                            showSuccessSnackbar(
                                                'Auto Play is ${_autoPlay.value ? "on" : "off"}',
                                                context);
                                          },
                                          onNext: ref
                                                      .watch(
                                                          musicVideoDetailProvider)
                                                      .musicVideoDetailModel!
                                                      .nextrecordId ==
                                                  null
                                              ? null
                                              : () {
                                                  ref
                                                      .read(
                                                          musicVideoDetailProvider)
                                                      .musicVideoDetailsAPI(
                                                          context: context,
                                                          Id: ref
                                                              .watch(
                                                                  musicVideoDetailProvider)
                                                              .musicVideoDetailModel!
                                                              .nextrecordId
                                                              .toString(),
                                                          videos: (videos,
                                                              previous,
                                                              next) async {
                                                            _prviousIndex
                                                                    .value =
                                                                previous;
                                                            _nextIndex.value =
                                                                next;
                                                            Map<String, String>
                                                                urls = {};

                                                            for (var element
                                                                in videos) {
                                                              urls[element
                                                                      .qty!] =
                                                                  element
                                                                      .fileName!;
                                                            }

                                                            BetterPlayerDataSource
                                                                dataSource;
                                                            dataSource =
                                                                BetterPlayerDataSource(
                                                                    BetterPlayerDataSourceType
                                                                        .network,
                                                                    urls
                                                                        .entries
                                                                        .first
                                                                        .value,
                                                                    resolutions:
                                                                        urls);
                                                            await _betterPlayerController
                                                                .setupDataSource(
                                                                    dataSource);
                                                            _betterPlayerController
                                                                .play();
                                                            movieName.value = ref
                                                                .watch(
                                                                    musicVideoDetailProvider)
                                                                .musicVideoDetailModel!
                                                                .musicDtails!
                                                                .name!;
                                                            setState(() {});
                                                          });
                                                },
                                          onPrevious: ref
                                                      .watch(
                                                          musicVideoDetailProvider)
                                                      .musicVideoDetailModel!
                                                      .preciousrecordId ==
                                                  null
                                              ? null
                                              : () {
                                                  ref
                                                      .read(
                                                          musicVideoDetailProvider)
                                                      .musicVideoDetailsAPI(
                                                          context: context,
                                                          Id: ref
                                                              .watch(
                                                                  musicVideoDetailProvider)
                                                              .musicVideoDetailModel!
                                                              .preciousrecordId
                                                              .toString(),
                                                          videos: (videos,
                                                              previous,
                                                              next) async {
                                                            _prviousIndex
                                                                    .value =
                                                                previous;
                                                            _nextIndex.value =
                                                                next;
                                                            Map<String, String>
                                                                urls = {};

                                                            for (var element
                                                                in videos) {
                                                              urls[element
                                                                      .qty!] =
                                                                  element
                                                                      .fileName!;
                                                            }

                                                            BetterPlayerDataSource
                                                                dataSource;
                                                            dataSource =
                                                                BetterPlayerDataSource(
                                                                    BetterPlayerDataSourceType
                                                                        .network,
                                                                    urls
                                                                        .entries
                                                                        .first
                                                                        .value,
                                                                    resolutions:
                                                                        urls);
                                                            await _betterPlayerController
                                                                .setupDataSource(
                                                                    dataSource);
                                                            _betterPlayerController
                                                                .play();
                                                            movieName.value = ref
                                                                .watch(
                                                                    musicVideoDetailProvider)
                                                                .musicVideoDetailModel!
                                                                .musicDtails!
                                                                .name!;
                                                            setState(() {});
                                                          });
                                                },
                                          movieName: movieName,
                                          amountGiven: ref
                                                      .watch(
                                                          musicVideoDetailProvider)
                                                      .musicVideoDetailModel!
                                                      .musicDtails!
                                                      .amountGiven ==
                                                  null
                                              ? null
                                              : ref
                                                  .watch(
                                                      musicVideoDetailProvider)
                                                  .musicVideoDetailModel!
                                                  .musicDtails!
                                                  .amountGiven!
                                                  .toInt(),
                                          videoType: ref
                                              .watch(musicVideoDetailProvider)
                                              .musicVideoDetailModel!
                                              .musicDtails!
                                              .type,
                                          onTap: () {
                                            PrefUtils.getToken().then((value) {
                                              Api.request(
                                                  method: HttpMethod.post,
                                                  path:
                                                      ApiEndPoints.saveEarnings,
                                                  params: {
                                                    "vid": widget.movieId,
                                                    "type": "Music Video",
                                                    "avg_run_time": ref
                                                        .read(
                                                            musicVideoDetailProvider)
                                                        .musicVideoDetailModel!
                                                        .musicDtails!
                                                        .avgRunTime,
                                                    "sid": ref
                                                        .read(
                                                            musicVideoDetailProvider)
                                                        .musicVideoDetailModel!
                                                        .musicDtails!
                                                        .studio,
                                                    "coins": 123

                                                    // "vid": widget.movieId,
                                                    // "run_time": ref
                                                    //     .read(
                                                    //         musicVideoDetailProvider)
                                                    //     .musicVideoDetailModel!
                                                    //     .musicDtails!
                                                    //     .runTime,
                                                    // "type": "Music Video",
                                                    // "sid": ref
                                                    //     .read(
                                                    //         musicVideoDetailProvider)
                                                    //     .musicVideoDetailModel!
                                                    //     .musicDtails!
                                                    //     .studio,
                                                    // "coins": ref
                                                    //     .read(
                                                    //         musicVideoDetailProvider)
                                                    //     .musicVideoDetailModel!
                                                    //     .musicDtails!
                                                    //     .amountGiven,
                                                  },
                                                  token: value ?? "",
                                                  isAuthorization: true,
                                                  isCustomResponse: true,
                                                  isLoading: false,
                                                  context: Get.context!,
                                                  onResponse:
                                                      (response) async {});
                                            });
                                          }),
                                    )
                                  : Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          child: SizedBox(
                                            height: 230,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: CommonImage(
                                              imageUrl:
                                                  '${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.musicDtails!.poster}',
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 230,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 35.0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                  onPressed: () async {
                                                    final pref =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    _autoPlay.value =
                                                        pref.getBool(PrefKeys
                                                                .autoPlay) ??
                                                            false;

                                                    final videoPlaybackMode =
                                                        pref.getString(PrefKeys
                                                            .videoPlayback);
                                                    if (videoPlaybackMode !=
                                                            null &&
                                                        videoPlaybackMode !=
                                                            Strings
                                                                .wifiAndMobileDataBoth) {
                                                      final result =
                                                          await Connectivity()
                                                              .checkConnectivity();
                                                      if (result ==
                                                              ConnectivityResult
                                                                  .wifi &&
                                                          videoPlaybackMode !=
                                                              Strings
                                                                  .wifiOnly) {
                                                        handleApiError(
                                                            'Please turn on your Mobile Data'
                                                                .tr,
                                                            context);
                                                        return;
                                                      }
                                                      if (result ==
                                                              ConnectivityResult
                                                                  .mobile &&
                                                          videoPlaybackMode !=
                                                              Strings
                                                                  .mobileData) {
                                                        handleApiError(
                                                            'Please turn on your Wifi'
                                                                .tr,
                                                            context);
                                                        return;
                                                      }
                                                    }
                                                    isVideoPlay.value = true;
                                                    _betterPlayerController
                                                        .play();
                                                  },
                                                  icon: const Icon(
                                                    Icons.play_circle_fill,
                                                    color: Colors.white,
                                                    size: 70,
                                                  )),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, top: 10),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.white,
                                                  size: 30,
                                                )),
                                          ),
                                        ),
                                      ],
                                    );
                            }),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ref
                                      .watch(musicVideoDetailProvider)
                                      .musicVideoDetailModel!
                                      .musicDtails!
                                      .certificate!
                                      .isNotEmpty
                                  ? ref
                                      .watch(musicVideoDetailProvider)
                                      .musicVideoDetailModel!
                                      .musicDtails!
                                      .certificate!
                                  : ' U/A 11+',
                              style: TextStyle(
                                fontFamily: Strings.robotoRegular,
                                fontSize: 11.0,
                                color: const Color(0xff535353),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 7.0),
                              child: Text(
                                  ref
                                          .watch(musicVideoDetailProvider)
                                          .musicVideoDetailModel!
                                          .musicDtails!
                                          .name!
                                          .isNotEmpty
                                      ? ref
                                          .watch(musicVideoDetailProvider)
                                          .musicVideoDetailModel!
                                          .musicDtails!
                                          .name!
                                      : '',
                                  style: TextStyle(
                                    fontFamily: Strings.robotoMedium,
                                    fontSize: 20.0,
                                    color: const Color(0xff272727),
                                  )),
                            ),
                            Text(
                              ref
                                      .watch(musicVideoDetailProvider)
                                      .musicVideoDetailModel!
                                      .musicDtails!
                                      .language!
                                      .isNotEmpty
                                  ? ref
                                      .watch(musicVideoDetailProvider)
                                      .musicVideoDetailModel!
                                      .musicDtails!
                                      .language!
                                  : '2019 . Sci-fi . Action',
                              style: TextStyle(
                                fontFamily: Strings.robotoRegular,
                                fontSize: 11.0,
                                color: const Color(0xff535353),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 7.0),
                              child: HtmlWidget(
                                ref
                                                .watch(musicVideoDetailProvider)
                                                .musicVideoDetailModel!
                                                .musicDtails!
                                                .description !=
                                            null &&
                                        ref
                                            .watch(musicVideoDetailProvider)
                                            .musicVideoDetailModel!
                                            .musicDtails!
                                            .description!
                                            .isNotEmpty
                                    ? ref
                                        .watch(musicVideoDetailProvider)
                                        .musicVideoDetailModel!
                                        .musicDtails!
                                        .description!
                                    : '',
                                // onTapUrl: (url) {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => CommonWebView(url: url),
                                //     ),
                                //   );
                                //   return true;
                                // },
                                textStyle: TextStyle(
                                  fontFamily: Strings.robotoMedium,
                                  fontSize: 13.0,
                                  letterSpacing: 0.6,
                                  color: const Color(0xff272727),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 10.0, bottom: 7.0),
                            //   child: Text(
                            //       ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.movieDtails!.description!.isNotEmpty ? ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.movieDtails!.description! : '',
                            //       style: TextStyle(
                            //         fontFamily: Strings.robotoMedium,
                            //         fontSize: 13.0,
                            //         letterSpacing: 0.6,
                            //         color: Color(0xff272727),
                            //       )),
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                // Expanded(
                                //   child: ABButtonGery(
                                //     paddingTop: 10.0,
                                //     paddingBottom: 15.0,
                                //     paddingLeft: 1.0,
                                //     paddingRight: 15.0,
                                //     text: 'Play Trailer',
                                //     onPressed: () {
                                //       showSuccessSnackbar(
                                //           ref
                                //                   .watch(musicVideoDetailProvider)
                                //                   .musicVideoDetailModel!
                                //                   .musicDtails!
                                //                   .trailer!
                                //                   .isNotEmpty
                                //               ? 'id : ${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.musicDtails!.id!}, Type : ${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.musicDtails!.type!}, Run Time : ${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.musicDtails!.runTime!}, ${AppUrls.baseUrl}${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.musicDtails!.trailer!}'
                                //               : '',
                                //           context);
                                //       // log('Movie id : ${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.movieDtails!.id!}, Movie Type : ${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.movieDtails!.type!}, Run Time : ${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.movieDtails!.runTime!}, Trailer : ${AppUrls.baseUrl}${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.movieDtails!.trailer!}');
                                //       // Navigator.push(
                                //       //   context,
                                //       //   MaterialPageRoute(
                                //       //       builder: (context) => const RegisterView()),
                                //       // );
                                //     },
                                //   ),
                                // ),

                                // Expanded(
                                //   child: ABButton(
                                //     paddingTop: 10.0,
                                //     paddingBottom: 15.0,
                                //     paddingLeft: 10.0,
                                //     paddingRight: 1.0,
                                //     text: 'Start Watching',
                                //     onPressed: () {
                                //       showSuccessSnackbar(
                                //           ref
                                //                   .watch(musicVideoDetailProvider)
                                //                   .musicVideoDetailModel!
                                //                   .musicDtails!
                                //                   .thumbnail!
                                //                   .isNotEmpty
                                //               ? 'id : ${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.musicDtails!.id!}, Type : ${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.musicDtails!.type!}, Run Time : ${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.musicDtails!.runTime!},Trailer : ${AppUrls.baseUrl}${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.musicDtails!.trailer!}, Video Link : ${AppUrls.baseUrl}${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.musicDtails!.video!}'
                                //               : '',
                                //           context);
                                //       // log('Movie id : ${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.movieDtails!.id!}, Movie Type : ${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.movieDtails!.type!}, Run Time : ${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.movieDtails!.runTime!},Trailer : ${AppUrls.baseUrl}${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.movieDtails!.trailer!}, Video Link : ${AppUrls.baseUrl}${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.movieDtails!.video!}');
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Obx(() {
                                  final movie = downloadController
                                      .downloadingTask
                                      .firstWhereOrNull((element) =>
                                          element.movieId ==
                                          ref
                                              .watch(musicVideoDetailProvider)
                                              .musicVideoDetailModel!
                                              .musicDtails!
                                              .id
                                              .toString());
                                  if (movie != null && movie.progress != 100) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (movie.status ==
                                                DownloadTaskStatus.running) {
                                              FlutterDownloader.pause(
                                                  taskId: movie.taskId!);
                                            }
                                            if (movie.status ==
                                                DownloadTaskStatus.paused) {
                                              FlutterDownloader.resume(
                                                      taskId: movie.taskId!)
                                                  .then((value) {
                                                downloadController
                                                    .downloadingTask
                                                    .firstWhere((element) =>
                                                        element.movieId ==
                                                        movie.movieId)
                                                    .taskId = value;
                                              });
                                            }
                                          },
                                          child: CircularPercentIndicator(
                                            radius: 20.0,
                                            lineWidth: 2.0,
                                            percent: movie.progress == null
                                                ? 0.0
                                                : (movie.progress! / 100)
                                                    .toDouble(),
                                            center: Icon(
                                              movie.status ==
                                                      DownloadTaskStatus.running
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              color: Colors.amber,
                                            ),
                                            circularStrokeCap:
                                                CircularStrokeCap.butt,
                                            backgroundColor: Colors.white,
                                            progressColor: Colors.amber,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text("${movie.progress} %",
                                            style: TextStyle(
                                              fontFamily: Strings.robotoMedium,
                                              fontSize: 12.0,
                                              color: const Color(0xff272727),
                                            )),
                                      ],
                                    );
                                  } else {
                                    return FutureBuilder(
                                        future: storage.ready,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            bool isDownloaded = false;
                                            final data =
                                                storage.getItem('movies');
                                            if (data != null) {
                                              final movies = (data as List)
                                                  .map((e) =>
                                                      Download.fromMap(e))
                                                  .toList();
                                              if (movies.isNotEmpty &&
                                                  movies.firstWhereOrNull((element) =>
                                                          element.movieId ==
                                                          ref
                                                              .read(
                                                                  musicVideoDetailProvider)
                                                              .musicVideoDetailModel!
                                                              .musicDtails!
                                                              .id
                                                              .toString()) !=
                                                      null) {
                                                isDownloaded = true;
                                              }
                                            }
                                            return InkWell(
                                              onTap: isDownloaded
                                                  ? () {
                                                      // storage.clear();
                                                      // return;

                                                      if (!Get.isSnackbarOpen) {
                                                        Get.rawSnackbar(
                                                            message:
                                                                'Already Downloaded'
                                                                    .tr,
                                                            duration:
                                                                const Duration(
                                                                    seconds:
                                                                        1));
                                                      }
                                                    }
                                                  : () async {
                                                      // Kishor
                                                      final movies =
                                                          getMovies();
                                                      if (movies.isEmpty) {
                                                        return;
                                                      }
                                                      final ConnectivityResult
                                                          result =
                                                          await Connectivity()
                                                              .checkConnectivity();
                                                      final pref =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      if (result ==
                                                          ConnectivityResult
                                                              .mobile) {
                                                        final isWifiOnly = pref
                                                            .getBool(PrefKeys
                                                                .downloadMode);
                                                        if (isWifiOnly !=
                                                                null &&
                                                            isWifiOnly) {
                                                          handleApiError(
                                                              'Please turn on your Wifi'
                                                                  .tr,
                                                              context);
                                                          Get.back();
                                                          return;
                                                        }
                                                      }
                                                      final videoQuality = pref
                                                          .getString(PrefKeys
                                                              .videoQuality);
                                                      for (var movie
                                                          in movies) {
                                                        if (movie.qty ==
                                                            videoQuality) {
                                                          downloadController
                                                                  .selectedQuality =
                                                              movie;
                                                        }
                                                      }
                                                      print(
                                                          "Movie lenght ${getMovies().length}");
                                                      if (downloadController
                                                              .selectedQuality
                                                              .qty ==
                                                          null) {
                                                        downloadController
                                                                .selectedQuality =
                                                            getMovies()[
                                                                getMovies()
                                                                        .length -
                                                                    1];
                                                      }
                                                      // if(result.name)
                                                      downloadController.downloadVideo(Download(
                                                          movieName: ref
                                                              .read(
                                                                  musicVideoDetailProvider)
                                                              .musicVideoDetailModel!
                                                              .musicDtails!
                                                              .name,
                                                          poster: ref
                                                              .read(
                                                                  musicVideoDetailProvider)
                                                              .musicVideoDetailModel!
                                                              .musicDtails!
                                                              .poster,
                                                          movieUrl: downloadController
                                                                  .selectedQuality
                                                                  .fileName ??
                                                              "",
                                                          qty: downloadController
                                                              .selectedQuality
                                                              .qty!,
                                                          movieId: ref
                                                              .read(
                                                                  musicVideoDetailProvider)
                                                              .musicVideoDetailModel!
                                                              .musicDtails!
                                                              .id
                                                              .toString()));

                                                      // Kishor
                                                    },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                      isDownloaded
                                                          ? Icons.check
                                                          : Icons.download,
                                                      color: Colors.amber,
                                                      size: 35),
                                                  Text(
                                                      isDownloaded
                                                          ? 'Downloaded'
                                                          : 'Download',
                                                      style: TextStyle(
                                                        fontFamily: Strings
                                                            .robotoMedium,
                                                        fontSize: 12.0,
                                                        color: const Color(
                                                            0xff272727),
                                                      )),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        });
                                  }
                                }),
                                Column(
                                  children: [
                                    ref
                                            .watch(musicVideoDetailProvider)
                                            .musicVideoDetailModel!
                                            .isFavourite!
                                        ? GestureDetector(
                                            onTap: () {
                                              ref
                                                  .watch(
                                                      influncerDetailProvider)
                                                  .updateFavourite(
                                                      context: context,
                                                      videoId: ref
                                                          .watch(
                                                              musicVideoDetailProvider)
                                                          .musicVideoDetailModel!
                                                          .musicDtails!
                                                          .id
                                                          .toString(),
                                                      fav: '0');
                                              setState(() {
                                                ref
                                                    .watch(
                                                        musicVideoDetailProvider)
                                                    .musicVideoDetailModel!
                                                    .isFavourite = false;
                                              });
                                            },
                                            child: const Icon(Icons.check,
                                                color: Colors.amber, size: 35),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              ref
                                                  .watch(
                                                      influncerDetailProvider)
                                                  .updateFavourite(
                                                      context: context,
                                                      videoId: ref
                                                          .watch(
                                                              musicVideoDetailProvider)
                                                          .musicVideoDetailModel!
                                                          .musicDtails!
                                                          .id
                                                          .toString(),
                                                      fav: '1');
                                              setState(() {
                                                ref
                                                    .watch(
                                                        musicVideoDetailProvider)
                                                    .musicVideoDetailModel!
                                                    .isFavourite = true;
                                              });
                                            },
                                            child: const Icon(Icons.add,
                                                color: Colors.amber, size: 35),
                                          ),
                                    const SizedBox(height: 3),
                                    Text('Watch List',
                                        style: TextStyle(
                                          fontFamily: Strings.robotoMedium,
                                          fontSize: 12.0,
                                          color: const Color(0xff272727),
                                        )),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text('Cast'.tr,
                          style: TextStyle(
                            fontFamily: Strings.robotoMedium,
                            fontSize: 16.0,
                            color: const Color(0xff272727),
                          )),
                    ),

                    ref
                                    .watch(musicVideoDetailProvider)
                                    .musicVideoDetailModel!
                                    .musicDtails !=
                                null &&
                            ref
                                    .watch(musicVideoDetailProvider)
                                    .musicVideoDetailModel!
                                    .actors !=
                                null &&
                            ref
                                .watch(musicVideoDetailProvider)
                                .musicVideoDetailModel!
                                .actors!
                                .isNotEmpty
                        ? SizedBox(
                            height: 220,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: ref
                                    .watch(musicVideoDetailProvider)
                                    .musicVideoDetailModel!
                                    .actors!
                                    .length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: SizedBox(
                                            height: 170,
                                            width: 120,
                                            child: CommonImage(
                                              imageUrl: ref
                                                      .watch(
                                                          musicVideoDetailProvider)
                                                      .musicVideoDetailModel!
                                                      .actors![index]
                                                      .photo!
                                                      .isNotEmpty
                                                  ? '${AppUrls.baseUrl}${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.actors![index].photo.toString()}'
                                                  : '',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        ref
                                                .watch(musicVideoDetailProvider)
                                                .musicVideoDetailModel!
                                                .actors![index]
                                                .type!
                                                .isNotEmpty
                                            ? ref
                                                .watch(musicVideoDetailProvider)
                                                .musicVideoDetailModel!
                                                .actors![index]
                                                .title
                                                .toString()
                                            : '',
                                        style: TextStyle(
                                            fontFamily: Strings.robotoMedium,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: Colors.black),
                                      )
                                    ],
                                  );
                                }),
                          )
                        : const SizedBox(),

                    // Padding(
                    //   padding: const EdgeInsets.only(left: 15.0),
                    //   child: Text('Details',
                    //       style: TextStyle(
                    //         fontFamily: Strings.robotoMedium,
                    //         fontSize: 16.0,
                    //         color: Color(0xff272727),
                    //       )),
                    // ),

                    // Padding(
                    //   padding: const EdgeInsets.only(left:15, top: 10.0, bottom: 7.0, right: 10),
                    //   child: Text('Directer\nAnna Boden, Ryan Fleck\n\nMusic Directer\nPinar Toprak',
                    //       style: TextStyle(
                    //         fontFamily: Strings.robotoMedium,
                    //         fontSize: 16.0,
                    //         letterSpacing: 0.5,
                    //         color: Color(0xff272727),
                    //       )),
                    // ),

                    // Padding(
                    //   padding: const EdgeInsets.only(left: 15.0, top: 10),
                    //   child: Text('Writers',
                    //       style: TextStyle(
                    //         fontFamily: Strings.robotoMedium,
                    //         fontSize: 16.0,
                    //         color: Color(0xff272727),
                    //       )),
                    // ),

                    // ref.watch(musicVideoDetailProvider).musicVideoDetailModel != null &&  ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.writters!.isNotEmpty ?
                    // SizedBox(
                    //   height: 220,
                    //   child: ListView.builder(
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.writters!.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return Column(
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: ClipRRect(
                    //                 borderRadius: BorderRadius.circular(5),
                    //                 child: SizedBox(
                    //                   height: 170,
                    //                   width: 120,
                    //                   child: Image.network( ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.writters![index].photo!.isNotEmpty ? '${AppUrls.baseUrl}${ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.writters![index].photo.toString()}' : '',
                    //                       fit: BoxFit.cover),
                    //                 ),
                    //               ),
                    //             ),
                    //             Text(
                    //               ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.writters![index].type!.isNotEmpty ? ref.watch(musicVideoDetailProvider).musicVideoDetailModel!.writters![index].type.toString() : '',
                    //               style: TextStyle(
                    //                   fontFamily: Strings.robotoMedium,
                    //                   fontWeight: FontWeight.w500,
                    //                   fontSize: 14.0,
                    //                   color: Colors.black),
                    //             )
                    //           ],
                    //         );
                    //       }),
                    // ): SizedBox(),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 25, bottom: 5),
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            'Similar movies'.tr,
                            style: TextStyle(
                                fontFamily: Strings.robotoMedium,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.black),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MoviesListView()),
                            );
                          },
                          child: Text(
                            '',
                            style: TextStyle(
                                fontFamily: Strings.robotoMedium,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                                color: const Color(0xFFFECC00)),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 200,
                      child: ref
                                      .watch(musicVideoDetailProvider)
                                      .suggestMusicVideoModel !=
                                  null &&
                              ref
                                  .watch(musicVideoDetailProvider)
                                  .suggestMusicVideoModel!
                                  .suggestlist!
                                  .isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: ref
                                  .watch(musicVideoDetailProvider)
                                  .suggestMusicVideoModel!
                                  .suggestlist!
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MusicVideoDetailView(
                                                  movieId: ref
                                                      .watch(
                                                          musicVideoDetailProvider)
                                                      .suggestMusicVideoModel!
                                                      .suggestlist![index]
                                                      .id!
                                                      .toString())),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                        width: 120.0,
                                        child: CommonImage(
                                          imageUrl:
                                              '${AppUrls.baseUrl}${ref.watch(musicVideoDetailProvider).suggestMusicVideoModel!.suggestlist![index].poster}',
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : const SizedBox(),
                    ),
                    const SizedBox(height: 25)
                  ],
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
