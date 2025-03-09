import 'package:get/get.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class SelectInterestController extends GetxController {
  final String emailAddress;
  SelectInterestController(this.emailAddress);

  final state = SelectInterestState();

  final ConnectService _connect = Connect();
  final LocationService _locationService = LocationImplementation();

  @override
  void onInit() {
    _locationService.getAddress(
      onSuccess: (address, position) {
        state.address.value = address;
      },
      onError: (error) {
        state.address.value = Database.instance.address;
      }
    );

    super.onInit();
  }

  @override
  void onReady() {
    _fetchCategories();

    super.onReady();
  }

  void _fetchCategories() async {
    String params = "";
    if(state.address.value.hasAddress) {
      params = "?latitude=${state.address.value.latitude}&longitude=${state.address.value.longitude}&place=${state.address.value.place}";
    }

    state.isFetchingCategories.value = true;
    _connect.get(endpoint: "/go/interest/category/all$params").then((Outcome response) {
      state.isFetchingCategories.value = false;

      if(response.isSuccessful) {
        state.categories.value = (response.data as List).map((e) => GoInterestCategory.fromJson(e)).toList();
      } else {
        notify.error(message: response.message);
      }
    });
  }

  void register() {
    state.isLoading.value = true;
    List<int> ids = state.selected.value.map((GoInterest interest) => interest.id).toSet().toList();

    _connect.post(endpoint: "/go/interest", body: {"interests": ids}).then((Outcome response) {
      state.isLoading.value = false;

      if(response.isSuccessful) {
        GoInterestUpdate update = GoInterestUpdate.fromJson(response.data);

        List<GoInterest> interests = update.taken.flatMap<GoInterest>((GoInterestCategory e) => e.interests).toList();
        CentreController.data.state.interests.value = interests;
        Database.instance.saveInterests(interests);

        CentreController.data.state.categories.value = update.taken;
        Database.instance.saveInterestCategories(update.taken);

        Navigate.close(closeAll: false);
        Navigate.all(ParentLayout.route);
      } else {
        notify.error(message: response.message);
      }
    });
  }
}