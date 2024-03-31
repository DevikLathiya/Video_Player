import 'package:flutter/material.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/home/movie_detail_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class SuggestedMoviesListView extends ConsumerStatefulWidget {
  const SuggestedMoviesListView({Key? key}) : super(key: key);

  @override
  ConsumerState<SuggestedMoviesListView> createState() =>
      _SuggestedMoviesListViewState();
}

class _SuggestedMoviesListViewState
    extends ConsumerState<SuggestedMoviesListView> {
  List<String> music = [
    "https://upload.wikimedia.org/wikipedia/en/9/96/Brave_Poster.jpg",
    "https://upload.wikimedia.org/wikipedia/en/f/f7/Spies_in_Disguise_Final_Poster.jpeg",
    "https://m.media-amazon.com/images/M/MV5BNWMzZjNjMjgtYjdlNS00ZmNiLThlYWQtOTkyNmNmZjBlOTdhXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_.jpg",
    "https://upload.wikimedia.org/wikipedia/en/7/7e/Ice_Age_Scrat_Tales_Poster.jpg",
    "https://upload.wikimedia.org/wikipedia/en/9/96/Brave_Poster.jpg",
    "https://upload.wikimedia.org/wikipedia/en/f/f7/Spies_in_Disguise_Final_Poster.jpeg",
    "https://m.media-amazon.com/images/M/MV5BNWMzZjNjMjgtYjdlNS00ZmNiLThlYWQtOTkyNmNmZjBlOTdhXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_.jpg",
    "https://upload.wikimedia.org/wikipedia/en/7/7e/Ice_Age_Scrat_Tales_Poster.jpg",
    "https://lumiere-a.akamaihd.net/v1/images/p_frozen_18373_3131259c.jpeg?region=0%2C0%2C540%2C810",
    "https://lumiere-a.akamaihd.net/v1/images/p_frankenweenie2012_20501_06183b98.jpeg",
    "https://www.joblo.com/wp-content/uploads/2012/04/oblivion-Imax-poster-4-9-1.jpg",
    "https://upload.wikimedia.org/wikipedia/en/1/19/Iron_Man_3_poster.jpg",
    "https://www.asparkleofgenius.com/wp-content/uploads/2017/03/image003.jpg",
    "https://wallup.net/wp-content/uploads/2019/07/24/748894-spider-man-superhero-marvel-spider-man-action-spiderman-poster-748x997.jpg",
    "https://wallpapersmug.com/download/1600x900/b41742/thanos-and-the-black-order.jpg",
    "https://a10.gaanacdn.com/gn_img/albums/DwPKOBbqVZ/PKOx5awz3q/size_m.jpg",
    "https://a10.gaanacdn.com/gn_img/albums/qa4WEqWP1p/4WEky0e8KP/size_m.jpg",
    "https://a10.gaanacdn.com/gn_img/albums/oAJbDElKnL/JbDEgg60Kn/size_m.jpg",
    "https://a10.gaanacdn.com/gn_img/albums/Dk9KN2KBx1/9KNkaBp93B/size_m.jpg",
    "https://a10.gaanacdn.com/gn_img/albums/kGxbnw0Ky4/xbnwoP61Ky/size_m.jpg",
    "https://a10.gaanacdn.com/gn_img/albums/10q3ZR1352/q3ZRrjZo35/size_m.jpg",
  ];

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   ref
  //       .watch(suggestedMoviesListProvider)
  //       .suggestedMoviesListAPI(context: context);
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }
      else
      {
        ref
            .watch(suggestedMoviesListProvider)
            .suggestedMoviesListAPI(context: context);
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
              'Movies',
              style: TextStyle(
                  fontFamily: Strings.robotoMedium,
                  fontSize: 21.0,
                  color: Colors.black),
            ),
            actions: [
              const Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Icon(Icons.search_rounded),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Icon(Icons.notifications_none),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFECC00),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.person_rounded, color: Colors.white),
                  ),
                ),
              )
            ],
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ref.watch(suggestedMoviesListProvider).suggestList != null &&
                ref.watch(suggestedMoviesListProvider).suggestList!.isNotEmpty
            ? Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 10.0, top: 5, bottom: 5),
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          '${ref.watch(suggestedMoviesListProvider).suggestList!.length} Movies',
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
                            .watch(suggestedMoviesListProvider)
                            .suggestList!
                            .length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.32,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MoviesDetailView(
                                        movieId: ref
                                            .watch(suggestedMoviesListProvider)
                                            .suggestList![index]
                                            .id!
                                            .toString())),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: SizedBox(
                                        height: 100,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: CommonImage(
                                            imageUrl:
                                                '${AppUrls.baseUrl}${ref.watch(suggestedMoviesListProvider).suggestList![index].poster!}')),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12.0),
                                  child: Text(
                                    ref
                                        .watch(suggestedMoviesListProvider)
                                        .suggestList![index]
                                        .name!,
                                    style: TextStyle(
                                        fontFamily: Strings.robotoRegular,
                                        fontSize: 14.0,
                                        color: Colors.black),
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
            : const SizedBox(),
      ),
    );
  }
}
