import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/home/stories_detail_view.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifications_view.dart';
import '../search/search.dart';
import 'more_view.dart';

class StoriesListView extends ConsumerStatefulWidget {
  const StoriesListView({Key? key}) : super(key: key);

  @override
  ConsumerState<StoriesListView> createState() => _StoriesListViewState();
}

class _StoriesListViewState extends ConsumerState<StoriesListView> {
  List<String> music = [
    "https://thefolktales.com/media/2019/05/Featured-image-The-folk-tales-of-Meghalaya.jpg",
    "https://static.toiimg.com/photo/92933202.cms",
    "https://www.hlimg.com/images/stories/738X538/images-8_1589945942-9152e.jpg",
    "https://static.toiimg.com/photo/93036421/93036421.jpg?v=3",
    "https://thefolktales.com/media/2019/05/Featured-image-The-folk-tales-of-Meghalaya.jpg",
    "https://static.toiimg.com/photo/92933202.cms",
    "https://thefolktales.com/media/2019/05/Featured-image-The-folk-tales-of-Meghalaya.jpg",
    "https://static.toiimg.com/photo/92933202.cms",
    "https://www.hlimg.com/images/stories/738X538/images-8_1589945942-9152e.jpg",
    "https://static.toiimg.com/photo/93036421/93036421.jpg?v=3",
    "https://www.hlimg.com/images/stories/738X538/images-8_1589945942-9152e.jpg",
    "https://static.toiimg.com/photo/93036421/93036421.jpg?v=3",
    "https://upload.wikimedia.org/wikipedia/en/f/f7/Spies_in_Disguise_Final_Poster.jpeg",
    "https://a10.gaanacdn.com/gn_img/albums/DwPKOBbqVZ/PKOx5awz3q/size_m.jpg",
    "https://a10.gaanacdn.com/gn_img/albums/qa4WEqWP1p/4WEky0e8KP/size_m.jpg",
    "https://a10.gaanacdn.com/gn_img/albums/oAJbDElKnL/JbDEgg60Kn/size_m.jpg",
    "https://a10.gaanacdn.com/gn_img/albums/Dk9KN2KBx1/9KNkaBp93B/size_m.jpg",
    "https://a10.gaanacdn.com/gn_img/albums/kGxbnw0Ky4/xbnwoP61Ky/size_m.jpg",
    "https://a10.gaanacdn.com/gn_img/albums/10q3ZR1352/q3ZRrjZo35/size_m.jpg",
  ];
  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   ref.watch(storyListProvider).storyListAPI(context: context);
  // }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }
      else{
        ref.watch(storyListProvider).storyListAPI(context: context);
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
              'Stories',
              style: TextStyle(
                  fontFamily: Strings.robotoMedium,
                  fontSize: 21.0,
                  color: Colors.black),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              search("Storie")));
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
        child: ref.watch(storyListProvider).storyListModel != null &&
                ref
                    .watch(storyListProvider)
                    .storyListModel!
                    .storiesList!
                    .isNotEmpty
            ? Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 10.0, top: 5, bottom: 5),
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          '${ref.watch(storyListProvider).storyListModel!.storiesList!.length} Stories',
                          style: TextStyle(
                              fontFamily: Strings.robotoMedium,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Colors.black),
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.all(10.0),
                      //   padding: const EdgeInsets.only(
                      //       left: 7.0, right: 7.0, top: 3, bottom: 3),
                      //   decoration: BoxDecoration(
                      //       border: Border.all(color: Colors.amber)),
                      //   child: Row(
                      //     children: const [
                      //       Icon(Icons.filter_alt_outlined,
                      //           color: Colors.amber),
                      //       Text('Filter'),
                      //     ],
                      //   ),
                      // )
                    ]),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ref
                            .watch(storyListProvider)
                            .storyListModel!
                            .storiesList!
                            .length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StoriesDetailView(
                                        storyId: ref
                                            .watch(storyListProvider)
                                            .storyListModel!
                                            .storiesList![index]
                                            .id
                                            .toString())),
                              );
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: SizedBox(
                                      height: 80,
                                      width: MediaQuery.of(context).size.width,
                                      child: CommonImage(
                                          imageUrl:
                                              '${AppUrls.baseUrl}${ref.watch(storyListProvider).storyListModel!.storiesList![index].poster!}'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text(
                                    ref
                                        .watch(storyListProvider)
                                        .storyListModel!
                                        .storiesList![index]
                                        .name!,
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: Strings.robotoRegular,
                                        fontSize: 14.0,
                                        color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}
