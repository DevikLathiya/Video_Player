import 'dart:convert';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:file_cryptor/file_cryptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/theme_config.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/music/DownloadMusicListView.dart';
import 'package:hellomegha/music/Favouritelist.dart';
import 'package:hellomegha/music/SearchMusic/SearchMusicFile.dart';
import 'package:hellomegha/music/common.dart';
import 'package:hellomegha/music/course_list_tem.dart';
import 'package:hellomegha/music/music_play_list_model.dart';
import 'package:hellomegha/screens/home/bottom_navigation_view.dart';
import 'package:hellomegha/screens/home/music_list_view.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

import '../models/latest_music_detail_model.dart';

class MusicPlayerScreen extends ConsumerStatefulWidget {
  /* MusicPlayerScreen({Key? key, required this.id, required this.title, required this.thumbnail_image, required this.description}) : super(key: key);*/

  MusicPlayerScreen({
    Key? key,
    required this.categoryType,
    required this.albumId,
    required this.image,
    required this.title,
    required this.description,
    required this.play,
  }) : super(key: key);

  String categoryType;
  String albumId;
  String image;
  String title;
  String description;
  bool play;

  @override
  ConsumerState<MusicPlayerScreen> createState() => MusicPlayerScreenState();
}

class MusicPlayerScreenState extends ConsumerState<MusicPlayerScreen> {
  int id = 0;
  String title = "";
  String thumbnail_image = "";
  String description = "";
  static int _nextMediaId = 0;
  late AudioPlayer _player;
  late List<String> titleList = [];
  final List<AlbumMp3List> _playListArray = [];
  LocalStorage storage = LocalStorage('music');
  int _addedCount = 0;

  late String path;

  String _pathfinal = "";

  late FileCryptor fileCryptor;

  var _progressbar = false;

  var _downloadIcon = true;

  var selectIndex = false;

  bool isDownloading = false;

  List<bool> isSettings = [];

  bool isDownloadStarted = false;

  bool isDownloadFinish = false;

  List<AlbumMp3List>? playList = [];

  SequenceState? state;

  bool isPlayerView = false;
  bool isAlbumView = true;

