import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:disk_space/disk_space.dart';
import 'package:external_path/external_path.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_keys.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/screens/home/model/download_model.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hellomegha/screens/CommonWebView.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home/model/download_model.dart';
import 'package:path_provider/path_provider.dart';

import 'package:external_path/external_path.dart';
import '../languages.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  double _diskSpace = 0;
  Map<Directory, double> _directorySpace = {};
  bool isExternalStorageAvailable = false;
  bool value = true;
  bool getinform = false;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String language = "";
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getinfo();
  //   initDiskSpace();
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }
      else
      {
        getinfo();
        initDiskSpace();
      }
    });
  }
  Future<void> initDiskSpace() async {
    double? diskSpace = 0;
    diskSpace = await DiskSpace.getFreeDiskSpace;
    // Kishor
    List<String> exPath = [];
    exPath = await ExternalPath.getExternalStorageDirectories();
    isExternalStorageAvailable = (exPath.length > 1);
    // Kishor
    List<Directory> directories;
    Map<Directory, double> directorySpace = {};
    if (Platform.isIOS) {
      directories = [await getApplicationDocumentsDirectory()];
    } else if (Platform.isAndroid) {
      directories =
          await getExternalStorageDirectories(type: StorageDirectory.movies)
              .then(
        (list) async => list ?? [await getApplicationDocumentsDirectory()],
      );
    } else {
      return;
    }
    for (var directory in directories) {
      var space = await DiskSpace.getFreeDiskSpaceForPath(directory.path);
      directorySpace.addEntries([MapEntry(directory, space!)]);
    }
    if (!mounted) return;
    setState(() {
      _diskSpace = diskSpace!;
      _directorySpace = directorySpace;
    });
  }

  getinfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    _deviceData = _readAndroidBuildData(androidInfo);
    language = await PrefUtils.getlanguage();
    print(_deviceData);
    setState(() {
      getinform = true;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        title: Text(
          'App Settings'.tr,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'Video Playback'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.hasData && snapshot.data != null,
                  child: snapshot.data == null
                      ? const SizedBox.shrink()
                      : CustomListTile(
                          iconName: 'assets/network.png',
                          title: 'Cellular Data Usage'.tr,
                          subtitle: snapshot.data!
                                  .getString(PrefKeys.videoPlayback) ??
                              Strings.wifiAndMobileDataBoth,
                          onTap: () {
                            final pref = snapshot.data;
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: IntrinsicHeight(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: RadioListTile(
                                              value: Strings.wifiOnly,
                                              title: Text(Strings.wifiOnly),
                                              groupValue: snapshot.data!
                                                      .getString(PrefKeys
                                                          .videoPlayback) ??
                                                  Strings.wifiAndMobileDataBoth,
                                              onChanged: (value) async {
                                                pref!.setString(
                                                    PrefKeys.videoPlayback,
                                                    Strings.wifiOnly);
                                                Navigator.pop(context);
                                                setState(() {});
                                              }),
                                        ),
                                        Expanded(
                                          child: RadioListTile(
                                              value: Strings.mobileData,
                                              title: Text(Strings.mobileData),
                                              groupValue: snapshot.data!
                                                      .getString(PrefKeys
                                                          .videoPlayback) ??
                                                  Strings.wifiAndMobileDataBoth,
                                              onChanged: (value) async {
                                                pref!.setString(
                                                    PrefKeys.videoPlayback,
                                                    Strings.mobileData);
                                                Navigator.pop(context);
                                                setState(() {});
                                              }),
                                        ),
                                        Expanded(
                                          child: RadioListTile(
                                              value:
                                                  Strings.wifiAndMobileDataBoth,
                                              title: Text(Strings
                                                  .wifiAndMobileDataBoth),
                                              groupValue: snapshot.data!
                                                      .getString(PrefKeys
                                                          .videoPlayback) ??
                                                  Strings.wifiAndMobileDataBoth,
                                              onChanged: (value) async {
                                                pref!.setString(
                                                    PrefKeys.videoPlayback,
                                                    Strings
                                                        .wifiAndMobileDataBoth);
                                                Navigator.pop(context);
                                                setState(() {});
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                );
              }),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'Notifications'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomListTile(
            iconName: 'assets/notification.png',
            title: 'Allow Notifications'.tr,
            subtitle: 'Customize in Settings'.tr,
            trailing: Switch(
              value: value,
              activeColor: const Color(0xffFECC00),
              activeTrackColor: const Color(0xff535353),
              onChanged: (v) {
                setState(() {
                  value = v;
                });
              },
            ),
            onTap: () {},
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'Downloads'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.hasData,
                  child: snapshot.data == null
                      ? const SizedBox.shrink()
                      : CustomListTile(
                          iconName: 'assets/wifi.png',
                          title: 'Wi-Fi Only',
                          trailing: Switch(
                            value:
                                snapshot.data!.getBool(PrefKeys.downloadMode) ??
                                    false,
                            activeColor: const Color(0xffFECC00),
                            activeTrackColor: const Color(0xff535353),
                            onChanged: (v) {
                              snapshot.data!.setBool(PrefKeys.downloadMode, v);
                              setState(() {});
                            },
                          ),
                          onTap: () {},
                        ),
                );
              }),
          // CustomListTile(
          //   iconName: 'assets/smart_download.png',
          //   title: 'Smart Downloads',
          //   onTap: () {},
          // ),
          FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.hasData && snapshot.data != null,
                  child: snapshot.data == null
                      ? const SizedBox.shrink()
                      : CustomListTile(
                          iconName: 'assets/download.png',
                          title: 'Download Video Quality'.tr,
                          subtitle:
                              snapshot.data!.getString(PrefKeys.videoQuality) ??
                                  Strings.videoQuality720,
                          onTap: () {
                            final pref = snapshot.data;
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: IntrinsicHeight(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ListTile(
                                            title: Text(
                                                "Select Download Video Quality"
                                                    .tr)),
                                        Expanded(
                                          child: RadioListTile(
                                              value: Strings.videoQuality360,
                                              title: Text(
                                                  "${Strings.videoQuality360} px"),
                                              groupValue: snapshot.data!
                                                      .getString(PrefKeys
                                                          .videoQuality) ??
                                                  Strings.videoQuality720,
                                              onChanged: (value) async {
                                                pref!.setString(
                                                    PrefKeys.videoQuality,
                                                    Strings.videoQuality360);
                                                Navigator.pop(context);
                                                setState(() {});
                                              }),
                                        ),
                                        Expanded(
                                          child: RadioListTile(
                                              value: Strings.videoQuality480,
                                              title: Text(
                                                  "${Strings.videoQuality480} px"),
                                              groupValue: snapshot.data!
                                                      .getString(PrefKeys
                                                          .videoQuality) ??
                                                  Strings.videoQuality720,
                                              onChanged: (value) async {
                                                pref!.setString(
                                                    PrefKeys.videoQuality,
                                                    Strings.videoQuality480);
                                                Navigator.pop(context);
                                                setState(() {});
                                              }),
                                        ),
                                        Expanded(
                                          child: RadioListTile(
                                              value: Strings.videoQuality720,
                                              title: Text(
                                                  "${Strings.videoQuality720} px"),
                                              groupValue: snapshot.data!
                                                      .getString(PrefKeys
                                                          .videoQuality) ??
                                                  Strings.videoQuality720,
                                              onChanged: (value) async {
                                                pref!.setString(
                                                    PrefKeys.videoQuality,
                                                    Strings.videoQuality720);
                                                Navigator.pop(context);
                                                setState(() {});
                                              }),
                                        ),
                                        Expanded(
                                          child: RadioListTile(
                                              value: Strings.videoQuality1080,
                                              title: Text(
                                                  "${Strings.videoQuality1080} px"),
                                              groupValue: snapshot.data!
                                                      .getString(PrefKeys
                                                          .videoQuality) ??
                                                  Strings.videoQuality720,
                                              onChanged: (value) async {
                                                pref!.setString(
                                                    PrefKeys.videoQuality,
                                                    Strings.videoQuality1080);
                                                Navigator.pop(context);
                                                setState(() {});
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                );
              }),
          FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.hasData && snapshot.data != null,
                  child: snapshot.data == null
                      ? const SizedBox.shrink()
                      : CustomListTile(
                          iconName: 'assets/download.png',
                          title: 'Play Video Quality'.tr,
                          subtitle: snapshot.data!
                                  .getString(PrefKeys.playVideoQuality) ??
                              Strings.videoQuality720,
                          onTap: () {
                            final pref = snapshot.data;
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: IntrinsicHeight(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ListTile(
                                            title: Text(
                                                "Select Play Video Quality"
                                                    .tr)),
                                        Expanded(
                                          child: RadioListTile(
                                              value: Strings.videoQuality360,
                                              title: Text(
                                                  "${Strings.videoQuality360} px"),
                                              groupValue: snapshot.data!
                                                      .getString(PrefKeys
                                                          .playVideoQuality) ??
                                                  Strings.videoQuality720,
                                              onChanged: (value) async {
                                                pref!.setString(
                                                    PrefKeys.playVideoQuality,
                                                    Strings.videoQuality360);
                                                Navigator.pop(context);
                                                setState(() {});
                                              }),
                                        ),
                                        Expanded(
                                          child: RadioListTile(
                                              value: Strings.videoQuality480,
                                              title: Text(
                                                  "${Strings.videoQuality480} px"),
                                              groupValue: snapshot.data!
                                                      .getString(PrefKeys
                                                          .playVideoQuality) ??
                                                  Strings.videoQuality720,
                                              onChanged: (value) async {
                                                pref!.setString(
                                                    PrefKeys.playVideoQuality,
                                                    Strings.videoQuality480);
                                                Navigator.pop(context);
                                                setState(() {});
                                              }),
                                        ),
                                        Expanded(
                                          child: RadioListTile(
                                              value: Strings.videoQuality720,
                                              title: Text(
                                                  "${Strings.videoQuality720} px"),
                                              groupValue: snapshot.data!
                                                      .getString(PrefKeys
                                                          .playVideoQuality) ??
                                                  Strings.videoQuality720,
                                              onChanged: (value) async {
                                                pref!.setString(
                                                    PrefKeys.playVideoQuality,
                                                    Strings.videoQuality720);
                                                Navigator.pop(context);
                                                setState(() {});
                                              }),
                                        ),
                                        Expanded(
                                          child: RadioListTile(
                                              value: Strings.videoQuality1080,
                                              title: Text(
                                                  "${Strings.videoQuality1080} px"),
                                              groupValue: snapshot.data!
                                                      .getString(PrefKeys
                                                          .playVideoQuality) ??
                                                  Strings.videoQuality720,
                                              onChanged: (value) async {
                                                pref!.setString(
                                                    PrefKeys.playVideoQuality,
                                                    Strings.videoQuality1080);
                                                Navigator.pop(context);
                                                setState(() {});
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                );
              }),
          FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.hasData && snapshot.data != null,
                  child: snapshot.data == null
                      ? const SizedBox.shrink()
                      : CustomListTile(
                          iconName: 'assets/download_location.png',
                          title: 'Download Location'.tr,
                          subtitle: snapshot.data!
                                  .getString(PrefKeys.downloadLocation) ??
                              Strings.internalStorage,
                          onTap: () {
                            final pref = snapshot.data;
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: IntrinsicHeight(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ListTile(
                                            title: Text(
                                                "Select Download Location".tr)),
                                        Expanded(
                                          child: RadioListTile(
                                              value: Strings.internalStorage,
                                              title:
                                                  Text(Strings.internalStorage),
                                              groupValue: snapshot.data!
                                                      .getString(PrefKeys
                                                          .downloadLocation) ??
                                                  Strings.internalStorage,
                                              onChanged: (value) async {
                                                pref!.setString(
                                                    PrefKeys.downloadLocation,
                                                    Strings.internalStorage);
                                                Navigator.pop(context);
                                                setState(() {});
                                              }),
                                        ),
                                        if (isExternalStorageAvailable &&
                                            !(Platform.isIOS))
                                          Expanded(
                                            child: RadioListTile(
                                                value: Strings.externalStorage,
                                                title: Text(
                                                    Strings.externalStorage),
                                                groupValue: snapshot.data!
                                                        .getString(PrefKeys
                                                            .downloadLocation) ??
                                                    Strings.internalStorage,
                                                onChanged: (value) async {
                                                  pref!.setString(
                                                      PrefKeys.downloadLocation,
                                                      Strings.externalStorage);
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                }),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                );
              }),
          // CustomListTile(
          //   iconName: 'assets/download.png',
          //   title: 'Download Video Quality',
          //   subtitle: 'Standard',
          //   onTap: () {},
          // ),
          // CustomListTile(
          //   iconName: 'assets/download_location.png',
          //   title: 'Download Location',
          //   subtitle: 'Internal Storage',
          //   onTap: () {},
          // ),
          CustomListTile(
            iconName: 'assets/delete_download.png',
            title: 'Delete All Downloads'.tr,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Are you sure? you want to to delete all download?'
                                .tr,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
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
                                    final LocalStorage storage =
                                        LocalStorage('movies');
                                    await storage.ready;
                                    var items = storage.getItem('movies');
                                    if (items != null) {
                                      final movies = (items as List)
                                          .map((e) => Download.fromMap(e))
                                          .toList();
                                      Navigator.pop(context);
                                      final files = movies
                                          .map((e) => File(e.fileName!))
                                          .toList();

                                      Future.wait(
                                          files.map((file) => file.delete()));
                                      storage.setItem('movies', []);
                                    }

                                    setState(() {});
                                  },
                                  child: Text(
                                    'Delete'.tr,
                                    style: TextStyle(color: Colors.red),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ).then(
                (value) {
                  setState(() {});
                },
              );
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'Diagnostics'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomListTile(
            iconName: 'assets/certificate.png',
            title: 'Internet Speed Check'.tr,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommonWebView(
                      title: "Internet Speed Check ", url: "https://fast.com"),
                ),
              );
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'Legal'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomListTile(
            iconName: 'assets/certificate.png',
            title: 'Open-Source Licenses'.tr,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommonWebView(
                      title: "Open-Source Licences",
                      url:
                          "http://prabhu.yoursoftwaredemo.com/opensourcelicence"),
                ),
              );
            },
          ),
          CustomListTile(
            iconName: 'assets/privacypolicy.png',
            title: 'Privacy'.tr,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommonWebView(
                      title: "Privacy statement",
                      url: "http://prabhu.yoursoftwaredemo.com/privacy"),
                ),
              );
            },
          ),
          CustomListTile(
            iconName: 'assets/cookie.png',
            title: 'Cookie Preference'.tr,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommonWebView(
                      title: "Cookie Preference ",
                      url:
                          "http://prabhu.yoursoftwaredemo.com/cookiespreference"),
                ),
              );
            },
          ),
          CustomListTile(
            iconName: 'assets/cookie.png',
            title: 'Terms of Use'.tr,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommonWebView(
                      title: "Terms of Use",
                      url: "http://prabhu.yoursoftwaredemo.com/termsofuse"),
                ),
              );
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'Help'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomListTile(
            iconName: 'assets/certificate.png',
            title: 'Help Centre ( 1800 572 4549 )',
            onTap: () {
              _launchUrl();
            },
          ),
          CustomListTile(
            iconName: 'assets/privacypolicy.png',
            title: 'Privacy Agreement'.tr,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommonWebView(
                      title: "Privacy Agreement",
                      url: "http://prabhu.yoursoftwaredemo.com/privacy_mobile"),
                ),
              );
            },
          ),
          CustomListTile(
            iconName: 'assets/cookie.png',
            title: 'Terms of Use'.tr,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommonWebView(
                      title: "Terms of Use",
                      url: "http://prabhu.yoursoftwaredemo.com/termsofuse"),
                ),
              );
            },
          ),
          CustomListTile(
            iconName: 'assets/cookie.png',
            title: 'Hello Meghalaya customer service'.tr,
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => CommonWebView(title:"Terms of Use",url: "http://prabhu.yoursoftwaredemo.com/termsofuse"),
              //   ),
              // );
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'About'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          getinform
              ? CustomListTile(
                  iconName: 'assets/cookie.png',
                  title:
                      'Device ${_deviceData['version.sdkInt']} build ${_deviceData['version.release']}(code ${_deviceData['version.codename']}) ${_deviceData['model']} ${_deviceData['board']} ${_deviceData['brand']}',
                  onTap: () {},
                )
              : SizedBox(),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'Your Preferred Language'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomListTile(
            iconName: 'assets/cookie.png',
            title: 'Your Preffered Language'.tr,
            subtitle: language,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => languages(),
                ),
              );
            },
          ),
        ],
      )),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse("tel://1800 572 4549"))) {
      throw Exception('Could not launch');
    }
  }
}

class CustomListTile extends StatelessWidget {
  final String iconName;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final GestureTapCallback onTap;
  const CustomListTile({
    Key? key,
    required this.iconName,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: ListTile(
        dense: true,
        onTap: onTap,
        leading: Image.asset(
          iconName,
          width: 20,
          height: 20,
          fit: BoxFit.contain,
        ),
        tileColor: const Color(0xffF5F5F5),
        title: Text(
          title,
          style: const TextStyle(color: Color(0xff272727)),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: const TextStyle(color: Color(0xff878787)),
              )
            : null,
        trailing: trailing,
      ),
    );
  }
}
