import 'package:flutter/material.dart';
import 'package:hellomegha/core/utils/dialogs.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/ab_button.dart';
import 'package:hellomegha/core/widgets/ab_button_grey.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:get/get.dart';
class SchemesDetailView extends StatefulWidget {
  const SchemesDetailView({Key? key}) : super(key: key);

  @override
  State<SchemesDetailView> createState() => _SchemesDetailViewState();
}

class _SchemesDetailViewState extends State<SchemesDetailView> {
  List<String> stories = [
    "https://thefolktales.com/media/2019/05/Featured-image-The-folk-tales-of-Meghalaya.jpg",
    "https://static.toiimg.com/photo/92933202.cms",
    "https://www.hlimg.com/images/stories/738X538/images-8_1589945942-9152e.jpg",
    "https://static.toiimg.com/photo/93036421/93036421.jpg?v=3",
    "https://wallpapersmug.com/download/1600x900/b41742/thanos-and-the-black-order.jpg",
    "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/dramatic-movie-poster-template-design-f0f2c261e077379d0f82604f96b6a774_screen.jpg?ts=1602570456",
  ];
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    nointernet(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: SizedBox(
                    height: 230,
                    width: MediaQuery.of(context).size.width,
                    child: const CommonImage(
                      imageUrl:
                          'https://i0.wp.com/www.eastmojo.com/wp-content/uploads/2020/06/CM_MONDAY.jpg?fit=1208%2C691&ssl=1',
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
                      padding: const EdgeInsets.only(top: 10.0, bottom: 7.0),
                      child: Text('CM Speech',
                          style: TextStyle(
                            fontFamily: Strings.robotoMedium,
                            fontSize: 20.0,
                            color: const Color(0xff272727),
                          )),
                    ),
                    Text(
                      '9:35 PM | 30 Nov, 2022',
                      style: TextStyle(
                        fontFamily: Strings.robotoRegular,
                        fontSize: 11.0,
                        color: const Color(0xff535353),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 7.0),
                      child: Text(
                          'The government assumes the Jaegers, robotic war machines battling the Kaijus, to be ineffective.',
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
                          child: ABButton(
                            paddingTop: 10.0,
                            paddingBottom: 15.0,
                            paddingLeft: 10.0,
                            paddingRight: 10.0,
                            text: 'Start Reading',
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 25, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Related Stories',
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const MusicListView()),
                    // );
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
              height: 230,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: stories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox(
                              height: 170,
                              width: 140,
                              child: CommonImage(imageUrl: stories[index]),
                            ),
                          ),
                        ),
                        Text(
                          'Stories ${index + 1}',
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
          ],
        ),
      ),
    );
  }
}
