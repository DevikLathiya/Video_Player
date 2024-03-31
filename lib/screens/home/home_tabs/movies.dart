import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/home/movie_detail_view.dart';
import 'package:hellomegha/screens/home/movies_list_view.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get/get.dart';

class Movies extends ConsumerStatefulWidget {
  const Movies({Key? key}) : super(key: key);

  @override
  ConsumerState<Movies> createState() => _AllViewState();
}

class _AllViewState extends ConsumerState<Movies> {
  late PageController _pageController;

  // List<String> watchMovie = [
  //   "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/dramatic-movie-poster-template-design-f0f2c261e077379d0f82604f96b6a774_screen.jpg?ts=1602570456",
  //   "https://wallup.net/wp-content/uploads/2019/07/24/748894-spider-man-superhero-marvel-spider-man-action-spiderman-poster-748x997.jpg",
  //   "https://wallpapersmug.com/download/1600x900/b41742/thanos-and-the-black-order.jpg",
  //   "https://www.joblo.com/wp-content/uploads/2012/04/oblivion-Imax-poster-4-9-1.jpg",
  //   "https://upload.wikimedia.org/wikipedia/en/1/19/Iron_Man_3_poster.jpg",
  //   "https://www.asparkleofgenius.com/wp-content/uploads/2017/03/image003.jpg",
  // ];

