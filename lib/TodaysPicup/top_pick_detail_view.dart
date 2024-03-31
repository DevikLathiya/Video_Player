import 'package:flutter/material.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/core/widgets/ab_button.dart';
import 'package:hellomegha/core/widgets/ab_button_grey.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/home/suggest_movies_list_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get/get.dart';
class TopPickupDetailView extends ConsumerStatefulWidget {
  final String movieId;
  const TopPickupDetailView({Key? key, required this.movieId})
      : super(key: key);

  @override
  ConsumerState<TopPickupDetailView> createState() =>
      _TopPickupDetailViewState();
}

class _TopPickupDetailViewState extends ConsumerState<TopPickupDetailView> {
  List<String> cast = [
    "https://pyxis.nymag.com/v1/imgs/a34/e26/dc6b70f9211376a9783b91dd693e1cca9f-brie-larson-captain-marvel.rsquare.w330.jpg",
    "https://m.media-amazon.com/images/M/MV5BMDAxNGE2ODMtNTI0ZC00ZmJhLTg0OTctODdkZTQ1ZWI3NTVkXkEyXkFqcGdeQXVyMTE3ODY2Nzk@._V1_.jpg",
    "https://m.media-amazon.com/images/M/MV5BMmY2OGM1NjEtNGRiZi00NGY5LThjMzMtOTViYTMwOGM2YmE0XkEyXkFqcGdeQXVyNzY1ODU1OTk@._V1_.jpg",
    "https://image.tmdb.org/t/p/w500/uqaJuR24yXL1oXvAqUbOoEGChgb.jpg",
    "https://m.media-amazon.com/images/M/MV5BMTMwOTg5NTQ3NV5BMl5BanBnXkFtZTcwNzM3MDAzNQ@@._V1_.jpg",
    "https://a10.gaanacdn.com/gn_img/albums/10q3ZR1352/q3ZRrjZo35/size_m.jpg",
  ];