  double lw = 0, lh = 0;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

  }

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

  hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> _init(ConcatenatingAudioSource _playlist) async {
    final session = await AudioSession.instance;
    session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    print("=play=${_player.playing}");
    try {
      if (_player.playing) {
      } else {
        _player.setAudioSource(_playlist);
      }
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  @override
  void didChangeDependencies() {
    print(isPlayerView);
    super.didChangeDependencies();
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }
      else
      {
        ref.watch(favouriteListProvider).favouriteListAPI(context: context);
        if (isPlayerView == false) {
          if (widget.categoryType == "Music Artists") {
            if (widget.albumId == "") {
              ref
                  .watch(musicArtistListProvider)
                  .musicArtistListAPI(context: context);
            } else {
              setState(() {
                id = int.parse(widget.albumId);
                title = widget.title;
                thumbnail_image = widget.image;
                description = widget.description;

                isPlayerView = true;
                isAlbumView = false;

                channelNotify();

                SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                ));

                print(id);
                setState(() {
                  _addPlayListContent();
                });
              });
            }
          } else {
            if (widget.albumId == "") {
              ref.watch(musicAlbumListProvider).musicListAPI(context: context);
            } else {
              setState(() {
                id = int.parse(widget.albumId);
                title = widget.title;
                thumbnail_image = widget.image;
                description = widget.description;

                isPlayerView = true;
                isAlbumView = false;

                channelNotify();

                SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                ));

                print(id);
                setState(() {
                  _addPlayListContent();
                });
              });
            }
          }
        }
      }
    });
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    print("====>$lw"); //352.72727272727275
    print(lh);
    return WillPopScope(
      onWillPop: () async {
        if (_player.playing) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Quit Media"),
              content: const Text("Are you want to quit music player?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Container(
                    color: ThemeColor.yellow_lite,
                    padding: EdgeInsets.all(14),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: ThemeColor.black),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: ThemeColor.yellow_lite,
                    padding: EdgeInsets.all(14),
                    child: Text(
                      "okay",
                      style: TextStyle(color: ThemeColor.black),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        else
          {
            // Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavigationView(index: 0),
                ));
          }

        return true;
      },
      child: Scaffold(
          body: SafeArea(
              child: Stack(
        children: [
          Visibility(
            visible: isPlayerView,
            child: Column(
              children: <Widget>[
                // PlayList
                Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, bottom: 5, top: 20),
                        height: 50,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  widget.play = false;
                                  if (widget.albumId == "") {
                                    isPlayerView = false;
                                    isAlbumView = true;
                                  } else {
                                    if (_player.playing) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text("Quit Media"),
                                          content: const Text(
                                              "Are you want to quit music player?"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: Container(
                                                color: ThemeColor.yellow_lite,
                                                padding: EdgeInsets.all(14),
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: ThemeColor.black),
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                color: ThemeColor.yellow_lite,
                                                padding: EdgeInsets.all(14),
                                                child: Text(
                                                  "okay",
                                                  style: TextStyle(
                                                      color: ThemeColor.black),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  }
                                });
                              },
                              child: Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: ThemeColor.yellow_lite,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Now Playing",
                              style: TextStyle(
                                fontFamily: Strings.robotoMedium,
                                color: ThemeColor.black,
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      // Song Details Widget
                      Container(
                        height: 350,
                        width: MediaQuery.of(context).size.width,
                        child: StreamBuilder<SequenceState?>(
                          stream: _player.sequenceStateStream,
                          builder: (context, snapshot) {
                            final state = snapshot.data;
                            if (state?.sequence.isEmpty ?? true) {
                              return const SizedBox();
                            }
                            final metadata =
                                state!.currentSource!.tag as MediaItem;
                            return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              height: 180,
                                              width: 180,
                                              child: CommonImage(
                                               imageUrl:  "http://prabhu.yoursoftwaredemo.com/" + thumbnail_image,
                                                width: 180,
                                                height: 180,
                                                // fit: BoxFit.cover,
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(title,
                                      style: TextStyle(
                                          color: ThemeColor.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    removeAllHtmlTags(description),
                                    style: TextStyle(
                                        color: ThemeColor.gray25,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 100,
                                    child: MaterialButton(
                                      minWidth: 100,
                                      elevation: 0.1,
                                      height: 35,
                                      color: ThemeColor.yellow_dark,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      onPressed: () {
                                        _player.play();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.play_arrow,
                                            color: ThemeColor.black,
                                            size: 18,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              //storage/emulated/0/MusicPlayer/Dhoom Dhaam Dhosthaan.mp3
                                              /*Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                          MyDownloads()));*/
                                            },
                                            child: Text("Play All",
                                                style: TextStyle(
                                                    color: ThemeColor.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Songs Play List
                      Container(
                        margin: EdgeInsets.only(left: 20, bottom: 0, top: 10),
                        child: Text(
                          "All Songs",
                          style: TextStyle(
                            color: ThemeColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      Container(
                        // height: 300,
                        // height: MediaQuery.of(context).size.height - ,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          primary: false,
                          shrinkWrap: true,
                          itemCount: playList!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  print("===$playList");
                                  _player.seek(Duration.zero, index: index);
                                  setState(() {
                                    ThemeColor.color = ThemeColor.gray25;
                                    ThemeColor.isClick = true;
                                  });
                                  _player.setAudioSource(_playlist,
                                      initialIndex: index);
                                },
                                child: Container(
                                    child: MusicListItem(
                                        title:
                                            playList![index].title.toString(),
                                        music_url:
                                            "http://prabhu.yoursoftwaredemo.com/" +
                                                playList![index]
                                                    .file
                                                    .toString(),
                                        index: index,
                                        player: _player,
                                        is_favourite: playList![index]
                                            .isFavourite
                                            .toString(),
                                        playList: playList!)));
                          },
                        ),
                      ),
                    ],
                  )),
                ),
                // Controls
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                  child: Container(
                      color: ThemeColor.yellow_lite,
                      height: 160,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: StreamBuilder<SequenceState?>(
                                stream: _player.sequenceStateStream,
                                builder: (context, snapshot) {
                                  state = snapshot.data;
                                  print("state=>$state");
                                  if (state?.sequence.isEmpty ?? true) {
                                    return const SizedBox();
                                  }
                                  final metadata = state!.currentSource!.tag as MediaItem;
                                  return Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.only(left: 15, top: 0),
                                          child: Center(
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 0),
                                                  height: 40,
                                                  width: 40,
                                                  child: CommonImage(
                                                    imageUrl: metadata.artUri.toString(),
                                                    width: 40,
                                                    height: 40,
                                                    // fit: BoxFit.fill,
                                                  ),
                                                )),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(metadata.album!,
                                                style: TextStyle(
                                                    color: ThemeColor.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              metadata.title,
                                              style: TextStyle(
                                                  color: ThemeColor.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            //Controls
                            ControlButtons(_player),
                            Container(
                              child: StreamBuilder<PositionData>(
                                stream: _positionDataStream,
                                builder: (context, snapshot) {
                                  final positionData = snapshot.data;
                                  return SeekBar(
                                    duration:
                                        positionData?.duration ?? Duration.zero,
                                    position:
                                        positionData?.position ?? Duration.zero,
                                    bufferedPosition:
                                        positionData?.bufferedPosition ??
                                            Duration.zero,
                                    onChangeEnd: (newPosition) {
                                      _player.seek(newPosition);
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (BuildContext ctx, BoxConstraints constraints) {
              // if the screen width >= 480 i.e Wide Screen
              if (widget.categoryType == "Music Artists") {
                return Visibility(
                  visible: isAlbumView,
                  child: SingleChildScrollView(
                      child: ref
                                      .watch(musicArtistListProvider)
                                      .musicartistList !=
                                  null &&
                              ref
                                  .watch(musicArtistListProvider)
                                  .musicartistList!
                                  .isNotEmpty
                          ? Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 10, bottom: 5, top: 20),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (_player.playing) {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title:
                                                      const Text("Quit Media"),
                                                  content: const Text(
                                                      "Are you want to quit music player?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: Container(
                                                        color: ThemeColor
                                                            .yellow_lite,
                                                        padding:
                                                            EdgeInsets.all(14),
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color: ThemeColor
                                                                  .black),
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        color: ThemeColor
                                                            .yellow_lite,
                                                        padding:
                                                            EdgeInsets.all(14),
                                                        child: Text(
                                                          "okay",
                                                          style: TextStyle(
                                                              color: ThemeColor
                                                                  .black),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              Navigator.pop(context);
                                            }
                                            print("Are you want to Exit");
                                          });
                                        },
                                        child: Icon(
                                          Icons.arrow_back,
                                          size: 20,
                                          color: ThemeColor.yellow_lite,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Music",
                                        style: TextStyle(
                                          color: ThemeColor.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 10.0,
                                      top: 5,
                                      bottom: 5),
                                  child: Row(children: [
                                    Expanded(
                                      child: Text(
                                        ref
                                                .watch(musicArtistListProvider)
                                                .musicartistList!
                                                .length!
                                                .toString() +
                                            ' Music Album',
                                        style: TextStyle(
                                            fontFamily: Strings.robotoMedium,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: GridView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: const ScrollPhysics(),
                                      itemCount: ref
                                          .watch(musicArtistListProvider)
                                          .musicartistList!
                                          .length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 0.77,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              id = ref
                                                  .watch(
                                                      musicArtistListProvider)
                                                  .musicartistList![index]
                                                  .id!;
                                              title = ref
                                                  .watch(
                                                      musicArtistListProvider)
                                                  .musicartistList![index]
                                                  .title!;
                                              thumbnail_image = ref
                                                  .watch(
                                                      musicArtistListProvider)
                                                  .musicartistList![index]
                                                  .image!;
                                              description = ref
                                                  .watch(
                                                      musicArtistListProvider)
                                                  .musicartistList![index]
                                                  .description!;

                                              isPlayerView = true;
                                              isAlbumView = false;

                                              channelNotify();

                                              SystemChrome
                                                  .setSystemUIOverlayStyle(
                                                      const SystemUiOverlayStyle(
                                                statusBarColor: Colors.black,
                                              ));

                                              print(id);
                                              setState(() {
                                                _addPlayListContent();
                                              });
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: SizedBox(
                                                    height: 110,
                                                    width: 110,
                                                    child: CommonImage(
                                                       imageUrl:  'http://prabhu.yoursoftwaredemo.com/${ref.watch(musicArtistListProvider).musicartistList![index].image}',
                                                        // fit: BoxFit.cover
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 3.0),
                                                child: Text(
                                                  ref
                                                      .watch(
                                                          musicArtistListProvider)
                                                      .musicartistList![index]
                                                      .title
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        Strings.robotoRegular,
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                  ),
                                                  softWrap: true,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                )
                              ],
                            )
                          : const SizedBox()),
                );
              } else {
                return Visibility(
                  visible: isAlbumView,
                  child: SingleChildScrollView(
                      child: ref.watch(musicAlbumListProvider).albumList !=
                                  null &&
                              ref
                                  .watch(musicAlbumListProvider)
                                  .albumList!
                                  .isNotEmpty
                          ? Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 10, bottom: 5, top: 20),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (_player.playing) {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title:
                                                      const Text("Quit Media"),
                                                  content: const Text(
                                                      "Are you want to quit music player?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: Container(
                                                        color: ThemeColor
                                                            .yellow_lite,
                                                        padding:
                                                            EdgeInsets.all(14),
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color: ThemeColor
                                                                  .black),
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        color: ThemeColor
                                                            .yellow_lite,
                                                        padding:
                                                            EdgeInsets.all(14),
                                                        child: Text(
                                                          "okay",
                                                          style: TextStyle(
                                                              color: ThemeColor
                                                                  .black),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const BottomNavigationView(index: 0),
                                                  ));
                                              // Navigator.pop(context);
                                            }
                                            print("Are you want to Exit");
                                          });
                                        },
                                        child: Icon(
                                          Icons.arrow_back,
                                          size: 25,
                                          color: ThemeColor.yellow_lite,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Music Album",
                                        style: TextStyle(
                                            fontFamily: Strings.robotoMedium,
                                            fontSize: 21.0,
                                            color: Colors.black)
                                      ),
                                      Spacer(),
                                      IconButton(onPressed: () {
                                        Navigator.of(ctx).pop();
                                        // Navigator.pop(con/text);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchMusicFile(),));
                                      }, icon: Icon(Icons.search))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => DownloadMusicListView(true)),
                                                );
                                              },
                                              child: Card(
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(5),
                                                    child: Container(
                                                      height: 100,
                                                      color: Colors.white,
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Icon(Icons.download),
                                                          Text("Downloads"),
                                                          FutureBuilder(builder: (context, snapshot) {
                                                            if (snapshot.hasData) {
                                                              final data =
                                                              storage.getItem('music');
                                                              if (data != null) {
                                                                final movies = (data as List).map((e) => Mp3List.fromMap(e)).toList();
                                                                return Text("${movies.length} songs");
                                                              }
                                                              else {
                                                                return Text("0 songs");
                                                              }
                                                            }else {
                                                             return Text("0 songs");
                                                            }
                                                          },future: storage.ready,)
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => const FavouriteList()),
                                                );
                                              },
                                              child: Card(
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(5),
                                                    child: Container(
                                                      height: 100,
                                                      color: Colors.white,
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Icon(Icons.favorite,color: ThemeColor.yellow_lite),
                                                          Text("Liked Music"),
                                                          ref.watch(favouriteListProvider).favouriteList!=null?
                                                          Text("${ref.watch(favouriteListProvider).favouriteList!.length} songs"):
                                                          Text("0 Songs"),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 10.0,
                                      top: 5,
                                      bottom: 5),
                                  child: Row(children: [
                                    Expanded(
                                      child: Text(
                                        '${ref.watch(musicAlbumListProvider).albumList!.length} Music',
                                        style: TextStyle(
                                            fontFamily: Strings.robotoMedium,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: GridView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemCount: ref
                                          .watch(musicAlbumListProvider)
                                          .albumList!
                                          .length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 0.85,
                                      ),
                                        itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              id = ref
                                                  .watch(musicAlbumListProvider)
                                                  .albumList![index]
                                                  .id!;
                                              title = ref
                                                  .watch(musicAlbumListProvider)
                                                  .albumList![index]
                                                  .title!;
                                              thumbnail_image = ref
                                                  .watch(musicAlbumListProvider)
                                                  .albumList![index]
                                                  .thumbnailImage!;
                                              description = ref
                                                  .watch(musicAlbumListProvider)
                                                  .albumList![index]
                                                  .description!;

                                              isPlayerView = true;
                                              isAlbumView = false;

                                              channelNotify();

                                              SystemChrome
                                                  .setSystemUIOverlayStyle(
                                                      const SystemUiOverlayStyle(
                                                statusBarColor: Colors.black,
                                              ));

                                              print(id);
                                              setState(() {
                                                _addPlayListContent();
                                              });
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: SizedBox(
                                                    height: 100,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child:CommonImage(
                                                        imageUrl: 'http://prabhu.yoursoftwaredemo.com/${ref.watch(musicAlbumListProvider).albumList![index].thumbnailImage!}',
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 3.0),
                                                child: Text(
                                                  ref
                                                      .watch(
                                                          musicAlbumListProvider)
                                                      .albumList![index]
                                                      .title!,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        Strings.robotoRegular,
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  softWrap: true,
                                                  maxLines: 1,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                )
                              ],
                            )
                          : const SizedBox()),
                );
              }
            },
          )
        ],
      ))),
    );
  }
  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
  }
  dynamic _playlist;

  ContentDesign(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: 0, right: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.cancel_outlined,
                  color: Colors.black,
                  size: 30,
                ),
              )),
          Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: 0, right: 10),
              child: Text("Are you want to close the Music Player?")),
          Align(
            alignment: Alignment.topRight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 0, right: 10),
                    child: Text("Ok")),
                Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 0, right: 10),
                    child: Text("Ok")),
              ],
            ),
          )
        ],
      ),
    );
  }
