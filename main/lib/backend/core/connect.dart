import 'package:connectify/connectify.dart';
import 'package:drive/library.dart';

class Connect<T> implements ConnectService<T> {
  Connect();

  ConnectifyService get _connect {
    Headers headers = {
      'Content-Type': 'application/json',
      'X-Serch-Drive-Api-Key': Keys.apiKey,
      'X-Serch-Drive-Secret-Key': Keys.secretKey,
      'X-Serch-Signed': Keys.signature,
    };

    if(Database.instance.auth.isLoggedIn) {
      headers['Go-Authorization'] = Database.instance.auth.session;
    }

    return Connectify(config: ConnectifyConfig(
      useToken: false,
      mode: PlatformEngine.instance.debug ? Server.SANDBOX : Server.PRODUCTION,
      headers: headers,
      showErrorLogs: true,
      showRequestLogs: false,
      showResponseLogs: false,
      isWebPlatform: PlatformEngine.instance.isWeb
    ));
  }

  @override
  Future<Outcome<T>> delete({required String endpoint, RequestParam? query, RequestBody body}) async {
    try {
      ApiResponse<dynamic> response = await _connect.delete(endpoint: endpoint, body: body, query: query);
      return transformResponse(response);
    } on ConnectifyException catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Outcome<T>> get({required String endpoint, RequestParam? query}) async {
    try {
      ApiResponse<dynamic> response = await _connect.get(endpoint: endpoint, query: query);
      return transformResponse(response);
    } on ConnectifyException catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Outcome<T>> patch({required String endpoint, RequestBody body, RequestParam? query}) async {
    try {
      ApiResponse<dynamic> response = await _connect.patch(endpoint: endpoint, body: body, query: query);
      return transformResponse(response);
    } on ConnectifyException catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Outcome<T>> post({required String endpoint, RequestBody body, RequestParam? query,}) async {
    try {
      ApiResponse<dynamic> response = await _connect.post(endpoint: endpoint, body: body, query: query);
      return transformResponse(response);
    } on ConnectifyException catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Outcome<T>> put({required String endpoint, RequestBody body, RequestParam? query,}) async {
    try {
      ApiResponse<dynamic> response = await _connect.put(endpoint: endpoint, body: body, query: query);
      return transformResponse(response);
    } on ConnectifyException catch (e) {
      return handleException(e);
    }
  }

  Outcome<T> transformResponse(ApiResponse<dynamic> response) {
    return ApiResponse(
      status: response.status,
      code: response.code,
      message: response.message,
      data: response.data
    );
  }

  Outcome<T> handleException(ConnectifyException e) {
    notify.error(message: e.message);

    return ApiResponse.error(e.message);
  }
}