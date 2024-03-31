import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellomegha/core/utils/app_images.dart';
import 'package:hellomegha/core/utils/strings.dart';

Widget widthSizedBox(double width) {
  return SizedBox(
    width: width.w,
  );
}

Widget heightSizedBox(double height) {
  return SizedBox(
    height: height.h,
  );
}

Widget symmetricPadding(Widget child, {double? vertical, double? horizontal}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: horizontal?.w ?? 0.0,
      vertical: vertical?.h ?? 0.0,
    ),
    child: child,
  );
}

Widget lTRBPadding({
  required Widget child,
  double? left,
  double? top,
  double? right,
  double? bottom,
  double? all,
}) {
  if (all != null) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        all.w,
        all.h,
        all.w,
        all.h,
      ),
      child: child,
    );
  } else {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        left?.w ?? 0.0,
        top?.h ?? 0.0,
        right?.w ?? 0.0,
        bottom?.h ?? 0.0,
      ),
      child: child,
    );
  }
}

EdgeInsetsGeometry symmetric({double? vertical, double? horizontal}) {
  return EdgeInsets.symmetric(
    horizontal: horizontal?.w ?? 0.0,
    vertical: vertical?.h ?? 0.0,
  );
}

EdgeInsetsGeometry lTRB({
  double? left,
  double? top,
  double? right,
  double? bottom,
  double? all,
}) {
  if (all != null) {
    return EdgeInsets.fromLTRB(
      all.w,
      all.h,
      all.w,
      all.h,
    );
  } else {
    return EdgeInsets.fromLTRB(
      left?.w ?? 0.0,
      top?.h ?? 0.0,
      right?.w ?? 0.0,
      bottom?.h ?? 0.0,
    );
  }
}

PreferredSize appBarWidget() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(75.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppBar(
        leadingWidth: 170,
        leading: Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: SizedBox(
            height: 27,
            child: Image.asset('assets/logo_new.png', fit: BoxFit.cover),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
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
  );
}
