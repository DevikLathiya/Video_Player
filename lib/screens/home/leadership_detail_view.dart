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
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/home/movies_list_view.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstorage/localstorage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api_factory/api.dart';
import '../../core/api_factory/api_end_points.dart';
import '../../core/api_factory/prefs/pref_keys.dart';
import '../../core/api_factory/prefs/pref_utils.dart';
import '../../core/utils/utils.dart';
import '../../models/movie_detail_model.dart';
import 'dowload_view.dart';
import 'download_controller.dart';
import 'model/download_model.dart';

class LeadershipDetailView extends ConsumerStatefulWidget {
  final String videoId;
  const LeadershipDetailView({Key? key, required this.videoId}) : super(key: key);

  @override
  ConsumerState<LeadershipDetailView> createState() => _LeadershipDetailViewState();
}

class _LeadershipDetailViewState extends ConsumerState<LeadershipDetailView> {
  late BetterPlayerController _betterPlayerController;
  ValueNotifier<bool> isVideoPlay = ValueNotifier(false);
  DownloadController downloadController = Get.find<DownloadController>();
  final LocalStorage storage = LocalStorage('movies');
  ValueNotifier<String> movieName = ValueNotifier("");
  final ValueNotifier<bool> _autoPlay = ValueNotifier(false);
  final ValueNotifier<int> _prviousIndex = ValueNotifier(-1);
  final ValueNotifier<int> _nextIndex = ValueNotifier(-1);
  List<MovieVideo> getMovies() {
    if (ref
                .watch(leadershipDetailProvider)
                .leaderDetailModel!
                .leaderDetails!
                .first
                .movieVideos !=
            null ||
        ref
            .watch(leadershipDetailProvider)
            .leaderDetailModel!
            .leaderDetails!
            .first
            .movieVideos!
            .isNotEmpty) {
      print('called moin after if');
      final movies = ref
          .watch(leadershipDetailProvider)
          .leaderDetailModel!
          .leaderDetails!
          .first
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
    super.initState();
    downloadController.currentMovieId = widget.videoId;
    ref.read(leadershipDetailProvider)
        .LeadershipDetailsAPI(context: context, LeadershipId: widget.videoId)
        .then((value) async {
      await Future.delayed(const Duration(seconds: 1));
      _nextIndex.value =
          ref.read(leadershipDetailProvider).leaderDetailModel!.nextrecordId ?? -1;
      _prviousIndex.value =
          ref.read(leadershipDetailProvider).leaderDetailModel!.preciousrecordId ??
              -1;
      Map<String, String> urls = {};
      movieName.value = ref
          .read(leadershipDetailProvider)
          .leaderDetailModel!
          .leaderDetails!
          .first
          .name!;
      String url="";
      for (var element in getMovies()) {
        urls[element.qty!] = element.fileName!;
        // if(element.movieId==widget.videoId)
        //   {
        //     url=element.fileName!;
        //   }
      }


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

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }
  GlobalKey globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.black,
        // ),
        body: SingleChildScrollView(
          child: ref.watch(leadershipDetailProvider).leaderDetailModel != null &&
                  ref
                      .watch(leadershipDetailProvider)
                      .leaderDetailModel!
                      .leaderDetails!
                      .isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<bool>(
                        valueListenable: isVideoPlay,
                        builder: (context, value, _) {
                          return value
                              ? AspectRatio(
                            aspectRatio: 1.2,
                            child: BetterPlayer(
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
                                  .watch(leadershipDetailProvider)
                                  .leaderDetailModel!
                                  .nextrecordId ==
                                  null
                                  ? null
                                  : () {
                                ref
                                    .read(leadershipDetailProvider)
                                    .LeadershipDetailsAPI(
                                    context: context,
                                    LeadershipId: ref
                                        .watch(
                                        leadershipDetailProvider)
                                        .leaderDetailModel!
                                        .nextrecordId
                                        .toString(),
                                    videos: (videos,
                                        previous,
                                        next) async {
                                      _prviousIndex.value =
                                          previous;
                                      _nextIndex.value =
                                          next;
                                      Map<String, String>
                                      urls = {};

                                      for (var element
                                      in videos) {
                                        urls[element.qty!] =
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
                                          leadershipDetailProvider)
                                          .leaderDetailModel!
                                          .leaderDetails!
                                          .first
                                          .name!;
                                      setState(() {});
                                    });
                              },
                              onPrevious: ref
                                  .watch(leadershipDetailProvider)
                                  .leaderDetailModel!
                                  .preciousrecordId ==
                                  null
                                  ? null
                                  : () {
                                ref
                                    .read(leadershipDetailProvider)
                                    .LeadershipDetailsAPI(
                                    context: context,
                                    LeadershipId: ref
                                        .watch(
                                        leadershipDetailProvider)
                                        .leaderDetailModel!
                                        .preciousrecordId
                                        .toString(),
                                    videos: (videos,
                                        previous,
                                        next) async {
                                      _prviousIndex.value =
                                          previous;
                                      _nextIndex.value =
                                          next;
                                      Map<String, String>
                                      urls = {};

                                      for (var element
                                      in videos) {
                                        urls[element.qty!] =
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
                                          leadershipDetailProvider)
                                          .leaderDetailModel!
                                          .leaderDetails!
                                          .first
                                          .name!;
                                      setState(() {});
                                    });
                              },
                              movieName: movieName,
                              avgRuntime: double.parse(ref
                                  .watch(leadershipDetailProvider)
                                  .leaderDetailModel!
                                  .leaderDetails!
                                  .first
                                  .avgRunTime!)
                                  .toInt(),
                              videoType: ref
                                  .watch(leadershipDetailProvider)
                                  .leaderDetailModel!
                                  .leaderDetails!
                                  .first
                                  .type,
                              amountGiven: ref
                                  .watch(leadershipDetailProvider)
                                  .leaderDetailModel!
                                  .leaderDetails!
                                  .first
                                  .amountGiven,
                              onDialogShow: () {
                                PrefUtils.getToken().then((value) {
                                  Api.request(
                                      method: HttpMethod.post,
                                      path: ApiEndPoints.saveEarnings,
                                      params: {
                                        "vid": ref
                                            .watch(
                                            leadershipDetailProvider)
                                            .leaderDetailModel!
                                            .leaderDetails!
                                            .first
                                            .id,
                                        "type": "Schemes",
                                        "avg_run_time": ref
                                            .watch(
                                            leadershipDetailProvider)
                                            .leaderDetailModel!
                                            .leaderDetails!
                                            .first
                                            .avgRunTime!,
                                        "sid": "18",
                                        "coins": ref
                                            .watch(
                                            leadershipDetailProvider)
                                            .leaderDetailModel!
                                            .leaderDetails!
                                            .first
                                            .amountGiven
                                        // "vid": widget.videoId,
                                        // "run_time": ref
                                        //     .read(leadershipDetailProvider)
                                        //     .leaderDetailModel!
                                        //     .leaderDetails!
                                        //     .first
                                        //     .runTime,
                                        // "sid": ref
                                        //     .read(leadershipDetailProvider)
                                        //     .leaderDetailModel!
                                        //     .leaderDetails!
                                        //     .first
                                        //     .studio,
                                        // 'type': "Scheme Video",
                                        // "coins": ref
                                        //     .read(leadershipDetailProvider)
                                        //     .leaderDetailModel!
                                        //     .leaderDetails!
                                        //     .first
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
                              },
                            ),
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
                                    '${AppUrls.baseUrl}${ref.watch(leadershipDetailProvider).leaderDetailModel!.leaderDetails![0].poster}',
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
                                          if (ref
                                              .watch(
                                              leadershipDetailProvider)
                                              .leaderDetailModel!
                                              .leaderDetails!
                                              .first
                                              .movieVideos!
                                              .isNotEmpty) {
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
                                          } else {
                                            ScaffoldMessenger.of(
                                                context)
                                                .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "No movie available")));
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.play_circle_fill,
                                          color: Colors.white,
                                          size: 70,
                                        )),
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       left: 10.0, top: 40),
                              //   child: Align(
                              //     alignment: Alignment.topLeft,
                              //     child: IconButton(
                              //         onPressed: () {
                              //           Navigator.pop(context);
                              //         },
                              //         icon: const Icon(
                              //           Icons.arrow_back,
                              //           color: Colors.white,
                              //           size: 30,
                              //         )),
                              //   ),
                              // ),
                            ],
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 7.0),
                                    child: Text(
                                        ref
                                                .watch(leadershipDetailProvider)
                                                .leaderDetailModel!
                                                .leaderDetails![0]
                                                .name!
                                                .isNotEmpty
                                            ? ref
                                                .watch(leadershipDetailProvider)
                                                .leaderDetailModel!
                                                .leaderDetails![0]
                                                .name!
                                            : '',
                                        style: TextStyle(
                                          fontFamily: Strings.robotoMedium,
                                          fontSize: 20.0,
                                          color: const Color(0xff272727),
                                        )),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.amber),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(40))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6.0,
                                        right: 6.0,
                                        top: 3.0,
                                        bottom: 3.0),
                                    child: Row(
                                      children: [
                                        Image.asset('assets/coin.png',
                                            fit: BoxFit.cover, height: 25),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${ref.watch(leadershipDetailProvider).leaderDetailModel!.leaderDetails!.first.amountGiven}',
                                          style: TextStyle(
                                            fontFamily: Strings.robotoRegular,
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
              '${ ref
                  .watch(leadershipDetailProvider)
                  .leaderDetailModel!
                  .leaderDetails![0]
                  .language!
                  .isNotEmpty
                  ? ref
                  .watch(leadershipDetailProvider)
                  .leaderDetailModel!
                  .leaderDetails![0]
                  .language!
                  : '2019 . Sci-fi . 779 Views'}',
              style: TextStyle(
                fontFamily: Strings.robotoRegular,
                fontSize: 11.0,
                color: const Color(0xff535353),
              ),
            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 13.0),
                              child: HtmlWidget(
                                ref
                                        .watch(leadershipDetailProvider)
                                        .leaderDetailModel!
                                        .leaderDetails![0]
                                        .description!
                                        .isNotEmpty
                                    ? '${ref.watch(leadershipDetailProvider).leaderDetailModel!.leaderDetails![0].description!}.....'
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
                            //       ref.watch(leadershipDetailProvider).movieDetails!.movieDtails!.description!.isNotEmpty ? ref.watch(leadershipDetailProvider).movieDetails!.movieDtails!.description! : '',
                            //       style: TextStyle(
                            //         fontFamily: Strings.robotoMedium,
                            //         fontSize: 13.0,
                            //         letterSpacing: 0.6,
                            //         color: Color(0xff272727),
                            //       )),
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     Card(
                            //       semanticContainer: true,
                            //       clipBehavior: Clip.antiAliasWithSaveLayer,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(50.0),
                            //       ),
                            //       elevation: 6,
                            //       margin: const EdgeInsets.all(10),
                            //       child: Image.asset('assets/logo_new.png',
                            //           fit: BoxFit.cover, height: 48),
                            //     ),
                            //     Padding(
                            //       padding: const EdgeInsets.all(5.0),
                            //       child: Text('Voice of Meghalaya',
                            //           // child: Text(ref.watch(leadershipDetailProvider).leaderDetailModel!.leaderDetails![0].name!.isNotEmpty ? ref.watch(leadershipDetailProvider).leaderDetailModel!.leaderDetails![0].name! : '',
                            //           style: TextStyle(
                            //             fontFamily: Strings.robotoMedium,
                            //             fontSize: 16.0,
                            //             color: const Color(0xff272727),
                            //           )),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Obx(() {
                                  final movie = downloadController.downloadingTask
                                      .firstWhereOrNull((element) =>
                                          element.movieId ==
                                          ref.read(leadershipDetailProvider)
                                              .leaderDetailModel!
                                              .leaderDetails!
                                              .first
                                              .id
                                              .toString());
                                  print(movie);
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
                                                downloadController.downloadingTask
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
                                                  .map((e) => Download.fromMap(e))
                                                  .toList();
                                              if (movies.isNotEmpty &&
                                                  movies.firstWhereOrNull((element) =>
                                                          element.movieId ==
                                                          ref
                                                              .read(
                                                                  leadershipDetailProvider)
                                                              .leaderDetailModel!
                                                              .leaderDetails!
                                                              .first
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
                                                                'Already Downloaded'.tr,
                                                            duration:
                                                                const Duration(
                                                                    seconds: 1));
                                                      }
                                                    }
                                                  : () async {

                                                // Kishor
                                                final movies = getMovies();
                                                if (movies.isEmpty) {
                                                  return;
                                                }
                                                final ConnectivityResult result =
                                                    await Connectivity().checkConnectivity();

                                                final pref = await SharedPreferences.getInstance();
                                                if (result == ConnectivityResult.mobile) {

                                                  final isWifiOnly = pref.getBool(PrefKeys.downloadMode);
                                                  if (isWifiOnly != null && isWifiOnly) {
                                                    handleApiError(
                                                        'Please turn on your Wifi'.tr, context);
                                                    Get.back();
                                                    return;
                                                  }
                                                }

                                                final videoQuality = pref.getString(PrefKeys.videoQuality);

                                                for (var movie in movies) {
                                                  if (movie.qty == videoQuality) {
                                                    downloadController.selectedQuality = movie;
                                                  }
                                                }
                                                print("Movie lenght ${getMovies().length}");

                                                if (downloadController.selectedQuality.qty == null) {
                                                  downloadController.selectedQuality = getMovies()[getMovies().length - 1];
                                                }

                                                // if(result.name)
                                                downloadController.downloadVideo(Download(
                                                    movieName:  ref
                                                        .read(
                                                        leadershipDetailProvider)
                                                        .leaderDetailModel!
                                                        .leaderDetails!
                                                        .first
                                                        .name!,
                                                    poster: ref
                                                        .read(
                                                        leadershipDetailProvider)
                                                        .leaderDetailModel!
                                                        .leaderDetails!
                                                        .first
                                                        .poster!,
                                                    movieUrl:
                                                    downloadController.selectedQuality.fileName ??
                                                        "",
                                                    qty: downloadController.selectedQuality.qty!,
                                                    movieId: ref
                                                        .read(
                                                        leadershipDetailProvider)
                                                        .leaderDetailModel!
                                                        .leaderDetails!
                                                        .first
                                                        .id!
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
                                                        fontFamily:
                                                            Strings.robotoMedium,
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
                                            .watch(leadershipDetailProvider)
                                            .leaderDetailModel!
                                            .leaderDetails![0]
                                            .isFavourite!
                                        ? GestureDetector(
                                            onTap: () {
                                              ref
                                                  .watch(leadershipDetailProvider)
                                                  .updateFavourite(
                                                      context: context,
                                                      videoId: ref
                                                          .watch(
                                                              leadershipDetailProvider)
                                                          .leaderDetailModel!
                                                          .leaderDetails![0]
                                                          .id
                                                          .toString(),
                                                      fav: '0');
                                              setState(() {
                                                ref
                                                    .watch(leadershipDetailProvider)
                                                    .leaderDetailModel!
                                                    .leaderDetails![0]
                                                    .isFavourite = false;
                                              });
                                            },
                                            child: const Icon(Icons.check,
                                                color: Colors.amber, size: 35),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              ref
                                                  .watch(leadershipDetailProvider)
                                                  .updateFavourite(
                                                      context: context,
                                                      videoId: ref
                                                          .watch(
                                                              leadershipDetailProvider)
                                                          .leaderDetailModel!
                                                          .leaderDetails![0]
                                                          .id
                                                          .toString(),
                                                      fav: '1');
                                              setState(() {
                                                ref
                                                    .watch(leadershipDetailProvider)
                                                    .leaderDetailModel!
                                                    .leaderDetails![0]
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
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 25, bottom: 5),
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            'More Videos',
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
                      child: ref.watch(leadershipDetailProvider).suggestleaderModel !=
                                  null &&
                              ref
                                  .watch(leadershipDetailProvider)
                                  .suggestleaderModel!
                                  .suggestlist!
                                  .isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: ref
                                  .watch(leadershipDetailProvider)
                                  .suggestleaderModel!
                                  .suggestlist!
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LeadershipDetailView(
                                              videoId: ref.watch(leadershipDetailProvider).suggestleaderModel!.suggestlist![index].id!.toString())),);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                        width: 120.0,
                                        child: CommonImage(
                                          imageUrl:
                                              '${AppUrls.baseUrl}${ref.watch(leadershipDetailProvider).suggestleaderModel!.suggestlist![index].poster}',
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
  String formatDuration(Duration? duration) {
    String hours = duration!.inHours.toString().padLeft(0, '2');
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }
}
