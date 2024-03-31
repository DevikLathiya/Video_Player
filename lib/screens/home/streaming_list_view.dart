import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/theme_config.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/home/bottom_navigation_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class StreamingListView extends ConsumerStatefulWidget {
  const StreamingListView({Key? key}) : super(key: key);

  @override
  ConsumerState<StreamingListView> createState() => _StreamingListViewState();
}

class _StreamingListViewState extends ConsumerState<StreamingListView> {
  List<String> liveStream = [
    "https://www.dreamcast.ae/blog/wp-content/uploads/2019/07/Live-Streaming-vs-Live-Broadcasting_01.png",
    "https://cdn3.vectorstock.com/i/1000x1000/14/52/live-streaming-logo-online-stream-sign-flat-vector-30241452.jpg",
    "https://png.pngtree.com/png-clipart/20201125/ourlarge/pngtree-live-streaming-red-play-button-png-image_2473505.jpg",
    "https://upload.wikimedia.org/wikipedia/en/7/7e/Ice_Age_Scrat_Tales_Poster.jpg",
    "https://lumiere-a.akamaihd.net/v1/images/p_frozen_18373_3131259c.jpeg?region=0%2C0%2C540%2C810",
    "https://lumiere-a.akamaihd.net/v1/images/p_frankenweenie2012_20501_06183b98.jpeg",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(liveStreamProvider).liveListAPI(context: context);
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
    });
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
              overflow: TextOverflow.ellipsis,
              'Streaming',
              style: TextStyle(
                  fontFamily: Strings.robotoMedium,
                  fontSize: 21.0,
                  color: Colors.black),
            ),
            actions: [
              const Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Icon(Icons.search_rounded),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Icon(Icons.notifications_none),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFECC00),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.person_rounded, color: Colors.white),
                  ),
                ),
              )
            ],
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ref.watch(liveStreamProvider).liveStreamList != null &&
                ref
                    .watch(liveStreamProvider)
                    .liveStreamList!
                    .livestream!
                    .isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 10.0, top: 5, bottom: 5),
                    child: Text(
                      '${ref.watch(liveStreamProvider).liveStreamList!.livestream!.length} Streaming',
                      style: TextStyle(
                          fontFamily: Strings.robotoMedium,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: Colors.black),
                    )
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ScrollPhysics(),
                      itemCount: ref
                          .watch(liveStreamProvider)
                          .liveStreamList!
                          .livestream!
                          .length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.77,
                      ),
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
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: SizedBox(
                                    height: 170,
                                    width: MediaQuery.of(context).size.width,
                                    child: CommonImage(
                                        imageUrl: ref
                                            .watch(liveStreamProvider)
                                            .liveStreamList!
                                            .livestream![index]
                                            .image
                                            .toString()),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  ref
                                      .watch(liveStreamProvider)
                                      .liveStreamList!
                                      .livestream![index]
                                      .userName
                                      .toString(),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: Strings.robotoRegular,
                                      fontSize: 14.0,
                                      color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        );
                      })
                ],
              )
            : const SizedBox(),
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
                child: Text('Live Stream',
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
                child: Text('Live stream will start soon...',
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
                        child: Text('OK',
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
                child: Text('Live Stream',
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
                child: Text('Click on watch live',
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
                        jumpToLivePage(context,type, name,link: link,isHost: false, liveId: liveId);
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

  jumpToLivePage(BuildContext context,String type,String name,
      {required bool isHost, required String liveId, required String link}) {
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
            LivePage(name:name,link: link,type:type,liveID: liveId, isHost: isHost, userID: userId,lastname: lastname,),
      ),
    );
  }
}
