import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_keys.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/core/widgets/ab_button.dart';
import 'package:hellomegha/core/widgets/ab_button_grey.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/models/movie_detail_model.dart';
import 'package:hellomegha/screens/home/download_controller.dart';
import 'package:hellomegha/screens/home/movies_list_view.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstorage/localstorage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/video_player_next_previous_model.dart';
import 'model/download_model.dart';
import 'video_player_view.dart';

class MoviesDetailView extends ConsumerStatefulWidget {
  final String movieId;
  const MoviesDetailView({Key? key, required this.movieId}) : super(key: key);

  @override
  ConsumerState<MoviesDetailView> createState() => _MoviesDetailViewState();
}

class _MoviesDetailViewState extends ConsumerState<MoviesDetailView> {
  late BetterPlayerController? _betterPlayerController;
  ValueNotifier<bool> isVideoPlay = ValueNotifier(false);
  DownloadController downloadController = Get.find<DownloadController>();
  final LocalStorage storage = LocalStorage('movies');
  StreamController<VideoPlayerNextPreviousModel> controller =
      StreamController<VideoPlayerNextPreviousModel>();
  late Stream<VideoPlayerNextPreviousModel> stream;
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    stream = controller.stream.asBroadcastStream();
    downloadController.currentMovieId = widget.movieId;
    ref
        .read(movieDetailProvider)
        .moviesDetailsAPI(context: context, movieId: widget.movieId)
        .then((value) async {
      await Future.delayed(const Duration(seconds: 1));
      Map<String, String> urls = {};
      getMovies().forEach((element) {
        urls[element.qty!] = element.fileName!;
      }
      );
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
      _betterPlayerController!.setupDataSource(dataSource);
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // SystemChrome.setPreferredOrientations([
  //   //   DeviceOrientation.portraitDown,
  //   //   DeviceOrientation.portraitUp,
  //   // ]);
  // }
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
  // GlobalKey globalKey = GlobalKey();
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused ||
  //       state == AppLifecycleState.inactive) {
  //     _betterPlayerController!.enablePictureInPicture(globalKey);
  //   }
  // }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    // _betterPlayerController!.dispose();
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ref.watch(movieDetailProvider).movieDetails != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: SizedBox(
                          height: 230,
                          width: MediaQuery.of(context).size.width,
                          child: CommonImage(
                            imageUrl:
                                '${AppUrls.baseUrl}${ref.watch(movieDetailProvider).movieDetails!.movieDtails!.poster}',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 40),
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
                      )
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
                                    .watch(movieDetailProvider)
                                    .movieDetails!
                                    .movieDtails!
                                    .certificate!
                                    .isNotEmpty
                                ? ref
                                    .watch(movieDetailProvider)
                                    .movieDetails!
                                    .movieDtails!
                                    .certificate!
                                : 'Premium | U/A 7+',
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
                                        .watch(movieDetailProvider)
                                        .movieDetails!
                                        .movieDtails!
                                        .name!
                                        .isNotEmpty
                                    ? ref
                                        .watch(movieDetailProvider)
                                        .movieDetails!
                                        .movieDtails!
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
                                    .watch(movieDetailProvider)
                                    .movieDetails!
                                    .movieDtails!
                                    .language!
                                    .isNotEmpty
                                ? ref
                                    .watch(movieDetailProvider)
                                    .movieDetails!
                                    .movieDtails!
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
                                          .watch(movieDetailProvider)
                                          .movieDetails!
                                          .movieDtails!
                                          .description !=
                                      null
                                  ? ref
                                      .watch(movieDetailProvider)
                                      .movieDetails!
                                      .movieDtails!
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (ref
                                      .watch(movieDetailProvider)
                                      .movieDetails!
                                      .movieDtails!
                                      .movieVideos !=
                                  null)
                                Expanded(
                                  child: ABButtonGery(
                                    paddingTop: 10.0,
                                    paddingBottom: 15.0,
                                    paddingLeft: 1.0,
                                    paddingRight: 15.0,
                                    text: 'Play Trailer'.tr,
                                    onPressed: () {
                                      playVideo(QtyType.TRAILER);
                                    },
                                  ),
                                ),
                              Expanded(
                                child: ABButton(
                                  paddingTop: 10.0,
                                  paddingBottom: 15.0,
                                  paddingLeft: 10.0,
                                  paddingRight: 1.0,
                                  text: 'Start Watching'.tr,
                                  onPressed: () {
                                    playVideo(QtyType.MOVIE);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Obx(() {
                                final movie = downloadController.downloadingTask
                                    .firstWhereOrNull((element) =>
                                        element.movieId == widget.movieId);
                                print('new movie data');
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
                                                movies.firstWhereOrNull(
                                                        (element) =>
                                                            element.movieId ==
                                                            widget.movieId) !=
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
                                                                  seconds: 1));
                                                    }
                                                  }
                                                : () async {
                                                    // Kishor
                                                    final movies = getMovies();
                                                    if (movies.isEmpty) {
                                                      return;
                                                    }

                                                    // showDialog(
                                                    //     context: context,
                                                    //     builder: (context) =>
                                                    //         Dialog(
                                                    //           child: DownloadView(
                                                    //             qualities: getMovies(),
                                                    //             movieName: ref
                                                    //                       .read(
                                                    //                       movieDetailProvider)
                                                    //                       .movieDetails!
                                                    //                       .movieDtails!
                                                    //                       .name!,
                                                    //             poster: ref
                                                    //                       .read(
                                                    //                       movieDetailProvider)
                                                    //                       .movieDetails!
                                                    //                       .movieDtails!
                                                    //                       .poster!,
                                                    //             movieId: ref
                                                    //                     .read(
                                                    //                     movieDetailProvider)
                                                    //                     .movieDetails!
                                                    //                     .movieDtails!.id
                                                    //                 .toString(),
                                                    //           ),
                                                    //         )).then((value) {
                                                    //           print("hello$value");
                                                    //   setState(() {});
                                                    // });

                                                    final pref =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          Dialog(
                                                        child: StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                            return IntrinsicHeight(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Column(
                                                                  children: [
                                                                    ListTile(
                                                                        title:
                                                                            Text(
                                                                      "Select Download Video Quality"
                                                                          .tr,
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )),
                                                                    Expanded(
                                                                      child: RadioListTile(
                                                                          value: Strings.videoQuality360,
                                                                          title: Text("${Strings.videoQuality360} px"),
                                                                          groupValue: pref.getString(PrefKeys.videoQuality) ?? Strings.videoQuality720,
                                                                          onChanged: (value) async {
                                                                            await pref.setString(PrefKeys.videoQuality,
                                                                                Strings.videoQuality360);
                                                                            // Navigator.pop(context);
                                                                            setState(() {});
                                                                          }),
                                                                    ),
                                                                    Expanded(
                                                                      child: RadioListTile(
                                                                          value: Strings.videoQuality480,
                                                                          title: Text("${Strings.videoQuality480} px"),
                                                                          groupValue: pref.getString(PrefKeys.videoQuality) ?? Strings.videoQuality720,
                                                                          onChanged: (value) async {
                                                                            pref.setString(PrefKeys.videoQuality,
                                                                                Strings.videoQuality480);
                                                                            // Navigator.pop(context);
                                                                            setState(() {});
                                                                          }),
                                                                    ),
                                                                    Expanded(
                                                                      child: RadioListTile(
                                                                          value: Strings.videoQuality720,
                                                                          title: Text("${Strings.videoQuality720} px"),
                                                                          groupValue: pref.getString(PrefKeys.videoQuality) ?? Strings.videoQuality720,
                                                                          onChanged: (value) async {
                                                                            pref.setString(PrefKeys.videoQuality,
                                                                                Strings.videoQuality720);
                                                                            // Navigator.pop(context);
                                                                            setState(() {});
                                                                          }),
                                                                    ),
                                                                    Expanded(
                                                                      child: RadioListTile(
                                                                          value: Strings.videoQuality1080,
                                                                          title: Text("${Strings.videoQuality1080} px"),
                                                                          groupValue: pref.getString(PrefKeys.videoQuality) ?? Strings.videoQuality720,
                                                                          onChanged: (value) async {
                                                                            pref.setString(PrefKeys.videoQuality,
                                                                                Strings.videoQuality1080);
                                                                            // Navigator.pop(context);
                                                                            setState(() {});
                                                                          }),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Get.back();
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'Cancel'.tr,
                                                                            )),
                                                                        const SizedBox(
                                                                          width:
                                                                              25,
                                                                        ),
                                                                        TextButton(
                                                                            onPressed:
                                                                                () async {
                                                                              final ConnectivityResult result = await Connectivity().checkConnectivity();

                                                                              if (result == ConnectivityResult.mobile) {
                                                                                final pref = await SharedPreferences.getInstance();
                                                                                final isWifiOnly = pref.getBool(PrefKeys.downloadMode);
                                                                                if (isWifiOnly != null && isWifiOnly) {
                                                                                  handleApiError('Please turn on your Wifi'.tr, context);
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
                                                                              downloadController.downloadVideo(Download(movieName: ref.read(movieDetailProvider).movieDetails!.movieDtails!.name!, poster: ref.read(movieDetailProvider).movieDetails!.movieDtails!.poster!, movieUrl: downloadController.selectedQuality.fileName ?? "", qty: downloadController.selectedQuality.qty!, movieId: ref.read(movieDetailProvider).movieDetails!.movieDtails!.id.toString()));
                                                                              Navigator.pop(context);
                                                                              setState(() {});
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'Download'.tr,
                                                                            ))
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
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
                                          .read(movieDetailProvider)
                                          .movieDetails!
                                          .isFavourite!
                                      ? GestureDetector(
                                          onTap: () {
                                            ref
                                                .watch(movieDetailProvider)
                                                .updateFavourite(
                                                    context: context,
                                                    videoId: ref
                                                        .read(
                                                            movieDetailProvider)
                                                        .movieDetails!
                                                        .movieDtails!
                                                        .id
                                                        .toString(),
                                                    fav: '0');
                                            setState(() {
                                              ref
                                                  .read(movieDetailProvider)
                                                  .movieDetails!
                                                  .isFavourite = false;
                                            });
                                          },
                                          child: const Icon(Icons.check,
                                              color: Colors.amber, size: 35),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            ref
                                                .watch(movieDetailProvider)
                                                .updateFavourite(
                                                    context: context,
                                                    videoId: ref
                                                        .read(
                                                            movieDetailProvider)
                                                        .movieDetails!
                                                        .movieDtails!
                                                        .id
                                                        .toString(),
                                                    fav: '1');
                                            setState(() {
                                              ref
                                                  .read(movieDetailProvider)
                                                  .movieDetails!
                                                  .isFavourite = true;
                                            });
                                          },
                                          child: const Icon(Icons.add,
                                              color: Colors.amber, size: 35),
                                        ),
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

                  ref.watch(movieDetailProvider).movieDetails != null &&
                          ref
                              .watch(movieDetailProvider)
                              .movieDetails!
                              .actors!
                              .isNotEmpty
                      ? SizedBox(
                          height: 220,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: ref
                                  .watch(movieDetailProvider)
                                  .movieDetails!
                                  .actors!
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: SizedBox(
                                          height: 170,
                                          width: 120,
                                          child: CommonImage(
                                            imageUrl: ref
                                                    .watch(movieDetailProvider)
                                                    .movieDetails!
                                                    .actors![index]
                                                    .photo!
                                                    .isNotEmpty
                                                ? '${AppUrls.baseUrl}${ref.watch(movieDetailProvider).movieDetails!.actors![index].photo.toString()}'
                                                : '',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ref
                                              .watch(movieDetailProvider)
                                              .movieDetails!
                                              .actors![index]
                                              .title!
                                              .isNotEmpty
                                          ? ref
                                              .watch(movieDetailProvider)
                                              .movieDetails!
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

                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text('Directer & Writers'.tr,
                        style: TextStyle(
                          fontFamily: Strings.robotoMedium,
                          fontSize: 16.0,
                          color: const Color(0xff272727),
                        )),
                  ),

                  ref.watch(movieDetailProvider).movieDetails != null &&
                          ref
                              .watch(movieDetailProvider)
                              .movieDetails!
                              .directors!
                              .isNotEmpty
                      ? SizedBox(
                          height: 220,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: ref
                                  .watch(movieDetailProvider)
                                  .movieDetails!
                                  .directors!
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: SizedBox(
                                          height: 170,
                                          width: 120,
                                          child: CommonImage(
                                            imageUrl: ref
                                                    .watch(movieDetailProvider)
                                                    .movieDetails!
                                                    .directors![index]
                                                    .photo!
                                                    .isNotEmpty
                                                ? '${AppUrls.baseUrl}${ref.watch(movieDetailProvider).movieDetails!.directors![index].photo.toString()}'
                                                : '',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ref
                                              .watch(movieDetailProvider)
                                              .movieDetails!
                                              .directors![index]
                                              .title!
                                              .isNotEmpty
                                          ? ref
                                              .watch(movieDetailProvider)
                                              .movieDetails!
                                              .directors![index]
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
                  //         color: const Color(0xff272727),
                  //       )),
                  // ),

                  // ref.watch(movieDetailProvider).movieDetails != null &&
                  //         ref
                  //             .watch(movieDetailProvider)
                  //             .movieDetails!
                  //             .writters!
                  //             .isNotEmpty
                  //     ? SizedBox(
                  //         height: 220,
                  //         child: ListView.builder(
                  //             scrollDirection: Axis.horizontal,
                  //             itemCount: ref
                  //                 .watch(movieDetailProvider)
                  //                 .movieDetails!
                  //                 .writters!
                  //                 .length,
                  //             itemBuilder: (BuildContext context, int index) {
                  //               return Column(
                  //                 children: [
                  //                   Padding(
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: ClipRRect(
                  //                       borderRadius: BorderRadius.circular(5),
                  //                       child: SizedBox(
                  //                         height: 170,
                  //                         width: 120,
                  //                         child: Image.network(
                  //                             ref
                  //                                     .watch(
                  //                                         movieDetailProvider)
                  //                                     .movieDetails!
                  //                                     .writters![index]
                  //                                     .photo!
                  //                                     .isNotEmpty
                  //                                 ? 'https://jayamsolutions.signertech.in/${ref.watch(movieDetailProvider).movieDetails!.writters![index].photo.toString()}'
                  //                                 : '',
                  //                             fit: BoxFit.cover),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   Text(
                  //                     ref
                  //                             .watch(movieDetailProvider)
                  //                             .movieDetails!
                  //                             .writters![index]
                  //                             .title!
                  //                             .isNotEmpty
                  //                         ? ref
                  //                             .watch(movieDetailProvider)
                  //                             .movieDetails!
                  //                             .writters![index]
                  //                             .title
                  //                             .toString()
                  //                         : '',
                  //                     style: TextStyle(
                  //                         fontFamily: Strings.robotoMedium,
                  //                         fontWeight: FontWeight.w500,
                  //                         fontSize: 14.0,
                  //                         color: Colors.black),
                  //                   )
                  //                 ],
                  //               );
                  //             }),
                  //       )
                  //     : const SizedBox(),

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
                          'See More'.tr,
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
                    child: ref.watch(movieDetailProvider).suggestMovieModel !=
                                null &&
                            ref
                                .watch(movieDetailProvider)
                                .suggestMovieModel!
                                .suggestlist!
                                .isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: ref
                                .watch(movieDetailProvider)
                                .suggestMovieModel!
                                .suggestlist!
                                .length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MoviesDetailView(
                                            movieId: ref
                                                .watch(movieDetailProvider)
                                                .suggestMovieModel!
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
                                            '${AppUrls.baseUrl}${ref.watch(movieDetailProvider).suggestMovieModel!.suggestlist![index].poster}',
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
    );
  }

  void playVideo(QtyType videoType) async {
    final pref = await SharedPreferences.getInstance();
    final videoPlaybackMode = pref.getString(PrefKeys.videoPlayback);
    if (videoPlaybackMode != null &&
        videoPlaybackMode != Strings.wifiAndMobileDataBoth) {
      final result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.wifi &&
          videoPlaybackMode != Strings.wifiOnly) {
        handleApiError('Please turn on your Mobile Data'.tr, context);
        return;
      }
      if (result == ConnectivityResult.mobile &&
          videoPlaybackMode != Strings.mobileData) {
        handleApiError('Please turn on your Wifi'.tr, context);
        return;
      }
    }
    final videos = ref
        .watch(movieDetailProvider)
        .movieDetails!
        .movieDtails!
        .movieVideos!
        .where(((element) => element.type == videoType))
        .toList();
    videos.sort((a, b) => int.parse(a.qty!).compareTo(int.parse(b.qty!)));
    Map<String, String> urls = {};
    for (var element in videos) {
      urls[element.qty!] = element.fileName!;
    }

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VideoPlayerView(
                movieName: ref
                    .read(movieDetailProvider)
                    .movieDetails!
                    .movieDtails!
                    .name!,
                urls: urls,
                isFromMoive: true,
                previousId: ref
                    .read(movieDetailProvider)
                    .movieDetails!
                    .preciousrecordId,
                nextId:
                    ref.read(movieDetailProvider).movieDetails!.nextrecordId,
                onNext: () async {
                  await ref.read(movieDetailProvider).moviesDetailsAPI(
                        context: context,
                        isLoading: false,
                        videoType: videoType,
                        movieId: ref
                            .read(movieDetailProvider)
                            .movieDetails!
                            .nextrecordId
                            .toString(),
                        onSuccess: ((moviedetail) =>
                            controller.add(moviedetail)),
                      );
                  setState(() {});
                },
                onPrevious: () async {
                  await ref.read(movieDetailProvider).moviesDetailsAPI(
                        context: context,
                        isLoading: false,
                        videoType: videoType,
                        movieId: ref
                            .read(movieDetailProvider)
                            .movieDetails!
                            .preciousrecordId
                            .toString(),
                        onSuccess: ((moviedetail) =>
                            controller.add(moviedetail)),
                      );
                  setState(() {});
                },
                stream: stream,
                isMovie: videoType == QtyType.MOVIE,
                isFromNetwork: true,
                movieId: ref
                    .read(movieDetailProvider)
                    .movieDetails!
                    .movieDtails!
                    .id
                    .toString(),
                seekTo: Duration(
                  seconds: int.parse(videoType == QtyType.MOVIE
                      ? ref
                          .read(movieDetailProvider)
                          .movieDetails!
                          .movieDuration!
                      : ref
                          .read(movieDetailProvider)
                          .movieDetails!
                          .trailerDuration!),
                ),
                onVideoDuration: (duration) {
                  videoType == QtyType.MOVIE
                      ? ref
                          .watch(movieDetailProvider)
                          .movieDetails!
                          .movieDuration = duration.toString()
                      : ref
                          .watch(movieDetailProvider)
                          .movieDetails!
                          .trailerDuration = duration.toString();
                },
                sid: ref
                    .read(movieDetailProvider)
                    .movieDetails!
                    .movieDtails!
                    .studio,
              )),
    );
  }

  List<MovieVideo> getMovies() {
    if (ref.watch(movieDetailProvider).movieDetails!.movieDtails!.movieVideos !=
            null ||
        ref
            .watch(movieDetailProvider)
            .movieDetails!
            .movieDtails!
            .movieVideos!
            .isNotEmpty) {
      final movies = ref
          .watch(movieDetailProvider)
          .movieDetails!
          .movieDtails!
          .movieVideos!
          .where(((element) => element.type == QtyType.MOVIE))
          .toList();

      movies.sort((a, b) => int.parse(a.qty!).compareTo(int.parse(b.qty!)));
      return movies;
    } else {
      return [];
    }
  }
}
