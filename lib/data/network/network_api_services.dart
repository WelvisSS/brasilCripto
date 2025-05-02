import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  // GET API Response
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;

    try {
      // Perform a GET request to the provided URL with a 10-second timeout
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      // Process and validate the response using the returnResponse method
      responseJson = returnResponse(response);
    } on SocketException {
      // Handle no internet connection scenarios
      throw FetchDataException('No Internet connection');
    }
    return responseJson; // Return the parsed JSON response
  }

  // POST API Response
  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;

    try {
      // Perform a POST request with the given URL and data, with a 10-second timeout
      Response response = await http
          .post(Uri.parse(url), body: data)
          .timeout(const Duration(seconds: 10));

      // Process and validate the response using the returnResponse method
      //
      responseJson = returnResponse(response);
    } on SocketException {
      // Handle no internet connection scenarios
      throw FetchDataException('No Internet connection');
    }

    return responseJson; // Return the parsed JSON response
  }

  // Process and validate the HTTP response based on status codes
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200: // HTTP OK
        // Parse and return the response body as JSON
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      case 201: // Resource created successfully
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      case 204: // No content returned by the server
        return null;

      case 400: // Bad request
        throw BadRequestException(response.body.toString());

      case 401: // Unauthorized access
        throw UnauthorizedException(
          'Unauthorized: ${response.body.toString()}',
        );

      case 403: // Forbidden access
        throw UnauthorizedException('Forbidden: ${response.body.toString()}');

      case 404: // Resource not found
        throw BadRequestException('Not Found: ${response.body.toString()}');

      case 429: // Too many requests
        throw RateLimitExceededException(
          'Rate Limit Exceeded: ${response.body.toString()}',
        );

      case 500: // Server error
        throw FetchDataException(
          'Internal Server Error: ${response.body.toString()}',
        );

      case 503: // Service unavailable
        throw FetchDataException(
          'Service Unavailable: ${response.body.toString()}',
        );

      default: // Any other unexpected HTTP status code
        throw FetchDataException(
          'Unexpected Error Occurred: ${response.statusCode} - ${response.body.toString()}',
        );
    }
  }
}
