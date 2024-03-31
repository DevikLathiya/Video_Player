import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/ab_button.dart';
import 'package:hellomegha/core/widgets/ab_button_grey.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class StoriesReadView extends ConsumerStatefulWidget {
  final String storyId;
  final String story;
  const StoriesReadView({Key? key, required this.story, required this.storyId}) : super(key: key);

  @override
  ConsumerState<StoriesReadView> createState() => _StoriesReadViewState();
}

class _StoriesReadViewState extends ConsumerState<StoriesReadView> {


  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   ref.watch(storyDetailProvider).storyDetailsAPI(context: context, story: widget.storyId);
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
        ref.watch(storyDetailProvider).storyDetailsAPI(context: context, story: widget.storyId);
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'Story',
              style: TextStyle(
                  fontFamily: Strings.robotoMedium,
                  fontSize: 21.0,
                  color: Colors.black),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stack(
              //   children: [
              //     ClipRRect(
              //       borderRadius: BorderRadius.circular(0),
              //       child: SizedBox(
              //         height: 230,
              //         width: MediaQuery.of(context).size.width,
              //         child: ref.watch(storyDetailProvider).storyDetailModel != null &&
              //             ref.watch(storyDetailProvider).storyDetailModel!.storiesDetails!.isNotEmpty ?
              //         Image.network(
              //             'https://jayamsolutions.signertech.in/${ref.watch(storyDetailProvider).storyDetailModel!.storiesDetails![0].poster}',
              //             fit: BoxFit.cover): const SizedBox(),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(left: 10.0, top: 40),
              //       child: Align(
              //         alignment: Alignment.topLeft,
              //         child: IconButton(
              //             onPressed: () {
              //               Navigator.pop(context);
              //             },
              //             icon: Icon(
              //               Icons.arrow_back,
              //               color: Colors.white,
              //               size: 30,
              //             )),
              //       ),
              //     )
              //   ],
              // ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ref.watch(storyDetailProvider).storyDetailModel != null &&
                          ref.watch(storyDetailProvider).storyDetailModel!.storiesDetails!.isNotEmpty ?
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 7.0),
                        child: Text(ref.watch(storyDetailProvider).storyDetailModel!.storiesDetails![0].name!.isNotEmpty ? ref.watch(storyDetailProvider).storyDetailModel!.storiesDetails![0].name! : '',
                            style: TextStyle(
                              fontFamily: Strings.robotoMedium,
                              fontSize: 20.0,
                              color: Color(0xff272727),
                            )),
                      ):SizedBox(),
                    ],
                  ),
                ),
              ),

              ref.watch(storyDetailProvider).storyDetailModel != null &&
                  ref.watch(storyDetailProvider).storyDetailModel!.storiesDetails!.isNotEmpty ?
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 7.0,left: 15.0),
                child: HtmlWidget(
                  ref.watch(storyDetailProvider).storyDetailModel!.storiesDetails![0].longDescription!.isNotEmpty ? ref.watch(storyDetailProvider).storyDetailModel!.storiesDetails![0].longDescription! : '',
                  // onTapUrl: (url) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => CommonWebView(url: url),
                  //     ),
                  //   );
                  //   return true;
                  // },
                  textStyle:  TextStyle(
                    fontFamily: Strings.robotoMedium,
                    fontSize: 13.0,
                    letterSpacing: 0.6,
                    color: Color(0xff272727),
                  ),
                ),
              ): SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
