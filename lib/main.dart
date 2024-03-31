import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hellomegha/NotificationBadge.dart';
import 'package:hellomegha/PushNotification.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'WorldLanguage.dart';
import 'core/api_factory/prefs/pref_keys.dart';
import 'core/utils/strings.dart';
import 'splash_view.dart';
import 'package:http/http.dart' as http;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Kishor
  final pref = await SharedPreferences.getInstance();

  if (pref.getString(PrefKeys.videoQuality) == null) {
    pref.setString(
        PrefKeys.videoQuality,
        Strings
            .videoQuality720);
  }
  if (pref.getString(PrefKeys.playVideoQuality) == null) {
    pref.setString(
        PrefKeys.playVideoQuality,
        Strings
            .videoQuality720);
  }
  var isLoggedIn = await PrefUtils.getIsLoggedIn() ?? false;
// Plugin must be initialized before using
  await FlutterDownloader.initialize(
      debug: true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
      );
  JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    Permission.camera,
    Permission.bluetooth,
    Permission.photos,

  ].request();
  runApp(ProviderScope(
    child: MyApp(isLoggedIn: isLoggedIn),
  ));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // FirebaseMessaging? _messaging;
  //
  // PushNotification? _notificationInfo;
  //
  // int _totalNotifications=0;
  //
  // void registerNotification() async {
  //   await Firebase.initializeApp();
  //   _messaging = FirebaseMessaging.instance;
  //
  //   // 3. On iOS, this helps to take the user permissions
  //   NotificationSettings settings = await _messaging!.requestPermission(
  //     alert: true,
  //     badge: true,
  //     provisional: false,
  //     sound: true,
  //   );
  //
  //   print(settings);
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       print("Hello1$message");
  //       if (_notificationInfo != null) {
  //         // For displaying the notification as an overlay
  //         showSimpleNotification(
  //           Text(_notificationInfo!.title!),
  //           leading: NotificationBadge(totalNotifications: _totalNotifications),
  //           subtitle: Text(_notificationInfo!.body!),
  //           // background: Colors.cyan.shade700,
  //           duration: Duration(seconds: 2),
  //         );
  //       }
  //     });
  //   } else {
  //     print('User declined or has not accepted permission');
  //   }
  // }
  // checkForInitialMessage() async {
  //   await Firebase.initializeApp();
  //   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  //   print("Hello2$initialMessage");
  //   if (initialMessage != null) {
  //     PushNotification notification = PushNotification(
  //       title: initialMessage.notification?.title,
  //       body: initialMessage.notification?.body,
  //       dataTitle: initialMessage.data['title'],
  //       dataBody: initialMessage.data['body'],
  //     );
  //     setState(() {
  //       _notificationInfo = notification;
  //       _totalNotifications++;
  //     });
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       print("Hello$message");
  //       if (_notificationInfo != null) {
  //         // For displaying the notification as an overlay
  //         showSimpleNotification(
  //           Text(_notificationInfo!.title!),
  //           leading: NotificationBadge(totalNotifications: _totalNotifications),
  //           subtitle: Text(_notificationInfo!.body!),
  //           background: Colors.grey.withOpacity(0.5),
  //           duration: Duration(seconds: 2),
  //         );
  //       }
  //     });
  //   }
  // }
  //
  // @override
  // void initState() {
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     PushNotification notification = PushNotification(
  //       title: message.notification?.title,
  //       body: message.notification?.body,
  //     );
  //     setState(() {
  //       _notificationInfo = notification;
  //       _totalNotifications++;
  //     });
  //   });
  //   checkForInitialMessage();
  //   registerNotification();
  //
  //   // TODO: implement initState
  //   super.initState();
  //   PrefUtils.setlanguage("english");
  //
  // }

   static Future init() async {
     String? _getImageUrl(RemoteNotification notification) {
       if (Platform.isIOS && notification.apple != null) return notification.apple?.imageUrl;
       if (Platform.isAndroid && notification.android != null) return notification.android?.imageUrl;
       return null;
     }
     AndroidNotificationChannel channel = AndroidNotificationChannel(
       'my_channel', // id
       'My Channel', // title
       'Important notifications from my server.', // description
       importance: Importance.high,
     );
     await Firebase.initializeApp();
     FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
     _firebaseMessaging.getToken().then((value){
       print("hello=====>$value");
       PrefUtils.setfcmToken(value!);
     });
     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
     await flutterLocalNotificationsPlugin
         .resolvePlatformSpecificImplementation<
         AndroidFlutterLocalNotificationsPlugin>()
         ?.createNotificationChannel(channel);
     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
       alert: true,
       badge: true,
       sound: true,
     );
     BigPictureStyleInformation? _buildBigPictureStyleInformation(
         String title,
         String body,
         String? picturePath,
         bool showBigPicture,
         ) {
       if (picturePath == null) return null;
       final FilePathAndroidBitmap filePath = FilePathAndroidBitmap(picturePath);
       return BigPictureStyleInformation(
         showBigPicture ? filePath : const FilePathAndroidBitmap("empty"),
         largeIcon: filePath,
         contentTitle: title,
         htmlFormatContentTitle: true,
         summaryText: body,
         htmlFormatSummaryText: true,
       );
     }
     NotificationDetails _buildDetails(String title, String body, String? picturePath, bool showBigPicture) {
       final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
         channel.id,
         channel.name,
         channel.description,
         styleInformation: _buildBigPictureStyleInformation(title, body, picturePath, showBigPicture),
         importance: channel.importance,
         icon:  "@mipmap/ic_launcher",
       );
       final IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(
         attachments: [if (picturePath != null) IOSNotificationAttachment(picturePath)],
       );
       final NotificationDetails details = NotificationDetails(
         android: androidPlatformChannelSpecifics,
         iOS: iOSPlatformChannelSpecifics,
       );
       return details;
     }
     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
       RemoteNotification? notification = message.notification;
       AndroidNotification? android = message.notification?.android;
       print("hello1 ${notification!.title}");
       print("hello1 ${android!.channelId}");
       if (notification != null && android != null) {
         await flutterLocalNotificationsPlugin.show(
           notification.hashCode,
           notification.title,
           notification.body,
           _buildDetails(notification.title!, notification.body!, _getImageUrl(notification), true),
         );
         // flutterLocalNotificationsPlugin.show(
         //     notification.hashCode,
         //     notification.title,
         //     notification.body,
         //     NotificationDetails(
         //       android: AndroidNotificationDetails(
         //         channel.id,
         //         channel.name,
         //         channel.description,
         //           styleInformation: _buildBigPictureStyleInformation(title, body, picturePath, showBigPicture),
         //           importance: channel.importance,
         //         icon: "@mipmap/ic_launcher"
         //       ),
         //     )
         // );
       }
     });
   }
  @override
  void initState() {
    init();
    PrefUtils.setlanguage("English");
  }
   @override
   void didChangeDependencies() {
     super.didChangeDependencies();
     SystemChrome.setPreferredOrientations([
       DeviceOrientation.portraitDown,
       DeviceOrientation.portraitUp,
     ]);
   }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
        child: ScreenUtilInit(builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            translations: WorldLanguage(), //Language class from world_languages.dart
            locale: Locale('en', 'US'), // translations will be displayed in that locale
            fallbackLocale: Locale('en', 'US'),
            title: "HelloMegha".tr,
            theme: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: const Color(0xFFB0CB1F),
                  ),
            ),
            home: Splash(isLoggedIn: widget.isLoggedIn),
          );
        }),
      ),
    );
  }
}

