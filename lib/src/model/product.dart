import 'dart:convert';

class Product {
  int id;
  String name;
  String imageUrl;
  String brandName;
  String packageName;
  int price;
  double rating;
  int qty;

  Product({this.id = 0, this.name, this.imageUrl, this.brandName,this.packageName,this.price,this.rating});

  factory Product.fromJson(Map<String,dynamic> map) {
    return Product(
        id: map["id"], 
        name: map["name"], 
        imageUrl: map["image_url"], 
        brandName: map["brand_name"],
        packageName: map['package_name'],
        price: map['price'],
        rating: map['rating']);
  }
  

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "image_url": imageUrl, "brand_name": brandName,"package_name": packageName,"price": price,"rating": rating};
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, image_url: $imageUrl, brand_name: $brandName,package_name: $packageName, price: $price, rating: $rating  }';
  }

}

List<Product> productFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Product>.from(data.map((item) => Product.fromJson(item)));
}

String productToJson(Product data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

