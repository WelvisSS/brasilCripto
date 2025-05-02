// Abstract class for API services
abstract class BaseApiServices {
  // Method for making GET API requests
  Future<dynamic> getGetApiResponse(String url);

  // Method for making POST API requests
  Future<dynamic> getPostApiResponse(String url, dynamic data);
}
