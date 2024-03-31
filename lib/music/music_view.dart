import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/music/music_play_list_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audio_session/audio_session.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/theme_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:hellomegha/music/common.dart';
import 'package:hellomegha/music/course_list_tem.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:file_cryptor/file_cryptor.dart';
import 'package:get/get.dart' as gemethod;
class MusicPlayerActivity extends ConsumerStatefulWidget {
  MusicPlayerActivity(
      {Key? key,
      required this.id,
      required this.title,
      required this.thumbnail_image,
      required this.description})
      : super(key: key);

  int id;
  String title;
  String thumbnail_image;
  String description;

  @override
  ConsumerState<MusicPlayerActivity> createState() =>
      MusicPlayerActivityState();
}

class MusicPlayerActivityState extends ConsumerState<MusicPlayerActivity> {
  static const int _nextMediaId = 0;
  late AudioPlayer _player;
  late List<String> titleList = [];
  final List<AlbumMp3List> _playListArray = [];

  final int _addedCount = 0;

  late String path;

  String _pathfinal = "";

  late FileCryptor fileCryptor;

  final _progressbar = false;

  final _downloadIcon = true;

  var selectIndex = false;

  bool isDownloading = false;

  List<bool> isSettings = [];

  bool isDownloadStarted = false;

  bool isDownloadFinish = false;

  List<AlbumMp3List>? playList = [];

  @override
  void initState() {
    super.initState();

    channelNotify();

    _player = AudioPlayer();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    print(widget.id);
    setState(() {
      _addPlayListContent();
    });
  }

