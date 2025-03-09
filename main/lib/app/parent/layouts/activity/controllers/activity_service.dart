import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class ActivityService {
  ActivityService._();
  static final ActivityService instance = ActivityService._();

  final ConnectService _connect = Connect();

  void attend({required GoActivity activity, GoActivityUpdated? onUpdated}) {
    if(Database.instance.auth.isLoggedIn && activity.isClosed.isFalse) {
      GoActivity value = activity;
      if(value.hasResponded) {
        value = value.copyWith(hasResponded: false);
      } else {
        value = value.copyWith(hasResponded: true);
      }

      if(onUpdated.isNotNull) {
        onUpdated!(value);
      }
      ActivityController.data.onGoActivityUpdated(value);
      CentreController.data.onGoActivityUpdated(value);
      GoActivityController.data?.onGoActivityUpdated(value);

      _connect.patch(endpoint: "/go/activity/attend/${value.id}").then((Outcome response) {
        if(response.isSuccessful) {
          value = GoActivity.fromJson(response.data);

          if(onUpdated.isNotNull) {
            onUpdated!(value);
          }
          ActivityController.data.onGoActivityUpdated(value);
          CentreController.data.onGoActivityUpdated(value);
          GoActivityController.data?.onGoActivityUpdated(value);
        } else {
          if(value.hasResponded) {
            value = value.copyWith(hasResponded: false);
          } else {
            value = value.copyWith(hasResponded: true);
          }

          if(onUpdated.isNotNull) {
            onUpdated!(value);
          }
          ActivityController.data.onGoActivityUpdated(value);
          CentreController.data.onGoActivityUpdated(value);
          GoActivityController.data?.onGoActivityUpdated(value);

          notify.error(message: response.message);
        }
      });
    } else {
      GoIntro.open();
    }
  }

  Future<bool> end({required GoActivity activity, required GoActivityUpdated onUpdated}) async {
    if(Database.instance.auth.isLoggedIn) {
      return await _connect.patch(endpoint: "/go/activity/end/${activity.id}").then((Outcome response) {
        if(response.isSuccessful) {
          GoActivity value = GoActivity.fromJson(response.data);
          onUpdated(value);
          ActivityController.data.onGoActivityUpdated(value);
          CentreController.data.onGoActivityUpdated(value);
        } else {
          notify.error(message: response.message);
        }

        return true;
      });
    } else {
      GoIntro.open();
      return true;
    }
  }

  Future<bool> start({required GoActivity activity, required GoActivityUpdated onUpdated}) async {
    if(Database.instance.auth.isLoggedIn) {
      return await _connect.patch(endpoint: "/go/activity/start/${activity.id}").then((Outcome response) {
        if(response.isSuccessful) {
          GoActivity value = GoActivity.fromJson(response.data);
          onUpdated(value);
          ActivityController.data.onGoActivityUpdated(value);
          CentreController.data.onGoActivityUpdated(value);
        } else {
          notify.error(message: response.message);
        }

        return true;
      });
    } else {
      GoIntro.open();
      return true;
    }
  }

  Future<bool> delete(GoActivity value) async {
    if(Database.instance.auth.isLoggedIn) {
      return await _connect.delete(endpoint: "/go/activity/delete/${value.id}").then((Outcome response) {
        return response.isSuccessful;
      });
    } else {
      GoIntro.open();
      return false;
    }
  }
}