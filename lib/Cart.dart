import 'package:flutter/material.dart';
import "package:scoped_model/scoped_model.dart";
import 'package:spinner_input/spinner_input.dart';
import "ScopeManage.dart";

class Cart extends StatefulWidget{
  static final String route = "Cart-route";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CartState();
  }
}

class CartState extends State<Cart>{

  Widget generateCart(Data d){
    double spinnerQty = 1;
    double subtotal = d.qty * d.price;
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
            border: Border(
                bottom: BorderSide(
                    color: Colors.grey[100],
                    width: 1.0
                ),
              top: BorderSide(
                  color: Colors.grey[100],
                  width: 1.0
              ),
            )
        ),
        height: 100.0,
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0
                  )
                ],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)
                ),
                image: DecorationImage(image: NetworkImage(d.image),fit: BoxFit.fill)
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0,left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(d.name,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0),),
                        ),
                        Expanded(
                          child: Text(d.qty.toString(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0),),
                        ),
                        Expanded(
                          child: Text(subtotal.toString(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0),),
                        ),
                        Container(
                            alignment: Alignment.bottomRight,
                            child: ScopedModelDescendant<AppModel>(
                              builder: (cotext,child,model){
                                return InkResponse(
                                    onTap: (){
                                      model.removeCart(d);
                                    },
                                    child: Row(
                                      children:<Widget>[Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Icon(Icons.remove_circle,color: Colors.red,),
                                    ),Container(
                                    margin: EdgeInsets.all(5),
                                    child: SpinnerInput(
                                      spinnerValue: spinnerQty,
                                      minValue: 1,
                                      maxValue: 100,
                                      onChange: (newValue) {
                                        setState(() {
                                          spinnerQty = newValue;
                                          //d.qty = newValue.ceil();
                                          //d.subtotal = newValue * d.price;
                                          //model.UpdateCartDB(d);
                                        });
                                      },
                                    ),
                                  )]),
                                    
                                );
                              },
                            )
                        )
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Text("Price ${d.price.toString()}"),

                  ],
                ),
              )
            ),
          ],
          
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar:AppBar(
        elevation: 0.0,
        title: Text("Cart List"),
      ),
      backgroundColor: Colors.white,
      body:Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Colors.grey[300],
                    width: 1.0
                )
            )
        ),
        child: ScopedModelDescendant<AppModel>(
          builder: (context,child,model){
            return ListView(
              shrinkWrap: true,
              children: model.cartListing.map((d)=>generateCart(d)).toList(),
            );
          },
        ),
      )
    );
  }
}
