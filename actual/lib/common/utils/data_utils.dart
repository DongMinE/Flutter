import 'package:actual/common/const/data.dart';

class DataUtils {
  //JsonKey값은 static 필수
  static pathToUrl(String value) {
    return 'http://$ip$value';
  }
}
