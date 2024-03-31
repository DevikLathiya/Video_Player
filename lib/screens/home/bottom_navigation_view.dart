import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/music/music_player_activity.dart';
import 'package:hellomegha/screens/CommonWebView.dart';
import 'package:hellomegha/screens/DownloadAllList.dart';
import 'package:hellomegha/screens/home/downloads_list_view.dart';
import 'package:hellomegha/screens/home/home_view.dart';
import 'package:hellomegha/screens/home/more_view.dart';
import 'package:hellomegha/screens/home/stories_list_view.dart';
import 'package:hellomegha/screens/home/streaming_list_view.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:hellomegha/screens/notifications_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import '../../core/api_factory/prefs/pref_utils.dart';
import '../search/search.dart';
import 'comming_soon_screen.dart';
import 'package:get/get.dart';
class BottomNavigationView extends ConsumerStatefulWidget {
  const BottomNavigationView({Key? key, this.index}) : super(key: key);
  final int? index;

  @override
  ConsumerState<BottomNavigationView> createState() =>
      _BottomNavigationViewState();
}

class _BottomNavigationViewState extends ConsumerState<BottomNavigationView> {
  List<Widget> _views = [];
  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (ref.watch(baseViewModel).selectedIndex != 0) {
      ref.watch(baseViewModel).selectedIndex = 0;
    } else {
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        showSnackBar(
            context: context, message: "Please press back again to Exit".tr);
        return Future.value(false);
      }
      return Future.value(true);
    }
    return Future.value(false);
  }
  int n=0;

  // void callApi() {
  //   Future.delayed(const Duration(seconds: 1), () {
  //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //       ref.watch(notificationViewModel).notificationAPI(context: context);
  //       // if(ref.watch(notificationViewModel).notificationModel != null &&
  //       //     ref.watch(notificationViewModel).notificationModel!.notifications != null  )
  //         {
  //           callApi();
  //           PrefUtils.setNoti(ref.watch(notificationViewModel).notificationModel!.notifications!.length);
  //           n=await PrefUtils.getNoti();
  //           print("Hello $n");
  //           if(n>ref.watch(notificationViewModel).notificationModel!.notifications!.length)
  //             {
  //               PrefUtils.setNoti(ref.watch(notificationViewModel).notificationModel!.notifications!.length);
  //               showSimpleNotification(
  //                   Text("${ref
  //                       .watch(notificationViewModel)
  //                       .notificationModel!
  //                       .notifications![ref
  //                       .watch(notificationViewModel)
  //                       .notificationModel!
  //                       .notifications!.length-1].name}"),
  //                   background: Colors.green);
  //             }
  //
  //         }
  //
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    ref.read(baseViewModel).onInit();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (widget.index != null) {
    //     ref.watch(baseViewModel).selectedIndex = widget.index!;
    //   }
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.index != null && widget.index==1) {
        ref.watch(baseViewModel).selectedIndex = widget.index!;
      }
      else
      {
        Connectivity().checkConnectivity().then((value) {
          if (value == ConnectivityResult.none) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
          }
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // callApi();
  }

  @override
  Widget build(BuildContext context) {
    _views = [const HomeView(), const DownloadAllList(), const MoreView()];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ref.watch(baseViewModel).selectedIndex == 1
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(75.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppBar(
                  leadingWidth: 170,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        height: 27,
                        child: Image.asset('assets/logo.png', fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  actions: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => search()));
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
                      child:const Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Icon(Icons.notifications_none),
                      )
                      // ref.watch(notificationViewModel).notificationModel!.notifications!.length>n
                      //         ? const Padding(
                      //             padding: EdgeInsets.only(right: 15.0),
                      //             child: Icon(Icons.notifications_none),
                      //           )
                      //         : Padding(
                      //             padding: EdgeInsets.only(right: 15.0),
                      //             child: Icon(Icons.notification_add),
                      //           ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MoreView()),
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
                  iconTheme: const IconThemeData(color: Colors.black),
                ),
              ),
            ),
      body: WillPopScope(
          onWillPop: onWillPop,
          child: _views[ref.watch(baseViewModel).selectedIndex]),
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         Expanded(
      //           child: Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: ElevatedButton(
      //                 onPressed: () {
      //                   jumpToLivePage(context, isHost: true);
      //                 },
      //                 child: const Text('Start a live')),
      //           ),
      //         ),
      //         Expanded(
      //           child: Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: ElevatedButton(
      //                 onPressed: () {
      //                   jumpToLivePage(context, isHost: false);
      //                 },
      //                 child: const Text('Watch a live')),
      //           ),
      //         )
      //       ],
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: ElevatedButton(
      //           onPressed: () {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => WelcomeScreen(),
      //               ),
      //             );
      //           },
      //           child: const Text('Quiz')),
      //     )
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFECC00),
        onPressed: () {
          ref.watch(baseViewModel).selectedIndex = 0;
        },
        child: const Icon(
          Icons.home_outlined,
          color: Colors.black,
        ), //icon inside button
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shape: const CircularNotchedRectangle(),
        notchMargin: 3,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StoriesListView()),
                  );
                },
                child: SizedBox(
                  height: 50,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.movie_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
                      Text(
                        'Stories'.tr,
                        style: TextStyle(
                            fontFamily: Strings.robotoMedium,
                            fontSize: 11.0,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Expanded(
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const StreamingListView()),
            //       );
            //     },
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         const Icon(
            //           Icons.live_tv_rounded,
            //           color: Colors.white,
            //           size: 25,
            //         ),
            //         Text(
            //           'Live Stream'.tr,
            //           style: TextStyle(
            //               fontFamily: Strings.robotoMedium,
            //               fontSize: 11.0,
            //               color: Colors.white),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MusicPlayerScreen(categoryType: "Music",albumId: "",image: "",title: "", description: "",play: true,)),
                  );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const StreamingListView()),
                  // );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.music_note_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                    Text(
                      'Music'.tr,
                      style: TextStyle(
                          fontFamily: Strings.robotoMedium,
                          fontSize: 11.0,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DownloadAllList()),
                  );
                  // ref.read(baseViewModel).selectedIndex = 1;

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const DownloadListView()),
                  // );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.downloading_sharp,
                      color: Colors.white,
                      size: 25,
                    ),
                    Text(
                      'Downloads'.tr,
                      style: TextStyle(
                          fontFamily: Strings.robotoMedium,
                          fontSize: 11.0,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommingSoonView()),
                    // MaterialPageRoute(builder: (context) => const MoreView()),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 25,
                    ),
                    Text(
                      'Coming Soon'.tr,
                      style: TextStyle(
                          fontFamily: Strings.robotoMedium,
                          fontSize: 11.0,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // jumpToLivePage(BuildContext context,String type, {required bool isHost}) {
  //   var userId = ref.watch(baseViewModel).kCurrentUser!.firstname != null
  //       ? "${ref.watch(baseViewModel).kCurrentUser?.firstname!}"
  //       : Random().nextInt(1000).toString();
  //   var lastname = ref.watch(baseViewModel).kCurrentUser!.lastname != null
  //       ? "${ref.watch(baseViewModel).kCurrentUser?.lastname!}"
  //       : Random().nextInt(1000).toString();
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) =>
  //           LivePage(type: type,liveID: 'testliveID89', isHost: isHost, userID: userId,lastname: lastname,),
  //     ),
  //   );
  // }
}

