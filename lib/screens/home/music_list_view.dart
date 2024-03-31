import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/music/music_player_activity.dart';
import 'package:hellomegha/music/music_view.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get/get.dart';
class MusicListView extends ConsumerStatefulWidget {


  MusicListView({Key? key, required this.categoryType}) : super(key: key);


  final String categoryType;

  @override
  ConsumerState<MusicListView> createState() => _MusicListViewState();
}

class _MusicListViewState extends ConsumerState<MusicListView> {
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   ref.watch(musicAlbumListProvider).musicListAPI(context: context);
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(widget.categoryType);

    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }
      else
      {
        ref.watch(musicAlbumListProvider).musicListAPI(context: context);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 3.0),
                child: SizedBox(
                  height: 27,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              'Music'.tr,
              style: TextStyle(
                  fontFamily: Strings.robotoMedium,
                  fontSize: 21.0,
                  color: Colors.black),
            ),
            // actions: [
            //   const Padding(
            //     padding: EdgeInsets.only(right: 15.0),
            //     child: Icon(Icons.search_rounded),
            //   ),
            //   const Padding(
            //     padding: EdgeInsets.only(right: 15.0),
            //     child: Icon(Icons.notifications_none),
            //   ),
            //   Padding(
            //     padding: const EdgeInsets.only(right: 15.0),
            //     child: Container(
            //       decoration: const BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: Color(0xFFFECC00),
            //       ),
            //       child: const Padding(
            //         padding: EdgeInsets.all(4.0),
            //         child: Icon(Icons.person_rounded, color: Colors.white),
            //       ),
            //     ),
            //   )
            // ],
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: ref.watch(musicAlbumListProvider).albumList != null &&
                  ref.watch(musicAlbumListProvider).albumList!.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 10.0, top: 5, bottom: 5),
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
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MusicPlayerActivity(
                                                id: ref
                                                    .watch(
                                                        musicAlbumListProvider)
                                                    .albumList![index]
                                                    .id!,
                                                title: ref
                                                    .watch(
                                                        musicAlbumListProvider)
                                                    .albumList![index]
                                                    .title!,
                                                thumbnail_image: ref
                                                    .watch(
                                                        musicAlbumListProvider)
                                                    .albumList![index]
                                                    .thumbnailImage!,
                                                description: ref
                                                    .watch(
                                                        musicAlbumListProvider)
                                                    .albumList![index]
                                                    .description!)));
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: SizedBox(
                                        height: 100,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: CommonImage(
                                          imageUrl:
                                              '${AppUrls.baseUrl}${ref.watch(musicAlbumListProvider).albumList![index].thumbnailImage!}',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: Text(
                                      ref
                                          .watch(musicAlbumListProvider)
                                          .albumList![index]
                                          .title!,
                                      style: TextStyle(
                                        fontFamily: Strings.robotoRegular,
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
}
