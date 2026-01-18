import 'package:http/http.dart' as http;

class StockApi {
  static const String baseUrl = 'https://www.alphavantage.co';
  static const String apiKey = 'FG7ZQLXPHOP4OB14';

  final http.Client client;

  StockApi(this.client);

  Future<http.Response> getListings(String apiKey) async {
    return await client.get(
        Uri.parse('$baseUrl/query?function=LISTING_STATUS&apikey=$apiKey'));
  }
}
