import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/home/stories_detail_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/notifier/providers.dart';
import '../../core/utils/strings.dart';
import '../home/influncer_detail_view.dart';
import '../home/movie_detail_view.dart';
import '../home/musiv_video_detail_view.dart';
import '../home/scheme_detail_view.dart';
import '../no_network.dart';

class search extends ConsumerStatefulWidget {
  String? type;
  search([this.type]);

  @override
  ConsumerState<search> createState() => _searchState();
}

class _searchState extends ConsumerState<search> {
  TextEditingController _searchController=TextEditingController();
  bool network=false;
  bool search=false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Connectivity().checkConnectivity().then((value) {
        if (value == ConnectivityResult.none) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
          // Get.rawSnackbar(
          //   snackPosition: SnackPosition.BOTTOM,
          //   backgroundColor: Colors.redAccent,
          //   message: 'Please check you network',
          // );
        } else {
          ref.watch(searchViewModel).searchdata=[];
        }
      });
    });

  }

  bool _isToggle1=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 10.0,),
          child: AppBar(
            // leading: GestureDetector(
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            //   child: SizedBox(
            //     height: 15,
            //     child: Icon(
            //       Icons.arrow_back,
            //       color: Colors.amber,
            //     ),
            //   ),
            // ),
            automaticallyImplyLeading: false,
            elevation: 0,
            titleSpacing: 0,
            backgroundColor: Colors.white,
            title:SizedBox(
              height: 45,
              child: TextFormField(
                onFieldSubmitted: (value) {
                  print(value);
                  if(widget.type==null)
                  {
                    ref.watch(searchViewModel).SearchModelAPI(context: context,keyword: "$value",type:"");
                  }
                  else
                  {

                    print("Hello");
                    ref.watch(searchViewModel).SearchModelAPI(context: context,keyword: "$value",type:"${widget.type}");
                  }
                  setState((){
                    search=true;
                  });
                },
                onChanged: (value) {
                  print(value);
                  if(widget.type==null && value.length>2)
                  {

                    ref.watch(searchViewModel).SearchModelAPI(context: context,keyword: "$value",type:"");
                    search=true;
                  }
                  else if(value.length>2)
                  {
                    search=true;
                    ref.watch(searchViewModel).SearchModelAPI(context: context,keyword: "$value",type:"${widget.type}");
                  }
                  else
                    {
                      search=false;
                    }
                  setState((){
                    _isToggle1=true;
                  });
                },
                // onTapOutside: (event) => setState(()=>_isToggle1=false),
                controller: _searchController,
                autofocus: true,
                cursorColor: Colors.amber,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  hintText: 'Search',
                  // isCollapsed: true,
                  filled: true,
                  suffixIcon: Padding(
                      padding: EdgeInsetsDirectional.only(end: 12.0),
                      child: GestureDetector(
                        child: _isToggle1 ? InkWell(onTap: () {
                            _searchController.text="";
                          },child: Icon(Icons.close, color: Colors.amber,))  :
                        SizedBox(),
                      )
                  ),
                  // suffixIcon: InkWell(onTap: () {
                  //   _searchController.text="";
                  // },child: Icon(Icons.close,color: Colors.amber,)),
                  fillColor: Colors.grey.withOpacity(0.2),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.amber,
                    ),
                  )
                ),
              ),
            ),

            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body:ref.watch(searchViewModel).searchdata != null && search
          // ref.watch(searchViewModel).searchdata!.isNotEmpty
          ? SingleChildScrollView(
        child: InkWell(
          onTap: () {
            print("tap");
            setState((){
              _isToggle1=!_isToggle1;
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 10.0, top: 5, bottom: 5),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      '${ref.watch(searchViewModel).searchdata!.length} Search Results',
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
                child: ref
                    .watch(searchViewModel)
                    .searchdata!
                    .length>0?GridView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ref
                        .watch(searchViewModel)
                        .searchdata!
                        .length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          if (ref.watch(searchViewModel).searchdata![index].name ==
                              'Schemes') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SchemeDetailView(
                                      videoId: ref.watch(searchViewModel).searchdata![index]
                                          .id!
                                          .toString())),
                            );
                          } else if (ref.watch(searchViewModel).searchdata![index]
                              .type ==
                              'Music Video') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MusicVideoDetailView(
                                          movieId: ref.watch(searchViewModel).searchdata![index]
                                              .id!
                                              .toString())),
                            );
                          } else if (ref.watch(searchViewModel).searchdata![index]
                              .type ==
                              'Stories') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StoriesDetailView(
                                      storyId: ref.watch(searchViewModel).searchdata![index]
                                          .id!
                                          .toString())),
                            );
                          } else if(ref.watch(searchViewModel).searchdata![index]
                              .type ==
                              'Influncer')
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InfluncerDetailView(
                                        videoId: ref.watch(searchViewModel).searchdata![index]
                                            .id!
                                            .toString())),
                              );
                            }
                          else{
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MoviesDetailView(
                                      movieId: ref.watch(searchViewModel).searchdata![index]
                                          .id
                                          .toString())),
                            );
                          }
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
                                      '${ref.watch(searchViewModel).searchdata![index].poster!}'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text(
                                ref
                                    .watch(searchViewModel)
                                    .searchdata![index]
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
                    }):ListTile(
                  // contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  title: Text("No Search Found for '${ _searchController.text}'", style: TextStyle(
                      fontFamily: Strings.robotoMedium,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: Colors.black),
                  ),
                  subtitle: Text("Please try seaching again with another keyword",style: TextStyle(
                    fontFamily: Strings.robotoMedium,
                    fontSize: 13.0,
                    letterSpacing: 0.6,
                    color: const Color(0xff272727).withOpacity(0.7),
                  ),),
                )
              ),
            ],
          ),
        ),
      ):InkWell(onTap: () {
        print("tap");
        setState((){
          _isToggle1=!_isToggle1;
        });
      },child: SizedBox())
    );
  }
}
