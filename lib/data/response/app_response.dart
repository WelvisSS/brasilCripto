import 'status.dart';  // Importing the Status enum

class ApiResponse<T> {
  Status? status;       // The status of the API response (loading, completed, or error)
  T? data;              // The data returned from the API
  String? message;      // An optional message for any errors or status updates

  // Constructor initializing data, status, and message
  ApiResponse(this.data, this.status, this.message);

  // Factory constructor to create a loading response
  ApiResponse.loading() : status = Status.LOADING;

  // Factory constructor to create a completed response
  ApiResponse.completed(this.data) : status = Status.COMPLETED;

  // Factory constructor to create an error response
  ApiResponse.error(this.message) : status = Status.ERROR;

  // Override toString for easy debugging and logging
  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
