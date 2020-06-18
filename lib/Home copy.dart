import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:teguh_kulina_app/src/model/product.dart';

import 'Details.dart';
import 'ScopeManage.dart';
 
class Home extends StatefulWidget {
  AppModel appModel;
  static final String route = "Home-route";

  Home({this.appModel});
  @override
  State<StatefulWidget> createState() => new HomeState();
}
 
class HomeState extends State<Home> {
  static int page = 0;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  List users = new List();
  List<Product> pList;
  final dio = new Dio();
  @override
  void initState() {
    this._getMoreData(page);
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels ==
          _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }
 
  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lazy Load Large List"),
      ),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
 
  Widget _buildList() {
    return ListView.builder(
      itemCount: users.length + 1, // Add one more item for progress indicator
      padding: EdgeInsets.symmetric(vertical: 2.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == users.length) {
          return _buildProgressIndicator();
        } else {
          return new ListTile(
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                    users[index]['image_url'],
                    height: 150.0,
                    width: 100.0,
                ),
            ),
            title: Text((users[index]['name'])),
            subtitle: Text((users[index]['package_name'])),
            onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> Details(detail: pList[index]))
                  );
                },
          );
        }
      },
      controller: _sc,
    );
  }
   
  void _getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var url = "https://kulina-recruitment.herokuapp.com/products?_page="+index.toString() +"&_limit=10";
      print(url);
      final response = await dio.get(url);
      
      List tList = new List();
      for (int i = 0; i < response.data.length; i++) {
        tList.add(response.data[i]);
      }
 
      setState(() {
        isLoading = false;
        users.addAll(tList);
        page++;
      });
    }
  }
 
  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
 
}