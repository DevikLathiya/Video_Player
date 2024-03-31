import 'dart:math';

import 'package:better_player/better_player.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/Leadership/Leadership_list_view.dart';
import 'package:hellomegha/Schemes/schemes_list_view.dart';
import 'package:hellomegha/Shortfilms/shortfilms_list_view.dart';
import 'package:hellomegha/TodaysPicup/top_picked_list_view.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_keys.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/theme_config.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/models/movie_detail_model.dart';
import 'package:hellomegha/quiz/winners_view.dart';
import 'package:hellomegha/screens/home/bottom_navigation_view.dart';
import 'package:hellomegha/screens/home/hot_videos_list_view.dart';
import 'package:hellomegha/screens/home/influncer_detail_view.dart';
import 'package:hellomegha/screens/home/leadership_detail_view.dart';
import 'package:hellomegha/screens/home/movie_detail_view.dart';
import 'package:hellomegha/screens/home/musiv_video_detail_view.dart';
import 'package:hellomegha/screens/home/scheme_detail_view.dart';
import 'package:hellomegha/screens/home/stories_detail_view.dart';
import 'package:hellomegha/screens/home/stories_list_view.dart';
import 'package:hellomegha/screens/home/streaming_list_view.dart';
import 'package:hellomegha/screens/home/video_player_view.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:hellomegha/screens/recomaded_music_video.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AllView extends ConsumerStatefulWidget {
  const AllView({Key? key}) : super(key: key);

  @override
  ConsumerState<AllView> createState() => _AllViewState();
}

class _AllViewState extends ConsumerState<AllView> {
  late PageController _pageController;
  late BetterPlayerController _betterPlayerController;
  List<String> watchMovie = [
    "https://wallup.net/wp-content/uploads/2019/07/24/748894-spider-man-superhero-marvel-spider-man-action-spiderman-poster-748x997.jpg",
    "https://wallpapersmug.com/download/1600x900/b41742/thanos-and-the-black-order.jpg",
    "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/dramatic-movie-poster-template-design-f0f2c261e077379d0f82604f96b6a774_screen.jpg?ts=1602570456",
    "https://www.joblo.com/wp-content/uploads/2012/04/oblivion-Imax-poster-4-9-1.jpg",
    "https://upload.wikimedia.org/wikipedia/en/1/19/Iron_Man_3_poster.jpg",
    "https://www.asparkleofgenius.com/wp-content/uploads/2017/03/image003.jpg",
  ];

