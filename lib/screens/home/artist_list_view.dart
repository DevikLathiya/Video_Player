import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:get/get.dart';
import 'package:hellomegha/screens/no_network.dart';
class ArtistListView extends StatefulWidget {
  const ArtistListView({Key? key}) : super(key: key);

  @override
  State<ArtistListView> createState() => _ArtistListViewState();
}

class _ArtistListViewState extends State<ArtistListView> {
  List<String> musicArtist = [
    "https://www.scrolldroll.com/wp-content/uploads/2021/05/Ustad_Zakir_Hussain-famous-indian-musicians-scaled.jpg",
    "https://cdn.shopify.com/s/files/1/0730/1451/files/3_a6fc77b5-2c5c-47ff-b272-301c7a79f887_large.jpg?v=1542280873",
    "https://i.pinimg.com/236x/b1/5a/1a/b15a1a4fdbaa10602952b9b51165bd2c--top-music-artists-imran-khan.jpg",
    "https://upload.wikimedia.org/wikipedia/en/7/7e/Ice_Age_Scrat_Tales_Poster.jpg",
    "https://lumiere-a.akamaihd.net/v1/images/p_frozen_18373_3131259c.jpeg?region=0%2C0%2C540%2C810",
    "https://lumiere-a.akamaihd.net/v1/images/p_frankenweenie2012_20501_06183b98.jpeg",
    "https://www.scrolldroll.com/wp-content/uploads/2021/05/Ustad_Zakir_Hussain-famous-indian-musicians-scaled.jpg",
    "https://cdn.shopify.com/s/files/1/0730/1451/files/3_a6fc77b5-2c5c-47ff-b272-301c7a79f887_large.jpg?v=1542280873",
    "https://i.pinimg.com/236x/b1/5a/1a/b15a1a4fdbaa10602952b9b51165bd2c--top-music-artists-imran-khan.jpg",
    "https://upload.wikimedia.org/wikipedia/en/7/7e/Ice_Age_Scrat_Tales_Poster.jpg",
    "https://lumiere-a.akamaihd.net/v1/images/p_frozen_18373_3131259c.jpeg?region=0%2C0%2C540%2C810",
    "https://lumiere-a.akamaihd.net/v1/images/p_frankenweenie2012_20501_06183b98.jpeg",
    "https://www.scrolldroll.com/wp-content/uploads/2021/05/Ustad_Zakir_Hussain-famous-indian-musicians-scaled.jpg",
    "https://cdn.shopify.com/s/files/1/0730/1451/files/3_a6fc77b5-2c5c-47ff-b272-301c7a79f887_large.jpg?v=1542280873",
    "https://i.pinimg.com/236x/b1/5a/1a/b15a1a4fdbaa10602952b9b51165bd2c--top-music-artists-imran-khan.jpg",
    "https://upload.wikimedia.org/wikipedia/en/7/7e/Ice_Age_Scrat_Tales_Poster.jpg",
    "https://lumiere-a.akamaihd.net/v1/images/p_frozen_18373_3131259c.jpeg?region=0%2C0%2C540%2C810",
    "https://lumiere-a.akamaihd.net/v1/images/p_frankenweenie2012_20501_06183b98.jpeg",
  ];
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 10.0, top: 5, bottom: 5),
              child: Row(children: [
                Expanded(
                  child: Text(
                    '80 Music',
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
                  physics: const ScrollPhysics(),
                  itemCount: musicArtist.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.77,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                              height: 110,
                              width: 110,
                              child: CommonImage(imageUrl: musicArtist[index]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Text(
                            'Music ${index + 1}',
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: Strings.robotoRegular,
                                fontSize: 14.0,
                                color: Colors.black),
                          ),
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
