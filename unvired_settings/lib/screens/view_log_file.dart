
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:unvired_sdk/unvired_sdk.dart';
import 'package:unvired_settings/utils/bot_toast.dart';

String content = '';
String search = '';
List<int> matchList = [];
List<double> matchIndexList = [];
int iterator = 0;
var keys = List.generate(content.length, (i) => GlobalKey());

TextStyle focRes = TextStyle(
    color: Colors.black,
    backgroundColor: Colors.limeAccent,
    fontWeight: FontWeight.bold),
    posRes = TextStyle(
        color: Colors.black,
        backgroundColor: Colors.red,
        fontStyle: FontStyle.normal),
    negRes = TextStyle(
        color: Colors.black,
        backgroundColor: Colors.white,
        fontWeight: FontWeight.normal);

class LogViewerDemo extends StatefulWidget {
  @override
  _LogViewerPageState createState() => _LogViewerPageState();
}

class _LogViewerPageState extends State<LogViewerDemo> {
  GlobalKey richTextKey = GlobalKey();
  String val='';
  late TextEditingController _textEditingController;
  late ScrollController _controller;
  String curStr = '', prevStr = '', nextStr = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: TextField(
          controller: _textEditingController,
          style: TextStyle(fontSize: 22, color: Colors.white),
          decoration: InputDecoration(
              hintText: "Search", hintStyle: TextStyle(color: Colors.white)),
          onSubmitted: (t) {
            /*Fluttertoast.showToast(
                msg: "Request Sent. Please Wait...",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black26,
                textColor: Colors.white,
                fontSize: 16.0);*/
            setState(() {
              search = t;
            });
            iterator = 0;
            _navigator();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                BotToastPage().timedCustomLoading(context,5);
                setState(() => search = _textEditingController.text);
                iterator = 0;
                _navigator();
              },
              icon: Icon(Icons.search_outlined))
        ],
      ),
      backgroundColor: Colors.white,
      body: Scrollbar(
        child: FutureBuilder(
          future: loadAsset(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child:
                Text('Unable to Load Logs...' + snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              return FutureBuilder(
                future: _searchPattern(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return Scrollbar(
                    child: SingleChildScrollView(
                      controller: _controller,
                      child: RichText(
                          textScaleFactor: 1.2,
                          key: richTextKey,
                          text: changeStr(prevStr, curStr, nextStr)),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Please wait Logs are loading...',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold,fontSize: 16),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: 'Up',
              icon: IconButton(
                  onPressed: () {
                    setState(() {
                      if (iterator > matchList.length + 1)
                        iterator = iterator - 1;
                      else if (iterator == matchList.length + 1) iterator = 0;
                      _moveUp();
                      _navigator();
                    });
                  },
                  color: Colors.blue,
                  icon: Icon(Icons.navigate_before))),
          BottomNavigationBarItem(
              label: 'Top',
              icon: IconButton(
                  onPressed: () {
                    _reachTop();
                  },
                  color: Colors.blue,
                  icon: Icon(Icons.skip_previous))),
          BottomNavigationBarItem(
              label: 'Bottom',
              icon: IconButton(
                  onPressed: () {
                    _reachBottom();
                  },
                  color: Colors.blue,
                  icon: Icon(Icons.skip_next))),
          BottomNavigationBarItem(
              label: 'Down',
              icon: IconButton(
                  onPressed: () {
                    setState(() {
                      if (iterator < matchList.length - 1)
                        iterator = iterator + 1;
                      else if (iterator == matchList.length - 1) iterator = 0;
                      _moveDown();
                      _navigator();
                    });
                  },
                  color: Colors.blue,
                  icon: Icon(Icons.navigate_next))),
        ],
      ),
    );
  }

  @override
  void initState() {
    _controller = ScrollController();
    _textEditingController=TextEditingController();
    super.initState();
    tempAsyncMethod();
  }

  void tempAsyncMethod() async {
    prevStr = await loadAsset();
  }

  Future<String> loadAsset() async {
    content = await SettingsHelper().getCompleteLogs();
    return content;
  }

  _moveUp() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double valOffset=(((matchList[iterator]/height)*width)+((matchList[iterator]/height)+iterator*10)) - _controller.initialScrollOffset;
    _controller.animateTo(
        valOffset,
        curve: Curves.linear,
        duration: Duration(milliseconds: 500));
  }

  _moveDown() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double valOffset=((matchList[iterator]/height)*width)+((matchList[iterator]/height)+iterator*10) + _controller.initialScrollOffset;
    _controller.animateTo(
        valOffset,
        curve: Curves.linear,
        duration: Duration(milliseconds: 500));
  }

  _reachTop() {
    _controller.animateTo(_controller.offset - content.length,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  _reachBottom() {
    _controller.animateTo(_controller.offset + content.length,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  TextSpan searchMatch(String content) {
    if (search == "")
      return TextSpan(text: content, style: negRes);
    var refinedContent = content.toLowerCase();
    var refinedSearch = search.toLowerCase();

    if (refinedContent.contains(refinedSearch)) {
      if (refinedContent.substring(0, refinedSearch.length) == refinedSearch) {
        return TextSpan(
          style: focRes,
          text: content.substring(0, refinedSearch.length),
          children: [
            searchMatch(
              content.substring(refinedSearch.length),
            ),
          ],
        );
      } else if (refinedContent.length == refinedSearch.length) {
        return TextSpan(
          text: content,
          style: posRes,
        );
      } else {
        return TextSpan(
          style: negRes,
          text: content.substring(
            0,
            refinedContent.indexOf(refinedSearch),
          ),
          children: [
            searchMatch(
              content.substring(
                refinedContent.indexOf(refinedSearch),
              ),
            ),
          ],
        );
      }
    } else if (!refinedContent.contains(refinedSearch)) {
      return TextSpan(text: content, style: negRes);
    }
    return TextSpan(
      text: content.substring(0, refinedContent.indexOf(refinedSearch)),
      style: negRes,
      children: [
        searchMatch(content.substring(refinedContent.indexOf(refinedSearch)))
      ],
    );
  }

  /// note
  TextSpan changeStr(String prevStr, String curStr, String nextStr) {
    _searchPattern();

    TextSpan txtSpan=new TextSpan(
      style: negRes,
      text: "LOGS:",
      children: [
        searchMatch(prevStr),
        TextSpan(
          text: curStr,
          style: posRes,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              RenderBox box = richTextKey.currentContext!.findRenderObject() as RenderBox;
              Offset position = box.localToGlobal(Offset.zero); //this is global position
                          },
        ),
        searchMatch(nextStr),
      ],
    );
    return txtSpan;
  }

  _searchPattern() {
    var refinedContent = content.toLowerCase();
    var refinedSearch = search.toLowerCase();
    int rsLen = refinedSearch.length;
    int rcLen = refinedContent.length;
    int counter = 0;
    matchList.clear();

    for (int i = 0; i <= rcLen - rsLen; i++) {
      int j;

      for (j = 0; j < rsLen; j++)
        if (refinedContent[i + j] != refinedSearch[j])
          break;

      if (j == rsLen) {
        matchList.add(i);
        counter++;
      }
    }
  }

  _navigator() {
    _searchPattern();
    curStr = '';
    for (int i = matchList[iterator];
    i < matchList[iterator] + search.length;
    i++) {
      curStr += content[i];
    }
    prevStr = content.substring(0, matchList[iterator]);
    nextStr = content.substring(matchList[iterator] + search.length);
  }
}
