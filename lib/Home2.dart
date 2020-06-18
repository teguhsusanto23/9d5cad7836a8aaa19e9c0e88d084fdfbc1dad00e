import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import 'package:teguh_kulina_app/src/utils/stardisplay.dart';
import "Cart.dart";
import "ScopeManage.dart";
import "Details.dart";
import 'package:teguh_kulina_app/src/api/api.dart';
import 'package:teguh_kulina_app/src/model/product.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget{
  AppModel appModel;
  static final String route = "Home-route";

  Home({this.appModel});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<Home>{

  final curr = new NumberFormat("#,##0.00", "id_IDR");
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  ApiService apiService = ApiService();


  


  Widget GridGenerate(List<Product> data,aspectRadtio){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio:aspectRadtio),
        itemBuilder: (BuildContext context,int index){
          return Padding(
              padding: EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> Details(detail: data[index]))
                  );
                },
                child: Container(
                    height: 350.0,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8.0
                          )
                        ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 100.0,
                          child: Padding(
                            padding: EdgeInsets.all(1.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Image.network(data[index].imageUrl,fit: BoxFit.contain,),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Text("${data[index].name}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0),overflow: TextOverflow.ellipsis,),
                        ),
                        StarDisplay(value: data[index].rating),
                        Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Text("\Rp. ${curr.format(data[index].price).toString()}",style: TextStyle(fontWeight: FontWeight.w500),),
                              )
                      ],
                    )
                ),
              )
          );
        },
        itemCount: data.length,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    // TODO: implement build
        int page = 0;
        ScrollController _sc = new ScrollController();
        bool isLoading = false;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        elevation: 0.0,
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
      ),
      body:ScopedModelDescendant<AppModel>(
          builder: (context,child,model){
            return
            SafeArea(
      child: FutureBuilder(
        future: apiService.getProducts(page),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Product> productList = snapshot.data;
            return GridGenerate(productList,(itemWidth / itemHeight));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
              
          }
      ),
    );
  }

}
