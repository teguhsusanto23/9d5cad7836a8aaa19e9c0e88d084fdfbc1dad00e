import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:intl/intl.dart';

class StarDisplay extends StatelessWidget {
  final double value;
  const StarDisplay({Key key, this.value = 0})
      : assert(value != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
  final curr = new NumberFormat("#,##0.00", "id_IDR");
    if(value >  3 ){
        return Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: <Widget>[
                    Text(curr.format(value).toString(),style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
                    
                    StarRating(
                                  size: 15.0,
                                  rating: value,
                                  color: Colors.orange,
                                  borderColor: Colors.grey,
                                  starCount: 5
                              )
                                    ]
                                  );
    } else {
      return Text("New",style: TextStyle(
                    color: Colors.green[500],
                    fontWeight: FontWeight.bold,
                    fontSize: 12));
    }
    
  }
}