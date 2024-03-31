import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/models/home_all_model.dart';
import 'package:hellomegha/models/latest_music_detail_model.dart';
import 'package:hellomegha/models/searchmusicmodel.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:file_cryptor/file_cryptor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/utils/theme_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'favourite/favourite_list_model.dart';
import 'music_player_activity.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_session/audio_session.dart';
class FavouriteList extends ConsumerStatefulWidget {
  const FavouriteList({Key? key}) : super(key: key);

  @override
  ConsumerState<FavouriteList> createState() => _FavouriteListState();
}

class _FavouriteListState extends ConsumerState<FavouriteList> {
  // bool isFavourite = false;
  LocalStorage storage = LocalStorage('music');
  AudioPlayer? player;

  // bool isDownloadStarted = false;
  // bool isDownloadFinish = false;
  // bool play=false;
  List<bool> isFavouritelist = [];
  List<bool> isDownloadStartedlist = [];
  List<bool> isDownloadFinishlist = [];
  List<bool> playlist = [];

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    player!.dispose();
    super.dispose();
    //
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }
      else
      {
      }
    });
    ref.watch(favouriteListProvider).favouriteListAPI(context: context);
    print(ref.watch(favouriteListProvider).favouriteList);
    isFavouritelist = List.filled(
        ref.watch(favouriteListProvider).favouriteList!.length, false);
    isDownloadStartedlist = List.filled(
        ref.watch(favouriteListProvider).favouriteList!.length, false);
    isDownloadFinishlist = List.filled(
        ref.watch(favouriteListProvider).favouriteList!.length, false);
    playlist = List.filled(
        ref.watch(favouriteListProvider).favouriteList!.length, false);
    _addPlayListContent();


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
  dynamic _playlist;
  List<UserFavourite>? playList = [];
  Future<void> _addPlayListContent() async {
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
    setState(() {
      playList = ref.watch(favouriteListProvider).favouriteList;
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

        // hideLoading(context);
        _init(_playlist);

        // _player.pause();

        if (player!.playerState.playing == true) {
          print("========================================>");
        } else {
          print("========================================+");
        }
      });
    });
  }
  Future<void> _init(ConcatenatingAudioSource _playlist) async {
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
        player!.setAudioSource(_playlist);
      }
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }
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
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xffFECC00),
            ),
          ),
          title: const Text(
            'Favourite List',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: ref.watch(favouriteListProvider).favouriteList != null &&
                ref.watch(favouriteListProvider).favouriteList!.length != 0
            ? ListView.builder(
                itemBuilder: (context, index) {
                  UserFavourite userFavourite = ref.watch(favouriteListProvider).favouriteList![index];
                  return StreamBuilder<SequenceState?>(
                    stream: player!.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state?.sequence.isEmpty ?? true) {
                        return const SizedBox();
                      }
                      return ListTile(
                        title: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: ThemeColor.songColor,
                              height: 100,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: Container(
                                            height: 60,
                                            width: 60,
                                            child:  CommonImage(
                                              imageUrl: "http://prabhu.yoursoftwaredemo.com/" +
                                                  userFavourite.image!,
                                              height: 60,
                                              width: 60,
                                              // fit: BoxFit.cover,
                                            ),
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, top: 20, bottom: 0),
                                          child: Text(
                                            userFavourite.title!,
                                            style: TextStyle(
                                              color: ThemeColor.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                color: ThemeColor.gray25,
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                userFavourite.duration!,
                                                style: TextStyle(
                                                  color: ThemeColor.gray25,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: double.infinity,
                                    // margin: EdgeInsets.only(bottom: 30, right: 5),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            child: Center(
                                              child: Stack(children: [
                                                Visibility(
                                                    visible: isDownloadStartedlist[index],
                                                    child: Container(
                                                      height: 25,
                                                      width: 25,
                                                      margin: EdgeInsets.only(
                                                          right: 10, top: 0),
                                                      child: CircularProgressIndicator(
                                                        color: ThemeColor.yellow_dark,
                                                      ),
                                                    )),
                                                FutureBuilder(
                                                  future: storage.ready,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      final data =
                                                      storage.getItem('music');
                                                      if (data != null) {
                                                        final movies = (data as List)
                                                            .map(
                                                                (e) => Mp3List.fromMap(e))
                                                            .toList();

                                                        print(movies.firstWhereOrNull(
                                                                (element) =>
                                                            element.id ==
                                                                userFavourite.id));
                                                        if (movies.isNotEmpty &&
                                                            movies.firstWhereOrNull(
                                                                    (element) =>
                                                                element.id ==
                                                                    userFavourite
                                                                        .id) !=
                                                                null) {
                                                          isDownloadFinishlist[index] =
                                                          true;
                                                          isDownloadStartedlist[index] =
                                                          false;
                                                        }
                                                      }
                                                      return Visibility(
                                                          visible: !isDownloadStartedlist[
                                                          index],
                                                          child: IconButton(
                                                            icon: isDownloadFinishlist[
                                                            index]
                                                                ? const Icon(
                                                              Icons.download_done,
                                                              size: 25,
                                                            )
                                                                : const Icon(
                                                              Icons
                                                                  .download_for_offline_outlined,
                                                              size: 25,
                                                            ),
                                                            color: isDownloadFinishlist[
                                                            index]
                                                                ? ThemeColor.yellow_lite
                                                                : ThemeColor.yellow_lite,
                                                            onPressed: () {
                                                              if (isDownloadFinishlist[
                                                              index]) {
                                                                if (!Get.isSnackbarOpen) {
                                                                  Get.rawSnackbar(
                                                                      message:
                                                                      'Already Downloaded'
                                                                          .tr,
                                                                      duration:
                                                                      const Duration(
                                                                          seconds:
                                                                          1));
                                                                }
                                                              } else {
                                                                isDownloadStartedlist[
                                                                index] = true;
                                                                isDownloadFinishlist[
                                                                index] = false;
                                                                downloadProgress = 0;
                                                                setState(() {});
                                                                Mp3List album = Mp3List(
                                                                    image: userFavourite
                                                                        .image,
                                                                    title: userFavourite
                                                                        .title,
                                                                    coverImage:
                                                                    userFavourite
                                                                        .coverImage,
                                                                    description:
                                                                    userFavourite
                                                                        .description,
                                                                    duration: userFavourite
                                                                        .duration,
                                                                    file: userFavourite
                                                                        .file,
                                                                    id: userFavourite.id,
                                                                    lyrics: userFavourite
                                                                        .lyrics,
                                                                    mp3Status: userFavourite
                                                                        .mp3Id,
                                                                    newdescription:
                                                                    userFavourite
                                                                        .newdescription,
                                                                    newlyrics:
                                                                    userFavourite
                                                                        .newlyrics,
                                                                    isFavourite: 1);
                                                                _downloadCache(
                                                                    "http://prabhu.yoursoftwaredemo.com/${userFavourite.file}",
                                                                    userFavourite.title,
                                                                    index,
                                                                    album);
                                                              }
                                                            },
                                                          ));
                                                    } else {
                                                      return const SizedBox();
                                                    }
                                                  },
                                                ),
                                              ]),
                                            )),
                                        InkWell(
                                          onTap: () {
                                            setfavourite(index,userFavourite.mp3Id!,userFavourite.title!);
                                          },
                                          child: Container(
                                              margin: EdgeInsets.only(top: 0),
                                              child: Stack(
                                                children: [
                                                  // Visibility(
                                                  //   child: Icon(
                                                  //     Icons.favorite_border,
                                                  //     color: ThemeColor.yellow_lite,
                                                  //     size: 25,
                                                  //   ),
                                                  //   visible: !isFavouritelist[index],
                                                  // ),
                                                  Visibility(
                                                    child: Icon(Icons.favorite,
                                                        color: Colors.redAccent,
                                                        size: 25),
                                                    visible: !isFavouritelist[index],
                                                  )
                                                ],
                                              )

                                            //getFavourite(widget.is_favourite),

                                          ),
                                        ),
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
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );

                },
                itemCount: ref.watch(favouriteListProvider).favouriteList!.length,
              )
            : SizedBox(),
      ),
    );
  }

  Future<void> setfavourite(int index, int id, String title) async {
    print("id=$id");
    var token = await PrefUtils.getToken() ?? "";
    var fav = 0;
    var response = await http.post(
      Uri.parse('http://prabhu.yoursoftwaredemo.com/api/user/' +
          ApiEndPoints.mp3_update),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'mp3_id': id.toString(),
        'status': fav.toString(),
      }),
    );

    print(response.body);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      bool status = result['status'];
      if (status != false) {
        print(result['data']["status"]);
        Get.rawSnackbar(
            message: 'Removed $title from Favourite List'.tr,
            duration: const Duration(seconds: 1));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => FavouriteList()));
      }
    }
  }

  // void downloadCourse(String imgurl, String title,int index) async {
  //   isDownloadStartedlist[index] = true;
  //   isDownloadFinishlist[index] = false;
  //   downloadProgress = 0;
  //   setState(() {});
  //   _downloadCache(imgurl, title,index);
  //   //Download logic
  //
  // }

  int downloadProgress = 0;

  Future<String> createFolder(
      String cow, String songLink, title, int index, Mp3List albumlist) async {
    final folderName = cow;
    // var folder=await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    // final path = Directory("$folder/$folderName");
    final appDocDir = await getApplicationDocumentsDirectory();
    String downloadDirctoryPath = "${appDocDir.path}/$folderName";
    final path = Directory(downloadDirctoryPath);
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      // print(path.path+"/[iSongs.info] 01 - Dhoom Dhaam Dhosthaan.mp3");
      var _pathfinal = path.path + "/" + title + ".mp3";
      var _photopathfinal = path.path + "/" + albumlist.title! + ".jpg";
//      _player.setFilePath(_pathfinal);
      // _player.play();
      downloadFile(_pathfinal, songLink, title, index, albumlist,_photopathfinal);
      return downloadDirctoryPath;
    } else {
      path.create(recursive: true);
      //print(path.path+"/[iSongs.info] 01 - Dhoom Dhaam Dhosthaan.mp3");
      var _pathfinal = path.path + "/" + title + ".mp3";

      var _photopathfinal = path.path + "/" + albumlist.title! + ".jpg";

      downloadFile(_pathfinal, songLink, title, index, albumlist,_photopathfinal);

      return path.path;
    }
  }

  Future<void> downloadFile(String pathfinal, String songLink, title, int index,
      Mp3List albumlist,String photopathfinal) async {
    LocalStorage storage = LocalStorage('music');
    List musiclist = [];
    try {
      final bool isReady = await storage.ready;
      if (isReady) {
        final data = storage.getItem('music');
        if (data != null) {
          musiclist = (data as List).map((e) => Mp3List.fromMap(e)).toList();
        } else {

        }
      }
    } catch (e) {
      Get.rawSnackbar(title: 'Error', message: 'Failed to Download');
    } finally {}

    print(songLink);
    await Dio().download(songLink, pathfinal).whenComplete(() async {
      print(pathfinal);
      print("Download Completed.");
      await Dio().download("${AppUrls.baseUrl}${albumlist.image!}", photopathfinal).whenComplete(() async {
        print("photo download Completed.");
        setState(() {
          isDownloadFinishlist[index] = true;
          isDownloadStartedlist[index] = false;
        });
        albumlist.file=pathfinal;
        albumlist.image=photopathfinal;
        musiclist.add(albumlist);
        storage.setItem('music', musiclist.map((e) => e.toMap()).toList());
        print(storage.getItem('music'));
        print("audio==>${albumlist}");
        final appDocDir = await getApplicationDocumentsDirectory();
        String downloadDirctoryPath = "${appDocDir.path}/MusicPlayer";
        // final path = Directory(downloadDirctoryPath);
        // var folder=await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
        final path = Directory("$downloadDirctoryPath");
        var fileCryptor = FileCryptor(
          key: "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456",
          iv: 16,
          // dir: "storage/emulated/0/MusicPlayer",
          dir: path.path,
        );


        File encryptedFile = await fileCryptor.encrypt(
            inputFile: title + ".mp3", outputFile: title + ".aes");
        print(encryptedFile.absolute);
      });
    });
  }

  Future<void> _downloadCache(
      String songLink, title, int index, Mp3List albumlist) async {
    print("Click 1");
    print("Song : " + songLink);
    createFolder("MusicPlayer", songLink, title, index, albumlist);
  }
}
