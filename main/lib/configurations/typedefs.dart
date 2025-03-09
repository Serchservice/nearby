import 'package:camera/camera.dart';
import 'package:connectify/connectify.dart';
import 'package:drive/library.dart';
import 'package:multimedia/multimedia.dart';
import 'package:smart/smart.dart';

/// Callback for receiving a single selected media item.
typedef SelectedMediaReceived = Function(SelectedMedia media);

/// Callback for receiving a list of selected media items.
typedef SelectedMediaListReceived = Function(List<SelectedMedia> media);

/// Callback for receiving an informational message.
typedef OnInformationReceived = Function(String message);

/// Callback for receiving an error message.
typedef OnErrorReceived = Function(String error, bool useTip);

/// Callback for receiving updated camera descriptions.
typedef CameraDescriptionUpdated = Function(List<CameraDescription> cameras);

/// Callback for receiving a list of media items.
typedef MediumListReceived = void Function(List<Medium>);

/// Callback for receiving a single media item.
typedef MediumReceived = void Function(Medium);

/// Represents an API response with data and potential errors.
typedef Outcome<T> = ApiResponse<T>;

/// Callback for device validation.
typedef ValidatorCallback = Future<DeviceValidator> Function();

/// A map of device validation callbacks.
typedef DeviceValidation = Map<String, ValidatorCallback>;

/// Callback for rating success
typedef RatingSuccessCallback = void Function(String comment, double rating);

/// Callback to receive the selected interests
typedef GoInterestListener = void Function(List<GoInterest> interests);

/// Callback to receive the selected interest
typedef GoInterestSelected = void Function(GoInterest interest);

/// Callback to receive the updated [activity]
typedef GoActivityUpdated = void Function(GoActivity activity);

/// Callback to receive the updated [bcap]
typedef GoBCapUpdated = void Function(GoBCap bcap);

/// Callback to handle [GoCreateUpload] [upload]
typedef GoCreateUploadReceived = void Function(GoCreateUpload upload);

/// Callback to handle [GoBCapCreateUpload] [upload]
typedef GoBCapCreateUploadReceived = void Function(GoBCapCreateUpload upload);

/// Callback to handle [address]
typedef AddressReceived = void Function(Address address);

/// Callback to handle updated list of activities
typedef GoActivityListUpdated = void Function(List<GoActivity> activities);

/// Callback to handle updated list of activity comments
typedef GoActivityCommentListUpdated = void Function(List<GoActivityComment> comments);

/// Callback to handle updated list of activity ratings
typedef GoActivityRatingListUpdated = void Function(List<GoActivityRating> ratings);

/// Callback to handle updated GoUserAddon
typedef GoUserAddonUpdated = void Function(GoUserAddon addon);