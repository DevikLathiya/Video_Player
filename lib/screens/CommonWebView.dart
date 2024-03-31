import 'package:flutter/material.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebView extends ConsumerStatefulWidget {
 String? url,title;
 CommonWebView({this.url,this.title});
  @override
  ConsumerState<CommonWebView> createState() => _CommonWebViewState();
}

class _CommonWebViewState extends ConsumerState<CommonWebView> {
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("url=${widget.url}");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(liveStreamProvider).liveListAPI(context: context);
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
              widget.title!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: Strings.robotoMedium,
                  fontSize: 21.0,
                  color: Colors.black),
            ),
            // actions: [
            //   GestureDetector(
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) =>
            //                   search("Short film")));
            //     },
            //     child: const Padding(
            //       padding: EdgeInsets.only(right: 15.0),
            //       child: Icon(Icons.search_rounded),
            //     ),
            //   ),
            //   GestureDetector(
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) =>
            //               const NotificationsView()));
            //     },
            //     child: const Padding(
            //       padding: EdgeInsets.only(right: 15.0),
            //       child: Icon(Icons.notifications_none),
            //     ),
            //   ),
            //   Padding(
            //     padding: const EdgeInsets.only(right: 15.0),
            //     child: GestureDetector(
            //       onTap: (){
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => const MoreView()),
            //         );
            //       },
            //       child: Container(
            //         decoration: const BoxDecoration(
            //           shape: BoxShape.circle,
            //           color: Color(0xFFFECC00),
            //         ),
            //         child: const Padding(
            //           padding: EdgeInsets.all(4.0),
            //           child:
            //           Icon(Icons.person_rounded, color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   )
            // ],
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body:  Stack(
        children: [
          WebViewWidget(controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color(0x00000000))
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  // Update loading bar.
                },
                onPageStarted: (String url) {},
                onPageFinished: (String url) {
                  setState(() {
                    isLoading = false;
                  });
                },
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(Uri.parse('${widget.url}')),

          ),
          isLoading ? Center( child: CircularProgressIndicator(color: Colors.amber),)
              : Stack(),
        ],
      ),
    );
  }
}
