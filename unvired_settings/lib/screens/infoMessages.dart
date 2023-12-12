import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unvired_sdk/unvired_sdk.dart';

class InfoMessages extends StatefulWidget {
  @override
  _InfoMessages createState() => _InfoMessages();
}

class _InfoMessages extends State<InfoMessages> {
  var listInfo;
  String dropdownValue = 'All';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        leading: null,
        title: Text('Info Messages'),
        elevation: 0,
        actions: [
          Align(
              alignment: Alignment.centerRight,
              child: DropdownButton<String>(
                selectedItemBuilder: (BuildContext ctxt) {
                  return ['All', 'Error', 'Warning', 'Info']
                      .map<Widget>((item) {
                    return DropdownMenuItem(
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text("$item",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        value: item);
                  }).toList();
                },
                value: dropdownValue,
                style: new TextStyle(
                  color: Colors.black,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>[
                  'All',
                  'Error',
                  'Warning',
                  'Info',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                }).toList(),
              )),
        ],
      ),
      body: projectWidget(dropdownValue),
    );
  }

  Widget projectWidget(String level) {
    if (level == 'All') {
      return FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return Container();
          }
          if (projectSnap.hasData) {
            List<InfoMessageData> infoMsgList =
                projectSnap.data as List<InfoMessageData>;
            infoMsgList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
            if (infoMsgList.length == 0)
              return Center(
                child: Text('No Data Found'),
              );
            else
              return Container(
                child: ListView.builder(
                  itemCount: infoMsgList != null ? infoMsgList.length : 0,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        // Widget to display the list of project
                        Container(
                          child: ListTile(
                            leading: _getIcon(infoMsgList[index].category),
                            title: Container(
                              child: Column(
                                children: [
                                  new Align(
                                    child: Text(
                                      infoMsgList[index].message,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                    alignment: FractionalOffset.centerLeft,
                                  ),
                                  Row(children: <Widget>[
                                    Text('BE: ${infoMsgList[index].bename}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12.0)),
                                    Expanded(child: Text('')),
                                    Text(
                                        datePicker(
                                            infoMsgList[index].timestamp),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontSize: 12.0)),
                                  ]),
                                  Row(children: <Widget>[
                                    Expanded(
                                      child: Text(
                                          'ID: ${infoMsgList[index].lid}',
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 12.0)),
                                      flex: 5,
                                    ),
                                    Text(
                                        timePicker(
                                            infoMsgList[index].timestamp),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontSize: 12.0)),
                                  ]),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailedInfoMessages(
                                      infoMsg: infoMsgList[index]),
                                  settings: RouteSettings(
                                    arguments: infoMsgList[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
          } else if (projectSnap.hasError) {
            return Center(
              child: Text(projectSnap.error.toString()),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        future: getProjectDetails(),
      );
    } else if (level == 'Error') {
      return FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return Container();
          }
          List<dynamic> projectOrg = projectSnap.data as List<dynamic>;
          projectOrg.sort((a, b) => a.category.compareTo(b.category));
          List<dynamic> tempErrorList = <dynamic>[];
          projectOrg.forEach((element) {
            if (element.category == 'FAILURE') tempErrorList.add(element);
          });
          if (tempErrorList.length == 0)
            return Center(
              child: Text('No Data Found'),
            );
          else
            return Container(
              child: ListView.builder(
                itemCount: tempErrorList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      // Widget to display the list of project
                      Container(
                        child: ListTile(
                          leading: _getIcon(tempErrorList[index].category),
                          title: Container(
                            child: Column(
                              children: [
                                new Align(
                                  child: Text(
                                    tempErrorList[index].message,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Text(
                                          'BE: ${tempErrorList[index].bename}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 12.0))),
                                  Text(
                                      datePicker(
                                          tempErrorList[index].timestamp),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 12.0)),
                                ]),
                                Row(children: <Widget>[
                                  Expanded(
                                    child: Text(
                                        'ID: ${tempErrorList[index].lid}',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12.0)),
                                    flex: 5,
                                  ),
                                  Text(
                                      timePicker(
                                          tempErrorList[index].timestamp),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 12.0)),
                                ]),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailedInfoMessages(
                                    infoMsg: tempErrorList[index]),
                                settings: RouteSettings(
                                  arguments: tempErrorList[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
        },
        future: getProjectDetails(),
      );
    } else if (level == 'Warning') {
      return FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return Container();
          }
          List<dynamic> projectOrg = projectSnap.data as List<dynamic>;
          projectOrg.sort((a, b) => a.category.compareTo(b.category));
          List<dynamic> tempErrorList = <dynamic>[];
          projectOrg.forEach((element) {
            if (element.category == 'WARNING') tempErrorList.add(element);
          });
          if (tempErrorList.length == 0)
            return Center(
              child: Text('No Data Found'),
            );
          else
            return Container(
              child: ListView.builder(
                itemCount: tempErrorList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      // Widget to display the list of project
                      Container(
                        child: ListTile(
                          leading: _getIcon(tempErrorList[index].category),
                          title: Container(
                            child: Column(
                              children: [
                                new Align(
                                  child: Text(
                                    tempErrorList[index].message,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                Row(children: <Widget>[

                                  Expanded(child: Text('BE: ${tempErrorList[index].bename}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 12.0))),
                                  Text(
                                      datePicker(
                                          tempErrorList[index].timestamp),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 12.0)),
                                ]),
                                Row(children: <Widget>[
                                  Expanded(
                                    child: Text(
                                        'ID: ${tempErrorList[index].lid}',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12.0)),
                                    flex: 5,
                                  ),
                                  Text(
                                      timePicker(
                                          tempErrorList[index].timestamp),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 12.0)),
                                ]),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailedInfoMessages(
                                    infoMsg: tempErrorList[index]),
                                settings: RouteSettings(
                                  arguments: tempErrorList[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
        },
        future: getProjectDetails(),
      );
    } else if (level == 'Info') {
      return FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return Container();
          }
          List<dynamic> projectOrg = projectSnap.data as List<dynamic>;
          projectOrg.sort((a, b) => a.category.compareTo(b.category));
          List<dynamic> tempErrorList = <dynamic>[];
          projectOrg.forEach((element) {
            if (element.category == 'SUCCESS') tempErrorList.add(element);
          });
          if (tempErrorList.length == 0)
            return Center(
              child: Text('No Data Found'),
            );
          else
            return Container(
              child: ListView.builder(
                itemCount: tempErrorList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      // Widget to display the list of project
                      Container(
                        child: ListTile(
                          leading: _getIcon(tempErrorList[index].category),
                          title: Container(
                            child: Column(
                              children: [
                                new Align(
                                  child: Text(
                                    tempErrorList[index].message,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  alignment: FractionalOffset.centerLeft,
                                ),
                                Row(children: <Widget>[

                                  Expanded(child: Text('BE: ${tempErrorList[index].bename}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 12.0))),
                                  Text(
                                      datePicker(
                                          tempErrorList[index].timestamp),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 12.0)),
                                ]),
                                Row(children: <Widget>[
                                  Expanded(
                                    child: Text(
                                        'ID: ${tempErrorList[index].lid}',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12.0)),
                                    flex: 5,
                                  ),
                                  Text(
                                      timePicker(
                                          tempErrorList[index].timestamp),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 12.0)),
                                ]),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailedInfoMessages(
                                    infoMsg: tempErrorList[index]),
                                settings: RouteSettings(
                                  arguments: tempErrorList[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
        },
        future: getProjectDetails(),
      );
    } else
      return Text('No Info Messages found');
  }

  Future<List<InfoMessageData>> getProjectDetails() async {
    List<InfoMessageData> result = await SettingsHelper().getInfoMessages();
    listCount();
    return result;
  }

  listCount() async {
    listInfo = await SettingsHelper().getInfoMessages();
  }

  String datePicker(timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var d12 = new DateFormat('d MMM yyyy').format(date);
    return d12.toString();
  }

  String timePicker(timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var d12 = new DateFormat('HH:mm').format(date);
    return d12.toString();
  }

  Widget _getIcon(category) {
    if (category == 'FAILURE')
      return Icon(Icons.error_outline, color: Colors.red);
    else if (category == 'ERROR')
      return Icon(Icons.error_outline, color: Colors.yellow);
    else if (category == 'WARNING')
      return Icon(Icons.warning, color: Colors.yellow);
    else
      return Icon(Icons.info, color: Colors.blue);
  }
}

class DetailedInfoMessages extends StatelessWidget {
  final InfoMessageData infoMsg;

  const DetailedInfoMessages({Key? key, required this.infoMsg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        leading: null,
        elevation: 0,
      ),
      body: Column(
        children: [
          Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 10.0, top: 5.0, bottom: 5.0, right: 10.0),
              child: Column(
                children: [
                  Align(
                    child: Text(
                      '${datePicker(infoMsg.timestamp)} at ${timePicker(infoMsg.timestamp)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    alignment: FractionalOffset.centerLeft,
                  ),
                  SizedBox(height: 4),
                  Align(
                    child: Text(
                      'Date',
                      style: TextStyle(fontSize: 12),
                    ),
                    alignment: FractionalOffset.centerLeft,
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5),
                  Align(
                    child: Text(
                      '',
                      style: TextStyle(fontSize: 16),
                    ),
                    alignment: FractionalOffset.centerLeft,
                  ),
                  SizedBox(height: 4),
                  Align(
                    child: Text(
                      'Business Entity',
                      style: TextStyle(fontSize: 12),
                    ),
                    alignment: FractionalOffset.centerLeft,
                  ),
                  SizedBox(height: 5),
                  Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  Align(
                    child: Text(
                      infoMsg.category,
                      style: TextStyle(fontSize: 16),
                    ),
                    alignment: FractionalOffset.centerLeft,
                  ),
                  SizedBox(height: 4),
                  Align(
                    child: Text(
                      'Category',
                      style: TextStyle(fontSize: 12),
                    ),
                    alignment: FractionalOffset.centerLeft,
                  ),
                  SizedBox(height: 5),
                  Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  Align(
                    child: Text(
                      infoMsg.message,
                      style: TextStyle(fontSize: 16),
                    ),
                    alignment: FractionalOffset.centerLeft,
                  ),
                  SizedBox(height: 4),
                  Align(
                    child: Text(
                      'Message',
                      style: TextStyle(fontSize: 12),
                    ),
                    alignment: FractionalOffset.centerLeft,
                  ),
                ],
              ),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),
          ),
        ],
      ),
    );
  }

  String datePicker(timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var d12 = new DateFormat('d MMM yyyy').format(date);
    return d12.toString();
  }

  String timePicker(timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var d12 = new DateFormat('HH:MM').format(date);
    return d12.toString();
  }
}
