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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: Text('Your Remainders!'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, AddItemPage.id);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: datalist.isEmpty
          ? Center(
              child: Text('No Preview Available!!!'),
            )
          : ListView.builder(
              itemBuilder: (context, index) => Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                onDismissed: (dir) {
                  _dbMngr.deleteTile(datalist[index].id).then((value) => {
                        print('item deleted'),
                      });
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
                    color: Colors.indigo,
                  ),
                ),
                child: Card(
                  elevation: 5.0,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(7.0),
                        height: 150.0,
                        width: 100.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: Colors.grey,
                          ),
                        ),
                        child: Image.file(
                          datalist[index].imagePath,
                          height: 150.0,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
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
                                    color: Colors.indigo,
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
