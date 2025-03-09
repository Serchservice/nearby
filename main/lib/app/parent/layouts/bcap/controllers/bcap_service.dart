import 'package:drive/library.dart';

class BCapService {
  BCapService._();
  static final BCapService instance = BCapService._();

  final ConnectService _connect = Connect();

  Future<bool> delete(String cap) async {
    if(Database.instance.auth.isLoggedIn) {
      return await _connect.delete(endpoint: "/go/bcap/delete/$cap").then((Outcome response) {
        return response.isSuccessful;
      });
    } else {
      GoIntro.open();
      return false;
    }
  }
}