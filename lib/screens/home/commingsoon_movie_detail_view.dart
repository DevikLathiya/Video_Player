import 'package:better_player/better_player.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_keys.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/core/widgets/ab_button.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/models/movie_detail_model.dart';
import 'package:hellomegha/screens/home/download_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'video_player_view.dart';
import 'package:hellomegha/screens/no_network.dart';
class CommingSoonMoviesDetailView extends ConsumerStatefulWidget {
  final String movieId;
  final int? remider, index;

  const CommingSoonMoviesDetailView(
      {Key? key,
      required this.movieId,
      required this.remider,
      required this.index})
      : super(key: key);

  @override
  ConsumerState<CommingSoonMoviesDetailView> createState() =>
      _CommingSoonMoviesDetailViewState();
}

class _CommingSoonMoviesDetailViewState
    extends ConsumerState<CommingSoonMoviesDetailView>
    with WidgetsBindingObserver {
  late BetterPlayerController _betterPlayerController;
  ValueNotifier<bool> isVideoPlay = ValueNotifier(false);
  DownloadController downloadController = Get.find<DownloadController>();
  final LocalStorage storage = LocalStorage('movies');

  List<String> cast = [
    "https://pyxis.nymag.com/v1/imgs/a34/e26/dc6b70f9211376a9783b91dd693e1cca9f-brie-larson-captain-marvel.rsquare.w330.jpg",
    "https://m.media-amazon.com/images/M/MV5BMDAxNGE2ODMtNTI0ZC00ZmJhLTg0OTctODdkZTQ1ZWI3NTVkXkEyXkFqcGdeQXVyMTE3ODY2Nzk@._V1_.jpg",
    "https://m.media-amazon.com/images/M/MV5BMmY2OGM1NjEtNGRiZi00NGY5LThjMzMtOTViYTMwOGM2YmE0XkEyXkFqcGdeQXVyNzY1ODU1OTk@._V1_.jpg",
    "https://image.tmdb.org/t/p/w500/uqaJuR24yXL1oXvAqUbOoEGChgb.jpg",
    "https://m.media-amazon.com/images/M/MV5BMTMwOTg5NTQ3NV5BMl5BanBnXkFtZTcwNzM3MDAzNQ@@._V1_.jpg",
    "https://a10.gaanacdn.com/gn_img/albums/10q3ZR1352/q3ZRrjZo35/size_m.jpg",
  ];

  List<String> watchMovie = [
    "https://wallup.net/wp-content/uploads/2019/07/24/748894-spider-man-superhero-marvel-spider-man-action-spiderman-poster-748x997.jpg",
    "https://wallpapersmug.com/download/1600x900/b41742/thanos-and-the-black-order.jpg",
    "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/dramatic-movie-poster-template-design-f0f2c261e077379d0f82604f96b6a774_screen.jpg?ts=1602570456",
    "https://www.joblo.com/wp-content/uploads/2012/04/oblivion-Imax-poster-4-9-1.jpg",
    "https://upload.wikimedia.org/wikipedia/en/1/19/Iron_Man_3_poster.jpg",
    "https://www.asparkleofgenius.com/wp-content/uploads/2017/03/image003.jpg",
  ];

  @override
  void initState() {
    super.initState();
    downloadController.currentMovieId = widget.movieId;
    ref
        .read(movieDetailProvider)
        .moviesDetailsAPI(context: context, movieId: widget.movieId)
        .then((value) async {
      await Future.delayed(const Duration(seconds: 1));
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
      _betterPlayerController.setupDataSource(dataSource);
    });
  }

  // @override
  // void didChangeDependencies() {
  //   ref.watch(commingSoonProvider).commingSoonAPI(context: context);
  //   super.didChangeDependencies();
  // }

  @override
  void didChangeDependencies() {
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }
      else
      {
        ref.watch(commingSoonProvider).commingSoonAPI(context: context);
      }
    });

    super.didChangeDependencies();
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
                          ListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 0.0, right: 0.0),
                            trailing: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                    onTap: () {
                                      ref
                                          .watch(commingSoonProvider)
                                          .setReminderMovie(
                                            context: context,
                                            movieID: widget.movieId,
                                            reminder: ref
                                                        .watch(
                                                            commingSoonProvider)
                                                        .commingSoonMovieListModel
                                                        ?.data
                                                        ?.movielist?[
                                                            widget.index!]
                                                        ?.isReminder ==
                                                    0
                                                ? 1
                                                : 0,
                                          );
                                      if (ref
                                              .watch(commingSoonProvider)
                                              .commingSoonMovieListModel
                                              ?.data
                                              ?.movielist?[widget.index!]
                                              ?.isReminder ==
                                          0) {
                                        ref
                                            .watch(commingSoonProvider)
                                            .commingSoonMovieListModel
                                            ?.data
                                            ?.movielist?[widget.index!]
                                            ?.isReminder = 1;
                                      } else {
                                        ref
                                            .watch(commingSoonProvider)
                                            .commingSoonMovieListModel
                                            ?.data
                                            ?.movielist?[widget.index!]
                                            ?.isReminder = 0;
                                      }
                                      setState(() {});
                                    },
                                    child: ref
                                                .watch(commingSoonProvider)
                                                .commingSoonMovieListModel
                                                ?.data
                                                ?.movielist?[widget.index!]
                                                ?.isReminder ==
                                            1
                                        ? const Icon(
                                            Icons.check,
                                            size: 28,
                                            color: Colors.amber,
                                          )
                                        : const Icon(Icons.notifications,
                                            size: 28, color: Colors.amber)),
                                Text(
                                  widget.remider == 1
                                      ? Strings.reminded.tr
                                      : Strings.remindMe.tr,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            title: Padding(
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
                                color: const Color(0xff272727).withOpacity(0.7),
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
                                // Expanded(
                                //   child: ABButtonGery(
                                //     paddingTop: 10.0,
                                //     paddingBottom: 15.0,
                                //     paddingLeft: 1.0,
                                //     paddingRight: 15.0,
                                //     text: 'Play Trailer'.tr,
                                //     onPressed: () {
                                //       playVideo(QtyType.TRAILER);
                                //     },
                                //   ),
                                // ),
                                Expanded(
                                  child: ABButton(
                                    paddingTop: 10.0,
                                    paddingBottom: 15.0,
                                    paddingLeft: 0.0,
                                    paddingRight: 1.0,
                                    text: 'Play Trailer'.tr,
                                    onPressed: () {
                                      playVideo(QtyType.MOVIE);
                                    },
                                  ),
                                ),
                            ],
                          ),
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
                  //   padding: const EdgeInsets.only(
                  //       left: 10.0, right: 10.0, top: 25, bottom: 5),
                  //   child: Row(children: [
                  //     Expanded(
                  //       child: Text(
                  //         'Similar movies'.tr,
                  //         style: TextStyle(
                  //             fontFamily: Strings.robotoMedium,
                  //             fontWeight: FontWeight.w600,
                  //             fontSize: 16.0,
                  //             color: Colors.black),
                  //       ),
                  //     ),
                  //     GestureDetector(
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => const MoviesListView()),
                  //         );
                  //       },
                  //       child: Text(
                  //         'See More'.tr,
                  //         style: TextStyle(
                  //             fontFamily: Strings.robotoMedium,
                  //             fontWeight: FontWeight.w600,
                  //             fontSize: 14.0,
                  //             color: const Color(0xFFFECC00)),
                  //       ),
                  //     ),
                  //   ]),
                  // ),
                  // SizedBox(
                  //   height: 200,
                  //   child: ref.watch(movieDetailProvider).suggestMovieModel !=
                  //       null &&
                  //       ref
                  //           .watch(movieDetailProvider)
                  //           .suggestMovieModel!
                  //           .suggestlist!
                  //           .isNotEmpty
                  //       ? ListView.builder(
                  //       scrollDirection: Axis.horizontal,
                  //       itemCount: ref
                  //           .watch(movieDetailProvider)
                  //           .suggestMovieModel!
                  //           .suggestlist!
                  //           .length,
                  //       itemBuilder: (BuildContext context, int index) {
                  //         return GestureDetector(
                  //           onTap: () {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => MoviesDetailView(
                  //                       movieId: ref
                  //                           .watch(movieDetailProvider)
                  //                           .suggestMovieModel!
                  //                           .suggestlist![index]
                  //                           .id!
                  //                           .toString())),
                  //             );
                  //           },
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(10.0),
                  //             child: ClipRRect(
                  //               borderRadius: BorderRadius.circular(10),
                  //               child: SizedBox(
                  //                 width: 120.0,
                  //                 child: CommonImage(
                  //                   imageUrl:
                  //                   '${AppUrls.baseUrl}${ref.watch(movieDetailProvider).suggestMovieModel!.suggestlist![index].poster}',
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         );
                  //       })
                  //       : const SizedBox(),
                  // ),
                  // const SizedBox(height: 25)
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
