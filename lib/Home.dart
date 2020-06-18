import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:teguh_kulina_app/Cart.dart';
import 'package:teguh_kulina_app/src/api/api.dart';
import 'dart:convert';
import 'package:teguh_kulina_app/src/model/product.dart';
import 'package:teguh_kulina_app/src/utils/stardisplay.dart';
import 'package:intl/intl.dart';
import 'Details.dart';
import 'ScopeManage.dart';
 
class Home extends StatelessWidget {
  AppModel appModel;
  static final String route = "Home-route";
  

  Home({this.appModel});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Foodcourt'),
            actions: <Widget>[
          Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: InkResponse(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Cart()));
                  },
                  child: Icon(Icons.shopping_cart),
                ),
              ),
              Positioned(
                child: ScopedModelDescendant<AppModel>(
                  builder: (context,child,model){
                    return Container(
                      child: Text((model.cartListing.length > 0) ? model.cartListing.length.toString() : "",textAlign: TextAlign.center,style: TextStyle(color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                    );
                  },
                ),
              )
            ],
          )
        ],
            bottom: TabBar(tabs: [
              Tab(
                text: 'List',
              ),
              Tab(text: 'Grid')
            ]),
          ),
          body: TabBarView(
            children: [
              PagewiseListViewExample(),
              PagewiseGridViewExample()
            ],
          )),
    );
  }
}

class PagewiseGridViewExample extends StatelessWidget {
  static const int PAGE_SIZE = 6;
  ApiService apiService = ApiService();
  
  final curr = new NumberFormat("#,##0.00", "id_IDR");

  @override
  Widget build(BuildContext context) {
    return PagewiseGridView.count(
      pageSize: PAGE_SIZE,
      crossAxisCount: 3,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      childAspectRatio: 0.555,
      padding: EdgeInsets.all(15.0),
      itemBuilder: this._itemBuilder,
      pageFuture: (pageIndex) =>
          apiService.getProducts(pageIndex)
    );
  }

  Widget _itemBuilder(context, Product entry, _) {
    return Padding(
              padding: EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> Details(detail: entry))
                  );
                },
                child:Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[600]),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      image: DecorationImage(
                          image: NetworkImage(entry.imageUrl),
                          fit: BoxFit.fill)),
                ),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                        height: 10.0,
                        child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:<Widget>[Text(entry.name,
                                style: TextStyle(fontSize: 12.0)
                            ),
                            SizedBox(height: 8.0),
                            Text('By '+entry.brandName,
                                style: TextStyle(fontSize: 10.0)
                            ),
                            SizedBox(height: 8.0),
                            Text('Category '+entry.packageName,
                                style: TextStyle(fontSize: 10.0)
                            ),
                            SizedBox(height: 8.0),
                            Text('Rp. '+curr.format(entry.price).toString(),
                                style: TextStyle(fontSize: 10.0)
                            )
                            ])
                          )
                        )
                      )
                    ),
              
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.0),
                child: StarDisplay(value: entry.rating),
              ),
              SizedBox(height: 8.0)
            ]))));
  }
}

class PagewiseListViewExample extends StatelessWidget {
  static const int PAGE_SIZE = 6;
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return PagewiseListView(
        pageSize: PAGE_SIZE,
        itemBuilder: this._itemBuilder,
        pageFuture: (pageIndex) =>
            apiService.getProducts(pageIndex) );
  }

  Widget _itemBuilder(context, Product entry, _) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                    entry.imageUrl,
                    height: 150.0,
                    width: 100.0,
                ),
            ),
          title: Text(entry.name),
          subtitle: Text(entry.packageName),
        ),
        Divider()
      ],
    );
  }
}

