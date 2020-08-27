import 'package:toast/toast.dart';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:newnativeproject/model/placemodel.dart';
import 'package:newnativeproject/databasemanager/dbmanager.dart';
import 'package:newnativeproject/model/listdatamodel.dart';
import 'package:flutter/material.dart';
import 'package:newnativeproject/pages/additempage.dart';
import 'usermaps.dart';

class ShowListData extends StatefulWidget {
  static const String id = 'showlist';
  @override
  _ShowListDataState createState() => _ShowListDataState();
}

class _ShowListDataState extends State<ShowListData> {
  List<ListModel> datalist = [];
  bool _maploading = false;

  DBmanager _dbMngr = DBmanager();
  void getDataFromDB() async {
    var data = await _dbMngr.queryDatabase();
    if (data != null) {
      setState(() {
        datalist = data;
      });
    } else {
      datalist = [];
    }
  }

  Future networkChecker() async {
    var connectionChecker = await (Connectivity().checkConnectivity());
    if (connectionChecker != ConnectivityResult.mobile &&
        connectionChecker != ConnectivityResult.wifi) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Not Internet Access'),
          content: Text('Allow internet via device data or Wifi'),
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pop(true);
                AppSettings.openWIFISettings();
              },
              label: Text('Settings'),
            )
          ],
        ),
      );
    }
  }

  Future<void> displayMapsOfCard(double lat, double long) async {
    setState(() {
      _maploading = true;
    });
    var latlong = PlaceCoordinates(latitude: lat, longitude: long);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserMapScreen(
          initialLocation: latlong,
        ),
      ),
    );
    setState(() {
      _maploading = false;
    });
  }

  @override
  void initState() {
    getDataFromDB();
    networkChecker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        title: Text('My Remainders'),
        centerTitle: true,
        actions: [
          Visibility(
            visible: datalist.isEmpty ? false : true,
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AddItemPage.id);
              },
              icon: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: datalist.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 150.0),
                            child: Image.asset(
                              'images/pngwave.png',
                              height: 150.0,
                              width: 150.0,
                            ),
                          ),
                          Text(
                            'No Remainders Yet!!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 50.0),
                        child: RaisedButton.icon(
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, AddItemPage.id);
                          },
                          label: Text(
                            'Remainder',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                          ),
                          elevation: 5.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) => Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                onDismissed: (dir) {
                  _dbMngr.deleteTile(datalist[index].id).then((value) => {});
                  Toast.show(
                    'Item Collected',
                    context,
                    duration: Toast.LENGTH_LONG,
                    gravity: Toast.BOTTOM,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white70,
                  );
                  setState(() {
                    datalist.removeAt(index);
                    print('item deleted at $index');
                  });
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Icon(
                      Icons.delete,
                      size: 40.0,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Card(
                  elevation: 5.0,
                  color: Color(0xffafffff),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(7.0),
                        height: 150.0,
                        width: 100.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2.0,
                            color: Theme.of(context).primaryColor,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Image.file(
                          datalist[index].imagePath,
                          height: 150.0,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Item:- ',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: datalist[index].item,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Message:- ',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: datalist[index].message,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Dated:- ',
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: datalist[index].datetime,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Address:- ',
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: datalist[index].address,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10.0),
                                  alignment: Alignment.centerRight,
                                  child: FlatButton(
                                    onPressed: () {
                                      displayMapsOfCard(
                                          datalist[index].latitude,
                                          datalist[index].longitude);
                                    },
                                    child: Text(
                                      'Location',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Visibility(
                                  visible: _maploading,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(7.0),
                ),
              ),
              itemCount: datalist.length,
              shrinkWrap: true,
            ),
    );
  }
}