//final String userID = Random().nextInt(1000).toString();

class LivePage extends ConsumerStatefulWidget {
  final String liveID;
  final String userID;
  final String lastname;
  final String type;
  final String link;
  final String name;
  final bool isHost;

  const LivePage(
      {Key? key,
      required this.liveID,
      required this.type,
      this.isHost = false,
      required this.userID,
      required this.lastname,
      required this.link,
      required this.name,
      })
      : super(key: key);

  @override
  ConsumerState<LivePage> createState() => _LivePageState();
}

class _LivePageState extends ConsumerState<LivePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: widget.type=="ZCLOUD"?
      ZegoUIKitPrebuiltLiveStreaming(
          appID: 773879451,
          // Fill in the appID that you get from ZEGOCLOUD Admin Console.
          appSign:
          '8aa4a6c8d2ab2458221b866d726a428b490551e88a008dce61e21e4eb0cef133',
          // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
          userID: widget.userID,
          userName: widget.isHost
          // ? 'admin_${widget.userID}'
              ? '${widget.userID} ${widget.lastname}'
              : '${widget.userID} ${widget.lastname}',
          liveID: widget.liveID,
          config: widget.isHost
              ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
              : ZegoUIKitPrebuiltLiveStreamingConfig.audience()
            ..onLeaveConfirmation = (BuildContext context) async {
              return await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    title: const Text("Are you sure ?",
                        style: TextStyle(color: Colors.black)),
                    content: const Text("Live will stop",
                        style: TextStyle(color: Colors.black)),
                    actions: [
                      ElevatedButton(
                        child: const Text("Cancel",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      ElevatedButton(
                          child: const Text("Exit"),
                          onPressed: () {
                            if (widget.isHost) {
                              ref
                                  .watch(liveStreamProvider)
                                  .liveStreamStatusTwoAPI(
                                  context: context,
                                  status: '3',
                                  liveStreamId: widget.liveID);
                            } else {
                              Navigator.of(context).pop(true);
                            }
                          }),
                    ],
                  );
                },
              );
            }):
      CommonWebView(
        title: '${widget.name}',
        url: "${widget.link}",
      ),
    );
  }
}