  int activePage = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Connectivity().checkConnectivity().then((value) {
        if (value == ConnectivityResult.none) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
        } else {
          ref.read(homeAllProvider).homeAPI(context: context);
          ref.read(homeAllProvider).continueWatchingAPI(context: context);
          ref.read(liveStreamProvider).liveListAPI(context: context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            ref.watch(homeAllProvider).homeAllModel != null &&
                ref.watch(homeAllProvider).homeAllModel!.sliders!.isNotEmpty
                ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: PageView.builder(
                    itemCount: ref
                        .watch(homeAllProvider)
                        .homeAllModel!
                        .sliders!
                        .length,
                    pageSnapping: true,
                    onPageChanged: (page) {
                      setState(() {
                        activePage = page;
                      });
                    },
                    itemBuilder: (context, pagePosition) {
                      return GestureDetector(
                          onTap: () {
                            if (ref
                                .watch(homeAllProvider)
                                .homeAllModel!
                                .sliders![pagePosition]
                                .type ==
                                'Schemes') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SchemeDetailView(
                                        videoId: ref
                                            .watch(homeAllProvider)
                                            .homeAllModel!
                                            .sliders![pagePosition]
                                            .id!
                                            .toString())),
                              );
                            } else if (ref
                                .watch(homeAllProvider)
                                .homeAllModel!
                                .sliders![pagePosition]
                                .type ==
                                'Music Video') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MusicVideoDetailView(
                                            movieId: ref
                                                .watch(homeAllProvider)
                                                .homeAllModel!
                                                .sliders![pagePosition]
                                                .id!
                                                .toString())),
                              );
                            } else if (ref
                                .watch(homeAllProvider)
                                .homeAllModel!
                                .sliders![pagePosition]
                                .type ==
                                'Stories') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StoriesDetailView(
                                        storyId: ref
                                            .watch(homeAllProvider)
                                            .homeAllModel!
                                            .sliders![pagePosition]
                                            .id!
                                            .toString())),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MoviesDetailView(
                                        movieId: ref
                                            .watch(homeAllProvider)
                                            .homeAllModel!
                                            .sliders![pagePosition]
                                            .id
                                            .toString())),
                              );
                            }
                          },
                          child: CommonImage(
                            imageUrl:
                            '${AppUrls.baseUrl}${ref.watch(homeAllProvider).homeAllModel!.sliders![pagePosition].sliderImage.toString()}',
                          )
                        // child: Image.network(
                        //     '${AppUrls.baseUrl}${ref.watch(homeAllProvider).homeAllModel!.sliders![pagePosition].sliderImage.toString()}',
                        //     fit: BoxFit.cover)
                      );
                    }))
                : const SizedBox(),
            const SizedBox(height: 4),
            ref.watch(homeAllProvider).homeAllModel != null &&
                ref.watch(homeAllProvider).homeAllModel!.sliders!.isNotEmpty
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: indicators(
                  ref
                      .watch(homeAllProvider)
                      .homeAllModel!
                      .sliders!
                      .isNotEmpty
                      ? ref
                      .watch(homeAllProvider)
                      .homeAllModel!
                      .sliders!
                      .length
                      : 0,
                  activePage),
            )
                : const SizedBox(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 25, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    '',
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
                          builder: (context) => const StoriesListView()),
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
            Container(
              height: 208,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xFFF3FFB4),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 65.0, left: 23),
                    child: RotatedBox(
                        quarterTurns: -1,
                        child: Text(
                          'Stories'.tr,
                          style: TextStyle(
                              fontFamily: Strings.robotoMedium,
                              fontWeight: FontWeight.w600,
                              fontSize: 25.0,
                              letterSpacing: 1.4,
                              color: Colors.black),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 70.0),
                    child: SizedBox(
                      height: 208,
                      child: ref.watch(homeAllProvider).homeAllModel != null &&
                          ref
                              .watch(homeAllProvider)
                              .homeAllModel!
                              .stories!
                              .isNotEmpty
                          ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ref
                              .watch(homeAllProvider)
                              .homeAllModel!
                              .stories!
                              .length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StoriesDetailView(
                                                  storyId: ref
                                                      .watch(homeAllProvider)
                                                      .homeAllModel!
                                                      .stories![index]
                                                      .id
                                                      .toString())),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                        width: 120.0,
                                        child: CommonImage(
                                            imageUrl: "${AppUrls.baseUrl}${ref
                                                .watch(homeAllProvider)
                                                .homeAllModel!
                                                .stories![index]
                                                .poster
                                                .toString()}")
                                      // child: Image.network(
                                      //     ref
                                      //         .watch(homeAllProvider)
                                      //         .homeAllModel!
                                      //         .stories![index]
                                      //         .poster
                                      //         .toString(),
                                      //     fit: Bo
                                      //                                     ),xFit.cover),
                                    ),
                                  ),
                                ));
                          })
                          : const SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
            if (ref.watch(homeAllProvider).watchMovieList != null &&
                ref
                    .watch(homeAllProvider)
                    .watchMovieList!
                    .movielist!
                    .isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 25, bottom: 5),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      'Continue Watching'.tr,
                      style: TextStyle(
                          fontFamily: Strings.robotoMedium,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: Colors.black),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
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

            if (ref.watch(homeAllProvider).watchMovieList != null &&
                ref
                    .watch(homeAllProvider)
                    .watchMovieList!
                    .movielist!
                    .isNotEmpty)
              SizedBox(
                  height: 210,
                  child: ref.watch(homeAllProvider).watchMovieList != null &&
                      ref
                          .watch(homeAllProvider)
                          .watchMovieList!
                          .movielist!
                          .isNotEmpty
                      ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ref
                          .watch(homeAllProvider)
                          .watchMovieList!
                          .movielist!
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        final filledValue = ref
                            .watch(homeAllProvider)
                            .watchMovieList!
                            .movielist![index]
                            .totalVideoSecond ==
                            null
                            ? 0
                            : (int.parse(ref
                            .watch(homeAllProvider)
                            .watchMovieList!
                            .movielist![index]
                            .videoSecond!) /
                            (int.parse(ref
                                .watch(homeAllProvider)
                                .watchMovieList!
                                .movielist![index]
                                .totalVideoSecond ??
                                "0")));
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () {
                              Map<String, String> urls = {};
                              ref
                                  .read(movieDetailProvider)
                                  .moviesDetailsAPI(
                                  context: context,
                                  movieId: ref
                                      .watch(homeAllProvider)
                                      .watchMovieList!
                                      .movielist![index]
                                      .id
                                      .toString())
                                  .then((value) async {
                                await Future.delayed(
                                    const Duration(seconds: 1));

                                getMovies().forEach((element) {
                                  urls[element.qty!] = element.fileName!;
                                });
                                BetterPlayerDataSource dataSource;
                                BetterPlayerConfiguration
                                betterPlayerConfiguration =
                                const BetterPlayerConfiguration(
                                    fit: BoxFit.contain,
                                    autoPlay: false,
                                    aspectRatio: 1.2,
                                    autoDetectFullscreenAspectRatio:
                                    true,
                                    controlsConfiguration:
                                    BetterPlayerControlsConfiguration(
                                        enablePlayPause: false,
                                        progressBarBufferedColor:
                                        Colors.white70,
                                        progressBarHandleColor:
                                        Colors.yellow,
                                        progressBarPlayedColor:
                                        Colors.yellow,
                                        progressBarBackgroundColor:
                                        Colors.white54,
                                        forwardSkipTimeInMilliseconds:
                                        15000,
                                        enableMute: false,
                                        backwardSkipTimeInMilliseconds:
                                        15000));
                                dataSource = BetterPlayerDataSource(
                                    BetterPlayerDataSourceType.network,
                                    urls.entries.first.value,
                                    resolutions: urls);

                                _betterPlayerController =
                                    BetterPlayerController(
                                        betterPlayerConfiguration);
                                _betterPlayerController
                                    .setupDataSource(dataSource);
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
                                        isMovie: true,
                                        isFromNetwork: true,
                                        movieId: ref
                                            .read(movieDetailProvider)
                                            .movieDetails!
                                            .movieDtails!
                                            .id
                                            .toString(),
                                        seekTo: Duration(
                                          seconds: int.parse(ref
                                              .read(movieDetailProvider)
                                              .movieDetails!
                                              .movieDuration!),
                                        ),
                                        onVideoDuration: (duration) {
                                          ref
                                              .watch(
                                              movieDetailProvider)
                                              .movieDetails!
                                              .movieDuration =
                                              duration.toString();
                                        },
                                        sid: ref
                                            .read(movieDetailProvider)
                                            .movieDetails!
                                            .movieDtails!
                                            .studio,
                                      )),
                                );
                              });

                              // final videos = ref
                              //     .watch(movieDetailProvider)
                              //     .movieDetails!
                              //     .movieDtails!
                              //     .movieVideos!
                              //       .where(((element) => element.type == QtyType.MOVIE))
                              //       .toList();
                              //   videos.sort((a, b) => int.parse(a.qty!).compareTo(int.parse(b.qty!)));
                              //   Map<String, String> urls = {};
                              //   for (var element in videos) {
                              //     urls[element.qty!] = element.fileName!;
                              //   }

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => MoviesDetailView(
                              //           movieId: ref
                              //               .watch(homeAllProvider)
                              //               .watchMovieList!
                              //               .movielist![index]
                              //               .id
                              //               .toString())),
                              // );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 120.0,
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        CommonImage(
                                          imageUrl: ref
                                              .watch(homeAllProvider)
                                              .watchMovieList!
                                              .movielist![index]
                                              .thumbnail!,
                                          height: 180,
                                        ),
                                        Positioned(
                                          bottom: 20,
                                          right: 8,
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(25),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: const Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    LinearProgressIndicator(
                                      backgroundColor: Colors.black38,
                                      valueColor:
                                      const AlwaysStoppedAnimation<
                                          Color>(Colors.amber),
                                      value: filledValue.toDouble(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                      : const SizedBox()),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 10.0, right: 10.0, top: 25, bottom: 5),
            //   child: Row(children: [
            //     Expanded(
            //       child: Text(
            //         'Music Album',
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
            //               builder: (context) => const MusicListView()),
            //         );
            //       },
            //       child: Text(
            //         'See More',
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
            //   height: 150,
            //   child: ref.watch(homeAllProvider).homeAllModel != null &&
            //           ref.watch(homeAllProvider).homeAllModel!.album!.isNotEmpty
            //       ? ListView.builder(
            //           scrollDirection: Axis.horizontal,
            //           itemCount: ref
            //               .watch(homeAllProvider)
            //               .homeAllModel!
            //               .album!
            //               .length,
            //           itemBuilder: (BuildContext context, int index) {
            //             return GestureDetector(
            //               onTap: () {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (context) => MusicPlayerActivity(
            //                             id: ref
            //                                 .watch(homeAllProvider)
            //                                 .homeAllModel!
            //                                 .album![index]
            //                                 .id!
            //                                 .toInt(),
            //                             title: ref
            //                                 .watch(homeAllProvider)
            //                                 .homeAllModel!
            //                                 .album![index]
            //                                 .title!,
            //                             thumbnail_image: ref
            //                                 .watch(homeAllProvider)
            //                                 .homeAllModel!
            //                                 .album![index]
            //                                 .thumbnailImage!,
            //                             description: ref
            //                                 .watch(homeAllProvider)
            //                                 .homeAllModel!
            //                                 .album![index]
            //                                 .description!)));
            //               },
            //               child: Column(
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(5),
            //                       child: SizedBox(
            //                         height: 100,
            //                         width: 100,
            //                         child: Image.network(
            //                             ref
            //                                 .watch(homeAllProvider)
            //                                 .homeAllModel!
            //                                 .album![index]
            //                                 .thumbnailImage
            //                                 .toString(),
            //                             fit: BoxFit.cover),
            //                       ),
            //                     ),
            //                   ),
            //                   Text(
            //                     ref
            //                         .watch(homeAllProvider)
            //                         .homeAllModel!
            //                         .album![index]
            //                         .title
            //                         .toString(),
            //                     style: TextStyle(
            //                         fontFamily: Strings.robotoMedium,
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 14.0,
            //                         color: Colors.black),
            //                   )
            //                 ],
            //               ),
            //             );
            //           })
            //       : const SizedBox(),
            // ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 25, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Recommend Movies'.tr,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const MoviesListView()),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TopPickedListView(
                              categoryType: "Recommend Videos")),
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
              child: ref.watch(homeAllProvider).homeAllModel != null &&
                  ref
                      .watch(homeAllProvider)
                      .homeAllModel!
                      .pickup!
                      .isNotEmpty
                  ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ref
                      .watch(homeAllProvider)
                      .homeAllModel!
                      .pickup!
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoviesDetailView(
                                  movieId: ref
                                      .watch(homeAllProvider)
                                      .homeAllModel!
                                      .pickup![index]
                                      .id!
                                      .toString())),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 120.0,
                                height: 200,
                                child: CommonImage(
                                    imageUrl: "${AppUrls.baseUrl}${ref
                                        .watch(homeAllProvider)
                                        .homeAllModel!
                                        .pickup![index]
                                        .thumbnail
                                        .toString()}"),
                                // child: Image.network(
                                //     ref
                                //         .watch(homeAllProvider)
                                //         .homeAllModel!
                                //         .pickup![index]
                                //         .poster
                                //         .toString(),
                                //     fit: BoxFit.cover),
                              ),
                            ),
                            Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                    fontFamily: Strings.robotoMedium,
                                    fontSize: 95.0,
                                    color: Colors.white.withOpacity(0.8)),
                                maxLines: 1,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })
                  : const SizedBox(),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20),
            //   child: Stack(
            //     children: [
            //       ClipRRect(
            //         borderRadius: BorderRadius.circular(10),
            //         child: SizedBox(
            //           width: MediaQuery.of(context).size.width,
            //           height: 90,
            //           child: CommonImage(
            //               imageUrl: 'https://cdn.wallpapersafari.com/48/97/jN2JiQ.jpg',
            //               // fit: BoxFit.cover
            //           ),
            //         ),
            //       ),
            //       SizedBox(
            //         width: MediaQuery.of(context).size.width,
            //         height: 90,
            //         child: GestureDetector(
            //           onTap: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => const WinnersView()),
            //             );
            //           },
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             mainAxisSize: MainAxisSize.max,
            //             children: [
            //               const SizedBox(width: 20),
            //               Expanded(
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       'Winner of',
            //                       style: TextStyle(
            //                           fontFamily: Strings.robotoMedium,
            //                           fontWeight: FontWeight.w400,
            //                           fontSize: 12.0,
            //                           color: Colors.white.withOpacity(0.8)),
            //                     ),
            //                     const SizedBox(height: 4),
            //                     Text(
            //                       'What is happening in universe',
            //                       style: TextStyle(
            //                           fontFamily: Strings.robotoMedium,
            //                           fontWeight: FontWeight.w500,
            //                           fontSize: 17.0,
            //                           color: Colors.white.withOpacity(0.9)),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //               const SizedBox(width: 5),
            //               Align(
            //                 alignment: Alignment.centerRight,
            //                 child: Text(
            //                   'Amrit Kumar',
            //                   style: TextStyle(
            //                       fontFamily: Strings.robotoMedium,
            //                       fontWeight: FontWeight.w600,
            //                       fontSize: 25.0,
            //                       color: Colors.white),
            //                 ),
            //               ),
            //               const SizedBox(width: 15),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 25, bottom: 5),
              child: SizedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Quiz',
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {

                        if(index==1)
                          {
                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => const WinnersView()),
                                            );
                          }else
                            {
                              ref.watch(quizProvider).quizListAPI(
                                  context: context, type: '${index + 1}');
                            }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 120.0,
                                height: 200,
                                child: CommonImage(
                                    imageUrl: 'https://cdn.wallpapersafari.com/48/97/jN2JiQ.jpg',
                                    // fit: BoxFit.fill
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              height: 200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          index == 1
                                              ? 'Winner List'
                                              : 'Quiz',
                                          style: TextStyle(
                                              fontFamily: Strings.robotoMedium,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15.0,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          index == 0?'Get Started':'See Our Winners',
                                          style: TextStyle(
                                              fontFamily: Strings.robotoMedium,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.0,
                                              color: Colors.white
                                                  .withOpacity(0.5)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 25, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Short Films'.tr,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const MoviesListView()),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ShortFilmListView(
                              categoryType: "Short Films")),
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
              child: ref.watch(homeAllProvider).homeAllModel != null &&
                  ref
                      .watch(homeAllProvider)
                      .homeAllModel!
                      .shortFilms!
                      .isNotEmpty
                  ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ref
                      .watch(homeAllProvider)
                      .homeAllModel!
                      .shortFilms!
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoviesDetailView(
                                  movieId: ref
                                      .watch(homeAllProvider)
                                      .homeAllModel!
                                      .shortFilms![index]
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
                                  imageUrl: "${AppUrls.baseUrl}${ref
                                      .watch(homeAllProvider)
                                      .homeAllModel!
                                      .shortFilms![index]
                                      .thumbnail
                                      .toString()}")
                            // child: Image.network(
                            //   ref
                            //       .watch(homeAllProvider)
                            //       .homeAllModel!
                            //       .shortFilms![index]
                            //       .poster
                            //       .toString(),
                            //   fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    );
                  })
                  : const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 25, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Live Streaming'.tr,
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
                          builder: (context) => const StreamingListView()),
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
              child: ref.watch(liveStreamProvider).liveStreamList != null &&
                  ref
                      .watch(liveStreamProvider)
                      .liveStreamList!
                      .livestream!
                      .isNotEmpty
                  ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ref
                      .watch(liveStreamProvider)
                      .liveStreamList!
                      .livestream!
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if(ref
                            .watch(liveStreamProvider)
                            .liveStreamList!
                            .livestream![index].type=="ZCLOUD")
                        {
                          if (ref
                              .watch(liveStreamProvider)
                              .liveStreamList!
                              .livestream![index]
                              .status ==
                              1) {
                            showStreamingDialog(context);
                          } else if (ref
                              .watch(liveStreamProvider)
                              .liveStreamList!
                              .livestream![index]
                              .status ==
                              2) {
                            watchStreamingDialog(
                              context,
                              ref
                                  .watch(liveStreamProvider)
                                  .liveStreamList!
                                  .livestream![index]
                                  .id
                                  .toString(),
                              ref
                                  .watch(liveStreamProvider)
                                  .liveStreamList!
                                  .livestream![index]
                                  .type
                                  .toString(),
                              ref
                                  .watch(liveStreamProvider)
                                  .liveStreamList!
                                  .livestream![index]
                                  .link
                                  .toString(),
                              ref
                                  .watch(liveStreamProvider)
                                  .liveStreamList!
                                  .livestream![index]
                                  .userName
                                  .toString(),

                            );
                          }
                        }
                        else{
                          watchStreamingDialog(
                            context,
                            ref
                                .watch(liveStreamProvider)
                                .liveStreamList!
                                .livestream![index]
                                .id
                                .toString(),
                            ref
                                .watch(liveStreamProvider)
                                .liveStreamList!
                                .livestream![index]
                                .type
                                .toString(),
                            ref
                                .watch(liveStreamProvider)
                                .liveStreamList!
                                .livestream![index]
                                .link
                                .toString(),
                            ref
                                .watch(liveStreamProvider)
                                .liveStreamList!
                                .livestream![index]
                                .userName
                                .toString(),

                          );
                        }
                        // if (ref
                        //     .watch(liveStreamProvider)
                        //     .liveStreamList!
                        //     .livestream![index]
                        //     .status ==
                        //     1) {
                        //   showStreamingDialog(context);
                        // } else if (ref
                        //     .watch(liveStreamProvider)
                        //     .liveStreamList!
                        //     .livestream![index]
                        //     .status ==
                        //     2) {
                        //   watchStreamingDialog(
                        //       context,
                        //       ref
                        //           .watch(liveStreamProvider)
                        //           .liveStreamList!
                        //           .livestream![index]
                        //           .id
                        //           .toString(),
                        //       ref
                        //           .watch(liveStreamProvider)
                        //           .liveStreamList!
                        //           .livestream![index]
                        //           .type
                        //           .toString(),
                        //       ref
                        //           .watch(liveStreamProvider)
                        //           .liveStreamList!
                        //           .livestream![index]
                        //           .link
                        //           .toString(),
                        //       ref
                        //           .watch(liveStreamProvider)
                        //           .liveStreamList!
                        //           .livestream![index]
                        //           .userName
                        //           .toString());
                        // }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                  width: 120.0,
                                  height: 200,
                                  child: CommonImage(
                                    imageUrl: "${ref
                                        .watch(liveStreamProvider)
                                        .liveStreamList!
                                        .livestream![index]
                                        .image
                                        .toString()}",
                                  )),
                            ),
                            SizedBox(
                              height: 200,
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    jumpToLivePage(context,ref
                                        .watch(liveStreamProvider)
                                        .liveStreamList!
                                        .livestream![index]
                                        .type
                                        .toString(),
                                      ref
                                          .watch(liveStreamProvider)
                                          .liveStreamList!
                                          .livestream![index]
                                          .userName
                                          .toString(),
                                        isHost: true,
                                        liveId: ref
                                            .watch(liveStreamProvider)
                                            .liveStreamList!
                                            .livestream![index]
                                            .id
                                            .toString(),
                                      link: ref
                                          .watch(liveStreamProvider)
                                          .liveStreamList!
                                          .livestream![index]
                                          .link
                                          .toString(),
                                    );
                                    ref
                                        .watch(liveStreamProvider)
                                        .liveStreamStatusAPI(
                                        context: context,
                                        status: '2',
                                        liveStreamId: ref
                                            .watch(liveStreamProvider)
                                            .liveStreamList!
                                            .livestream![index]
                                            .id
                                            .toString());
                                  },
                                  child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      child: Container(
                                          margin: const EdgeInsets.all(2.0),
                                          color: Colors.white,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                  Icons.live_tv_rounded,
                                                  color: Colors.red,
                                                  size: 40),
                                              Text(
                                                'Go',
                                                style: TextStyle(
                                                    fontFamily: Strings
                                                        .robotoMedium,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    fontSize: 14.0,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ))),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })
                  : const SizedBox(),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 10.0, right: 10.0, top: 25, bottom: 5),
            //   child: Row(children: [
            //     Expanded(
            //       child: Text(
            //         'Music Artists',
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
            //               builder: (context) => const ArtistListView()),
            //         );
            //       },
            //       child: Text(
            //         'See More',
            //         style: TextStyle(
            //             fontFamily: Strings.robotoMedium,
            //             fontWeight: FontWeight.w600,
            //             fontSize: 14.0,
            //             color: Color(0xFFFECC00)),
            //       ),
            //     ),
            //   ]),
            // ),
            // SizedBox(
            //   height: 150,
            //   child: ListView.builder(
            //       scrollDirection: Axis.horizontal,
            //       itemCount: musicArtist.length,
            //       itemBuilder: (BuildContext context, int index) {
            //         return Column(
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.all(10.0),
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.circular(50),
            //                 child: SizedBox(
            //                   height: 100,
            //                   width: 100,
            //                   child: Image.network(musicArtist[index],
            //                       fit: BoxFit.cover),
            //                 ),
            //               ),
            //             ),
            //             Text(
            //               'Artist ${index + 1}',
            //               style: TextStyle(
            //                   fontFamily: Strings.robotoMedium,
            //                   fontWeight: FontWeight.w500,
            //                   fontSize: 14.0,
            //                   color: Colors.black),
            //             )
            //           ],
            //         );
            //       }),
            // ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 20, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Most Watched Videos'.tr,
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
                          builder: (context) => const HotVideosListView(
                              categoryType: "Most Watched Videos ")),
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
              child: ref.watch(homeAllProvider).homeAllModel != null &&
                  ref.watch(homeAllProvider).homeAllModel!.hot!.isNotEmpty
                  ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                  ref.watch(homeAllProvider).homeAllModel!.hot!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfluncerDetailView(
                                  videoId: ref
                                      .watch(homeAllProvider)
                                      .homeAllModel!
                                      .hot![index]
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
                                  imageUrl: "${AppUrls.baseUrl}${ref
                                      .watch(homeAllProvider)
                                      .homeAllModel!
                                      .hot![index]
                                      .thumbnail
                                      .toString()}")
                            // child: Image.network(
                            //     ref
                            //         .watch(homeAllProvider)
                            //         .homeAllModel!
                            //         .hot![index]
                            //         .poster
                            //         .toString(),
                            //     fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    );
                  })
                  : const SizedBox(),
            ),
            // SizedBox(
            //   height: 70,
            //   child: ListView.builder(
            //       scrollDirection: Axis.horizontal,
            //       itemCount: 7,
            //       itemBuilder: (BuildContext context, int index) {
            //         return Padding(
            //           padding: const EdgeInsets.all(10.0),
            //           child: Stack(
            //             children: [
            //               ClipRRect(
            //                 borderRadius: BorderRadius.circular(7),
            //                 child: SizedBox(
            //                   width: 120.0,
            //                   height: 200,
            //                   child: Image.network(
            //                       'https://cdn.wallpapersafari.com/48/97/jN2JiQ.jpg',
            //                       fit: BoxFit.fill),
            //                 ),
            //               ),
            //               SizedBox(
            //                 width: 120,
            //                 height: 70,
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   mainAxisSize: MainAxisSize.max,
            //                   children: [
            //                     Padding(
            //                       padding: const EdgeInsets.all(10.0),
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             'Category ${index + 1}',
            //                             style: TextStyle(
            //                                 fontFamily: Strings.robotoMedium,
            //                                 fontWeight: FontWeight.w400,
            //                                 fontSize: 15.0,
            //                                 color: Colors.white),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               )
            //             ],
            //           ),
            //         );
            //       }),
            // ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 25, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Govt New Schemes'.tr,
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
                          builder: (context) => const SchemesListView(
                              categoryType: "Govt New Schemes ")),
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
              child: ref.watch(homeAllProvider).homeAllModel != null &&
                  ref
                      .watch(homeAllProvider)
                      .homeAllModel!
                      .schemes!
                      .isNotEmpty
                  ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ref
                      .watch(homeAllProvider)
                      .homeAllModel!
                      .schemes!
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SchemeDetailView(
                                    videoId: ref
                                        .watch(homeAllProvider)
                                        .homeAllModel!
                                        .schemes![index]
                                        .id!
                                        .toString())));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                              width: 120.0,
                              // child: Image.network(
                              //     ref
                              //         .watch(homeAllProvider)
                              //         .homeAllModel!
                              //         .schemes![index]
                              //         .poster
                              //         .toString(),
                              //     fit: BoxFit.cover),
                              child: CommonImage(
                                  imageUrl: "${AppUrls.baseUrl}${ref
                                      .watch(homeAllProvider)
                                      .homeAllModel!
                                      .schemes![index]
                                      .thumbnail
                                      .toString()}")),
                        ),
                      ),
                    );
                  })
                  : const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 25, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'State Leadership Video Bytes'.tr,
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
                          builder: (context) => const LeadershipListView(
                              categoryType: "Leadership Video")),
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
              child: ref.watch(homeAllProvider).homeAllModel != null &&
                  ref
                      .watch(homeAllProvider)
                      .homeAllModel!
                      .leaders!
                      .isNotEmpty
                  ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ref
                      .watch(homeAllProvider)
                      .homeAllModel!
                      .leaders!
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LeadershipDetailView(
                                    videoId: ref
                                        .watch(homeAllProvider)
                                        .homeAllModel!
                                        .leaders![index]
                                        .id!
                                        .toString())));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                              width: 120.0,
                              // child: Image.network(
                              //     ref
                              //         .watch(homeAllProvider)
                              //         .homeAllModel!
                              //         .schemes![index]
                              //         .poster
                              //         .toString(),
                              //     fit: BoxFit.cover),
                              child: CommonImage(
                                  imageUrl: "${AppUrls.baseUrl}${ref
                                      .watch(homeAllProvider)
                                      .homeAllModel!
                                      .leaders![index]
                                      .thumbnail
                                      .toString()}")),
                        ),
                      ),
                    );
                  })
                  : const SizedBox(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Recommend Music Videos'.tr,
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
                          builder: (context) => const RecomandedMusicVideo()),
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
              child: ref.watch(homeAllProvider).homeAllModel != null &&
                  ref
                      .watch(homeAllProvider)
                      .homeAllModel!
                      .recommended!
                      .isNotEmpty
                  ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ref
                      .watch(homeAllProvider)
                      .homeAllModel!
                      .recommended!
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MusicVideoDetailView(
                                  movieId: ref
                                      .watch(homeAllProvider)
                                      .homeAllModel!
                                      .recommended![index]
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
                                  imageUrl: "${AppUrls.baseUrl}${ref
                                      .watch(homeAllProvider)
                                      .homeAllModel!
                                      .recommended![index]
                                      .thumbnail
                                      .toString()}")
                            // child: Image.network(
                            //   ref
                            //       .watch(homeAllProvider)
                            //       .homeAllModel!
                            //       .recommended![index]
                            //       .poster
                            //       .toString(),
                            //   fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    );
                  })
                  : const SizedBox(),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  watchStreamingDialog(BuildContext context, String liveId,String type,String link,String name) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                child: Text('Live Stream'.tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: Strings.robotoMedium,
                      color: ThemeColor.bodyGrey,
                      fontWeight: FontWeight.w700,
                      fontSize: 17.0,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text('Click on watch live'.tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        color: ThemeColor.bodyGrey,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0)),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: Color(0xffDCDCDC),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        jumpToLivePage(context, type,name,link: link,isHost: false, liveId: liveId);
                      },
                      child: Center(
                        child: Text('Watch Live',
                            style: TextStyle(
                                fontFamily: Strings.robotoMedium,
                                color: const Color(0xff1B79EB),
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0)),
                      )),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  showStreamingDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                child: Text('Live Stream'.tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: Strings.robotoMedium,
                      color: ThemeColor.bodyGrey,
                      fontWeight: FontWeight.w700,
                      fontSize: 17.0,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text('Live stream will start soon...'.tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        color: ThemeColor.bodyGrey,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0)),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: Color(0xffDCDCDC),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text('OK'.tr,
                            style: TextStyle(
                                fontFamily: Strings.robotoMedium,
                                color: const Color(0xff1B79EB),
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0)),
                      )),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  jumpToLivePage(BuildContext context,String type,String name,
      {required bool isHost,required String link, required String liveId}) {
    var userId = ref.watch(baseViewModel).kCurrentUser!.firstname != null
        ? "${ref.watch(baseViewModel).kCurrentUser?.firstname!}"
        : Random().nextInt(1000).toString();
    var lastname = ref.watch(baseViewModel).kCurrentUser!.lastname != null
        ? "${ref.watch(baseViewModel).kCurrentUser?.lastname!}"
        : Random().nextInt(1000).toString();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LivePage(name: name,link: link,type: type,liveID: liveId, isHost: isHost, userID: userId,lastname:lastname),
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

List<Widget> indicators(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: const EdgeInsets.all(3),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
          color: currentIndex == index ? Colors.black : Colors.black26,
          shape: BoxShape.circle),
    );
  });
}
