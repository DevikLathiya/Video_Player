import 'package:flutter/material.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../screens/home/more_view.dart';
import '../../screens/notifications_view.dart';
import '../../screens/search/search.dart';
import '../Leadership/Leadership_List_View_Model.dart';
import '../screens/home/leadership_detail_view.dart';

class LeadershipListView extends ConsumerStatefulWidget {
  const LeadershipListView({Key? key, required this.categoryType})
      : super(key: key);

  final String categoryType;

  @override
  ConsumerState<LeadershipListView> createState() => _LeadershipListViewState();
}

class _LeadershipListViewState extends ConsumerState<LeadershipListView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(widget.categoryType);
    ref.watch(leadershipListProvider).LeadershipListAPI(context: context);
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
                              search("Leader List")));
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
          child: ref.watch(leadershipListProvider).leadershipLists != null &&
              ref.watch(leadershipListProvider).leadershipLists!.isNotEmpty
              ? Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 10.0, top: 5, bottom: 5),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      '${ref.watch(leadershipListProvider).leadershipLists!.length} State Leadership Video Bytes',
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
                        .watch(leadershipListProvider)
                        .leadershipLists!
                        .length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(_createRoute(ref
                              .watch(leadershipListProvider)
                              .leadershipLists![index]
                              .id!
                              .toString()));
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
                                          .watch(leadershipListProvider)
                                          .leadershipLists![index]
                                          .poster!),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text(
                                ref
                                    .watch(leadershipListProvider)
                                    .leadershipLists![index]
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
                      );
                    }),
              )
            ],
          )
              :Text("Hello")),
    );
  }

  Route _createRoute(String id) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          LeadershipDetailView(videoId: id),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        print("Done");

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
