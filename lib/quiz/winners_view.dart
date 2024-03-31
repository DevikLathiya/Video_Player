import 'package:flutter/material.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/utils/dialogs.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WinnersView extends ConsumerStatefulWidget {
  const WinnersView({Key? key}) : super(key: key);

  @override
  ConsumerState<WinnersView> createState() => _WinnersViewState();
}

class _WinnersViewState extends ConsumerState<WinnersView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(winnerProvider).WinnerListAPI(context: context);
    });
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    nointernet(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: AppBar(
            titleSpacing: 0,
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
              'Winners ',
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 5, bottom: 5),
              child: SizedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Weekly Winners',
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    border: Border.all(
                      color: Colors.amber,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.zero,
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0, top: 4),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.only(top: 10.0),
                          padding: const EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 3, bottom: 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.filter_alt_outlined,
                                    color: Colors.white),
                                Text(
                                  'Filter',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 90,
                                        width: 90,
                                        child: Image.asset("assets/Winner.png"),
                                      ),
                                      SizedBox(
                                        height: 90,
                                        width: 90,
                                        child: Center(
                                          child: Text(
                                            '2',
                                            style: TextStyle(
                                                fontFamily: Strings.robotoMedium,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 60.0,
                                                color: Colors.black
                                                    .withOpacity(0.7)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                'Winner name',
                                style: TextStyle(
                                    fontFamily: Strings.robotoMedium,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 30,
                                  width: 90,
                                  child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Image.asset(
                                        'assets/crown.png',
                                        fit: BoxFit.fill,
                                      ))),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 90,
                                        width: 90,
                                        child: Image.asset("assets/Winner.png"),
                                      ),
                                      SizedBox(
                                        height: 90,
                                        width: 90,
                                        child: Center(
                                          child: Text(
                                            '1',
                                            style: TextStyle(
                                                fontFamily: Strings.robotoMedium,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 60.0,
                                                color: Colors.black
                                                    .withOpacity(0.7)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                'Winner name',
                                style: TextStyle(
                                    fontFamily: Strings.robotoMedium,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 90,
                                        width: 90,
                                        child: Image.asset("assets/Winner.png"),
                                      ),
                                      SizedBox(
                                        height: 90,
                                        width: 90,
                                        child: Center(
                                          child: Text(
                                            '3',
                                            style: TextStyle(
                                                fontFamily: Strings.robotoMedium,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 60.0,
                                                color: Colors.black
                                                    .withOpacity(0.7)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                'Winner name',
                                style: TextStyle(
                                    fontFamily: Strings.robotoMedium,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 10.0, right: 10.0, top: 5, bottom: 5),
            //   child: SizedBox(
            //     child: Align(
            //       alignment: Alignment.centerLeft,
            //       child: Text(
            //         'Monthly Winners',
            //         style: TextStyle(
            //             fontFamily: Strings.robotoMedium,
            //             fontWeight: FontWeight.w600,
            //             fontSize: 16.0,
            //             color: Colors.black),
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //     height: 250,
            //     decoration: BoxDecoration(
            //         color: Colors.amber,
            //         border: Border.all(
            //           color: Colors.amber,
            //         ),
            //         borderRadius: BorderRadius.only(
            //             topLeft: Radius.zero,
            //             topRight: Radius.zero,
            //             bottomLeft: Radius.circular(20),
            //             bottomRight: Radius.circular(20))),
            //     child: Column(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.only(right: 15.0, top: 4),
            //           child: Align(
            //             alignment: Alignment.centerRight,
            //             child: Container(
            //               width: 80,
            //               margin: const EdgeInsets.only(top: 10.0),
            //               padding: const EdgeInsets.only(
            //                   left: 7.0, right: 7.0, top: 3, bottom: 3),
            //               decoration: BoxDecoration(
            //                 border: Border.all(color: Colors.white),
            //                 borderRadius: BorderRadius.all(Radius.circular(5)),
            //               ),
            //               child: Row(
            //                 children: [
            //                   Icon(Icons.filter_alt_outlined,
            //                       color: Colors.white),
            //                   Text(
            //                     'Filter',
            //                     style: TextStyle(color: Colors.white),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.only(top: 40.0),
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.all(10.0),
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(50),
            //                       child: Stack(
            //                         children: [
            //                           SizedBox(
            //                             height: 90,
            //                             width: 90,
            //                             child: Image.network(
            //                                 'https://upload.wikimedia.org/wikipedia/en/7/7e/Ice_Age_Scrat_Tales_Poster.jpg',
            //                                 fit: BoxFit.cover),
            //                           ),
            //                           SizedBox(
            //                             height: 90,
            //                             width: 90,
            //                             child: Center(
            //                               child: Text(
            //                                 '2',
            //                                 style: TextStyle(
            //                                     fontFamily: Strings.robotoMedium,
            //                                     fontWeight: FontWeight.w500,
            //                                     fontSize: 60.0,
            //                                     color: Colors.black
            //                                         .withOpacity(0.7)),
            //                               ),
            //                             ),
            //                           )
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                   Text(
            //                     'Winner name',
            //                     style: TextStyle(
            //                         fontFamily: Strings.robotoMedium,
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 14.0,
            //                         color: Colors.white),
            //                   )
            //                 ],
            //               ),
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.only(bottom: 40.0),
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   SizedBox(
            //                       height: 30,
            //                       width: 90,
            //                       child: Align(
            //                           alignment: Alignment.topCenter,
            //                           child: Image.asset(
            //                             'assets/crown.png',
            //                             fit: BoxFit.fill,
            //                           ))),
            //                   Padding(
            //                     padding: const EdgeInsets.only(
            //                         left: 10.0, right: 10.0),
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(50),
            //                       child: Stack(
            //                         children: [
            //                           SizedBox(
            //                             height: 90,
            //                             width: 90,
            //                             child: Image.network(
            //                                 'https://upload.wikimedia.org/wikipedia/en/7/7e/Ice_Age_Scrat_Tales_Poster.jpg',
            //                                 fit: BoxFit.cover),
            //                           ),
            //                           SizedBox(
            //                             height: 90,
            //                             width: 90,
            //                             child: Center(
            //                               child: Text(
            //                                 '1',
            //                                 style: TextStyle(
            //                                     fontFamily: Strings.robotoMedium,
            //                                     fontWeight: FontWeight.w500,
            //                                     fontSize: 60.0,
            //                                     color: Colors.black
            //                                         .withOpacity(0.7)),
            //                               ),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                   Text(
            //                     'Winner name',
            //                     style: TextStyle(
            //                         fontFamily: Strings.robotoMedium,
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 14.0,
            //                         color: Colors.white),
            //                   )
            //                 ],
            //               ),
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.only(top: 40.0),
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.all(10.0),
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(50),
            //                       child: Stack(
            //                         children: [
            //                           SizedBox(
            //                             height: 90,
            //                             width: 90,
            //                             child: Image.network(
            //                                 'https://upload.wikimedia.org/wikipedia/en/7/7e/Ice_Age_Scrat_Tales_Poster.jpg',
            //                                 fit: BoxFit.cover),
            //                           ),
            //                           SizedBox(
            //                             height: 90,
            //                             width: 90,
            //                             child: Center(
            //                               child: Text(
            //                                 '3',
            //                                 style: TextStyle(
            //                                     fontFamily: Strings.robotoMedium,
            //                                     fontWeight: FontWeight.w500,
            //                                     fontSize: 60.0,
            //                                     color: Colors.black
            //                                         .withOpacity(0.7)),
            //                               ),
            //                             ),
            //                           )
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                   Text(
            //                     'Winner name',
            //                     style: TextStyle(
            //                         fontFamily: Strings.robotoMedium,
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 14.0,
            //                         color: Colors.white),
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // )ing(
            //   padding: const EdgeInsets.only(
            //       left: 10.0, right: 10.0, top: 5, bottom: 5),
            //   child: SizedBox(
            //     child: Align(
            //       alignment: Alignment.centerLeft,
            //       child: Text(
            //         'Monthly Winners',
            //         style: TextStyle(
            //             fontFamily: Strings.robotoMedium,
            //             fontWeight: FontWeight.w600,
            //             fontSize: 16.0,
            //             color: Colors.black),
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //     height: 250,
            //     decoration: BoxDecoration(
            //         color: Colors.amber,
            //         border: Border.all(
            //           color: Colors.amber,
            //         ),
            //         borderRadius: BorderRadius.only(
            //             topLeft: Radius.zero,
            //             topRight: Radius.zero,
            //             bottomLeft: Radius.circular(20),
            //             bottomRight: Radius.circular(20))),
            //     child: Column(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.only(right: 15.0, top: 4),
            //           child: Align(
            //             alignment: Alignment.centerRight,
            //             child: Container(
            //               width: 80,
            //               margin: const EdgeInsets.only(top: 10.0),
            //               padding: const EdgeInsets.only(
            //                   left: 7.0, right: 7.0, top: 3, bottom: 3),
            //               decoration: BoxDecoration(
            //                 border: Border.all(color: Colors.white),
            //                 borderRadius: BorderRadius.all(Radius.circular(5)),
            //               ),
            //               child: Row(
            //                 children: [
            //                   Icon(Icons.filter_alt_outlined,
            //                       color: Colors.white),
            //                   Text(
            //                     'Filter',
            //                     style: TextStyle(color: Colors.white),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.only(top: 40.0),
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.all(10.0),
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(50),
            //                       child: Stack(
            //                         children: [
            //                           SizedBox(
            //                             height: 90,
            //                             width: 90,
            //                             child: Image.network(
            //                                 'https://upload.wikimedia.org/wikipedia/en/7/7e/Ice_Age_Scrat_Tales_Poster.jpg',
            //                                 fit: BoxFit.cover),
            //                           ),
            //                           SizedBox(
            //                             height: 90,
            //                             width: 90,
            //                             child: Center(
            //                               child: Text(
            //                                 '2',
            //                                 style: TextStyle(
            //                                     fontFamily: Strings.robotoMedium,
            //                                     fontWeight: FontWeight.w500,
            //                                     fontSize: 60.0,
            //                                     color: Colors.black
            //                                         .withOpacity(0.7)),
            //                               ),
            //                             ),
            //                           )
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                   Text(
            //                     'Winner name',
            //                     style: TextStyle(
            //                         fontFamily: Strings.robotoMedium,
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 14.0,
            //                         color: Colors.white),
            //                   )
            //                 ],
            //               ),
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.only(bottom: 40.0),
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   SizedBox(
            //                       height: 30,
            //                       width: 90,
            //                       child: Align(
            //                           alignment: Alignment.topCenter,
            //                           child: Image.asset(
            //                             'assets/crown.png',
            //                             fit: BoxFit.fill,
            //                           ))),
            //                   Padding(
            //                     padding: const EdgeInsets.only(
            //                         left: 10.0, right: 10.0),
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(50),
            //                       child: Stack(
            //                         children: [
            //                           SizedBox(
            //                             height: 90,
            //                             width: 90,
            //                             child: Image.network(
            //                                 'https://upload.wikimedia.org/wikipedia/en/7/7e/Ice_Age_Scrat_Tales_Poster.jpg',
            //                                 fit: BoxFit.cover),
            //                           ),
            //                           SizedBox(
            //                             height: 90,
            //                             width: 90,
            //                             child: Center(
            //                               child: Text(
            //                                 '1',
            //                                 style: TextStyle(
            //                                     fontFamily: Strings.robotoMedium,
            //                                     fontWeight: FontWeight.w500,
            //                                     fontSize: 60.0,
            //                                     color: Colors.black
            //                                         .withOpacity(0.7)),
            //                               ),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                   Text(
            //                     'Winner name',
            //                     style: TextStyle(
            //                         fontFamily: Strings.robotoMedium,
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 14.0,
            //                         color: Colors.white),
            //                   )
            //                 ],
            //               ),
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.only(top: 40.0),
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.all(10.0),
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(50),
            //                       child: Stack(
            //                         children: [
            //                           SizedBox(
            //                             height: 90,
            //                             width: 90,
            //                             child: Image.network(
            //                                 'https://upload.wikimedia.org/wikipedia/en/7/7e/Ice_Age_Scrat_Tales_Poster.jpg',
            //                                 fit: BoxFit.cover),
            //                           ),
            //                           SizedBox(
            //                             height: 90,
            //                             width: 90,
            //                             child: Center(
            //                               child: Text(
            //                                 '3',
            //                                 style: TextStyle(
            //                                     fontFamily: Strings.robotoMedium,
            //                                     fontWeight: FontWeight.w500,
            //                                     fontSize: 60.0,
            //                                     color: Colors.black
            //                                         .withOpacity(0.7)),
            //                               ),
            //                             ),
            //                           )
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                   Text(
            //                     'Winner name',
            //                     style: TextStyle(
            //                         fontFamily: Strings.robotoMedium,
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 14.0,
            //                         color: Colors.white),
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
DateTime? _selectedDate;
var _currentSelectedValue;
_selectDate(BuildContext context) async {
  DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        // return child!;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.amber,
              onPrimary: Colors.black,
              surface: Colors.amber,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      });
  if (newSelectedDate != null) {
    _selectedDate = newSelectedDate;
    // _date
    //   ..text = DateFormat('dd/MM/yyyy').format(_selectedDate!)
    //   ..selection = TextSelection.fromPosition(TextPosition(
    //       offset: _date.text.length,
    //       affinity: TextAffinity.upstream));
  }
}