//   Future<String> createFolder(
//       String cow, String songLink, title, int index) async {
//     final folderName = cow;
//     final path = Directory("storage/emulated/0/$folderName");
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }
//     if ((await path.exists())) {
//       // print(path.path+"/[iSongs.info] 01 - Dhoom Dhaam Dhosthaan.mp3");
//       _pathfinal = path.path + "/" + title + ".mp3";
//
// //      _player.setFilePath(_pathfinal);
//       // _player.play();
//       downloadFile(_pathfinal, songLink);
//       return path.path;
//     } else {
//       path.create();
//       //print(path.path+"/[iSongs.info] 01 - Dhoom Dhaam Dhosthaan.mp3");
//       _pathfinal = path.path + "/" + title + ".mp3";
//
//       downloadFile(_pathfinal, songLink);
//
//       return path.path;
//     }
//   }

  // static Future<String> createFolderInAppDocDir(String folderName) async {
  //   //Get this App Document Directory
  //   final Directory _appDocDir = await getApplicationDocumentsDirectory();
  //   //App Document Directory + folder name
  //   final Directory _appDocDirFolder =
  //       Directory('${_appDocDir.path}/$folderName/');
  //
  //   if (await _appDocDirFolder.exists()) {
  //     //if folder already exists return path
  //     print(_appDocDirFolder);
  //
  //     return _appDocDirFolder.path;
  //   } else {
  //     //if folder not exists create folder and then return its path
  //     final Directory _appDocDirNewFolder =
  //         await _appDocDirFolder.create(recursive: true);
  //     print(_appDocDirNewFolder);
  //     return _appDocDirNewFolder.path;
  //   }
  // }

  Future<void> _addPlayListContent() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          showLoading(context);
        }));

    String token = await PrefUtils.getToken() ?? "";

    var headers = {'Authorization': 'Bearer ' + token};

    var request = http.Request(
        'GET',
        Uri.parse("http://prabhu.yoursoftwaredemo.com/api/" +
            ApiEndPoints.albummusic +
            id.toString()));

    request.headers.addAll(headers);

    http.Response response =
        await http.Response.fromStream(await request.send());

    print(response.body);

    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      if (result["status"] == true) {
        setState(() {
          playList = MusicPlayListData.fromJson(result["data"]).albumMp3List;
          print("SURYA" + playList!.length.toString());
          print("SURYA" + playList.toString());
          print("-------------------------------------------");

          // isloading = true;

          _playlist = ConcatenatingAudioSource(
              // Start loading next item just before reaching it
              useLazyPreparation: true,
              // Customise the shuffle algorithm
              shuffleOrder: DefaultShuffleOrder(),
              children: []);

          setState(() {
            for (int i = 0; i < playList!.length; i++) {
              print("http://prabhu.yoursoftwaredemo.com/" +
                  playList![i].file.toString());
              _playlist.add(AudioSource.uri(Uri.parse("http://prabhu.yoursoftwaredemo.com/" + playList![i].file.toString()),
                tag: MediaItem(
                  id: playList![i].id.toString(),
                  album: playList![i].title,
                  title: playList![i].title.toString(),
                  artUri: Uri.parse("http://prabhu.yoursoftwaredemo.com/" +
                      playList![i].coverImage.toString()),
                ),
              ));
            }

            hideLoading(context);

            print("status=${widget.play}");
            // if(widget.play)
            {
              _init(_playlist);
            }

            // _player.pause();

            if (_player.playerState.playing == true) {
              print("========================================>");
            } else {
              print("========================================+");
            }
          });
        });
      } else {
        setState(() {
          //isloading = false;
        });
      }
    } else {
      setState(() {
        //isloading = false;
      });
    }
  }
  Future<void> channelNotify() async {
    /*JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );*/
  }
  Future<void> _downloadCache(
      String songLink, AudioPlayer player, title, int index) async {
    print("Click 1");
    print("Song : " + songLink);
    // getPath(songLink, title, index);
// Download and cache audio while playing it (experimental)
    // final audioSource = LockCachingAudioSource(Uri.parse(songLink));
    //await player.setAudioSource(audioSource);

    /*audioSource.cacheFile.then((value) {
      print("Song : "+ value.absolute.path);

      //final paths = "[iSongs.info] 01 - Dhoom Dhaam Dhosthaan"

      //path = value.absolute.path;
      player.setAudioSource(AudioSource.uri(Uri.file(value.absolute.path)),
          initialPosition: Duration.zero, preload: true);

    });*/
  }

  // Future<void> getPath(String songLink, title, int index) async {
  //   // _setPath();
  //   if (!mounted) return;
  //   // createFolder("MusicPlayer", songLink, title, index);
  // }

  Future<void> downloadFile(String pathfinal, String songLink) async {

    print(songLink);
    await Dio().download(songLink, pathfinal).whenComplete(() async {
      print(pathfinal);
      print("Download Completed.");

      setState(() {
        isDownloadFinish = true;
        isDownloadStarted = true;
      });
      // var folder = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
      // final path = Directory("$folder/MusicPlayer");

      final appDocDir = await getApplicationDocumentsDirectory();
      String downloadDirctoryPath = "${appDocDir.path}/MusicPlayer";
      final path = Directory("$downloadDirctoryPath");
      fileCryptor = FileCryptor(
        key: "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456",
        iv: 16,
        dir: path.path,
      );
      /* File encryptedFile =
          await fileCryptor.encrypt(inputFile: "Dhoom Dhaam Dhosthaan.mp3", outputFile: "Dhoom Dhaam Dhosthaan.aes");*/
      //  print(encryptedFile.absolute);
    });
  }

  String getText(IndexedAudioSource sequence) {
    var title = sequence.tag.title.toString();
    titleList.add(title);
    return sequence.tag.title.toString();
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder<LoopMode>(
            stream: player.loopModeStream,
            builder: (context, snapshot) {
              final loopMode = snapshot.data ?? LoopMode.off;
              const icons = [
                Icon(
                  Icons.repeat,
                  color: ThemeColor.black,
                  size: 20,
                ),
                Icon(
                  Icons.repeat,
                  color: ThemeColor.gray25,
                  size: 20,
                ),
                Icon(
                  Icons.repeat_one,
                  color: ThemeColor.gray25,
                  size: 20,
                ),
              ];
              const cycleModes = [
                LoopMode.off,
                LoopMode.all,
                LoopMode.one,
              ];
              final index = cycleModes.indexOf(loopMode);
              return IconButton(
                icon: icons[index],
                onPressed: () {
                  player.setLoopMode(cycleModes[
                      (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
                },
              );
            },
          ),
          StreamBuilder<SequenceState?>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: const Icon(
                Icons.fast_rewind,
                size: 25,
              ),
              onPressed: player.hasPrevious ? player.seekToPrevious : null,
            ),
          ),
          StreamBuilder<PlayerState>(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  width: 35.0,
                  height: 35.0,
                  child: const CircularProgressIndicator(
                    color: ThemeColor.black,
                  ),
                );
              } else if (playing != true) {
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 35.0,
                  onPressed: () {
                    player.play();
                  },
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 35.0,
                  onPressed: player.pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.replay),
                  onPressed: () => player.seek(Duration.zero,
                      index: player.effectiveIndices!.first),
                );
              }
            },
          ),
          StreamBuilder<SequenceState?>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: const Icon(
                Icons.fast_forward,
                size: 25,
              ),
              onPressed: player.hasNext ? player.seekToNext : null,
            ),
          ),
          StreamBuilder<bool>(
            stream: player.shuffleModeEnabledStream,
            builder: (context, snapshot) {
              final shuffleModeEnabled = snapshot.data ?? false;
              return IconButton(
                icon: shuffleModeEnabled
                    ? const Icon(
                        Icons.shuffle,
                        color: ThemeColor.gray25,
                        size: 20,
                      )
                    : const Icon(
                        Icons.shuffle,
                        color: ThemeColor.black,
                        size: 20,
                      ),
                onPressed: () async {
                  final enable = !shuffleModeEnabled;
                  if (enable) {
                    await player.shuffle();
                  }
                  await player.setShuffleModeEnabled(enable);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
