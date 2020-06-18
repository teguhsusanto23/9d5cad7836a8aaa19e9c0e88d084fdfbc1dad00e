import 'package:http/http.dart' show Client;
import 'package:teguh_kulina_app/src/model/product.dart';

class ApiService {
  final String baseUrl = "https://kulina-recruitment.herokuapp.com";
  Client client = Client();

  Future<List<Product>> getProducts(int page) async {
    final response = await client.get("$baseUrl/products?_page="+page.toString()+"&_limit=6");
    if (response.statusCode == 200) {
      return productFromJson(response.body);
    } else {
      return null;
    }
  }
}