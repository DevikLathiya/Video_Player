import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'dart:io' as io;
import 'package:audio_session/audio_session.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/theme_config.dart';
import 'package:hellomegha/models/latest_music_detail_model.dart';
import 'package:hellomegha/models/searchmusicmodel.dart';
import 'package:hellomegha/music/SearchMusic/SearchMusicFile.dart';
import 'package:hellomegha/music/common.dart';
import 'package:hellomegha/music/music_player_activity.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/screens/home/model/download_model.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../screens/home/more_view.dart';
import '../screens/notifications_view.dart';

class DownloadMusicListView extends StatefulWidget {
  bool appbar;

  DownloadMusicListView(this.appbar);
  @override
  State<DownloadMusicListView> createState() => _DownloadMusicListViewState();
}

class _DownloadMusicListViewState extends State<DownloadMusicListView> {
  int? selectedIndex;
  String directory="";
  int downloadProgress = 0;
  List<FileSystemEntity> file = [];
  LocalStorage storage = LocalStorage('music');
  List<bool> isFavouritelist=[];
  List<bool>  isDownloadStartedlist=[];
  List<bool>  isDownloadFinishlist=[];
  List<bool>  playlist=[];
  AudioPlayer? player;
  ConcatenatingAudioSource? _playlist;
  hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player=AudioPlayer();
    var items = storage.getItem('music');
    if (items != null) {
      final movies = (items as List)
          .map((e) => AlbumMp3List.fromMap(e))
          .toList();
      print("=>$movies");
      playlist = List.filled(movies.length, false);
      _addPlayListContent(movies);
    }

  }

  int id = 0;
  showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SizedBox(
          height: 50.0.h,
          width: 50.0.w,
          child: const FittedBox(
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
  Future<void> _addPlayListContent(List<AlbumMp3List> movies) async {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
      // showLoading(context);
    }));
    player!.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    _playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
        useLazyPreparation: true,
        // Customise the shuffle algorithm
        shuffleOrder: DefaultShuffleOrder(),
        children: [],
    );

    setState(() async {
      for (int i = 0; i < movies.length; i++) {
        print("length=$i");
        _playlist!.add(AudioSource.file(movies[i].file!,
            tag:MediaItem(
              id: movies[i].id.toString(),
              album: movies[i].title,
              title: movies[i].title.toString(),
              // artUri: Uri.parse(movies[i].image!)
            ) ));
      }
      print("audio=$_playlist");
      print("audio=${_playlist!.children}");

      // hideLoading(context);
      // _init(_playlist!);
      final session = await AudioSession.instance;
      session.configure(const AudioSessionConfiguration.speech());
      // Listen to errors during playback.
      player!.playbackEventStream.listen((event) {},
          onError: (Object e, StackTrace stackTrace) {
            print('A stream error occurred: $e');
          });
      print("=play=${player!.playing}");
      try {
        if (player!.playing) {
        } else {
          player!.setAudioSource(_playlist!);
        }
      } catch (e, stackTrace) {
        // Catch load errors: 404, invalid url ...
        print("Error loading playlist: $e");
        print(stackTrace);
      }
      if (player!.playerState.playing == true) {
        print("========================================>");
      } else {
        print("========================================+");
      }
    });
  }
  Stream<PositionData> get _positionDataStream =>
      rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player!.positionStream,
          player!.bufferedPositionStream,
          player!.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
  @override
  void dispose() {
    player!.dispose();
    super.dispose();
    //
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MusicPlayerScreen(categoryType: "Music",albumId: "",image: "",title: "", description: "",play: true,)),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75.0),
          child: widget.appbar?Padding(
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
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchMusicFile(),));
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
              iconTheme: const IconThemeData(color: Colors.black),
            ),
          ):SizedBox(),
        ),
        body: FutureBuilder(
            future: storage.ready,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // int i = 0;
                // List<Download> fillterdMovie = [];
                var items = storage.getItem('music');
                if (items != null) {
                  final movies = (items as List).map((e) => AlbumMp3List.fromMap(e)).toList();
                  // _addPlayListContent(movies);
                  return movies.isEmpty
                      ? Center(
                      child: Text(
                        "No Downloaded Music Available".tr,
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
                            height: 600,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                // physics: ScrollPhysics(),
                                itemCount: movies.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return StreamBuilder<SequenceState?>(
                                    stream: player!.sequenceStateStream,
                                    builder: (context, snapshot) {
                                      final state = snapshot.data;
                                      if (state?.sequence.isEmpty ?? true) {
                                        return const SizedBox();
                                      }
                                      return ListTile(
                                        tileColor: ThemeColor.songColor,
                                         leading:ClipRRect(
                                            borderRadius: BorderRadius.circular(5),
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              child: Image.file(
                                                File(movies[index].image!),
                                                // "http://prabhu.yoursoftwaredemo.com/" + movies[index].image!,
                                                height: 40,
                                                width: 40,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  print(error);
                                                  return Image.asset(
                                                    'assets/logo_new.png',
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              ),
                                            )),
                                        title: Row(
                                          children: [
                                            Text(movies[index].title!,style: TextStyle(color: ThemeColor.black,fontSize: 15,fontWeight: FontWeight.bold,),),
                                            // Spacer(),
                                            // Text(movies[index].duration!,style: TextStyle(color: ThemeColor.gray25,fontSize: 14,fontWeight: FontWeight.bold,),)
                                          ],
                                        ),
                                        trailing: Wrap(
                                          children: [
                                            IconButton(
                                              icon: playlist[index] ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                                              iconSize: 25.0,
                                              onPressed: () {
                                                player!.seek(Duration.zero, index: index);
                                                print(player!.playing);
                                                if(playlist[index])
                                                  {
                                                    player!.pause();
                                                    playlist=List.filled(playlist.length, false);
                                                    playlist[index]=false;
                                                  }
                                                else
                                                  {
                                                    player!.setAudioSource(_playlist![index],initialIndex: 0);
                                                    player!.play();
                                                    playlist=List.filled(playlist.length, false);
                                                    playlist[index]=true;
                                                  }
                                                setState(() {

                                                });

                                              },
                                            ),
                                            PopupMenuButton(
                                              offset: Offset(0,30),
                                              itemBuilder: (ctx) => [
                                                PopupMenuItem(child:TextButton(
                                                  onPressed: () {
                                                    selectedIndex = index;
                                                    setState(() {});
                                                    print(
                                                        'selected index $selectedIndex');
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
                                                                        'Are you sure? \n\n you want to to delete ${movies[index].title}?',
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
                                                                              onPressed: () async {
                                                                                Navigator.pop(context);
                                                                                print(movies[index].id);

                                                                                // final files = [movies[index].title!,movies[index].image!].map((path) => File(path)).toList();
                                                                                File f=File("${movies[index].file}");
                                                                                await f.delete();
                                                                                print(movies.length);
                                                                                movies.removeWhere((element) => element.id == movies[index].id);
                                                                                print(movies.length);
                                                                                storage.setItem(
                                                                                    'music',
                                                                                    movies
                                                                                        .map((e) =>
                                                                                        e.toMap())
                                                                                        .toList());
                                                                                // print(
                                                                                //     'caled moin length ${movies.length}');

                                                                                setState(
                                                                                        () {});
                                                                                Navigator.pop(context);
                                                                                Get.rawSnackbar(
                                                                                  snackPosition: SnackPosition.BOTTOM,
                                                                                  backgroundColor: Colors.redAccent,
                                                                                  message: 'Song Deleted Successfully',
                                                                                );
                                                                              },
                                                                              child:
                                                                              Text(
                                                                                'Delete'.tr,
                                                                                style: TextStyle(
                                                                                    color: Colors
                                                                                        .red),
                                                                              ))
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                )))).then((value) {
                                                      print('called moin ');
                                                      selectedIndex = null;
                                                      setState(() {});
                                                    });
                                                  },
                                                  child: Text("Delete"),
                                                ))
                                              ],
                                            )
                                          ],
                                        ),
                                      );;
                                    },
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
                  child: Text('No Dounloaded Music available'),
                );
              }
            }),
      ),
    );
  }
}
