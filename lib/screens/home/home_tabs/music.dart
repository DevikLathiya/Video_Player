import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/home/musiv_video_detail_view.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get/get.dart';
// import '../movie_detail_view.dart';
// import '../scheme_detail_view.dart';
// import '../stories_detail_view.dart';

class Music extends ConsumerStatefulWidget {
  const Music({Key? key}) : super(key: key);

  @override
  ConsumerState<Music> createState() => _AllViewState();
}

class _AllViewState extends ConsumerState<Music> {
  late PageController _pageController;

  int activePage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(homeMusicProvider).homeMusicAPI(context: context);
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
            ref.watch(homeMusicProvider).homeMusicModel != null &&
                    ref.watch(homeMusicProvider).homeMusicModel!.sliders !=
                        null &&
                    ref
                        .watch(homeMusicProvider)
                        .homeMusicModel!
                        .sliders!
                        .isNotEmpty
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: PageView.builder(
                        itemCount: ref
                            .watch(homeMusicProvider)
                            .homeMusicModel!
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
                                    builder: (context) => MusicVideoDetailView(
                                        movieId: ref
                                            .watch(homeMusicProvider)
                                            .homeMusicModel!
                                            .sliders![pagePosition]
                                            .id!
                                            .toString())),
                              );
                            },
                            child: CommonImage(
                              imageUrl:
                                  '${AppUrls.baseUrl}${ref.watch(homeMusicProvider).homeMusicModel!.sliders![pagePosition].sliderImage.toString()}',
                            ),
                            // child: Image.network(
                            //     '${AppUrls.baseUrl}${ref.watch(homeMusicProvider).homeMusicModel!.sliders![pagePosition].sliderImage.toString()}',
                            //     fit: BoxFit.cover)
                          );
                        }))
                : const SizedBox(),
            const SizedBox(height: 4),
            ref.watch(homeMusicProvider).homeMusicModel != null &&
                    ref.watch(homeMusicProvider).homeMusicModel!.sliders !=
                        null &&
                    ref
                        .watch(homeMusicProvider)
                        .homeMusicModel!
                        .sliders!
                        .isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicators(
                        ref
                                .watch(homeMusicProvider)
                                .homeMusicModel!
                                .sliders!
                                .isNotEmpty
                            ? ref
                                .watch(homeMusicProvider)
                                .homeMusicModel!
                                .sliders!
                                .length
                            : 0,
                        activePage),
                  )
                : const SizedBox(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 15, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Music videos'.tr,
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
              height: 150,
              child: ref.watch(homeMusicProvider).homeMusicModel != null &&
                      ref
                          .watch(homeMusicProvider)
                          .homeMusicModel!
                          .recommended!
                          .isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ref
                          .watch(homeMusicProvider)
                          .homeMusicModel!
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
                                          .watch(homeMusicProvider)
                                          .homeMusicModel!
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
                                width: 230.0,
                                child: CommonImage(
                                  imageUrl:
                                      '${AppUrls.baseUrl}${ref.watch(homeMusicProvider).homeMusicModel!.recommended![index].thumbnail.toString()}',
                                ),
                              ),
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
            //     Text(
            //       'See More',
            //       style: TextStyle(
            //           fontFamily: Strings.robotoMedium,
            //           fontWeight: FontWeight.w600,
            //           fontSize: 14.0,
            //           color: const Color(0xFFFECC00)),
            //     ),
            //   ]),
            // ),
            // SizedBox(
            //   height: 150,
            //   child: ref.watch(homeMusicProvider).homeMusicModel != null &&
            //           ref
            //               .watch(homeMusicProvider)
            //               .homeMusicModel!
            //               .musicArtists!
            //               .isNotEmpty
            //       ? ListView.builder(
            //           scrollDirection: Axis.horizontal,
            //           itemCount: ref
            //               .watch(homeMusicProvider)
            //               .homeMusicModel!
            //               .musicArtists!
            //               .length,
            //           itemBuilder: (BuildContext context, int index) {
            //             return Column(
            //               children: [
            //                 Padding(
            //                   padding: const EdgeInsets.all(10.0),
            //                   child: ClipRRect(
            //                     borderRadius: BorderRadius.circular(50),
            //                     child: SizedBox(
            //                       height: 100,
            //                       width: 100,
            //                       child: CommonImage(
            //                           imageUrl: ref
            //                               .watch(homeMusicProvider)
            //                               .homeMusicModel!
            //                               .musicArtists![index]
            //                               .image
            //                               .toString()),
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.only(left: 10.0),
            //                   child: Text(
            //                     ref
            //                         .watch(homeMusicProvider)
            //                         .homeMusicModel!
            //                         .musicArtists![index]
            //                         .title
            //                         .toString(),
            //                     style: TextStyle(
            //                         fontFamily: Strings.robotoMedium,
            //                         fontSize: 14.0,
            //                         color: Colors.black),
            //                   ),
            //                 )
            //               ],
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
                    'Music Album'.tr,
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
                //           builder: (context) => const MusicListView()),
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
              height: 150,
              child: ref.watch(homeMusicProvider).homeMusicModel != null &&
                      ref
                          .watch(homeMusicProvider)
                          .homeMusicModel!
                          .albums!
                          .isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ref
                          .watch(homeMusicProvider)
                          .homeMusicModel!
                          .albums!
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MusicVideoDetailView(
                                      movieId: ref
                                          .watch(homeMusicProvider)
                                          .homeMusicModel!
                                          .albums![index]
                                          .id!
                                          .toString())),
                            );
                          },
                          child: SizedBox(
                            height: 200,
                            width: 100,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: CommonImage(
                                          imageUrl: AppUrls.baseUrl +
                                              ref
                                                  .watch(homeMusicProvider)
                                                  .homeMusicModel!
                                                  .albums![index]
                                                  .thumbnailImage
                                                  .toString()),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    ref
                                        .watch(homeMusicProvider)
                                        .homeMusicModel!
                                        .albums![index]
                                        .name
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: Strings.robotoMedium,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: Colors.black),
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
                  left: 10.0, right: 10.0, top: 25, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Trending Music'.tr,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
                // Text(
                //   'See More',
                //   style: TextStyle(
                //       fontFamily: Strings.robotoMedium,
                //       fontWeight: FontWeight.w600,
                //       fontSize: 14.0,
                //       color: const Color(0xFFFECC00)),
                // ),
              ]),
            ),
            SizedBox(
              height: 150,
              child: ref.watch(homeMusicProvider).homeMusicModel != null &&
                      ref
                          .watch(homeMusicProvider)
                          .homeMusicModel!
                          .recommended!
                          .isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ref
                          .watch(homeMusicProvider)
                          .homeMusicModel!
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
                                          .watch(homeMusicProvider)
                                          .homeMusicModel!
                                          .recommended![index]
                                          .id!
                                          .toString())),
                            );
                          },
                          child: SizedBox(
                            height: 200,
                            width: 100,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: CommonImage(
                                        imageUrl:
                                            '${AppUrls.baseUrl}${ref.watch(homeMusicProvider).homeMusicModel!.recommended![index].poster}',
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    ref
                                        .watch(homeMusicProvider)
                                        .homeMusicModel!
                                        .recommended![index]
                                        .name
                                        .toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: Strings.robotoMedium,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: Colors.black),
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
                  left: 10.0, right: 10.0, top: 25, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Hot Music',
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
                // Text(
                //   'See More',
                //   style: TextStyle(
                //       fontFamily: Strings.robotoMedium,
                //       fontWeight: FontWeight.w600,
                //       fontSize: 14.0,
                //       color: const Color(0xFFFECC00)),
                // ),
              ]),
            ),
            SizedBox(
              height: 150,
              child: ref.watch(homeMusicProvider).homeMusicModel != null &&
                      ref
                          .watch(homeMusicProvider)
                          .homeMusicModel!
                          .hot!
                          .isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ref
                          .watch(homeMusicProvider)
                          .homeMusicModel!
                          .hot!
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MusicVideoDetailView(
                                      movieId: ref
                                          .watch(homeMusicProvider)
                                          .homeMusicModel!
                                          .hot![index]
                                          .id!
                                          .toString())),
                            );
                          },
                          child: SizedBox(
                            width: 100,
                            height: 200,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: CommonImage(
                                        imageUrl:
                                            '${AppUrls.baseUrl}${ref.watch(homeMusicProvider).homeMusicModel!.hot![index].poster}',
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    ref
                                        .watch(homeMusicProvider)
                                        .homeMusicModel!
                                        .hot![index]
                                        .name
                                        .toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: Strings.robotoMedium,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: Colors.black),
                                  ),
                                )
                              ],
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
