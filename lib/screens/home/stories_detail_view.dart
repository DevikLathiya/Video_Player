import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/ab_button.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/home/stories_read_view.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoriesDetailView extends ConsumerStatefulWidget {
  final String storyId;
  const StoriesDetailView({Key? key, required this.storyId}) : super(key: key);

  @override
  ConsumerState<StoriesDetailView> createState() => _StoriesDetailViewState();
}

class _StoriesDetailViewState extends ConsumerState<StoriesDetailView> {
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   ref
  //       .watch(storyDetailProvider)
  //       .storyDetailsAPI(context: context, story: widget.storyId);
  //   ref
  //       .watch(storyDetailProvider)
  //       .suggestStoryAPI(context: context, storyId: '6');
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
        ref
            .watch(storyDetailProvider)
            .storyDetailsAPI(context: context, story: widget.storyId);
        ref
            .watch(storyDetailProvider)
            .suggestStoryAPI(context: context, storyId: '6');
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: SizedBox(
                    height: 230,
                    width: MediaQuery.of(context).size.width,
                    child: ref.watch(storyDetailProvider).storyDetailModel !=
                                null &&
                            ref
                                .watch(storyDetailProvider)
                                .storyDetailModel!
                                .storiesDetails!
                                .isNotEmpty
                        ? CommonImage(
                            imageUrl:
                                '${AppUrls.baseUrl}${ref.watch(storyDetailProvider).storyDetailModel!.storiesDetails![0].poster}',
                          )
                        : const SizedBox(),
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
                          .watch(storyDetailProvider)
                          .storyDetailModel!
                          .storiesDetails!
                          .isNotEmpty &&
                          ref
                              .watch(storyDetailProvider)
                              .storyDetailModel!
                              .storiesDetails![0]
                              .city!
                              .isNotEmpty
                          ? "${ref
                          .watch(storyDetailProvider)
                          .storyDetailModel!
                          .storiesDetails![0]
                          .city!} | U/A 7+"
                          :'Premium | U/A 7+',
                      style: TextStyle(
                        fontFamily: Strings.robotoRegular,
                        fontSize: 11.0,
                        color: const Color(0xff535353),
                      ),
                    ),
                    ref.watch(storyDetailProvider).storyDetailModel != null &&
                            ref
                                .watch(storyDetailProvider)
                                .storyDetailModel!
                                .storiesDetails!
                                .isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 7.0),
                            child: Text(
                                        ref
                                            .watch(storyDetailProvider)
                                            .storyDetailModel!
                                            .storiesDetails!
                                            .isNotEmpty &&
                                        ref
                                            .watch(storyDetailProvider)
                                            .storyDetailModel!
                                            .storiesDetails![0]
                                            .name!
                                            .isNotEmpty
                                    ? ref
                                        .watch(storyDetailProvider)
                                        .storyDetailModel!
                                        .storiesDetails![0]
                                        .name!
                                    : '',
                                style: TextStyle(
                                  fontFamily: Strings.robotoMedium,
                                  fontSize: 20.0,
                                  color: const Color(0xff272727),
                                )),
                          )
                        : const SizedBox(),
                    Text(
                      ref
                          .watch(storyDetailProvider)
                          .storyDetailModel!
                          .storiesDetails!
                          .isNotEmpty &&
                          ref
                              .watch(storyDetailProvider)
                              .storyDetailModel!
                              .storiesDetails![0]
                              .updatedAt!
                              .isNotEmpty
                          ? ref
                          .watch(storyDetailProvider)
                          .storyDetailModel!
                          .storiesDetails![0]
                          .updatedAt!
                          :'9:35  | 30 Nov, 2022',
                      style: TextStyle(
                        fontFamily: Strings.robotoRegular,
                        fontSize: 11.0,
                        color: const Color(0xff535353),
                      ),
                    ),
                    // ref.watch(storyDetailProvider).storyDetailModel != null &&
                    //         ref
                    //             .watch(storyDetailProvider)
                    //             .storyDetailModel!
                    //             .storiesDetails!
                    //             .isNotEmpty
                    //     ? Padding(
                    //         padding:
                    //             const EdgeInsets.only(top: 10.0, bottom: 7.0),
                    //         child: HtmlWidget(
                    //           ref
                    //                   .watch(storyDetailProvider)
                    //                   .storyDetailModel!
                    //                   .storiesDetails![0]
                    //                   .description!
                    //                   .isNotEmpty
                    //               ? '${ref.watch(storyDetailProvider).storyDetailModel!.storiesDetails![0].description!}.....'
                    //               : '',
                    //           textStyle: TextStyle(
                    //             fontFamily: Strings.robotoMedium,
                    //             fontSize: 13.0,
                    //             letterSpacing: 0.6,
                    //             color: const Color(0xff272727),
                    //           ),
                    //         ),
                    //       )
                    //     : const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ABButton(
                            paddingTop: 10.0,
                            paddingBottom: 15.0,
                            paddingLeft: 10.0,
                            paddingRight: 10.0,
                            text: 'Start Reading',
                            onPressed: () {
                              Navigator.of(context).push(_createRoute(
                                  ref
                                      .watch(storyDetailProvider)
                                      .storyDetailModel!
                                      .storiesDetails![0]
                                      .id
                                      .toString(),
                                  ref
                                      .watch(storyDetailProvider)
                                      .storyDetailModel!
                                      .storiesDetails![0]
                                      .longDescription!
                                      .toString()));
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
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 25, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Related Stories',
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
                    //   MaterialPageRoute(builder: (context) => const MusicListView()),
                    // );
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
              height: 230,
              child: ref.watch(storyDetailProvider).suggestStoryModel != null &&
                      ref
                          .watch(storyDetailProvider)
                          .suggestStoryModel!
                          .suggestlist!
                          .isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ref
                          .watch(storyDetailProvider)
                          .suggestStoryModel!
                          .suggestlist!
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StoriesDetailView(
                                      storyId: ref
                                          .watch(storyDetailProvider)
                                          .suggestStoryModel!
                                          .suggestlist![index]
                                          .id
                                          .toString())),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: SizedBox(
                                    height: 170,
                                    width: 140,
                                    child: CommonImage(
                                      imageUrl:
                                          '${AppUrls.baseUrl}${ref.watch(storyDetailProvider).suggestStoryModel!.suggestlist![index].poster}',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  ref
                                      .watch(storyDetailProvider)
                                      .suggestStoryModel!
                                      .suggestlist![index]
                                      .name!,
                                  style: TextStyle(
                                      fontFamily: Strings.robotoMedium,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                      color: Colors.black),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        );
                      })
                  : const SizedBox(),
            )
          ],
        ),
      ),
    );
  }

  Route _createRoute(String storyId, String story) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          StoriesReadView(storyId: storyId, story: story),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
