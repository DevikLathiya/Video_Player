import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_keys.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';

import '../core/utils/strings.dart';

class languages extends StatefulWidget {
  const languages({Key? key}) : super(key: key);

  @override
  State<languages> createState() => _languagesState();
}

class _languagesState extends State<languages> {

  List list=[false,false,false,false,false];
  get()async
  {
    print(await PrefUtils.getlanguage());
    if(await PrefUtils.getlanguage()==PrefKeys.english)
    {
      list[0]=true;
    }
    else if(await PrefUtils.getlanguage()==PrefKeys.Garo)
    {
      list[1]=true;
    }
    else if(await PrefUtils.getlanguage()==PrefKeys.Hindi)
    {
      list[2]=true;
    }
    else if(await PrefUtils.getlanguage()==PrefKeys.Kashi)
    {
      list[3]=true;
    }
    else if(await PrefUtils.getlanguage()==PrefKeys.Pnar)
    {
      list[4]=true;
    }
    setState(() {});
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
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
              "Language".tr,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: Strings.robotoMedium,
                  fontSize: 21.0,
                  color: Colors.black),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body: Column(
       children: [
         ListTile(
           title: Text(PrefKeys.english),
            onTap: () {
              var locale = Locale('en', 'US');
              Get.updateLocale(locale); //set language to Spanish (ES)
              PrefUtils.setlanguage(PrefKeys.english);
             setState(() {
               list=List.filled(5, false);
               list[0]=true;
             });
            },
          trailing: list[0]?Icon(Icons.check_sharp,color: Colors.amber):null,
         ),
         ListTile(
           title: Text(PrefKeys.Garo),
           onTap: () {
             var locale = Locale('en', 'garo');
             Get.updateLocale(locale);
             PrefUtils.setlanguage(PrefKeys.Garo);
             setState(() {
               list=List.filled(5, false);
               list[1]=true;
               print("hello$list");
             });
           },
           trailing: list[1]?Icon(Icons.check_sharp,color: Colors.amber):null,
         ),
         ListTile(
           title: Text(PrefKeys.Hindi),
           onTap: () {
             var locale = Locale('en', 'Hindi');
             Get.updateLocale(locale);
             PrefUtils.setlanguage(PrefKeys.Hindi);
             setState(() {
               list=List.filled(5, false);
               list[2]=true;
             });
           },
           trailing: list[2]?Icon(Icons.check_sharp,color: Colors.amber):null,
         ),
         ListTile(
           title: Text(PrefKeys.Kashi),
           onTap: () {
             var locale = Locale('en', 'kashi');
             Get.updateLocale(locale);
             PrefUtils.setlanguage(PrefKeys.Kashi);
             setState(() {
               list=List.filled(5, false);
               list[3]=true;
             });
           },
           trailing: list[3]?Icon(Icons.check_sharp,color: Colors.amber):null,
         ),
         ListTile(
           title: Text(PrefKeys.Pnar),
           onTap: () {
             var locale = Locale('en', 'pnar');
             Get.updateLocale(locale);
             PrefUtils.setlanguage(PrefKeys.Pnar);
             setState(() {
               list=List.filled(5, false);
               list[4]=true;
             });
           },
           trailing: list[4]?Icon(Icons.check_sharp,color: Colors.amber):null,
         ),
       ],
      ),

    );
  }
}
