import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/widgets/ab_button.dart';
import 'package:hellomegha/core/widgets/common_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class WithdrawView extends ConsumerStatefulWidget {
  const WithdrawView({Key? key}) : super(key: key);

  @override
  ConsumerState<WithdrawView> createState() => _WithdrawViewState();
}

class _WithdrawViewState extends ConsumerState<WithdrawView> {
  String? amount;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(transactionProvider).transactionAPI(context: context);
      ref.watch(baseViewModel).kCurrentUser = await PrefUtils.getUser();
    });
  }

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
        preferredSize: const Size.fromHeight(70.0),
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
              'Withdraw ',
              style: TextStyle(
                  fontFamily: Strings.robotoMedium,
                  fontSize: 21.0,
                  color: Colors.black),
            ),
            // actions: [
            //   // const Padding(
            //   //   padding: EdgeInsets.only(right: 15.0),
            //   //   child: Icon(Icons.search_rounded),
            //   // ),
            //   Padding(
            //     padding: const EdgeInsets.only(right: 15.0),
            //     child: Container(
            //       decoration: const BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: Color(0xFFFECC00),
            //       ),
            //       child: const Padding(
            //         padding: EdgeInsets.all(4.0),
            //         child: Icon(Icons.person_rounded, color: Colors.white),
            //       ),
            //     ),
            //   )
            // ],
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFECC00),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child:  Image.asset("assets/coin.png"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Available',
                              style: TextStyle(
                                fontFamily: Strings.robotoMedium,
                                fontSize: 11.0,
                                color: Colors.grey,
                              )),
                          Text(  ref.watch(baseViewModel).kCurrentUser!.amount != null
                              ? "${ref.watch(baseViewModel).kCurrentUser?.amount!}"
                              : "0",
                            style: TextStyle(
                              fontFamily: Strings.robotoRegular,
                              fontSize: 22.0,
                              color: Color(0xff272727),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ABButton(
                paddingTop: 20.0,
                paddingBottom: 15.0,
                paddingLeft: 25.0,
                paddingRight: 25.0,
                text: 'Withdraw',
                onPressed: ref.watch(baseViewModel).kCurrentUser!.amount != null && ref.watch(baseViewModel).kCurrentUser!.amount!="0"?() {
                  amount = ref.watch(baseViewModel).kCurrentUser!.amount != null
                      ? "${ref.watch(baseViewModel).kCurrentUser?.amount!}"
                      : "0";
                  if(amount!= '0'){
                    openAlertDialog(context);
                  }else{
                    noAmountAlertDialog(context);
                  }
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const WithdrawView()),
                  // );
                }:null,
              ),
              const Divider(
                height: 5,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 10.0, top: 10, bottom: 5),
                child: SizedBox(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'All Transactions',
                      style: TextStyle(
                          fontFamily: Strings.robotoMedium,
                          fontSize: 18.0,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.67,
                child: ref.watch(transactionProvider).transactionModel != null  &&
                    ref.watch(transactionProvider).transactionModel!.userTransactions!.isNotEmpty ?
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: ref.watch(transactionProvider).transactionModel!.userTransactions!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name  : ${ref.watch(transactionProvider).transactionModel!.userTransactions![index].uname}',
                                        style: TextStyle(
                                            fontFamily: Strings.robotoMedium,
                                            fontSize: 16.0,
                                            color: Colors.black),
                                      ),

                                      SizedBox(height: 5),
                                      Text(
                                        'Order ID : ${ref.watch(transactionProvider).transactionModel!.userTransactions![index].orderId}',
                                        style: TextStyle(
                                            fontFamily: Strings.robotoMedium,
                                            fontSize: 13.0,
                                            color: Colors.grey),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        'Transaction Id :  ${ref.watch(transactionProvider).transactionModel!.userTransactions![index].transactionId}',
                                        style: TextStyle(
                                            fontFamily: Strings.robotoMedium,
                                            fontSize: 13.0,
                                            color: Colors.grey),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        'Remark:  ${ref.watch(transactionProvider).transactionModel!.userTransactions![index].remarks}',
                                        style: TextStyle(
                                            fontFamily: Strings.robotoMedium,
                                            fontSize: 13.0,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ) ,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                       '${ref.watch(transactionProvider).transactionModel!.userTransactions![index].paymentStatus}',
                                      style: TextStyle(
                                          fontFamily: Strings.robotoMedium,
                                          fontSize: 13.0,
                                          color: Colors.amber),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      '${ref.watch(transactionProvider).transactionModel!.userTransactions![index].amount}',
                                      style: TextStyle(
                                          fontFamily: Strings.robotoMedium,
                                          fontSize: 19.0,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      );
                    }): SizedBox(),
              )
            ],
          ),
        ),
      ),
    );
  }

  openAlertDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                child: Text('Are you sure?',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontSize: 17.0,
                        color: Colors.amber)),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text('Coins will convert into amount',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontSize: 17.0,
                        color: Colors.amber)),
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Color(0xffDCDCDC),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontFamily: Strings.robotoMedium,
                            color: const Color(0xff1B79EB),
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      ref.watch(authenticationProvider).withdrawCoinsAPI(context: context,coins: ref.watch(baseViewModel).kCurrentUser!.amount!.toString());
                    },
                    child: Center(
                      child: Text(
                        Strings.continueTxt,
                        style: TextStyle(
                            fontFamily: Strings.robotoMedium,
                            color: const Color(0xff1B79EB),
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0),
                      ),
                    ),
                  ),
                ],
              ),
              heightSizedBox(5),
            ],
          ),
        ),
      ),
    );
  }
  noAmountAlertDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                child: Text('Can\'t withdraw',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontSize: 17.0,
                        color: Colors.amber)),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text('Don\'t have amount',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontSize: 17.0,
                        color: Colors.amber)),
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Color(0xffDCDCDC),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                       'Ok',
                        style: TextStyle(
                            fontFamily: Strings.robotoMedium,
                            color: const Color(0xff1B79EB),
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0),
                      ),
                    ),
                  ),
                ],
              ),
              heightSizedBox(5),
            ],
          ),
        ),
      ),
    );
  }


}
