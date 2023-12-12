
import 'package:flutter/material.dart';
import 'package:unvired_sdk/unvired_sdk.dart';

/// FETCH NEW DATA
class FetchNewData extends StatefulWidget {
  @override
  _FetchNewData createState() => _FetchNewData();
}

class _FetchNewData extends State<FetchNewData> {
  String str = "Time out";
  int selectedIndex = 0;
  bool alreadySaved = false;
  int getTimeOut = 0;

  List<String> items = [
    'Every 15 Minutes',
    'Every 30 Minutes',
    'Every 1 Hour',
    'Every Day',
    'Manual'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          leading: null,
          title: Text('Fetch New Data'),
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
    getData();
  }

  Future<void> getData() async {
    getTimeOut = await SettingsHelper().getFetchInterval();
    if (getTimeOut == 900)
      selectedIndex = 0;
    else if (getTimeOut == 1800)
      selectedIndex = 1;
    else if (getTimeOut == 3600)
      selectedIndex = 2;
    else if (getTimeOut == 86400)
      selectedIndex = 3;
    else
      selectedIndex = 4;
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
                if (selectedIndex == index)
                  return ListTile(
                    title: Text(items[index]),
                    tileColor: selectedIndex == index ? Colors.white60 : null,
                    trailing: selectedIndex == index
                        ? Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                        : null,
                    onTap: () {
                      setState(() {
                        if (items[index] == 'Manual') {
                          SettingsHelper().setFetchInterval(4);
                          Navigator.pop(context, items[index]);
                        } else {
                          if (items[index] == 'Every 15 Minutes')
                            val = 15 * 60;
                          else if (items[index] == 'Every 30 Minutes')
                            val = 30 * 60;
                          else if (items[index] == 'Every 1 Hour')
                            val = 60 * 60;
                          else if (items[index] == 'Every Day')
                            val = 24 * 60 * 60;
                          else if (items[index] == 'Manual')
                            val = 0;
                          else
                            val = 0;
                          SettingsHelper().setFetchInterval(val);
                          selectedIndex = index;
                          Navigator.pop(context, items[index]);
                        }
                      });
                    },
                  );
                else
                  return ListTile(
                    title: Text(items[index]),
                    onTap: () {
                      setState(() {
                        if (items[index] == 'Manual') {
                          SettingsHelper().setFetchInterval(4);
                          Navigator.pop(context, items[index]);
                        } else {
                          if (items[index] == 'Every 15 Minutes')
                            val = 15 * 60;
                          else if (items[index] == 'Every 30 Minutes')
                            val = 30 * 60;
                          else if (items[index] == 'Every 1 Hour')
                            val = 60 * 60;
                          else if (items[index] == 'Every Day')
                            val = 24 * 60 * 60;
                          else if (items[index] == 'Manual')
                            val = 0;
                          else
                            val = 0;

                          SettingsHelper().setFetchInterval(val);
                          selectedIndex = index;
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


