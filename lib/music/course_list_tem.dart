import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:file_cryptor/file_cryptor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/theme_config.dart';
import 'package:hellomegha/music/music_play_list_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:permission_handler/permission_handler.dart';import '../core/notifier/providers.dart';
import '../models/latest_music_detail_model.dart';

class MusicListItem extends ConsumerStatefulWidget {
   MusicListItem({Key? key, required this.title, required this.music_url, required this.index, required this.player, required this.is_favourite, required this.playList,}) : super(key: key);

  final String title;
  final String music_url;
  final int index;
  final AudioPlayer player;
  final String is_favourite;
  final List<AlbumMp3List> playList;

  @override
  ConsumerState<MusicListItem> createState() => _MusicListItemPage();

}

class _MusicListItemPage extends ConsumerState<MusicListItem> {
  int downloadProgress = 0;
  LocalStorage storage = LocalStorage('music');
  bool isDownloadStarted = false;

  bool isDownloadFinish = false;

  bool isPlaying = false;

  bool isFavourite = false;

  late final List<AlbumMp3List> musicList;

  IconData icons = Icons.favorite_border;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("ID : "+widget.playList[widget.index].id.toString());

    //print(widget.is_favourite);
    if(widget.is_favourite == "0"){
      isFavourite = true;
      icons = Icons.favorite_border;
    }else if(widget.is_favourite == "1"){
      isFavourite = false;
      icons = Icons.favorite;
    }else{
      isFavourite = true;
      icons = Icons.favorite_border;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Container(
          child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
            child: Container(
              color: widget.index != widget.index
              ?ThemeColor.songColor: ThemeColor.songColor,
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10,right: 40,top: 15,bottom: 0),
                          child: Text(widget.title,style: TextStyle(color: ThemeColor.black,fontSize: 14,fontWeight: FontWeight.w400,),),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Icon(Icons.access_time,color: ThemeColor.gray25,size: 15,),
                              SizedBox(width: 5,),
                              Text("5.23",style: TextStyle(color: ThemeColor.gray25,fontSize: 12,fontWeight: FontWeight.w400,),),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30,right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Center(
                            child: Stack(
                                children: [
                                  Visibility(
                                      visible: isDownloadStarted,
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        margin: EdgeInsets.only(right: 15,top: 3),
                                        child: CircularProgressIndicator(
                                          color: ThemeColor.yellow_dark,
                                        ),
                                      )),
                                  FutureBuilder(future: storage.ready,builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final data =
                                      storage.getItem('music');
                                      if (data != null) {
                                        final movies = (data as List).map((e) => Mp3List.fromMap(e)).toList();

                                        print(movies.firstWhereOrNull((element) =>
                                        element.id ==widget.index));
                                        if (movies.isNotEmpty &&
                                            movies.firstWhereOrNull((element) =>
                                            element.id ==widget.playList[widget.index].id) !=
                                                null)
                                        {
                                          isDownloadFinish= true;
                                          isDownloadStarted = false;
                                        }
                                      }
                                      return Visibility(
                                          visible: !isDownloadStarted,
                                          child: IconButton(
                                            icon: isDownloadFinish
                                                ? const Icon(
                                              Icons.download_done,
                                              size: 25,)
                                                : const Icon(Icons
                                                .download_for_offline_outlined,
                                              size: 25,),
                                            color:isDownloadFinish
                                                ? ThemeColor
                                                .yellow_lite
                                                : ThemeColor
                                                .yellow_lite,
                                            onPressed: () {
                                              if(isDownloadFinish)
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
                                                isDownloadFinish=false;
                                                isDownloadStarted = true;
                                                downloadProgress = 0;
                                                setState(() {});
                                                Mp3List album=Mp3List(
                                                    image: widget.playList[widget.index].image,
                                                    title: widget.playList[widget.index].title,
                                                    coverImage: widget.playList[widget.index].coverImage,
                                                    description: widget.playList[widget.index].description,
                                                    // duration:widget.playList[widget.index].duration ,
                                                    file:widget.playList[widget.index].file ,
                                                    id: widget.playList[widget.index].id,
                                                    lyrics: widget.playList[widget.index].lyrics,
                                                    // mp3Status: widget.playList[widget.index].mp3Id,
                                                    // newdescription:widget.playList[widget.index].newdescription ,
                                                    // newlyrics: widget.playList[widget.index].newlyrics,
                                                    isFavourite: 1
                                                );
                                                _downloadCache(widget.music_url,widget.title,album);
                                                // _downloadCache(
                                                //     "http://prabhu.yoursoftwaredemo.com/${userFavourite
                                                //         .file}",
                                                //     userFavourite
                                                //         .title,index,album);
                                              }
                                            },
                                          ));
                                    } else {
                                      return const SizedBox();
                                    }
                                  },),
                                  // Visibility(
                                  //     visible: !isDownloadStarted,
                                  //     child: IconButton(
                                  //       icon: isDownloadFinish?const Icon(Icons.download_done,size: 30,):const Icon(Icons.download_for_offline_outlined,size: 30,),
                                  //       color: isDownloadFinish ? ThemeColor.yellow_lite : ThemeColor.yellow_lite,
                                  //       onPressed: () {
                                  //         isDownloadStarted = true;
                                  //         isDownloadFinish = false;
                                  //         downloadProgress = 0;
                                  //         setState(() {});
                                  //         _downloadCache(widget.music_url,widget.title,widget.playList[widget.index]);
                                  //       },
                                  //     ))
                                ]),
                          )
                        ),
                        InkWell(
                          onTap: (){
                            setfavourite(widget.index);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 0),
                            child: Stack(
                              children: [
                                Visibility(child: Icon(Icons.favorite_border,color: ThemeColor.yellow_lite,size: 30,),visible: isFavourite,),
                                Visibility(child: Icon(Icons.favorite,color: Colors.redAccent,size: 30),visible: !isFavourite,)
                              ],
                            )

                            //getFavourite(widget.is_favourite),

                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        /*trailing: Column(children: [
          Visibility(
              visible: isDownloadStarted,
              child: CircularPercentIndicator(
                radius: 20.0,
                lineWidth: 3.0,
                percent: (downloadProgress / 100),
                center: Text(
                  "$downloadProgress%",
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
                progressColor: Colors.blue,
              )),
          Visibility(
              visible: !isDownloadStarted,
              child: IconButton(
                icon: const Icon(Icons.download),
                color: isDownloadFinish ? Colors.green : Colors.grey,
                onPressed: downloadCourse,
              ))
        ])*/);
  }

  // void downloadCourse() async {
  //   isDownloadStarted = true;
  //   isDownloadFinish = false;
  //   downloadProgress = 0;
  //   setState(() {});
  //   _downloadCache(widget.music_url,widget.title);
  //   //Download logic
  //   /*while (downloadProgress < 100) {
  //     // Get download progress
  //
  //
  //     downloadProgress += 10;
  //     setState(() {});
  //     if (downloadProgress == 100) {
  //       isDownloadFinish = true;
  //       isDownloadStarted = false;
  //       setState(() {});
  //       break;
  //     }
  //     await Future.delayed(const Duration(milliseconds: 500));
  //   }*/
  // }
  Future<void> _downloadCache(String songLink, title,Mp3List albumMp3List) async {
    print("Click 1");
    print("Song : "+songLink);
    createFolder("MusicPlayer",songLink,title,albumMp3List);

  }
  Future<void> downloadFile(String pathfinal, String songLink, title,Mp3List albumlist,String photopathfinal) async {

    // print(songLink);
    // await Dio().download(songLink,
    //     pathfinal).whenComplete(() async {
    //   print(pathfinal);
    //   print("Download Completed.");
    //
    //
    //   final appDocDir = await getApplicationDocumentsDirectory();
    //   String downloadDirctoryPath = "${appDocDir.path}/MusicPlayer";
    //   // final path = Directory(downloadDirctoryPath);
    //
    //   // var folder=await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    //   final path = Directory("$downloadDirctoryPath");
    //   var fileCryptor = FileCryptor(
    //     key: "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456",
    //     iv: 16,
    //     // dir: "storage/emulated/0/MusicPlayer",
    //     dir: path.path,
    //   );
    //
    //   File encryptedFile =
    //   await fileCryptor.encrypt(inputFile: title+".mp3", outputFile: title+".aes");
    //   print(encryptedFile.absolute);
    //   setState(() {
    //     isDownloadFinish = true;
    //     isDownloadStarted = false;
    //   });
    //
    // });
    await Dio().download(songLink, pathfinal).whenComplete(() async {
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
      print(pathfinal);
      print("Download Completed.");
      await Dio().download("${AppUrls.baseUrl}${albumlist.image!}", photopathfinal).whenComplete(() async {
        print("photo download Completed.");
        setState(() {
          isDownloadFinish = true;
          isDownloadStarted = false;
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
  Future<String> createFolder(String cow, String songLink, title,Mp3List albumMp3List) async {
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
    // musiclist.add(albumMp3List);
    // storage.setItem('music', musiclist.map((e) => e.toMap()).toList());

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
      var _pathfinal = path.path+"/"+title+".mp3";
      var _photopathfinal = path.path + "/" + albumMp3List.title! + ".jpg";
//      _player.setFilePath(_pathfinal);
      // _player.play();
      downloadFile(_pathfinal,songLink,title,albumMp3List,_photopathfinal);
      return downloadDirctoryPath;
    } else {
      path.create(recursive: true);
      //print(path.path+"/[iSongs.info] 01 - Dhoom Dhaam Dhosthaan.mp3");
      var _pathfinal = path.path+"/"+title+".mp3";
      var _photopathfinal = path.path + "/" + albumMp3List.title! + ".jpg";

      downloadFile(_pathfinal,songLink,title,albumMp3List,_photopathfinal);

      return path.path;
    }


  }

  setPlay(){

  }

  getFavourite(String is_favourite) {

    print(is_favourite);

    if(is_favourite != "null"){
      if(is_favourite == "1"){
        print("Surya");
        return Icon(Icons.favorite,color: ThemeColor.progressBarColor,size: 30,);
      }else{
        return Icon(Icons.favorite_border,color: ThemeColor.yellow_lite,size: 30,);
      }
    }else{
      return Icon(Icons.favorite_border,color: ThemeColor.yellow_lite,size: 30,);
    }
  }

  Future<void> setfavourite(int index) async {
    //http://prabhu.yoursoftwaredemo.com/api/user/favourite_mp3

    var token = await PrefUtils.getToken() ?? "";


    var fav = 0;
    if(widget.playList[index].isFavourite == 0){
      fav = 1;
    }else{
      fav = 0;
    }



    print(widget.playList[index].id.toString());
    print(fav);

    var response = await http.post(
      Uri.parse('http://prabhu.yoursoftwaredemo.com/api/user/'+ApiEndPoints.mp3_update),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'mp3_id': widget.playList[index].id.toString(),
        'status': fav.toString(),
      }),
    );

    print(response.body);
    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      bool status = result['status'];
      if(status != false){
        //musicList = MusicPlayListData.fromJson(result["data"]).albumMp3List!;
        print(result['data']["status"]);
        //print(result +" Is Favourite ---------------------------------->");
        //notifyListeners();
        setState(() {
          //print(widget.playList);
          if(result['data']['status'] == "0"){
            isFavourite = true;
            icons = Icons.favorite_border;
            final tile = widget.playList.firstWhere((item) => item.id == widget.playList[index].id);
            setState(() => tile.isFavourite = 0);
          }else if(result['data']['status'] == "1"){
            isFavourite = false;
            icons = Icons.favorite;
            final tile = widget.playList.firstWhere((item) => item.id == widget.playList[index].id);
            setState(() => tile.isFavourite = 1);
          }else{
            isFavourite = true;
            icons = Icons.favorite_border;
          }
          //getFavourite(result['data']['status']);
        });
      }
    }

  }
}