  List<String> watchMovie = [
    "https://wallup.net/wp-content/uploads/2019/07/24/748894-spider-man-superhero-marvel-spider-man-action-spiderman-poster-748x997.jpg",
    "https://wallpapersmug.com/download/1600x900/b41742/thanos-and-the-black-order.jpg",
    "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/dramatic-movie-poster-template-design-f0f2c261e077379d0f82604f96b6a774_screen.jpg?ts=1602570456",
    "https://www.joblo.com/wp-content/uploads/2012/04/oblivion-Imax-poster-4-9-1.jpg",
    "https://upload.wikimedia.org/wikipedia/en/1/19/Iron_Man_3_poster.jpg",
    "https://www.asparkleofgenius.com/wp-content/uploads/2017/03/image003.jpg",
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref
        .watch(movieDetailProvider)
        .moviesDetailsAPI(context: context, movieId: widget.movieId);

    ref.watch(topPickedListProvider).topPickedListAPI(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ref.watch(movieDetailProvider).movieDetails != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: SizedBox(
                          height: 230,
                          width: MediaQuery.of(context).size.width,
                          child: CommonImage(
                            imageUrl:
                                '${AppUrls.baseUrl}${ref.watch(movieDetailProvider).movieDetails!.movieDtails!.poster}',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 40),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30,
                              )),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Premium | U/A 7+',
                            style: TextStyle(
                              fontFamily: Strings.robotoRegular,
                              fontSize: 11.0,
                              color: const Color(0xff535353),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 7.0),
                            child: Text(
                                ref
                                        .watch(movieDetailProvider)
                                        .movieDetails!
                                        .movieDtails!
                                        .name!
                                        .isNotEmpty
                                    ? ref
                                        .watch(movieDetailProvider)
                                        .movieDetails!
                                        .movieDtails!
                                        .name!
                                    : '',
                                style: TextStyle(
                                  fontFamily: Strings.robotoMedium,
                                  fontSize: 20.0,
                                  color: const Color(0xff272727),
                                )),
                          ),
                          Text(
                            '2019 . Sci-fi . Action',
                            style: TextStyle(
                              fontFamily: Strings.robotoRegular,
                              fontSize: 11.0,
                              color: const Color(0xff535353),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 7.0),
                            child: Text(
                                ref
                                        .watch(movieDetailProvider)
                                        .movieDetails!
                                        .movieDtails!
                                        .description!
                                        .isNotEmpty
                                    ? ref
                                        .watch(movieDetailProvider)
                                        .movieDetails!
                                        .movieDtails!
                                        .description!
                                    : '',
                                style: TextStyle(
                                  fontFamily: Strings.robotoMedium,
                                  fontSize: 13.0,
                                  letterSpacing: 0.6,
                                  color: const Color(0xff272727),
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ABButtonGery(
                                  paddingTop: 10.0,
                                  paddingBottom: 15.0,
                                  paddingLeft: 1.0,
                                  paddingRight: 15.0,
                                  text: 'Play Trailer'.tr,
                                  onPressed: () {
                                    showSuccessSnackbar(
                                        ref
                                                .watch(movieDetailProvider)
                                                .movieDetails!
                                                .movieDtails!
                                                .trailer!
                                                .isNotEmpty
                                            ? ref
                                                .watch(movieDetailProvider)
                                                .movieDetails!
                                                .movieDtails!
                                                .trailer!
                                            : '',
                                        context);
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => const RegisterView()),
                                    // );
                                  },
                                ),
                              ),
                              Expanded(
                                child: ABButton(
                                  paddingTop: 10.0,
                                  paddingBottom: 15.0,
                                  paddingLeft: 10.0,
                                  paddingRight: 1.0,
                                  text: 'Start Watching'.tr,
                                  onPressed: () {
                                    showSuccessSnackbar(
                                        ref
                                                .watch(movieDetailProvider)
                                                .movieDetails!
                                                .movieDtails!
                                                .thumbnail!
                                                .isNotEmpty
                                            ? ref
                                                .watch(movieDetailProvider)
                                                .movieDetails!
                                                .movieDtails!
                                                .thumbnail!
                                            : '',
                                        context);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.download,
                                      color: Colors.amber, size: 35),
                                  Text('Download',
                                      style: TextStyle(
                                        fontFamily: Strings.robotoMedium,
                                        fontSize: 12.0,
                                        color: const Color(0xff272727),
                                      )),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(Icons.add,
                                      color: Colors.amber, size: 35),
                                  Text('Watch List',
                                      style: TextStyle(
                                        fontFamily: Strings.robotoMedium,
                                        fontSize: 12.0,
                                        color: const Color(0xff272727),
                                      )),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text('Cast'.tr,
                        style: TextStyle(
                          fontFamily: Strings.robotoMedium,
                          fontSize: 16.0,
                          color: const Color(0xff272727),
                        )),
                  ),

                  ref.watch(movieDetailProvider).movieDetails != null &&
                          ref
                              .watch(movieDetailProvider)
                              .movieDetails!
                              .actors!
                              .isNotEmpty
                      ? SizedBox(
                          height: 220,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: ref
                                  .watch(movieDetailProvider)
                                  .movieDetails!
                                  .actors!
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: SizedBox(
                                          height: 170,
                                          width: 120,
                                          child: CommonImage(
                                            imageUrl: ref
                                                    .watch(movieDetailProvider)
                                                    .movieDetails!
                                                    .actors![index]
                                                    .photo!
                                                    .isNotEmpty
                                                ? '${AppUrls.baseUrl}${ref.watch(movieDetailProvider).movieDetails!.actors![index].photo.toString()}'
                                                : '',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ref
                                              .watch(movieDetailProvider)
                                              .movieDetails!
                                              .actors![index]
                                              .title!
                                              .isNotEmpty
                                          ? ref
                                              .watch(movieDetailProvider)
                                              .movieDetails!
                                              .actors![index]
                                              .title
                                              .toString()
                                          : '',
                                      style: TextStyle(
                                          fontFamily: Strings.robotoMedium,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0,
                                          color: Colors.black),
                                    )
                                  ],
                                );
                              }),
                        )
                      : const SizedBox(),

                  // Padding(
                  //   padding: const EdgeInsets.only(left: 15.0),
                  //   child: Text('Details',
                  //       style: TextStyle(
                  //         fontFamily: Strings.robotoMedium,
                  //         fontSize: 16.0,
                  //         color: Color(0xff272727),
                  //       )),
                  // ),

                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text('Director and Writter',
                        style: TextStyle(
                          fontFamily: Strings.robotoMedium,
                          fontSize: 16.0,
                          color: const Color(0xff272727),
                        )),
                  ),

                  ref.watch(movieDetailProvider).movieDetails != null &&
                          ref
                              .watch(movieDetailProvider)
                              .movieDetails!
                              .directors!
                              .isNotEmpty
                      ? SizedBox(
                          height: 220,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: ref
                                  .watch(movieDetailProvider)
                                  .movieDetails!
                                  .directors!
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: SizedBox(
                                          height: 170,
                                          width: 120,
                                          child: CommonImage(
                                            imageUrl: ref
                                                    .watch(movieDetailProvider)
                                                    .movieDetails!
                                                    .directors![index]
                                                    .photo!
                                                    .isNotEmpty
                                                ? '${AppUrls.baseUrl}${ref.watch(movieDetailProvider).movieDetails!.directors![index].photo.toString()}'
                                                : '',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ref
                                              .watch(movieDetailProvider)
                                              .movieDetails!
                                              .directors![index]
                                              .type!
                                              .isNotEmpty
                                          ? ref
                                              .watch(movieDetailProvider)
                                              .movieDetails!
                                              .directors![index]
                                              .type
                                              .toString()
                                          : '',
                                      style: TextStyle(
                                          fontFamily: Strings.robotoMedium,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0,
                                          color: Colors.black),
                                    )
                                  ],
                                );
                              }),
                        )
                      : const SizedBox(),
                  // Padding(
                  //   padding: const EdgeInsets.only(left:15, top: 10.0, bottom: 7.0, right: 10),
                  //   child: Text('Directer\nAnna Boden, Ryan Fleck\n\nMusic Directer\nPinar Toprak',
                  //       style: TextStyle(
                  //         fontFamily: Strings.robotoMedium,
                  //         fontSize: 16.0,
                  //         letterSpacing: 0.5,
                  //         color: Color(0xff272727),
                  //       )),
                  // ),

                  /*Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10),
              child: Text('Writers',
                  style: TextStyle(
                    fontFamily: Strings.robotoMedium,
                    fontSize: 16.0,
                    color: Color(0xff272727),
                  )),
            ),


            ref.watch(movieDetailProvider).movieDetails != null &&  ref.watch(movieDetailProvider).movieDetails!.writters!.isNotEmpty ?
            SizedBox(
              height: 220,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ref.watch(movieDetailProvider).movieDetails!.writters!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox(
                              height: 170,
                              width: 120,
                              child: Image.network( ref.watch(movieDetailProvider).movieDetails!.writters![index].photo!.isNotEmpty ? '${AppUrls.baseUrl}${ref.watch(movieDetailProvider).movieDetails!.writters![index].photo.toString()}' : '',
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Text(
                          ref.watch(movieDetailProvider).movieDetails!.writters![index].type!.isNotEmpty ? ref.watch(movieDetailProvider).movieDetails!.writters![index].type.toString() : '',
                          style: TextStyle(
                              fontFamily: Strings.robotoMedium,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              color: Colors.black),
                        )
                      ],
                    );
                  }),
            ): SizedBox(),*/

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 25, bottom: 5),
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          'Similar movies'.tr,
                          style: TextStyle(
                              fontFamily: Strings.robotoMedium,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SuggestedMoviesListView()),
                          );
                        },
                        child: Text(
                          'See More'.tr,
                          style: TextStyle(
                              fontFamily: Strings.robotoMedium,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                              color: const Color(0xFFFECC00)),
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: ref
                            .watch(topPickedListProvider)
                            .suggestList!
                            .length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 120.0,
                                child: CommonImage(
                                  imageUrl:
                                      '${AppUrls.baseUrl}${ref.watch(topPickedListProvider).suggestList![index].poster!}',
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  const SizedBox(height: 25)
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}
