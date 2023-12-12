import 'package:flutter/material.dart';
import 'package:unvired_sdk/unvired_sdk.dart';

class LocationTrackingInfo extends StatefulWidget {
  @override
  _LocationTrackingInfo createState() => _LocationTrackingInfo();
}

class _LocationTrackingInfo extends State<LocationTrackingInfo> {
  String days='',status='',start='',end='';
  @override
  Widget build(BuildContext context) {
    String str = "Please enter the login password to continue";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        leading: null,
        title: Text('Location Tracking'),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _getLocationInfo(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Container(
          child: locationTrackerBody(),
        );
      },)
    );
  }


  @override
  void initState() {
    super.initState();
    setState(() {
      _getLocationInfo();
    });
  }

  _getLocationInfo() async {
    start=await SettingsHelper().getLocationTrackingStartTime();
    end=await SettingsHelper().getLocationTrackingEndTime();
    days=await SettingsHelper().getLocationTrackingDays();
    if(await SettingsHelper().getLocationTrackingStatus()==false)
      status= 'DISABLED';
    else
      status= 'ENABLED';
    locationTrackerBody();
  }

  Widget locationTrackerBody()
  {
    return Center(
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Align(
                            child: Text('Location Tracking  ',
                              style: TextStyle(fontSize: 16),
                            ),
                            alignment: FractionalOffset.centerLeft,
                          ),
                          Expanded(child: Text('')),
                          Align(
                            child: Text(
                              status,
                              style: TextStyle(fontSize: 12),
                            ),
                            alignment: FractionalOffset.centerLeft,
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Align(
                            child: Text(
                              'Days ',
                              style: TextStyle(fontSize: 16),
                            ),
                            alignment: FractionalOffset.centerLeft,
                          ),
                          Expanded(child: Text('')),
                          Align(
                            child: Text(
                              days,
                              style: TextStyle(fontSize: 12),
                            ),
                            alignment: FractionalOffset.centerLeft,
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Align(
                            child: Text(
                              'Start Time ',
                              style: TextStyle(fontSize: 16),
                            ),
                            alignment: FractionalOffset.centerLeft,
                          ),
                          Expanded(child: Text('')),
                          Align(
                            child: Text(
                              start,
                              style: TextStyle(fontSize: 12),
                            ),
                            alignment: FractionalOffset.centerLeft,
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Align(
                            child: Text('End Time'
                            ),
                            alignment: FractionalOffset.centerLeft,
                          ),
                          Expanded(child: Text('')),
                          Align(
                            child: Text(
                              end,
                              style: TextStyle(fontSize: 12),
                            ),
                            alignment: FractionalOffset.bottomRight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
