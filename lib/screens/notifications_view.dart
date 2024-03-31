import 'package:flutter/material.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/home/musiv_video_detail_view.dart';
import 'package:hellomegha/screens/home/scheme_detail_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get/get.dart';
import 'home/influncer_detail_view.dart';
import 'home/movie_detail_view.dart';
import 'package:html/parser.dart';

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends ConsumerState<NotificationsView> {
  List<String> movies = [
    "https://www.joblo.com/wp-content/uploads/2012/04/oblivion-Imax-poster-4-9-1.jpg",
    "https://upload.wikimedia.org/wikipedia/en/1/19/Iron_Man_3_poster.jpg",
    "https://www.asparkleofgenius.com/wp-content/uploads/2017/03/image003.jpg",
    "https://wallup.net/wp-content/uploads/2019/07/24/748894-spider-man-superhero-marvel-spider-man-action-spiderman-poster-748x997.jpg",
    "https://wallpapersmug.com/download/1600x900/b41742/thanos-and-the-black-order.jpg",
    "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/dramatic-movie-poster-template-design-f0f2c261e077379d0f82604f96b6a774_screen.jpg?ts=1602570456",
    "https://www.joblo.com/wp-content/uploads/2012/04/oblivion-Imax-poster-4-9-1.jpg",
    "https://upload.wikimedia.org/wikipedia/en/1/19/Iron_Man_3_poster.jpg",
    "https://www.asparkleofgenius.com/wp-content/uploads/2017/03/image003.jpg",
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(notificationViewModel).notificationAPI(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 3.0),
                child: SizedBox(
                  height: 27,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              'Notifications'.tr,
              style: TextStyle(
                  fontFamily: Strings.robotoMedium,
                  fontSize: 21.0,
                  color: Colors.black),
            ),
            // actions: [
            //   // const Padding(
            //   //   padding: EdgeInsets.only(right: 15.0),
            //   //   child: Icon(Icons.search_rounded),
            //   // ),
            //   Padding(
            //     padding: const EdgeInsets.only(right: 15.0),
            //     child: Container(
            //       decoration: const BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: Color(0xFFFECC00),
            //       ),
            //       child: const Padding(
            //         padding: EdgeInsets.all(4.0),
            //         child: Icon(Icons.person_rounded, color: Colors.white),
            //       ),
            //     ),
            //   )
            // ],
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body: ref.watch(notificationViewModel).notificationModel != null &&
          ref
              .watch(notificationViewModel)
              .notificationModel!
              .notifications !=
              null
          ? SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: ref
                .watch(notificationViewModel)
                .notificationModel!
                .notifications!
                .length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                    onTap: () {
                      if (ref
                          .watch(notificationViewModel)
                          .notificationModel!
                          .notifications![index]
                          .type ==
                          'Schemes') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SchemeDetailView(
                                  videoId: ref
                                      .watch(notificationViewModel)
                                      .notificationModel!
                                      .notifications![index]
                                      .movieId!
                                      .toString())),
                        );
                      } else if (ref
                          .watch(notificationViewModel)
                          .notificationModel!
                          .notifications![index]
                          .type ==
                          'Short film') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoviesDetailView(
                                  movieId: ref
                                      .watch(notificationViewModel)
                                      .notificationModel!
                                      .notifications![index]
                                      .movieId!
                                      .toString())),
                        );
                      }else if (ref
                          .watch(notificationViewModel)
                          .notificationModel!
                          .notifications![index]
                          .type ==
                          'Music Video') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MusicVideoDetailView(
                                  movieId: ref
                                      .watch(notificationViewModel)
                                      .notificationModel!
                                      .notifications![index]
                                      .movieId!
                                      .toString())),
                        );
                      } else if (ref
                          .watch(notificationViewModel)
                          .notificationModel!
                          .notifications![index]
                          .type ==
                          'Influencer') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfluncerDetailView(
                                  videoId: ref
                                      .watch(notificationViewModel)
                                      .notificationModel!
                                      .notifications![index]
                                      .movieId!
                                      .toString())),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoviesDetailView(
                                  movieId: ref
                                      .watch(notificationViewModel)
                                      .notificationModel!
                                      .notifications![index]
                                      .nId!
                                      .toString())),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: SizedBox(
                              width: 125.0,
                              height: 70,
                              child: CommonImage(
                                  imageUrl: ref
                                      .watch(notificationViewModel)
                                      .notificationModel!
                                      .notifications![index]
                                      .image!)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                      ref
                                          .watch(notificationViewModel)
                                          .notificationModel!
                                          .notifications![index]
                                          .name!,
                                      style: TextStyle(
                                        fontFamily: Strings.robotoRegular,
                                        fontSize: 16.0,
                                        color: const Color(0xff272727),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, bottom: 4.0),
                                    child: Text(
                                      parse(parse("${ref
                                          .watch(
                                          notificationViewModel)
                                          .notificationModel!
                                          .notifications![index]
                                          .description==null ? '':ref
                                          .watch(
                                          notificationViewModel)
                                          .notificationModel!
                                          .notifications![index]
                                          .description}").body!.text).documentElement!.text,
                                      style: TextStyle(
                                        fontFamily: Strings.robotoRegular,
                                        fontSize: 13.0,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 3,
                                    ),
                                  ),
                                  Text('Dec ${index + 1}',
                                      style: TextStyle(
                                        fontFamily: Strings.robotoMedium,
                                        fontSize: 11.0,
                                        color: Colors.grey,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
              );
            }),
      )
          : const SizedBox(),
    );
  }
}
