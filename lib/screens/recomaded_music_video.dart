import 'package:flutter/material.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/home/musiv_video_detail_view.dart';
import 'package:hellomegha/screens/search/search.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get/get.dart';
import 'home/more_view.dart';
import 'notifications_view.dart';

class RecomandedMusicVideo extends ConsumerStatefulWidget {
  const RecomandedMusicVideo({Key? key}) : super(key: key);

  @override
  ConsumerState<RecomandedMusicVideo> createState() =>
      _RecomandedMusicVideoState();
}

class _RecomandedMusicVideoState extends ConsumerState<RecomandedMusicVideo> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.watch(musicVideoListProvider).musicListAPI(context: context);
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
              overflow: TextOverflow.ellipsis,
              'Recommend Music Videos'.tr,
              style: TextStyle(
                  fontFamily: Strings.robotoMedium,
                  fontSize: 21.0,
                  color: Colors.black),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              search("Music Video".tr)));
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Icon(Icons.search_rounded),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const NotificationsView()));
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Icon(Icons.notifications_none),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MoreView()),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFECC00),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child:
                      Icon(Icons.person_rounded, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: ref.watch(musicVideoListProvider).musicVideoList != null &&
                  ref.watch(musicVideoListProvider).musicVideoList!.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 10.0, top: 5, bottom: 5),
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            '${ref.watch(musicVideoListProvider).musicVideoList!.length} Music',
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
                              .watch(musicVideoListProvider)
                              .musicVideoList!
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
                                            MusicVideoDetailView(
                                              movieId: ref
                                                  .watch(musicVideoListProvider)
                                                  .musicVideoList![index]
                                                  .id
                                                  .toString(),
                                            )));
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: SizedBox(
                                          height: 80,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: CommonImage(
                                              imageUrl: ref
                                                  .watch(musicVideoListProvider)
                                                  .musicVideoList![index]
                                                  .poster)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: Text(
                                      ref
                                          .watch(musicVideoListProvider)
                                          .musicVideoList![index]
                                          .name,
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
