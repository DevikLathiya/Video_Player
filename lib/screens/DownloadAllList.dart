import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/theme_config.dart';
import 'package:hellomegha/music/DownloadMusicListView.dart';
import 'package:hellomegha/screens/home/bottom_navigation_view.dart';
import 'package:hellomegha/screens/home/downloads_list_view.dart';
import 'package:hellomegha/screens/home/model/download_model.dart';
import 'package:hellomegha/screens/home/more_view.dart';
import 'package:hellomegha/screens/search/search.dart';
import 'package:just_audio/just_audio.dart';
import 'package:localstorage/localstorage.dart';

import '../models/searchmusicmodel.dart';
import 'home/video_player_view.dart';
import 'notifications_view.dart';

import 'package:hellomegha/screens/no_network.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class DownloadAllList extends StatefulWidget {
  const DownloadAllList({Key? key}) : super(key: key);

  @override
  State<DownloadAllList> createState() => _DownloadAllListState();
}

class _DownloadAllListState extends State<DownloadAllList> {
  final LocalStorage storage = LocalStorage('movies');
  final LocalStorage storage2 = LocalStorage('music');
  int? selectedIndex;
  int? selectedIndex2;
  String directory="";
  int downloadProgress = 0;
  List<FileSystemEntity> file = [];
  List<bool> isFavouritelist=[];
  List<bool>  isDownloadStartedlist=[];
  List<bool>  isDownloadFinishlist=[];
  List<bool>  playlist=[];
  AudioPlayer? player;

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
          player=AudioPlayer();
          playlist =List.filled(200, false);
        }
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(95.0),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: AppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavigationView(index: 0),
                      ));
                  // Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: ThemeColor.yellow_dark,
                ),
              ),
              bottom: TabBar(
                indicatorColor: ThemeColor.yellow_dark,
                labelColor: ThemeColor.yellow_dark,
                tabs: [
                  Tab(text: "Videos",),
                  Tab(text: "Music",),
                ],
              ),
              titleSpacing: 0,
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(
                'Downloads'.tr,
                style: TextStyle(
                    fontFamily: Strings.robotoMedium,
                    fontSize: 21.0,
                    color: Colors.black),
              ),
              // actions: [
              //   GestureDetector(
              //     onTap: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) =>
              //                   search("Leader List")));
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
              iconTheme: const IconThemeData(color: ThemeColor.yellow_dark),
            ),
          ),
        ),
        body:TabBarView(
          children: [
            DownloadListView(),
            DownloadMusicListView(false)
          ],
        )
        // Column(
        //   children: [
        //     Expanded(child: FutureBuilder(
        //         future: storage.ready,
        //         builder: (context, snapshot) {
        //           if (snapshot.hasData) {
        //             // int i = 0;
        //             // List<Download> fillterdMovie = [];
        //             var items = storage.getItem('movies');
        //
        //             if (items != null) {
        //               final movies =
        //               (items as List).map((e) => Download.fromMap(e)).toList();
        //
        //               return movies.isEmpty
        //                   ?SizedBox()
        //               // Center(
        //               // child: Text(
        //               //   "No Downloaded Available".tr,
        //               //   style: TextStyle(
        //               //       fontFamily: Strings.robotoMedium,
        //               //       fontWeight: FontWeight.w600,
        //               //       fontSize: 16.0,
        //               //       color: Colors.black),
        //               // ))
        //                   : SingleChildScrollView(
        //                 child: Column(
        //                   mainAxisSize: MainAxisSize.max,
        //                   children: [
        //                     Padding(
        //                       padding: const EdgeInsets.only(
        //                           left: 20.0, right: 10.0, top: 5, bottom: 5),
        //                       child: Row(children: [
        //                         Expanded(
        //                           child: Text(
        //                             '${movies.length} Downloaded Videos',
        //                             style: TextStyle(
        //                                 fontFamily: Strings.robotoMedium,
        //                                 fontWeight: FontWeight.w600,
        //                                 fontSize: 14.0,
        //                                 color: Colors.black),
        //                           ),
        //                         ),
        //                         Spacer(),
        //                         GestureDetector(
        //                           onTap: () {
        //                             Navigator.push(
        //                               context,
        //                               MaterialPageRoute(builder: (context) => const DownloadListView()),
        //                             );
        //                           },
        //                           child: Text(
        //                             'See More'.tr,
        //                             style: TextStyle(
        //                                 fontFamily: Strings.robotoMedium,
        //                                 fontWeight: FontWeight.w600,
        //                                 fontSize: 14.0,
        //                                 color: const Color(0xFFFECC00)),
        //                           ),
        //                         ),
        //                       ]),
        //                     ),
        //                     Visibility(
        //                       visible: movies.isNotEmpty,
        //                       child: SizedBox(
        //                         height:
        //                         MediaQuery.of(context).size.height * 0.85,
        //                         child: ListView.builder(
        //                             scrollDirection: Axis.horizontal,
        //                             physics: const ScrollPhysics(),
        //                             itemCount: movies.length,
        //
        //                             // gridDelegate:
        //                             // const SliverGridDelegateWithFixedCrossAxisCount(
        //                             //   crossAxisCount: 3,
        //                             //   childAspectRatio: 0.68,
        //                             // ),
        //                             itemBuilder:
        //                                 (BuildContext context, int index) {
        //                               print("====?${movies[index].poster}");
        //                               print("====?${movies[index].movieUrl}");
        //                               return InkWell(
        //                                 onLongPress: () {
        //                                   selectedIndex = index;
        //                                   setState(() {});
        //                                   print(
        //                                       'selected index $selectedIndex');
        //                                   showDialog(
        //                                       context: context,
        //                                       builder: (context) => Dialog(
        //                                           child: IntrinsicHeight(
        //                                               child: Padding(
        //                                                 padding: const EdgeInsets
        //                                                     .symmetric(
        //                                                     horizontal: 18.0,
        //                                                     vertical: 8.0),
        //                                                 child: Column(
        //                                                   children: [
        //                                                     const SizedBox(
        //                                                       height: 25,
        //                                                     ),
        //                                                     Text(
        //                                                       'Are you sure? you want to to delete ${movies[index].movieName}?',
        //                                                       textAlign:
        //                                                       TextAlign.center,
        //                                                     ),
        //                                                     const SizedBox(
        //                                                       height: 25,
        //                                                     ),
        //                                                     Row(
        //                                                       mainAxisAlignment:
        //                                                       MainAxisAlignment
        //                                                           .end,
        //                                                       children: [
        //                                                         TextButton(
        //                                                             onPressed: () {
        //                                                               Get.back();
        //                                                             },
        //                                                             child: Text(
        //                                                               'Cancel'.tr,
        //                                                             )),
        //                                                         const SizedBox(
        //                                                           width: 25,
        //                                                         ),
        //                                                         TextButton(
        //                                                             onPressed: () {
        //                                                               Navigator.pop(
        //                                                                   context);
        //                                                               final files = [
        //                                                                 movies[index]
        //                                                                     .fileName!,
        //                                                                 movies[index]
        //                                                                     .poster!
        //                                                               ]
        //                                                                   .map((path) =>
        //                                                                   File(
        //                                                                       path))
        //                                                                   .toList();
        //
        //                                                               Future.wait(files
        //                                                                   .map((file) =>
        //                                                                   file.delete()));
        //                                                               movies.removeWhere((element) =>
        //                                                               element
        //                                                                   .movieId ==
        //                                                                   movies[index]
        //                                                                       .movieId);
        //                                                               storage.setItem(
        //                                                                   'movies',
        //                                                                   movies
        //                                                                       .map((e) =>
        //                                                                       e.toMap())
        //                                                                       .toList());
        //                                                               print(
        //                                                                   'caled moin length ${movies.length}');
        //
        //                                                               setState(
        //                                                                       () {});
        //                                                             },
        //                                                             child:
        //                                                             Text(
        //                                                               'Delete'.tr,
        //                                                               style: TextStyle(
        //                                                                   color: Colors
        //                                                                       .red),
        //                                                             ))
        //                                                       ],
        //                                                     )
        //                                                   ],
        //                                                 ),
        //                                               )))).then((value) {
        //                                     print('called moin ');
        //                                     selectedIndex = null;
        //                                     setState(() {});
        //                                   });
        //                                 },
        //                                 onTap: () {
        //                                   Navigator.push(
        //                                       context,
        //                                       MaterialPageRoute(
        //                                         builder: (context) =>
        //                                             VideoPlayerView(
        //                                                 filePath: movies[index]
        //                                                     .fileName,
        //                                                 movieName: movies[index]
        //                                                     .movieName ??
        //                                                     "",
        //                                                 isFromNetwork: false),
        //                                       ));
        //                                 },
        //                                 child: Container(
        //                                   width: 125,
        //                                   padding: const EdgeInsets.all(8.0),
        //                                   child: ClipRRect(
        //                                     borderRadius: BorderRadius.circular(7),
        //                                     child: SingleChildScrollView(
        //                                       child: Column(
        //                                         children: [
        //                                           Container(
        //                                             decoration: BoxDecoration(
        //                                                 border: selectedIndex !=
        //                                                     null &&
        //                                                     selectedIndex == index
        //                                                     ? Border.all(
        //                                                     width: 4,
        //                                                     color: Colors.amber)
        //                                                     : null),
        //                                             height: 170,
        //                                             width: MediaQuery.of(context)
        //                                                 .size
        //                                                 .width,
        //                                             child: Image.file(
        //                                                 File(movies[index].poster??""),
        //                                                 errorBuilder: (context, error,
        //                                                     stackTrace) {
        //                                                   print(error);
        //                                                   return Image.asset(
        //                                                     'assets/logo_new.png',
        //                                                     fit: BoxFit.cover,
        //                                                   );
        //                                                 },
        //                                                 fit: BoxFit.cover),
        //                                           ),
        //                                           // Text("${movies[index].poster}")
        //                                         ],
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 ),
        //                               );
        //                             }),
        //                       ),
        //                     )
        //                   ],
        //                 ),
        //               );
        //             } else {
        //               return const SizedBox();
        //             }
        //           } else {
        //             return const Center(
        //               child: Text('No Downloaded Movies avilable'),
        //             );
        //           }
        //         })),
        //     Expanded(child: FutureBuilder(
        //         future: storage2.ready,
        //         builder: (context, snapshot) {
        //           if (snapshot.hasData) {
        //             // int i = 0;
        //             // List<Download> fillterdMovie = [];
        //             var items = storage2.getItem('music');
        //             if (items != null) {
        //               final movies = (items as List).map((e) => AlbumMp3List.fromMap(e)).toList();
        //               return movies.isEmpty?SizedBox()
        //                   // ? Center(
        //                   // child: Text(
        //                   //   "No Downloaded Available".tr,
        //                   //   style: TextStyle(
        //                   //       fontFamily: Strings.robotoMedium,
        //                   //       fontWeight: FontWeight.w600,
        //                   //       fontSize: 16.0,
        //                   //       color: Colors.black),
        //                   // ))
        //                   : SingleChildScrollView(
        //                     child: Column(
        //                       mainAxisSize: MainAxisSize.max,
        //                       children: [
        //                         Padding(
        //                           padding: const EdgeInsets.only(
        //                               left: 20.0, right: 10.0, top: 5, bottom: 5),
        //                           child: Row(children: [
        //                             Expanded(
        //                               child: Text(
        //                                 '${movies.length} Downloaded Music',
        //                                 style: TextStyle(
        //                                     fontFamily: Strings.robotoMedium,
        //                                     fontWeight: FontWeight.w600,
        //                                     fontSize: 14.0,
        //                                     color: Colors.black),
        //                               ),
        //                             ),
        //                             // Spacer(),
        //                             GestureDetector(
        //                               onTap: () {
        //                                 Navigator.push(
        //                                   context,
        //                                   MaterialPageRoute(builder: (context) => const DownloadMusicListView()),
        //                                 );
        //                               },
        //                               child: Text(
        //                                 'See More'.tr,
        //                                 style: TextStyle(
        //                                     fontFamily: Strings.robotoMedium,
        //                                     fontWeight: FontWeight.w600,
        //                                     fontSize: 14.0,
        //                                     color: const Color(0xFFFECC00)),
        //                               ),
        //                             ),
        //                           ]),
        //                         ),
        //                         Visibility(
        //                           visible: movies.isNotEmpty,
        //                           child: SizedBox(
        //                             height: 200,
        //                             child: ListView.builder(
        //                                 scrollDirection: Axis.horizontal,
        //                                 // physics: ScrollPhysics(),
        //                                 itemCount: movies.length,
        //                                 itemBuilder:
        //                                     (BuildContext context, int index) {
        //                                   return InkWell(
        //                                     onLongPress: () {
        //                                       selectedIndex2 = index;
        //                                       setState(() {});
        //                                       print(
        //                                           'selected index $selectedIndex');
        //                                       showDialog(
        //                                           context: context,
        //                                           builder: (context) => Dialog(
        //                                               child: IntrinsicHeight(
        //                                                   child: Padding(
        //                                                     padding: const EdgeInsets
        //                                                         .symmetric(
        //                                                         horizontal: 18.0,
        //                                                         vertical: 8.0),
        //                                                     child: Column(
        //                                                       children: [
        //                                                         const SizedBox(
        //                                                           height: 25,
        //                                                         ),
        //                                                         Text(
        //                                                           'Are you sure? \n\n you want to to delete ${movies[index].title}?',
        //                                                           textAlign:
        //                                                           TextAlign.center,
        //                                                         ),
        //                                                         const SizedBox(
        //                                                           height: 25,
        //                                                         ),
        //                                                         Row(
        //                                                           mainAxisAlignment:
        //                                                           MainAxisAlignment
        //                                                               .end,
        //                                                           children: [
        //                                                             TextButton(
        //                                                                 onPressed: () {
        //                                                                   Get.back();
        //                                                                 },
        //                                                                 child: Text(
        //                                                                   'Cancel'.tr,
        //                                                                 )),
        //                                                             const SizedBox(
        //                                                               width: 25,
        //                                                             ),
        //                                                             TextButton(
        //                                                                 onPressed: () async {
        //                                                                   Navigator.pop(context);
        //                                                                   print(movies[index].id);
        //
        //                                                                   // final files = [movies[index].title!,movies[index].image!].map((path) => File(path)).toList();
        //                                                                   File f=File("${movies[index].file}");
        //                                                                   await f.delete();
        //                                                                   print(movies.length);
        //                                                                   movies.removeWhere((element) => element.id == movies[index].id);
        //                                                                   print(movies.length);
        //                                                                   storage.setItem(
        //                                                                       'music',
        //                                                                       movies
        //                                                                           .map((e) =>
        //                                                                           e.toMap())
        //                                                                           .toList());
        //                                                                   // print(
        //                                                                   //     'caled moin length ${movies.length}');
        //
        //                                                                   setState(
        //                                                                           () {});
        //                                                                   Navigator.pop(context);
        //                                                                   Get.rawSnackbar(
        //                                                                     snackPosition: SnackPosition.BOTTOM,
        //                                                                     backgroundColor: Colors.redAccent,
        //                                                                     message: 'Song Deleted Successfully',
        //                                                                   );
        //                                                                 },
        //                                                                 child:
        //                                                                 Text(
        //                                                                   'Delete'.tr,
        //                                                                   style: TextStyle(
        //                                                                       color: Colors
        //                                                                           .red),
        //                                                                 ))
        //                                                           ],
        //                                                         )
        //                                                       ],
        //                                                     ),
        //                                                   )))).then((value) {
        //                                         print('called moin ');
        //                                         selectedIndex2 = null;
        //                                         setState(() {});
        //                                       });
        //                                     },
        //                                     onTap: () {
        //                                       if (playlist[index]) {
        //                                         player!.pause();
        //                                       }
        //                                       else {
        //                                         player!.setFilePath("${movies[index].file}");
        //                                         player!.play();
        //                                       }
        //                                       setState(() {
        //                                         playlist[index] = !playlist[index];
        //                                       });
        //                                     },
        //                                     child: Container(
        //                                       height: 220,
        //                                       child: Column(
        //                                         // fit: StackFit.loose,
        //                                         // alignment: Alignment.center,
        //                                         children: [
        //                                           Container(
        //                                             width: 125,
        //                                             // color: Colors.black,
        //                                             // padding: const EdgeInsets.all(8.0),
        //                                             child: ClipRRect(
        //                                               borderRadius:
        //                                               BorderRadius.circular(7),
        //                                               child: SingleChildScrollView(
        //                                                 child: Column(
        //                                                   children: [
        //                                                     Container(
        //                                                       decoration: BoxDecoration(
        //                                                           border: selectedIndex !=
        //                                                               null &&
        //                                                               selectedIndex == index
        //                                                               ? Border.all(
        //                                                               width: 4,
        //                                                               color: Colors.amber)
        //                                                               : null),
        //                                                       height: 170,
        //                                                       width: MediaQuery.of(context)
        //                                                           .size
        //                                                           .width,
        //                                                       child: Image.file(
        //                                                           File(movies[index].image??""),
        //                                                           errorBuilder: (context, error,
        //                                                               stackTrace) {
        //                                                             print(error);
        //                                                             return Image.asset(
        //                                                               'assets/logo_new.png',
        //                                                               fit: BoxFit.cover,
        //                                                             );
        //                                                           },
        //                                                           fit: BoxFit.cover),
        //                                                     ),
        //                                                     // Text("${movies[index].poster}")
        //                                                   ],
        //                                                 ),
        //                                               ),
        //                                             ),
        //                                           ),
        //                                           playlist[index] ? Icon(Icons.pause) : Icon(Icons.play_arrow)
        //                                         ],
        //                                       ),
        //                                     ),
        //                                   );
        //                                 }),
        //                           ),
        //                         )
        //
        //                       ],
        //                     ),
        //                   );
        //             } else {
        //               return const SizedBox();
        //             }
        //           } else {
        //             return const Center(
        //               child: Text('No Music available'),
        //             );
        //           }
        //         })),
        //
        //   ],
        // ),
      ),
    );
  }
}