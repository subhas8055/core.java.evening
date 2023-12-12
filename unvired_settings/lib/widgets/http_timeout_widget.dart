import 'package:flutter/material.dart';
import 'package:unvired_sdk/unvired_sdk.dart';

/// HTTP TIMEOUT
class TimeOut extends StatefulWidget {
  @override
  _TimeOut createState() => _TimeOut();
}

class _TimeOut extends State<TimeOut> {
  String str = "Time out";
  int selectedIndex = 0;
  bool alreadySaved = false;
  int getTimeOut = 0;
  int setTimeOut = 0;
  List<String> items = [
    'Default',
    '1 Minute',
    '2 Minutes',
    '3 Minutes',
    '4 Minutes',
    '5 Minutes'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          leading: null,
          title: Text('HTTP Time Out'),
          elevation: 0,
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return getDataWid();
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    //getData();
  }

  Future<void> getData() async {
    getTimeOut = await SettingsHelper().getRequestTimeout();
  }

  getDataWid() {
    int val;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          child: Card(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                getData();
                if (index == getTimeOut)
                  return ListTile(
                    title: Text(items[index]),
                    tileColor: getTimeOut == index ? Colors.white60 : null,
                    trailing: getTimeOut == index
                        ? Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                        : null,
                    onTap: () {
                      setState(() async {
                        if (getTimeOut == 'Default') {
                          SettingsHelper().setRequestTimeout(0);
                          //Navigator.pop(context,'Default');
                        } else {
                          getTimeOut = index;
                          val = int.parse(items[index].substring(0, 1));
                          await SettingsHelper().setRequestTimeout(val);
                          //Navigator.pop(context,items[index]);
                        }
                      });
                    },
                  );
                else
                  return ListTile(
                    title: Text(items[index]),
                    onTap: () {
                      setState(() {
                        if (items[index] == 'Default') {
                          SettingsHelper().setRequestTimeout(0);
                          Navigator.pop(context, 'Default');
                        } else {
                          getTimeOut = index;
                          val = int.parse(items[index].substring(0, 1));
                          SettingsHelper().setRequestTimeout(val);
                          Navigator.pop(context, items[index]);
                        }
                      });
                    },
                  );
              },
            ),
          ),
        ),
      ),
    );
  }
}
