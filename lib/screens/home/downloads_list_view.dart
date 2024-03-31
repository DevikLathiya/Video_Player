import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/screens/home/model/download_model.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:localstorage/localstorage.dart';

import 'video_player_view.dart';

class DownloadListView extends StatefulWidget {
  const DownloadListView({Key? key}) : super(key: key);

  @override
  State<DownloadListView> createState() => _DownloadListViewState();
}

class _DownloadListViewState extends State<DownloadListView> {
  final LocalStorage storage = LocalStorage('movies');

  int? selectedIndex;

  @override
  void didChangeDependencies() {
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }

    });

    super.didChangeDependencies();
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
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              'Downloads'.tr,
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
      body: FutureBuilder(
          future: storage.ready,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // int i = 0;
              // List<Download> fillterdMovie = [];
              var items = storage.getItem('movies');

              if (items != null) {
                final movies =
                    (items as List).map((e) => Download.fromMap(e)).toList();

                return movies.isEmpty
                    ? Center(
                        child: Text(
                        "No Downloaded Available".tr,
                        style: TextStyle(
                            fontFamily: Strings.robotoMedium,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.black),
                      ))
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 10.0, top: 5, bottom: 5),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    '${movies.length} Items',
                                    style: TextStyle(
                                        fontFamily: Strings.robotoMedium,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                        color: Colors.black),
                                  ),
                                ),
                              ]),
                            ),
                            Visibility(
                              visible: movies.isNotEmpty,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.85,
                                child: GridView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: const ScrollPhysics(),
                                    itemCount: movies.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 0.68,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onLongPress: () {
                                          selectedIndex = index;
                                          setState(() {});
                                          showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                      child: IntrinsicHeight(
                                                          child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 18.0,
                                                        vertical: 8.0),
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 25,
                                                        ),
                                                        Text(
                                                          'Are you sure? you want to to delete ${movies[index].movieName}?',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        const SizedBox(
                                                          height: 25,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                child: Text(
                                                                  'Cancel'.tr,
                                                                )),
                                                            const SizedBox(
                                                              width: 25,
                                                            ),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  final files = [
                                                                    movies[index]
                                                                        .fileName!,
                                                                    movies[index]
                                                                        .poster!
                                                                  ]
                                                                      .map((path) =>
                                                                          File(
                                                                              path))
                                                                      .toList();

                                                                  Future.wait(files
                                                                      .map((file) =>
                                                                          file.delete()));
                                                                  movies.removeWhere((element) =>
                                                                      element
                                                                          .movieId ==
                                                                      movies[index]
                                                                          .movieId);
                                                                  storage.setItem(
                                                                      'movies',
                                                                      movies
                                                                          .map((e) =>
                                                                              e.toMap())
                                                                          .toList());

                                                                  setState(
                                                                      () {});
                                                                },
                                                                child: Text(
                                                                  'Delete'.tr,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )))).then((value) {
                                            selectedIndex = null;
                                            setState(() {});
                                          });
                                        },
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoPlayerView(
                                                movieName:
                                                    movies[index].movieName ??
                                                        "",
                                                movies: movies,
                                                currentDownloadedMovieIndex:
                                                    index,
                                                isFromNetwork: false,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: selectedIndex !=
                                                                    null &&
                                                                selectedIndex ==
                                                                    index
                                                            ? Border.all(
                                                                width: 4,
                                                                color: Colors
                                                                    .amber)
                                                            : null),
                                                    height: 170,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Image.file(
                                                        File(movies[index]
                                                                .poster ??
                                                            ""),
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            Image.asset(
                                                              'assets/logo_new.png',
                                                              fit: BoxFit.cover,
                                                            ),
                                                        fit: BoxFit.cover),
                                                  ),
                                                  // Text("${movies[index].poster}")
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),
                      );
              } else {
                return const SizedBox();
              }
            } else {
              return const Center(
                child: Text('No Downloaded Movies avilable'),
              );
            }
          }),
    );
  }
}
