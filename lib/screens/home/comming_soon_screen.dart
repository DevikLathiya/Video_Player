import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/screens/home/more_view.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:hellomegha/screens/notifications_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/notifier/providers.dart';
import '../search/search.dart';
import 'commingsoon_movie_detail_view.dart';

class CommingSoonView extends ConsumerStatefulWidget {
  const CommingSoonView({Key? key}) : super(key: key);

  @override
  ConsumerState<CommingSoonView> createState() => _CommingSoonViewState();
}

class _CommingSoonViewState extends ConsumerState<CommingSoonView> {
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

  TextStyle textStyle = TextStyle(
      fontFamily: Strings.robotoMedium,
      fontWeight: FontWeight.bold,
      fontSize: 21.0,
      color: Colors.black);

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
              'Coming Soon',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: Strings.robotoMedium,
                  fontSize: 21.0,
                  color: Colors.black),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              search("Movies")));
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Icon(Icons.search_rounded),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const NotificationsView()));
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Icon(Icons.notifications_none),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MoreView()),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFECC00),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child:
                      Icon(Icons.person_rounded, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
            // actions: [
            //   GestureDetector(
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) =>
            //                   search("Short film")));
            //     },
            //     child: const Padding(
            //       padding: EdgeInsets.only(right: 15.0),
            //       child: Icon(Icons.search_rounded),
            //     ),
            //   ),
            //   GestureDetector(
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) =>
            //               const NotificationsView()));
            //     },
            //     child: const Padding(
            //       padding: EdgeInsets.only(right: 15.0),
            //       child: Icon(Icons.notifications_none),
            //     ),
            //   ),
            //   Padding(
            //     padding: const EdgeInsets.only(right: 15.0),
            //     child: GestureDetector(
            //       onTap: (){
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => const MoreView()),
            //         );
            //       },
            //       child: Container(
            //         decoration: const BoxDecoration(
            //           shape: BoxShape.circle,
            //           color: Color(0xFFFECC00),
            //         ),
            //         child: const Padding(
            //           padding: EdgeInsets.all(4.0),
            //           child:
            //           Icon(Icons.person_rounded, color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   )
            // ],
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   mainAxisSize: MainAxisSize.max,
            //   children: [
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     Image.asset(
            //       "assets/popcorn.png",
            //       height: 35,
            //       width: 35,
            //     ),
            //     const SizedBox(width: 5),
            //     Text(
            //       Strings.commingSoon.tr,
            //       style: TextStyle(
            //           fontFamily: Strings.robotoMedium,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 21.0,
            //           color: Colors.black),
            //     )
            //   ],
            // ),
            // const SizedBox(height: 15),
            ref.watch(commingSoonProvider).commingSoonMovieListModel != null &&
                    ref
                            .watch(commingSoonProvider)
                            .commingSoonMovieListModel
                            ?.data
                            ?.movielist
                            ?.isNotEmpty ==
                        true
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: ref
                            .watch(commingSoonProvider)
                            .commingSoonMovieListModel
                            ?.data
                            ?.movielist
                            ?.length ??
                        0,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      print(" HY HEY ");
                      return commonCardView(
                        index:index,
                          id: ref
                              .watch(commingSoonProvider)
                              .commingSoonMovieListModel
                              ?.data
                              ?.movielist?[index]
                              ?.id
                              .toString(),
                          reminder: ref
                              .watch(commingSoonProvider)
                              .commingSoonMovieListModel
                              ?.data
                              ?.movielist?[index]
                              ?.isReminder,
                          title: ref
                              .watch(commingSoonProvider)
                              .commingSoonMovieListModel
                              ?.data
                              ?.movielist?[index]
                              ?.name,
                          date: "02",
                          imgPath: ref
                              .watch(commingSoonProvider)
                              .commingSoonMovieListModel
                              ?.data
                              ?.movielist?[index]
                              ?.poster,
                          description: ref
                              .watch(commingSoonProvider)
                              .commingSoonMovieListModel
                              ?.data
                              ?.movielist?[index]
                              ?.description,
                          longDescription: ref
                              .watch(commingSoonProvider)
                              .commingSoonMovieListModel
                              ?.data
                              ?.movielist?[index]
                              ?.longDescription,
                          month: "APR",
                          onTap: () {
                            ref.watch(commingSoonProvider).setReminderMovie(
                              context: context,
                              movieID: ref
                                  .watch(commingSoonProvider)
                                  .commingSoonMovieListModel
                                  ?.data
                                  ?.movielist?[index]
                                  ?.id
                                  .toString(),
                              reminder: ref
                                  .watch(commingSoonProvider)
                                  .commingSoonMovieListModel
                                  ?.data
                                  ?.movielist?[index]
                                  ?.isReminder ==
                                  0
                                  ? 1
                                  : 0,
                            );
                            if (ref
                                    .watch(commingSoonProvider)
                                    .commingSoonMovieListModel
                                    ?.data
                                    ?.movielist?[index]
                                    ?.isReminder ==
                                0) {
                              ref
                                  .watch(commingSoonProvider)
                                  .commingSoonMovieListModel
                                  ?.data
                                  ?.movielist?[index]
                                  ?.isReminder = 1;
                            } else {
                              ref
                                  .watch(commingSoonProvider)
                                  .commingSoonMovieListModel
                                  ?.data
                                  ?.movielist?[index]
                                  ?.isReminder = 0;
                            }
                            setState(() {});
                          });
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  commonCardView(
      {Function? onTap,
      String? id,
      int? reminder,
      int? index,
      String? date,
      String? month,
      String? imgPath,
      String? title,
      String? description,
      String? longDescription}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffa3ba29).withOpacity(0.6),
          borderRadius: BorderRadius.circular(15),
          // border: Border.all(color: Colors.black)
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                  text: "$month",
                  style: textStyle.copyWith(fontSize: 16),
                  children: [
                    TextSpan(
                      text: "\n",
                      style: textStyle,
                    ),
                    TextSpan(
                      text: "$date",
                      style: textStyle.copyWith(fontSize: 38),
                    ),
                  ]),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommingSoonMoviesDetailView(
                                movieId: id!,remider: reminder,index:index)),
                      );
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(fit: BoxFit.cover,
                          image: NetworkImage(
                            "$imgPath",
                            // height: 250,
                          ),
                        ),
                      ),
                      // child: Image.network(
                      //   "$imgPath",
                      //   height: 200,
                      // fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "$title",
                          maxLines:1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle.copyWith(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      // const Spacer(),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                              onTap: () {
                                if (onTap != null) onTap();
                              },
                              child: reminder == 1
                                  ? const Icon(Icons.check, size: 28)
                                  : const Icon(Icons.notifications, size: 28)),
                          Text(
                            reminder == 1
                                ? Strings.reminded.tr
                                : Strings.remindMe.tr,
                            style: const TextStyle(
                                fontSize: 12,fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      // Column(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     const Icon(Icons.info_outline, size: 28),
                      //     Text(
                      //       Strings.info.tr,
                      //       style: const TextStyle(
                      //           fontSize: 12, fontWeight: FontWeight.w500),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(width: 10),
                      // Image.asset("assets/bell.png"),
                      // Image.asset("assets/bell.png")
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Text(
                  //   overflow: TextOverflow.ellipsis,
                  //   "$description",
                  //   style: textStyle.copyWith(
                  //       fontSize: 16, fontWeight: FontWeight.w700),
                  // ),
                  // const SizedBox(height: 5),
                  Text(
                    "$longDescription",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15),
                  ),
                  /*Row(
                    children: [
                      Text(
                        "Nostalgic",
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        "Nostalgic",
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        "Nostalgic",
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        "Nostalgic",
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
