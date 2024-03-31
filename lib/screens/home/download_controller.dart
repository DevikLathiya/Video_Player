import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:localstorage/localstorage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hellomegha/models/movie_detail_model.dart';
import 'model/download_model.dart';

class DownloadController extends GetxController {
  String? currentMovieId;
  final ReceivePort _port = ReceivePort();
  RxList<Downloading> downloadingTask = RxList<Downloading>();
  final Rx<MovieVideo> _selectedQuality = Rx<MovieVideo>(MovieVideo());

  MovieVideo get selectedQuality => _selectedQuality.value;

  set selectedQuality(MovieVideo value) => _selectedQuality.value = value;

  _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void _bindBackgroundIsolate() {
    // Register the send port with the isolate name server
    bool isSuccess = IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      print("_bindBackgroundIsolate");
      return;
    }
    print("onConnectivityChanged");
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print("ConnectivityResult");
      if (result.name.toLowerCase() != "none") {
        _port.listen((dynamic data) async {
          // Extract task ID, status, and progress from the data
          String id = data[0];
          print('called moin task id $id');
          DownloadTaskStatus status = data[1];
          int progress = data[2];
          print("called moin $progress");
          // Find the task in the list of downloading tasks
          for (var element in downloadingTask) {
            print('called moin in loop ${element.taskId} $id $currentMovieId ${element.movieId}');
            if (element.taskId == id && currentMovieId == element.movieId) {
              print('called moin in if');

              // Update the task's progress and status
              element.progress = progress;
              element.status = status;
              // If the task is complete, store the movie in the local storage
              if (status == DownloadTaskStatus.complete) {
                storeMovieInLocal(element.movies!);
                // _unbindBackgroundIsolate();
                // currentMovieId = null;
              }
            }
          }
          print("called moin refresh");
          // Refresh the list of downloading tasks
          downloadingTask.refresh();
        });
      }
    });
  }

  void init() {
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void disposeIsolate() {
    _unbindBackgroundIsolate();
  }

  @override
  void onClose() {
    super.onClose();
    _unbindBackgroundIsolate();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    print('called moin in downloadCallback $id $progress');
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');

    print('called after sendport');
    print('called ');
    send!.send([id, status, progress]);
  }

  void downloadVideo(Download download) async {
    final LocalStorage storage = LocalStorage('movies');
    List<Download> movies = [];
    try {
      final bool isReady = await storage.ready;
      if (isReady) {
        final data = storage.getItem('movies');
        if (data != null) {
          movies = (data as List).map((e) => Download.fromMap(e)).toList();
          await downloadAndStoreMovie(movies, download, storage);
        } else {
          await downloadAndStoreMovie(movies, download, storage);
        }
      }
    } catch (e) {
      Get.rawSnackbar(title: 'Error', message: 'Falid to Download');
    } finally {}
  }

  bool isAlreadyDownloded(List<Download> movies, String movieId) {
    if (movies.firstWhereOrNull((element) => element.movieId == movieId) != null) {
      Get.back();
      if (!Get.isSnackbarOpen) {
        Get.rawSnackbar(message: 'Already Downloded'.tr, duration: const Duration(seconds: 1));
      }
      return true;
    } else {
      return false;
    }
  }

  Future<void> downloadAndStoreMovie(List<Download> movies, Download currentMovie, LocalStorage storage) async {
    try {
      final movieData = await downloadAndStoreFile(currentMovie, true, movies);
      final posterData = await downloadAndStoreFile(currentMovie, false, movies);
      currentMovie.fileName = movieData['file_path'];
      currentMovie.taskId = movieData['task_id'];
      currentMovie.poster = posterData['file_path'];
      movies.add(currentMovie);
      print('called moin movie id ${movieData['task_id']}');
      downloadingTask.add(Downloading(movieId: currentMovie.movieId, progress: 0, taskId: movieData['task_id'], movies: movies));
      // Get.back(); // Kishor
      // if (!Get.isSnackbarOpen) {
      //   Get.rawSnackbar(
      //       title: 'Successful',
      //       message: 'Movie Download Successfully',
      //       duration: const Duration(seconds: 1));
      // }
    } catch (e) {
      print('called moin $e');
    }
  }

  void storeMovieInLocal(List<Download> movies) {
    LocalStorage localStorage = LocalStorage('movies');
    localStorage.setItem('movies', movies.map((e) => e.toMap()).toList());
  }

  Future<Map<String, dynamic>> downloadAndStoreFile(Download currentMovie, bool isMovie, List<Download> movies) async {
    // Check for storage permission
    final permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted) {
      // Get the path to the app's documents directory
      final appDocDir = await getApplicationDocumentsDirectory();
      // Create the download directory if it doesn't exist
      String downloadDirctoryPath = "${appDocDir.path}/download";
      bool dirExists = await Directory(downloadDirctoryPath).exists();
      if (!dirExists) {
        final Directory dir = await Directory(downloadDirctoryPath).create(recursive: true);
        downloadDirctoryPath = dir.path;
      }
      // Generate a unique file name using the current date and time
      final currentDate = DateTime.now();
      String fileNameWithDate =
          '${currentMovie.movieName}${currentDate.year}${currentDate.month}${currentDate.day}${currentDate.hour}${currentDate.minute}${currentDate.second}${currentDate.millisecond}';
      fileNameWithDate = fileNameWithDate.replaceAll(" ", "_");
      String url = "";
      if (currentMovie.poster!.startsWith("${AppUrls.baseUrl}")) {
        url = "${currentMovie.poster}";
      } else {
        url = "${AppUrls.baseUrl}/${currentMovie.poster}";
      }
      // Download the file
      final taskId = await FlutterDownloader.enqueue(
        url: isMovie ? currentMovie.movieUrl! : url,
        savedDir: downloadDirctoryPath,
        fileName: fileNameWithDate,
        showNotification: isMovie,
        openFileFromNotification: false,
      );
      // Return the file path and task id (if downloading a movie)
      return isMovie ? {"file_path": "$downloadDirctoryPath/$fileNameWithDate", "task_id": taskId} : {"file_path": "$downloadDirctoryPath/$fileNameWithDate"};
    } else {
      // Return empty map if storage permission not granted
      return {};
    }
  }
}

class Downloading {
  int? progress;
  String? movieId;
  String? taskId;
  DownloadTaskStatus? status;
  List<Download>? movies;

  Downloading({this.progress, this.movieId, this.taskId, this.status, this.movies});
}