class OnlineList extends StatefulWidget with WidgetsBindingObserver {
  @override
  _OnlineListState createState() => _OnlineListState();
}
class _OnlineListState extends State<OnlineList> {
  final _urls = [
  'https://youtu.be/sXEWsTq_ryQ',
  'https://youtu.be/qu11pv6JgiQ',
  ];
  List<Map> downloadsListMaps= [];
  @override
  void initState() {
    task();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }
  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }
  Future task() async {
    List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();
    getTasks!.forEach((_task) {
      Map _map = Map();
      _map['status'] = _task.status;
      _map['progress'] = _task.progress;
      _map['id'] = _task.taskId;
      _map['filename'] = _task.filename;
      _map['savedDirectory'] = _task.savedDir;
      downloadsListMaps.add(_map);
    });
    setState(() {});
  }
  Widget downloadStatusWidget(DownloadTaskStatus _status) {
    return _status == DownloadTaskStatus.canceled
        ? Text('Download canceled')
        : _status == DownloadTaskStatus.complete
        ? Text('Download completed')
        : _status == DownloadTaskStatus.failed
        ? Text('Download failed')
        : _status == DownloadTaskStatus.paused
        ? Text('Download paused')
        : _status == DownloadTaskStatus.running
        ? Text('Downloading..')
        : Text('Download waiting');
  }
  Widget buttons(DownloadTaskStatus _status, String taskid, int index) {
    void changeTaskID(String taskid, String newTaskID) {
      Map? task = downloadsListMaps?.firstWhere(
            (element) => element['taskId'] == taskid,
        orElse: () => {},
      );
      task!['taskId'] = newTaskID;
      setState(() {});
    }
    return _status == DownloadTaskStatus.canceled
        ? GestureDetector(
      child: Icon(Icons.cached, size: 20, color: Colors.green),
      onTap: () {
        FlutterDownloader.retry(taskId: taskid)
            .then((newTaskID) {
          changeTaskID(taskid, newTaskID!);
        });
      },
    )
        : _status == DownloadTaskStatus.failed
        ? GestureDetector(
      child: Icon(Icons.cached, size: 20, color: Colors.green),
      onTap: () {
        FlutterDownloader.retry(taskId: taskid).then((newTaskID) {
          changeTaskID(taskid, newTaskID!);
        });
      },
    )
        : _status == DownloadTaskStatus.paused
        ? Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          child: Icon(Icons.play_arrow,
              size: 20, color: Colors.blue),
          onTap: () {
            FlutterDownloader.resume(taskId: taskid).then(
                  (newTaskID) => changeTaskID(taskid, newTaskID!),
            );
          },
        ),
        GestureDetector(
          child: Icon(Icons.close, size: 20, color: Colors.red),
          onTap: () {
            FlutterDownloader.cancel(taskId: taskid);
          },
        )
      ],
    )
        : _status == DownloadTaskStatus.running
        ? Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          child: Icon(Icons.pause,
              size: 20, color: Colors.green),
          onTap: () {
            FlutterDownloader.pause(taskId: taskid);
          },
        ),
        GestureDetector(
          child:
          Icon(Icons.close, size: 20, color: Colors.red),
          onTap: () {
            FlutterDownloader.cancel(taskId: taskid);
          },
        )
      ],
    )
        : _status == DownloadTaskStatus.complete
        ? GestureDetector(
      child:
      Icon(Icons.delete, size: 20, color: Colors.red),
      onTap: () {
        downloadsListMaps.removeAt(index);
        FlutterDownloader.remove(
            taskId: taskid, shouldDeleteContent: true);
        setState(() {});
      },
    )
        : Container();
  }
  ReceivePort _port = ReceivePort();
  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      var task = downloadsListMaps?.where((element) => element['id'] == id);
      task!.forEach((element) {
        element['progress'] = progress;
        element['status'] = status;
        setState(() {});
      });
    });
  }
  static void downloadCallback(
      String id, int status, int progress) {
    final SendPort? send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }
  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online links'),
      ),
      body:downloadsListMaps.length == 0
          ? Center(child: Text("No Downloads yet"))
          : Container(
        child: ListView.builder(
          itemCount: downloadsListMaps.length,
          itemBuilder: (BuildContext context, int i) {
            Map _map = downloadsListMaps[i];
            String _filename = _map['filename'];
            int _progress = _map['progress'];
            DownloadTaskStatus _status = _map['status'];
            String _id = _map['id'];
            String _savedDirectory = _map['savedDirectory'];
            return Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    isThreeLine: false,
                    title: Text(_filename),
                    subtitle: downloadStatusWidget(_status),
                    trailing: SizedBox(
                      child: buttons(_status, _id, i),
                      width: 60,
                    ),
                  ),
                  _status == DownloadTaskStatus.complete
                      ? Container()
                      : SizedBox(height: 5),
                  _status == DownloadTaskStatus.complete
                      ? Container()
                      : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text('$_progress%'),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: LinearProgressIndicator(
                                value: _progress / 100,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Future<void> requestDownload(String _url, String _name) async {
    final dir =
    await getApplicationDocumentsDirectory(); //From path_provider package
    var _localPath = dir.path + _name;
    final savedDir = Directory(_localPath);
    await savedDir.create(recursive: true).then((value) async {
      String? _taskid = await FlutterDownloader.enqueue(
        url: _url,
        fileName: _name,
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: false,
      );
      print(_taskid);
    });
  }
}