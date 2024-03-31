import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_cryptor/file_cryptor.dart';
import 'package:get/get.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/theme_config.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/models/latest_music_detail_model.dart';
import 'package:hellomegha/screens/home/movie_detail_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../core/api_factory/prefs/pref_utils.dart';
import '../models/searchmusicmodel.dart';
import '../screens/home/more_view.dart';
import '../screens/notifications_view.dart';
import '../screens/search/search.dart';

class LatestMusicList extends ConsumerStatefulWidget {

  @override
  ConsumerState<LatestMusicList> createState() => _LatestMusicListState();
}

class _LatestMusicListState extends ConsumerState<LatestMusicList> {
  AudioPlayer? player;
  List<bool> isFavouritelist=[];
  List<bool>  isDownloadStartedlist=[];
  List<bool>  isDownloadFinishlist=[];
  List<bool>  playlist=[];
  bool get=false;
  LocalStorage storage = LocalStorage('music');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player=AudioPlayer();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.watch(LatestMusicListProvider).musicListAPI(context: context);
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }
      else
      {

        Future.delayed(Duration(seconds: 1)).then((value) {
          if(ref.watch(LatestMusicListProvider).musicList!.data!.musiclist!.isNotEmpty)
          {
            isFavouritelist=List.filled(ref.watch(LatestMusicListProvider).musicList!.data!.musiclist!.length, false);
            isDownloadStartedlist=List.filled(ref.watch(LatestMusicListProvider).musicList!.data!.musiclist!.length, false);
            isDownloadFinishlist=List.filled(ref.watch(LatestMusicListProvider).musicList!.data!.musiclist!.length, false);
            playlist =List.filled(ref.watch(LatestMusicListProvider).musicList!.data!.musiclist!.length, false);
            setState(() {
              get=true;
            });
          }
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,

        body:get?SingleChildScrollView(
            child: ref.watch(LatestMusicListProvider).musicList?.data?.musiclist != null &&
                ref.watch(LatestMusicListProvider).musicList!.data!.musiclist!.isNotEmpty
                ? Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 10.0, top: 5, bottom: 5),
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        'Trending Searches',
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
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ScrollPhysics(),
                      itemCount: ref
                          .watch(LatestMusicListProvider)
                          .musicList!.data!.musiclist!.length,
                      // gridDelegate:
                      // const SliverGridDelegateWithFixedCrossAxisCount(
                      //   crossAxisCount: 3,
                      //   childAspectRatio: 0.85,
                      // ),
                      itemBuilder: (BuildContext context, int index) {
                        Mp3List userFavourite = ref.watch(LatestMusicListProvider).musicList!.data!.musiclist![index];
                        String imgpath=userFavourite.image!;
                        print("imgpath=$imgpath");
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
                                              child: imgpath.startsWith("/data/user/")?Image.file(
                                                File("$imgpath"),
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.cover,
                                              ):Image.network(
                                                "http://prabhu.yoursoftwaredemo.com/$imgpath",
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 20, bottom: 0),
                                            child: Text(userFavourite.title!,
                                              style: TextStyle(
                                                color: ThemeColor.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,),),
                                          ),
                                          SizedBox(height: 15,),
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: [
                                                Icon(Icons.access_time,
                                                  color: ThemeColor.gray25,
                                                  size: 15,),
                                                SizedBox(width: 5,),
                                                Text(userFavourite.duration!,
                                                  style: TextStyle(
                                                    color: ThemeColor.gray25,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,),),
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
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              child: Center(
                                                child: Stack(
                                                    children: [
                                                      Visibility(
                                                          visible: isDownloadStartedlist[index],
                                                          child: Container(
                                                            height: 25,
                                                            width: 25,
                                                            margin: EdgeInsets.only(
                                                                right: 10, top: 0),
                                                            child: CircularProgressIndicator(
                                                              color: ThemeColor
                                                                  .yellow_dark,
                                                            ),
                                                          )),
                                                      FutureBuilder(future: storage.ready,builder: (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          final data =
                                                          storage.getItem('music');
                                                          if (data != null) {
                                                            final movies = (data as List).map((e) => Mp3List.fromMap(e)).toList();

                                                            print(movies.firstWhereOrNull((element) =>
                                                            element.id ==userFavourite.id));
                                                            if (movies.isNotEmpty &&
                                                                movies.firstWhereOrNull((element) =>
                                                                element.id ==userFavourite.id) !=
                                                                    null)
                                                            {
                                                              isDownloadFinishlist[index] = true;
                                                              isDownloadStartedlist[index] = false;
                                                            }
                                                          }
                                                          return Visibility(
                                                              visible: !isDownloadStartedlist[index],
                                                              child: IconButton(
                                                                icon: isDownloadFinishlist[index]
                                                                    ? const Icon(
                                                                  Icons.download_done,
                                                                  size: 25,)
                                                                    : const Icon(Icons
                                                                    .download_for_offline_outlined,
                                                                  size: 25,),
                                                                color: isDownloadFinishlist[index]
                                                                    ? ThemeColor
                                                                    .yellow_lite
                                                                    : ThemeColor
                                                                    .yellow_lite,
                                                                onPressed: () {
                                                                  if(isDownloadFinishlist[index])
                                                                  {
                                                                    if (!Get.isSnackbarOpen) {
                                                                      Get.rawSnackbar(
                                                                          message:
                                                                          'Already Downloaded'.tr,
                                                                          duration:
                                                                          const Duration(
                                                                              seconds: 1));
                                                                    }
                                                                  }
                                                                  else
                                                                  {
                                                                    isDownloadStartedlist[index] =
                                                                    true;
                                                                    isDownloadFinishlist[index] =
                                                                    false;
                                                                    downloadProgress = 0;
                                                                    setState(() {});
                                                                    _downloadCache(
                                                                        "http://prabhu.yoursoftwaredemo.com/${userFavourite.file}",
                                                                        userFavourite.title,index,userFavourite);
                                                                  }
                                                                },
                                                              ));
                                                        } else {
                                                          return const SizedBox();
                                                        }
                                                      },),

                                                    ]),
                                              )
                                          ),
                                          InkWell(
                                            onTap: (){
                                              setfavourite(index,userFavourite.isFavourite!,userFavourite.id!);
                                            },
                                            child: Container(
                                                margin: EdgeInsets.only(top: 0),
                                                child: Stack(
                                                  children: [
                                                    Visibility(child: Icon(
                                                      Icons.favorite_border,
                                                      color: ThemeColor.yellow_lite,
                                                      size: 25,),
                                                      visible: !isFavouritelist[index],),
                                                    Visibility(child: Icon(
                                                        Icons.favorite,
                                                        color: Colors.redAccent,
                                                        size: 25),
                                                      visible: isFavouritelist[index],)
                                                  ],
                                                )

                                              //getFavourite(widget.is_favourite),

                                            ),
                                          ),
                                          IconButton(
                                            icon: playlist[index] ? Icon(Icons.pause) : Icon(
                                                Icons.play_arrow),
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
                                                player!.setAudioSource(AudioSource.uri(Uri.parse("http://prabhu.yoursoftwaredemo.com/" + userFavourite.file.toString()),
                                                  tag: MediaItem(
                                                    // Specify a unique ID for each media item:
                                                      id: userFavourite.id!.toString(),
                                                      // Metadata to display in the notification:
                                                      album: userFavourite.title,
                                                      title: userFavourite.title.toString(),
                                                      artUri: Uri.parse("http://prabhu.yoursoftwaredemo.com/" + userFavourite.coverImage.toString())
                                                  ),
                                                ));
                                                player!.play();
                                                playlist=List.filled(playlist.length, false);
                                                playlist[index]=true;
                                              }
                                              setState(() {

                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            )
                : SizedBox()):SizedBox()
    );
  }
  @override
  void dispose() {
    player!.dispose();
    super.dispose();
    //
  }
  Future<void> setfavourite(int index,int isFavourite,int id) async {
    //http://prabhu.yoursoftwaredemo.com/api/user/favourite_mp3

    var token = await PrefUtils.getToken() ?? "";


    var fav = 0;
    if(isFavourite == 0){
      fav = 1;
    }else{
      fav = 0;
    }



    // print(widget.playList[index].id.toString());
    print(fav);

    var response = await http.post(
      Uri.parse('http://prabhu.yoursoftwaredemo.com/api/user/'+ApiEndPoints.mp3_update),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'mp3_id':id.toString(),
        'status': fav.toString(),
      }),
    );

    print(response.body);
    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      bool status = result['status'];
      if(status != false){
        //musicList = MusicPlayListData.fromJson(result["data"]).Mp3List!;
        print(result['data']["status"]);
        //print(result +" Is Favourite ---------------------------------->");
        //notifyListeners();
        setState(() {
          //print(widget.playList);
          if(result['data']['status'] == "0"){
            isFavouritelist[index] = false;
            // icons = Icons.favorite_border;
            // final tile = widget.playList.firstWhere((item) => item.id == widget.playList[index].id);
            setState(() {});
          }else if(result['data']['status'] == "1"){
            isFavouritelist[index] = true;
            // icons = Icons.favorite;
            // final tile = widget.playList.firstWhere((item) => item.id == widget.playList[index].id);
            // setState(() => tile.isFavourite = 1);
            setState(() {});
          }else{
            isFavouritelist[index] = true;
            // icons = Icons.favorite_border;
          }
          //getFavourite(result['data']['status']);
        });
      }
    }

  }
  int downloadProgress = 0;
  Future<String> createFolder(String cow, String songLink, title,int index,Mp3List albumlist) async {
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
      downloadFile(_pathfinal, songLink, title,index,albumlist,_photopathfinal);
      return downloadDirctoryPath;
    } else {
      path.create(recursive: true);
      //print(path.path+"/[iSongs.info] 01 - Dhoom Dhaam Dhosthaan.mp3");
      var _pathfinal = path.path + "/" + title + ".mp3";
      var _photopathfinal = path.path + "/" + albumlist.title! + ".jpg";

      downloadFile(_pathfinal, songLink, title,index,albumlist,_photopathfinal);

      return path.path;
    }
  }
  Future<void> downloadFile(String pathfinal, String songLink, title,int index,Mp3List albumlist,String photopathfinal) async {
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
  Future<void> _downloadCache(String songLink, title,int index,Mp3List albumlist) async
  {
    print("Click 1");
    print("Song : " + songLink);
    createFolder("MusicPlayer", songLink, title,index,albumlist);
  }
}

