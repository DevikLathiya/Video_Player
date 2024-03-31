import 'package:flutter/material.dart';
import 'package:hellomegha/Leadership/Leadership_list_view.dart';
import 'package:hellomegha/Schemes/schemes_list_view.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/home/hot_videos_list_view.dart';
import 'package:hellomegha/screens/home/influncer_detail_view.dart';
import 'package:hellomegha/screens/home/leadership_detail_view.dart';
import 'package:hellomegha/screens/home/movie_detail_view.dart';
import 'package:hellomegha/screens/home/musiv_video_detail_view.dart';
import 'package:hellomegha/screens/home/scheme_detail_view.dart';
import 'package:hellomegha/screens/home/stories_detail_view.dart';
import 'package:hellomegha/screens/home/stories_list_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get/get.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class Influncers extends ConsumerStatefulWidget {
  const Influncers({Key? key}) : super(key: key);

  @override
  ConsumerState<Influncers> createState() => _AllViewState();
}

class _AllViewState extends ConsumerState<Influncers> {
  late PageController _pageController;

  int activePage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(homeVideoProvider).homeVideoAPI(context: context);
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
            ref.watch(homeVideoProvider).homeVideoModel != null &&
                ref
                    .watch(homeVideoProvider)
                    .homeVideoModel!
                    .sliders!
                    .isNotEmpty
                ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: PageView.builder(
                    itemCount: ref
                        .watch(homeVideoProvider)
                        .homeVideoModel!
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
                                .watch(homeVideoProvider)
                                .homeVideoModel!
                                .sliders![pagePosition]
                                .type ==
                                'Schemes') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SchemeDetailView(
                                        videoId: ref
                                            .watch(homeVideoProvider)
                                            .homeVideoModel!
                                            .sliders![pagePosition]
                                            .id!
                                            .toString())),
                              );
                            } else if (ref
                                .watch(homeVideoProvider)
                                .homeVideoModel!
                                .sliders![pagePosition]
                                .type ==
                                'Music Video') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MusicVideoDetailView(
                                            movieId: ref
                                                .watch(homeVideoProvider)
                                                .homeVideoModel!
                                                .sliders![pagePosition]
                                                .id!
                                                .toString())),
                              );
                            } else if (ref
                                .watch(homeVideoProvider)
                                .homeVideoModel!
                                .sliders![pagePosition]
                                .type ==
                                'Influncer') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InfluncerDetailView(
                                            videoId: ref
                                                .watch(homeVideoProvider)
                                                .homeVideoModel!
                                                .sliders![pagePosition]
                                                .id!
                                                .toString())),
                              );
                            } else if (ref
                                .watch(homeVideoProvider)
                                .homeVideoModel!
                                .sliders![pagePosition]
                                .type ==
                                'Stories') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StoriesDetailView(
                                        storyId: ref
                                            .watch(homeVideoProvider)
                                            .homeVideoModel!
                                            .sliders![pagePosition]
                                            .id!
                                            .toString())),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MusicVideoDetailView(
                                        movieId: ref
                                            .watch(homeVideoProvider)
                                            .homeVideoModel!
                                            .sliders![pagePosition]
                                            .id
                                            .toString())),
                              );
                            }
                          },
                          child: CommonImage(
                              imageUrl: AppUrls.baseUrl +
                                  ref
                                      .watch(homeVideoProvider)
                                      .homeVideoModel!
                                      .sliders![pagePosition]
                                      .sliderImage
                                      .toString())
                        // child: Image.network(
                        //     '${AppUrls.baseUrl}${ref.watch(homeVideoProvider).homeVideoModel!.sliders![pagePosition].sliderImage.toString()}',
                        //     fit: BoxFit.cover)
                      );
                    }))
                : const SizedBox(),
            const SizedBox(height: 4),
            ref.watch(homeVideoProvider).homeVideoModel != null &&
                ref
                    .watch(homeVideoProvider)
                    .homeVideoModel!
                    .sliders!
                    .isNotEmpty
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: indicators(
                  ref
                      .watch(homeVideoProvider)
                      .homeVideoModel!
                      .sliders!
                      .isNotEmpty
                      ? ref
                      .watch(homeVideoProvider)
                      .homeVideoModel!
                      .sliders!
                      .length
                      : 0,
                  activePage),
            )
                : const SizedBox(),
            const SizedBox(height: 10),
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
                      child: ref.watch(homeVideoProvider).homeVideoModel !=
                          null &&
                          ref
                              .watch(homeVideoProvider)
                              .homeVideoModel!
                              .stories!
                              .isNotEmpty
                          ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ref
                              .watch(homeVideoProvider)
                              .homeVideoModel!
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
                                                    .watch(
                                                    homeVideoProvider)
                                                    .homeVideoModel!
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
                                          imageUrl: AppUrls.baseUrl +ref
                                              .watch(homeVideoProvider)
                                              .homeVideoModel!
                                              .stories![index]
                                              .thumbnail
                                              .toString())
                                    // child: Image.network(
                                    //     '${ref.watch(homeVideoProvider).homeVideoModel!.stories![index].poster.toString()}',
                                    //     fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            );
                          })
                          : const SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 15, bottom: 5),
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
              height: 150,
              child: ref.watch(homeVideoProvider).homeVideoModel != null &&
                  ref
                      .watch(homeVideoProvider)
                      .homeVideoModel!
                      .scheme!
                      .isNotEmpty
                  ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ref
                      .watch(homeVideoProvider)
                      .homeVideoModel!
                      .scheme!
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SchemeDetailView(
                                  videoId: ref
                                      .watch(homeVideoProvider)
                                      .homeVideoModel!
                                      .scheme![index]
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
                                  imageUrl: AppUrls.baseUrl + ref
                                      .watch(homeVideoProvider)
                                      .homeVideoModel!
                                      .scheme![index]
                                      .thumbnail
                                      .toString())
                            // child: Image.network(
                            //     '${ref.watch(homeVideoProvider).homeVideoModel!.scheme![index].poster.toString()}',
                            //     fit: BoxFit.cover),
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
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 15, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Influncers videos'.tr,
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
              child: ref.watch(homeVideoProvider).homeVideoModel != null &&
                  ref
                      .watch(homeVideoProvider)
                      .homeVideoModel!
                      .influncer!
                      .isNotEmpty
                  ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ref
                      .watch(homeVideoProvider)
                      .homeVideoModel!
                      .influncer!
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfluncerDetailView(
                                  videoId: ref
                                      .watch(homeVideoProvider)
                                      .homeVideoModel!
                                      .influncer![index]
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
                                  imageUrl: AppUrls.baseUrl +ref
                                      .watch(homeVideoProvider)
                                      .homeVideoModel!
                                      .influncer![index]
                                      .poster
                                      .toString())
                            // child: Image.network(
                            //     ref
                            //         .watch(homeVideoProvider)
                            //         .homeVideoModel!
                            //         .influncer![index]
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