  Future<void> _init(ConcatenatingAudioSource playlist) async {
    final session = await AudioSession.instance;
    session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      _player.setAudioSource(playlist);
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            // PlayList
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: ThemeColor.white,
                child: SingleChildScrollView(
                    child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(left: 10, bottom: 5, top: 30),
                        height: 50,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                size: 20,
                                color: ThemeColor.yellow_lite,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                             Text(
                              "Now Playing".tr,
                              style: TextStyle(
                                color: ThemeColor.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),

                      // Song Details Widget
                      SizedBox(
                        height: 300,
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
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: SizedBox(
                                              height: 180,
                                              width: 180,
                                              child: CommonImage(
                                                imageUrl:
                                                    "http://prabhu.yoursoftwaredemo.com/${widget.thumbnail_image}",
                                                width: 180,
                                                height: 180,
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(widget.title,
                                      style: const TextStyle(
                                          color: ThemeColor.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    widget.description,
                                    style: const TextStyle(
                                        color: ThemeColor.gray25,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
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
                                          const Icon(
                                            Icons.play_arrow,
                                            color: ThemeColor.black,
                                            size: 18,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              //storage/emulated/0/MusicPlayer/Dhoom Dhaam Dhosthaan.mp3
                                              /*Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                MyDownloads()));*/
                                            },
                                            child:  Text("Play All".tr,
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
                        margin:
                            const EdgeInsets.only(left: 20, bottom: 0, top: 10),
                        child: const Text(
                          "All Songs",
                          style: TextStyle(
                            color: ThemeColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height + 300,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          primary: false,
                          shrinkWrap: true,
                          itemCount: playList!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  _player.seek(Duration.zero, index: index);
                                  setState(() {
                                    ThemeColor.color = ThemeColor.gray25;
                                    ThemeColor.isClick = true;
                                  });
                                },
                                child: Container(
                                    child: MusicListItem(
                                        title:
                                            playList![index].title.toString(),
                                        music_url:
                                            "http://prabhu.yoursoftwaredemo.com/${playList![index].file}",
                                        index: index,player: _player,is_favourite: playList![index].isFavourite.toString(),playList: playList!)));
                          },
                        ),
                      ),

                      /*Container(
                      height: MediaQuery.of(context).size.height+300,
                      child: StreamBuilder<SequenceState?>(
                        stream: _player.sequenceStateStream,
                        builder: (context, snapshot) {
                          final state = snapshot.data;
                          final sequence = state?.sequence ?? [];
                          isDownloadStarted = false;
                          isDownloadFinish = false;
                          int downloadProgress = 0;
                          return Container(
                            margin: EdgeInsets.only(bottom: 0),
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              primary: false,
                              shrinkWrap: true,
                              children: [

                                for (var i = 0; i < sequence.length; i++)

                                  Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,top: 0,bottom: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        height: 80,
                                        color: i == state!.currentIndex
                                            ? Colors.grey.shade300
                                            : ThemeColor.songColor,
                                        child: ListTile(
                                          title: Container(
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
                                                          margin: EdgeInsets.only(left: 0,right: 40,top: 10,bottom: 0),
                                                          child: Text(getText(sequence[i]),style: TextStyle(color: ThemeColor.black,fontSize: 14,fontWeight: FontWeight.w400,),),
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          children: [
                                                            Icon(Icons.access_time,color: ThemeColor.gray25,size: 15,),
                                                            SizedBox(width: 5,),
                                                            Text("5.23",style: TextStyle(color: ThemeColor.gray25,fontSize: 12,fontWeight: FontWeight.w400,),),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(top: 10),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        InkWell(
                                                          onTap: (){
                                                            setState(() {

                                                              isDownloadStarted = true;
                                                              isDownloadFinish = false;
                                                              downloadProgress = 0;
                                                              if(selectIndex == i){
                                                                _downloadIcon = false;
                                                                _progressbar = true;
                                                              }else{
                                                                _downloadIcon = true;
                                                                _progressbar = false;
                                                              }

                                                              _downloadCache(_playListArray[i]["url"],_player,_playListArray[i]["title"],i);
                                                            });
                                                          },
                                                          child: Container(
                                                            child: Stack(
                                                              children:  [
                                                                Container(
                                                                  child: isSettings[i]
                                                                  ? Container(child: Icon(Icons.download_for_offline_outlined,color: ThemeColor.yellow_lite,size: 30,),)
                                                                  : Container(
                                                                    height: 30,
                                                                    width: 30,
                                                                    child: CircularProgressIndicator(
                                                                      color: ThemeColor.yellow_dark,
                                                                    ),
                                                                  )
                                                                )


                                                                Visibility(visible: !isDownloadStarted,child: Icon(Icons.download_for_offline_outlined,color: ThemeColor.yellow_lite,size: 30,),),
                                                                Visibility(
                                                                  visible: !isDownloadStarted,
                                                                    child: Opacity(
                                                                      opacity: 1,
                                                                      child: Container(
                                                                        height: 30,
                                                                        width: 30,
                                                                        child: CircularProgressIndicator(
                                                                          color: ThemeColor.yellow_dark,
                                                                        ),
                                                                      ),
                                                                    ))

                                                              ],
                                                            )
                                                          ),
                                                        ),

                                                        SizedBox(width: 3,),
                                                        Container(
                                                          child: Icon(Icons.play_circle,color: ThemeColor.yellow_lite,size: 30,),

                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                          ),
                                          onTap: () {
                                            _player.seek(Duration.zero, index: i);
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          );
                        },
                      ),
                    ),*/
                    ],
                  ),
                ))),

            // Controls
            Positioned(
                bottom: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
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
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 50,
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
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 15, top: 0),
                                          child: Center(
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 0),
                                                  height: 40,
                                                  width: 40,
                                                  child: CommonImage(
                                                    imageUrl: metadata.artUri
                                                        .toString(),
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(metadata.album!,
                                                style: const TextStyle(
                                                    color: ThemeColor.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              metadata.title,
                                              style: const TextStyle(
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
                            const SizedBox(
                              height: 3,
                            )
                          ],
                        ),
                      )),
                )),
          ],
        ),
        /*floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            _playlist.add(AudioSource.uri(
              Uri.parse("asset:///audio/nature.mp3"),
              tag: MediaItem(
                id: '${_nextMediaId++}',
                album: "Public Domain",
                title: "Nature Sounds ${++_addedCount}",
                artUri: Uri.parse(
                    "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
              ),
            ));
          },
        ),*/
      ),
    );
  }

  Future<String> createFolder(
      String cow, String songLink, title, int index) async {
    final folderName = cow;
    final path = Directory("storage/emulated/0/$folderName");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      // print(path.path+"/[iSongs.info] 01 - Dhoom Dhaam Dhosthaan.mp3");
      _pathfinal = "${"${path.path}/" + title}.mp3";

//      _player.setFilePath(_pathfinal);
      // _player.play();
      downloadFile(_pathfinal, songLink);
      return path.path;
    } else {
      path.create();
      //print(path.path+"/[iSongs.info] 01 - Dhoom Dhaam Dhosthaan.mp3");
      _pathfinal = "${"${path.path}/" + title}.mp3";

      downloadFile(_pathfinal, songLink);

      return path.path;
    }
  }

  static Future<String> createFolderInAppDocDir(String folderName) async {
    //Get this App Document Directory
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory appDocDirFolder =
        Directory('${appDocDir.path}/$folderName/');

    if (await appDocDirFolder.exists()) {
      //if folder already exists return path
      print(appDocDirFolder);

      return appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory appDocDirNewFolder =
          await appDocDirFolder.create(recursive: true);
      print(appDocDirNewFolder);
      return appDocDirNewFolder.path;
    }
  }

  Future<void> _addPlayListContent() async {
    String token = await PrefUtils.getToken() ?? "";

    var headers = {'Authorization': 'Bearer $token'};

    var request = http.Request(
        'GET',
        Uri.parse(
            "http://prabhu.yoursoftwaredemo.com/api/${ApiEndPoints.albummusic}${widget.id}"));

    request.headers.addAll(headers);

    http.Response response =
        await http.Response.fromStream(await request.send());

    print(response.body);

    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      if (result["status"] == true) {
        setState(() {
          playList = MusicPlayListData.fromJson(result["data"]).albumMp3List;
          print("SURYA${playList!.length}");
          print("-------------------------------------------");

          // isloading = true;

          final playlist = ConcatenatingAudioSource(
              // Start loading next item just before reaching it
              useLazyPreparation: true,
              // Customise the shuffle algorithm
              shuffleOrder: DefaultShuffleOrder(),
              children: []);

          setState(() {
            for (int i = 0; i < playList!.length; i++) {
              print(
                  "http://prabhu.yoursoftwaredemo.com/${playList![i].file}");
              playlist.add(AudioSource.uri(
                Uri.parse(
                    "http://prabhu.yoursoftwaredemo.com/${playList![i].file}"),
                tag: MediaItem(
                  id: playList![i].id.toString(),
                  album: playList![i].title,
                  title: playList![i].title.toString(),
                  artUri: Uri.parse(
                      "http://prabhu.yoursoftwaredemo.com/${playList![i].coverImage}"),
                ),
              ));
            }

            _init(playlist);
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
    JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
  }

  Future<void> _downloadCache(
      String songLink, AudioPlayer player, title, int index) async {
    print("Click 1");
    print("Song : $songLink");
    getPath(songLink, title, index);
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

  Future<void> getPath(String songLink, title, int index) async {
    // _setPath();
    if (!mounted) return;
    createFolder("MusicPlayer", songLink, title, index);
  }

  Future<void> downloadFile(String pathfinal, String songLink) async {
    print(songLink);
    await Dio().download(songLink, pathfinal).whenComplete(() async {
      print(pathfinal);
      print("Download Completed.");

      setState(() {
        isDownloadFinish = true;
        isDownloadStarted = true;
      });
      // var folder=await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
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
                return const SizedBox(
                  width: 35.0,
                  height: 35.0,
                  child: CircularProgressIndicator(
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
