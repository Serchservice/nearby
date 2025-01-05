import 'package:drive/library.dart';

abstract class OneSignalService {
  void initialize();

  void addSearchTag(CategorySection tag);

  void addLocationTag(Address location);
}