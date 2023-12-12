



import 'package:flutter/widgets.dart';
import 'package:webviewx/webviewx.dart';

class WebView extends StatefulWidget {
  String url;
  Function onError;
  Function onSuccess;

  WebView({required this.url,required this.onError,required this.onSuccess});

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  @override
  Widget build(BuildContext context) {
    return WebViewX(
      height: double.maxFinite,
      width: double.maxFinite,
      initialSourceType: SourceType.urlBypass,
      initialContent: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
      webSpecificParams: WebSpecificParams(
          printDebugInfo: true,
          webAllowFullscreenContent: true
      ),
      onPageFinished: (url) async {
        String errKey = "&error=";
        String tokenKey = "&token=";
        if (url.contains("?action=login")) {
          if (url.contains(errKey)) {
            final int startIndex = url.toString().indexOf(errKey) + 7;

            widget.onError(Uri.decodeFull(
                url.toString().substring(startIndex)));

          }else if(url.contains(tokenKey)){
            final int startIndex = url.toString().indexOf(tokenKey) + 7;
            String token = Uri.decodeFull(url.toString().substring(startIndex));
            widget.onSuccess(token);

          }
        }
      },
      onPageStarted: (url){
        //showDialogLoading("Loading...", context);
      },
    );
  }
}

