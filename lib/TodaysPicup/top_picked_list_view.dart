import 'package:flutter/material.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/home/movie_detail_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../screens/home/more_view.dart';
import '../screens/notifications_view.dart';
import '../screens/search/search.dart';

class TopPickedListView extends ConsumerStatefulWidget {
  const TopPickedListView({Key? key, required this.categoryType})
      : super(key: key);

  final String categoryType;

  @override
  ConsumerState<TopPickedListView> createState() => _TopPickedListViewState();
}

class _TopPickedListViewState extends ConsumerState<TopPickedListView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(widget.categoryType);
    ref.watch(topPickedListProvider).topPickedListAPI(context: context);
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
              widget.categoryType,
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
                              search("Movies")));
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
          child: ref.watch(topPickedListProvider).suggestList != null &&
                  ref.watch(topPickedListProvider).suggestList!.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 10.0, top: 5, bottom: 5),
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            '${ref.watch(topPickedListProvider).suggestList!.length} Most Watched Videos ',
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
                      child: GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const ScrollPhysics(),
                          itemCount: ref
                              .watch(topPickedListProvider)
                              .suggestList!
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
                                      builder: (context) => MoviesDetailView(
                                          movieId: ref
                                              .watch(topPickedListProvider)
                                              .suggestList![index]
                                              .id!
                                              .toString())),
                                );
                              },
                              child: Container(
                                // color: Colors.amber,
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
                                              imageUrl:
                                                  '${AppUrls.baseUrl}${ref.watch(topPickedListProvider).suggestList![index].poster!}'),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: Text(
                                        ref
                                            .watch(topPickedListProvider)
                                            .suggestList![index]
                                            .name!,
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