  int activePage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(homeMoviesProvider).homeMoviesAPI(context: context);
    });
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }
      else
      {

      }
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
            ref.watch(homeMoviesProvider).homeMovieModel != null &&
                    ref.watch(homeMoviesProvider).homeMovieModel!.sliders !=
                        null &&
                    ref
                        .watch(homeMoviesProvider)
                        .homeMovieModel!
                        .sliders!
                        .isNotEmpty
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: PageView.builder(
                        itemCount: ref
                            .watch(homeMoviesProvider)
                            .homeMovieModel!
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MoviesDetailView(
                                        movieId: ref
                                            .watch(homeMoviesProvider)
                                            .homeMovieModel!
                                            .sliders![pagePosition]
                                            .movieId!
                                            .toString())),
                              );
                            },
                            child: CommonImage(
                                imageUrl:
                                    '${AppUrls.baseUrl}${ref.watch(homeMoviesProvider).homeMovieModel!.sliders![pagePosition].sliderImage.toString()}'),
                            // child: Image.network(
                            //     '${AppUrls.baseUrl}${ref.watch(homeMoviesProvider).homeMovieModel!.sliders![pagePosition].sliderImage.toString()}',
                            //     fit: BoxFit.cover)
                          );
                        }))
                : const SizedBox(),
            const SizedBox(height: 4),
            ref.watch(homeMoviesProvider).homeMovieModel != null &&
                    ref.watch(homeMoviesProvider).homeMovieModel!.sliders !=
                        null &&
                    ref
                        .watch(homeMoviesProvider)
                        .homeMovieModel!
                        .sliders!
                        .isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicators(
                        ref
                                .watch(homeMoviesProvider)
                                .homeMovieModel!
                                .sliders!
                                .isNotEmpty
                            ? ref
                                .watch(homeMoviesProvider)
                                .homeMovieModel!
                                .sliders!
                                .length
                            : 0,
                        activePage),
                  )
                : const SizedBox(),
            const SizedBox(height: 10),
            if (ref.watch(homeMoviesProvider).homeMovieModel != null &&
                ref
                    .watch(homeMoviesProvider)
                    .homeMovieModel!
                    .continueWatch!
                    .isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 15, bottom: 5),
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
                  Text(
                    '',
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        color: const Color(0xFFFECC00)),
                  ),
                ]),
              ),
            if (ref.watch(homeMoviesProvider).homeMovieModel != null &&
                ref
                    .watch(homeMoviesProvider)
                    .homeMovieModel!
                    .continueWatch!
                    .isNotEmpty)
              SizedBox(
                  height: 210,
                  child: ref.watch(homeMoviesProvider).homeMovieModel != null &&
                          ref
                              .watch(homeMoviesProvider)
                              .homeMovieModel!
                              .continueWatch!
                              .isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ref
                              .watch(homeMoviesProvider)
                              .homeMovieModel!
                              .continueWatch!
                              .length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MoviesDetailView(
                                            movieId: ref
                                                .watch(homeMoviesProvider)
                                                .homeMovieModel!
                                                .continueWatch![index]
                                                .id
                                                .toString())),
                                  );
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
                                                imageUrl: AppUrls.baseUrl +
                                                    ref
                                                        .watch(
                                                            homeMoviesProvider)
                                                        .homeMovieModel!
                                                        .continueWatch![index]
                                                        .thumbnail,
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
                                                        BorderRadius.circular(
                                                            25),
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
                                          // LinearProgressIndicator(
                                          //   backgroundColor: Colors.black38,
                                          //   valueColor:
                                          //       const AlwaysStoppedAnimation<
                                          //           Color>(Colors.amber),
                                          //   value: filledValue.toDouble(),
                                          // )
                                        ],
                                      )),
                                ),
                              ),
                            );
                          })
                      : const SizedBox()),
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
                InkWell(
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
              child: ref.watch(homeMoviesProvider).homeMovieModel != null &&
                      ref
                          .watch(homeMoviesProvider)
                          .homeMovieModel!
                          .pickup!
                          .isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ref
                          .watch(homeMoviesProvider)
                          .homeMovieModel!
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
                                          .watch(homeMoviesProvider)
                                          .homeMovieModel!
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
                                          imageUrl: AppUrls.baseUrl +
                                              ref
                                                  .watch(homeMoviesProvider)
                                                  .homeMovieModel!
                                                  .pickup![index]
                                                  .thumbnail
                                                  .toString())
                                      // child: Image.network('${ref.watch(homeMoviesProvider).homeMovieModel!.pickup![index].poster.toString()}',
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
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 20, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Recommend Short Films'.tr,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const MoviesListView()),
                //     );
                //   },
                //   child: Text(
                //     'See More',
                //     style: TextStyle(
                //         fontFamily: Strings.robotoMedium,
                //         fontWeight: FontWeight.w600,
                //         fontSize: 14.0,
                //         color: const Color(0xFFFECC00)),
                //   ),
                // ),
              ]),
            ),
            SizedBox(
              height: 200,
              child: ref.watch(homeMoviesProvider).homeMovieModel != null &&
                      ref
                          .watch(homeMoviesProvider)
                          .homeMovieModel!
                          .recommended!
                          .isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ref
                          .watch(homeMoviesProvider)
                          .homeMovieModel!
                          .recommended!
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MoviesDetailView(
                                      movieId: ref
                                          .watch(homeMoviesProvider)
                                          .homeMovieModel!
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
                                      imageUrl: AppUrls.baseUrl +
                                          ref
                                              .watch(homeMoviesProvider)
                                              .homeMovieModel!
                                              .recommended![index]
                                              .poster
                                              .toString())
                                  // child:
                                  // Image.network('${ref.watch(homeMoviesProvider).homeMovieModel!.recommended![index].poster.toString()}', fit: BoxFit.cover),
                                  ),
                            ),
                          ),
                        );
                      })
                  : const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 20, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Most Watched Short Films'.tr,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const HotVideosListView(
                //               categoryType: "Hot Videos")),
                //     );
                //   },
                //   child: Text(
                //     'See More',
                //     style: TextStyle(
                //         fontFamily: Strings.robotoMedium,
                //         fontWeight: FontWeight.w600,
                //         fontSize: 14.0,
                //         color: const Color(0xFFFECC00)),
                //   ),
                // ),
              ]),
            ),
            SizedBox(
              height: 200,
              child: ref.watch(homeMoviesProvider).homeMovieModel != null &&
                      ref
                          .watch(homeMoviesProvider)
                          .homeMovieModel!
                          .hot!
                          .isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ref
                          .watch(homeMoviesProvider)
                          .homeMovieModel!
                          .hot!
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
                                      imageUrl: AppUrls.baseUrl +
                                          ref
                                              .watch(homeMoviesProvider)
                                              .homeMovieModel!
                                              .hot![index]
                                              .poster
                                              .toString())
                                  // child: Image.network('${ref.watch(homeMoviesProvider).homeMovieModel!.hot![index].poster.toString()}', fit: BoxFit.cover),
                                  ),
                            ),
                          ),
                        );
                      })
                  : const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 20, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Action Movies'.tr,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
                Text(
                  '',
                  style: TextStyle(
                      fontFamily: Strings.robotoMedium,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                      color: const Color(0xFFFECC00)),
                ),
              ]),
            ),
            SizedBox(
              height: 200,
              child: ref.watch(homeMoviesProvider).homeMovieModel != null &&
                      ref
                          .watch(homeMoviesProvider)
                          .homeMovieModel!
                          .genre1!
                          .isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ref
                          .watch(homeMoviesProvider)
                          .homeMovieModel!
                          .genre1!
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MoviesDetailView(
                                      movieId: ref
                                          .watch(homeMoviesProvider)
                                          .homeMovieModel!
                                          .genre1![index]
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
                                    imageUrl: AppUrls.baseUrl +
                                        ref
                                            .watch(homeMoviesProvider)
                                            .homeMovieModel!
                                            .genre1![index]
                                            .poster
                                            .toString()),
                                //child: Image.network('${ref.watch(homeMoviesProvider).homeMovieModel!.genre1![index].poster.toString()}', fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        );
                      })
                  : const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 20, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Crime Thriller'.tr,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
                Text(
                  '',
                  style: TextStyle(
                      fontFamily: Strings.robotoMedium,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                      color: const Color(0xFFFECC00)),
                ),
              ]),
            ),
            SizedBox(
              height: 200,
              child: ref.watch(homeMoviesProvider).homeMovieModel != null &&
                      ref
                          .watch(homeMoviesProvider)
                          .homeMovieModel!
                          .genre2!
                          .isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ref
                          .watch(homeMoviesProvider)
                          .homeMovieModel!
                          .genre2!
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MoviesDetailView(
                                      movieId: ref
                                          .watch(homeMoviesProvider)
                                          .homeMovieModel!
                                          .genre2![index]
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
                                      imageUrl: AppUrls.baseUrl +
                                          ref
                                              .watch(homeMoviesProvider)
                                              .homeMovieModel!
                                              .genre2![index]
                                              .poster
                                              .toString())
                                  //child: Image.network('${ref.watch(homeMoviesProvider).homeMovieModel!.genre2![index].poster.toString()}', fit: BoxFit.cover),
                                  ),
                            ),
                          ),
                        );
                      })
                  : const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 20, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Romantic'.tr,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
                Text(
                  '',
                  style: TextStyle(
                      fontFamily: Strings.robotoMedium,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                      color: const Color(0xFFFECC00)),
                ),
              ]),
            ),
            SizedBox(
              height: 200,
              child: ref.watch(homeMoviesProvider).homeMovieModel != null &&
                      ref
                          .watch(homeMoviesProvider)
                          .homeMovieModel!
                          .genre3!
                          .isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ref
                          .watch(homeMoviesProvider)
                          .homeMovieModel!
                          .genre3!
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MoviesDetailView(
                                      movieId: ref
                                          .watch(homeMoviesProvider)
                                          .homeMovieModel!
                                          .genre3![index]
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
                                    imageUrl: AppUrls.baseUrl +
                                        ref
                                            .watch(homeMoviesProvider)
                                            .homeMovieModel!
                                            .genre3![index]
                                            .poster
                                            .toString()),
                                // child: Image.network('${ref.watch(homeMoviesProvider).homeMovieModel!.genre3![index].poster.toString()}', fit: BoxFit.cover),
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
