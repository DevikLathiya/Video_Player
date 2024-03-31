import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_keys.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/movie_detail_model.dart';
import 'package:hellomegha/screens/home/download_controller.dart';
import 'package:hellomegha/screens/home/model/download_model.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/strings.dart';

class DownloadView extends StatefulWidget {
  final List<MovieVideo> qualities;
  final String movieName;
  final String poster;
  final String movieId;
  const DownloadView(
      {Key? key,
        required this.qualities,
        required this.movieName,
        required this.poster,
        required this.movieId})
      : super(key: key);

  @override
  State<DownloadView> createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  DownloadController downloadController = Get.find<DownloadController>();

  @override
  void initState() {
    super.initState();

    downloadController.selectedQuality = widget.qualities.first;
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }
      else
      {

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
        child: Obx(() => Column(
          children: [
            Text(
              "Video Resolution Quality".tr,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20,
            ),
            ...widget.qualities
                .map((e) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  e.qty ?? "",
                  style:
                  const TextStyle(fontWeight: FontWeight.w600),
                ),
                Radio<MovieVideo>(
                    value: e,
                    fillColor: MaterialStateProperty.all(
                        const Color(0xffFDB706)),
                    groupValue: downloadController.selectedQuality,
                    onChanged: (value) {
                      downloadController.selectedQuality = value!;
                    })
              ],
            ))
                .toList(),
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
                    child:  Text(
                      'Cancel'.tr,
                    )),
                const SizedBox(
                  width: 25,
                ),
                TextButton(
                    onPressed: () async {
                      final ConnectivityResult result =
                      await Connectivity().checkConnectivity();

                      if (result == ConnectivityResult.mobile) {
                        final pref = await SharedPreferences.getInstance();
                        final isWifiOnly =
                        pref.getBool(PrefKeys.downloadMode);
                        if (isWifiOnly != null && isWifiOnly) {
                          handleApiError(
                              'Please turn on your Wifi'.tr, context);
                          Get.back();
                          return;
                        }
                      }
                      // if (downloadController.selectedQuality.qty == null) {
                      //   downloadController.selectedQuality = getMovies()[getMovies().length - 1];
                      // }
                      // if(result.name)
                      downloadController.downloadVideo(Download(
                          movieName: widget.movieName,
                          poster: widget.poster,
                          movieUrl:
                          downloadController.selectedQuality.fileName ??
                              "",
                          qty: downloadController.selectedQuality.qty!,
                          movieId: downloadController
                              .selectedQuality.movieId
                              .toString()));
                      Get.back();
                    },
                    child:  Text(
                      'Download'.tr,
                    ))
              ],
            )
          ],
        )),
      ),
    );
  }
}
