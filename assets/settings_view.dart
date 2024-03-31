import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

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
        title: const Text(
          'App Settings',
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
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Video Playback',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomListTile(
            iconName: 'assets/network.png',
            title: 'Cellular Data Usage',
            subtitle: 'Wi-Fi Only',
            onTap: () {},
          ),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomListTile(
            iconName: 'assets/notification.png',
            title: 'Allow Notifications',
            subtitle: 'Customize in Settings',
            trailing: Switch(
              value: true,
              activeColor: const Color(0xffFECC00),
              activeTrackColor: const Color(0xff535353),
              onChanged: (v) {},
            ),
            onTap: () {},
          ),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Downloads',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomListTile(
            iconName: 'assets/wifi.png',
            title: 'Wi-Fi Only',
            trailing: Switch(
              value: true,
              activeColor: const Color(0xffFECC00),
              activeTrackColor: const Color(0xff535353),
              onChanged: (v) {},
            ),
            onTap: () {},
          ),
          CustomListTile(
            iconName: 'assets/smart_download.png',
            title: 'Smart Downloads',
            onTap: () {},
          ),
          CustomListTile(
            iconName: 'assets/download.png',
            title: 'Download Video Quality',
            subtitle: 'Standard',
            onTap: () {},
          ),
          CustomListTile(
            iconName: 'assets/download_location.png',
            title: 'Download Location',
            subtitle: 'Internal Storage',
            onTap: () {},
          ),
          CustomListTile(
            iconName: 'assets/delete_download.png',
            title: 'Delete All Downloads',
            onTap: () {},
          ),
        ],
      )),
    );
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
