import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:drive/library.dart';

class Connect<T> implements ConnectService<T> {
  bool useToken;
  Connect({this.useToken = true});

  Connectify get connect {
    return Connectify(options: ConnectifyOptions(
      useToken: false,
      showLog: false,
      mode: ConnectifyMode.PRODUCTION,
      headers: {
        'Content-Type': 'application/json',
        'X-Serch-Drive-Api-Key': Keys.apiKey,
        'X-Serch-Drive-Secret-Key': Keys.secretKey,
        'X-Serch-Signed': Keys.signature
      },
    ));
  }

  @override
  Future<ApiResponse<T>> delete({required String endpoint, Map<String, dynamic>? query, body}) async {
    try {
      var response = await connect.delete(endpoint: endpoint, body: body, query: query);

      return transformResponse(response);
    } on ConnectifyException catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<ApiResponse<T>> get({required String endpoint, Map<String, dynamic>? query}) async {
    try {
      var response = await connect.get(endpoint: endpoint, query: query);

      return transformResponse(response);
    } on ConnectifyException catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<ApiResponse<T>> patch({required String endpoint, body, Map<String, dynamic>? query}) async {
    try {
      var response = await connect.patch(endpoint: endpoint, body: body, query: query);

      return transformResponse(response);
    } on ConnectifyException catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<ApiResponse<T>> post({required String endpoint, body, Map<String, dynamic>? query}) async {
    try {
      var response = await connect.post(endpoint: endpoint, body: body, query: query);

      return transformResponse(response);
    } on ConnectifyException catch (e) {
      return handleException(e);
    }
  }

  ApiResponse<T> transformResponse(ApiResponse<dynamic> response) {
    return ApiResponse(
      status: response.status,
      code: response.code,
      message: response.message,
      data: response.data
    );
  }

  ApiResponse<T> handleException(ConnectifyException e) {
    notify.error(message: e.message);

    return ApiResponse.error(e.message);
  }
}