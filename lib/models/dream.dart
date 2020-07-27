import 'package:dream_journal/data/database_provider.dart';
import 'package:intl/intl.dart';

class Dream {
  static DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  int id;
  String dream;
  bool isLucid;
  int vividity;
  DateTime date;

  Dream({this.id, this.dream, this.isLucid, this.vividity, this.date});

  Map<String, dynamic> toMap() {
    String dateString = dateFormat.format(date);
    Map<String, dynamic> map = {
      DatabaseProvider.COLUMN_DREAM: dream,
      DatabaseProvider.COLUMN_ISLUCID: isLucid ? 1 : 0,
      DatabaseProvider.COLUMN_VIVIDITY: vividity,
      DatabaseProvider.COLUMN_DATE: dateString,
    };
    if(id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Dream.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    dream = map[DatabaseProvider.COLUMN_DREAM];
    isLucid = map[DatabaseProvider.COLUMN_ISLUCID] == 1;
    vividity = map[DatabaseProvider.COLUMN_VIVIDITY];
    String dateString = map[DatabaseProvider.COLUMN_DATE];
    date = dateFormat.parse(dateString);
  }
}