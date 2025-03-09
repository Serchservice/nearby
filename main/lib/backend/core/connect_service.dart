import 'package:connectify/connectify.dart';

import '../../configurations/typedefs.dart';

/// Abstract class to define the base structure for connecting to a service and performing HTTP requests.
abstract class ConnectService<T> {
  /// Sends a GET request to the specified endpoint.
  ///
  /// @param endpoint The API endpoint to send the request to.
  /// @param query Optional query parameters to include in the request.
  ///
  /// @return A `Future` that completes with an `Outcome` containing the result of the GET request.
  Future<Outcome<T>> get({required String endpoint, RequestParam? query});

  /// Sends a POST request to the specified endpoint with the given body.
  ///
  /// @param endpoint The API endpoint to send the request to.
  /// @param body The data to be sent in the body of the POST request.
  /// @param query Optional query parameters to include in the request.
  ///
  /// @return A `Future` that completes with an `Outcome` containing the result of the POST request.
  Future<Outcome<T>> post({required String endpoint, RequestBody body, RequestParam? query});

  /// Sends a PUT request to the specified endpoint with the given body.
  ///
  /// @param endpoint The API endpoint to send the request to.
  /// @param body The data to be sent in the body of the PUT request.
  /// @param query Optional query parameters to include in the request.
  ///
  /// @return A `Future` that completes with an `Outcome` containing the result of the PUT request.
  Future<Outcome<T>> put({required String endpoint, RequestBody body, RequestParam? query});

  /// Sends a PATCH request to the specified endpoint with the given body.
  ///
  /// @param endpoint The API endpoint to send the request to.
  /// @param body The data to be sent in the body of the PATCH request.
  /// @param query Optional query parameters to include in the request.
  ///
  /// @return A `Future` that completes with an `Outcome` containing the result of the PATCH request.
  Future<Outcome<T>> patch({required String endpoint, RequestBody body, RequestParam? query});

  /// Sends a DELETE request to the specified endpoint.
  ///
  /// @param endpoint The API endpoint to send the request to.
  /// @param query Optional query parameters to include in the request.
  /// @param body Optional data to be sent in the body of the DELETE request.
  ///
  /// @return A `Future` that completes with an `Outcome` containing the result of the DELETE request.
  Future<Outcome<T>> delete({required String endpoint, RequestParam? query, RequestBody body});
}