import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/screens/home/home_tabs//all_view.dart';
import 'package:hellomegha/screens/home/home_tabs//influncers.dart';
import 'package:hellomegha/screens/home/home_tabs//movies.dart';
import 'package:hellomegha/screens/home/home_tabs//music.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'download_controller.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with TickerProviderStateMixin<HomeView> {
  late final TabController _tabController;
  DownloadController downloadController = Get.put(DownloadController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
    downloadController.init();
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
  void dispose() {
    downloadController.disposeIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 35,
              child: DefaultTabController(
                length: 4,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      // Creates border
                      color: Colors.yellow), //
                  tabs: [
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          '  All  ',
                          style: TextStyle(
                              fontFamily: Strings.robotoMedium,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text('Movies',
                              style: TextStyle(
                                  fontFamily: Strings.robotoMedium,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                  color: Colors.black))),
                    ),
                    Tab(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text('Music Video',
                              style: TextStyle(
                                  fontFamily: Strings.robotoMedium,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                  color: Colors.black))),
                    ),
                    Tab(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text('Videos',
                              style: TextStyle(
                                  fontFamily: Strings.robotoMedium,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                  color: Colors.black))),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.74,
              child: TabBarView(
                controller: _tabController,
                children: const [AllView(), Movies(), Music(), Influncers()],
              ),
            ),
          )
        ],
      ),
    );
  }
}
