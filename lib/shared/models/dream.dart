import 'package:dream_journal/shared/database_provider.dart';
import 'package:dream_journal/shared/models/mood.dart';
import 'package:dream_journal/shared/models/tag.dart';
import 'package:dream_journal/shared/models/time_of_day.dart';
import 'package:intl/intl.dart';

class Dream {
  static DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  late int? id;
  late String? dream;
  late bool isNightmare;
  late bool isRecurrent;
  late bool sleepParalysisOccured;
  late bool falseAwakeningOccured;
  late bool isLucid;
  late int vividity;
  late int lucidity;
  late DateTime date;
  Mood? mood;
  TimeOfDayEnum? time;
  List<Tag> tags = [];

  Dream({
    this.id,
    this.dream,
    required this.isNightmare,
    required this.isRecurrent,
    required this.sleepParalysisOccured,
    required this.falseAwakeningOccured,
    required this.isLucid,
    required this.vividity,
    required this.lucidity,
    required this.date,
    this.mood,
    this.time,
  });

  Dream.copy(Dream dream) {
    id = dream.id;
    this.dream = dream.dream;
    isNightmare = dream.isNightmare;
    isRecurrent = dream.isRecurrent;
    sleepParalysisOccured = dream.sleepParalysisOccured;
    falseAwakeningOccured = dream.falseAwakeningOccured;
    isLucid = dream.isLucid;
    vividity = dream.vividity;
    lucidity = dream.lucidity;
    date = dream.date;
    mood = dream.mood;
    time = dream.time;
    tags = dream.tags.map((e) => Tag.copy(e)).toList();
  }

  Map<String, dynamic> toMap() {
    String dateString = dateFormat.format(date);
    Map<String, dynamic> map = {
      DatabaseProvider.COLUMN_DREAM: dream,
      DatabaseProvider.COLUMN_ISLUCID: isLucid ? 1 : 0,
      DatabaseProvider.COLUMN_ISNIGHTMARE: isNightmare ? 1 : 0,
      DatabaseProvider.COLUMN_ISRECURRENT: isRecurrent ? 1 : 0,
      DatabaseProvider.COLUMN_SLEEPPARALYSIS: sleepParalysisOccured ? 1 : 0,
      DatabaseProvider.COLUMN_FALSEAWAKENING: falseAwakeningOccured ? 1 : 0,
      DatabaseProvider.COLUMN_VIVIDITY: vividity,
      DatabaseProvider.COLUMN_LUCIDITY: lucidity,
      DatabaseProvider.COLUMN_DATE: dateString,
    };
    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Dream.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    dream = map[DatabaseProvider.COLUMN_DREAM];
    isLucid = map[DatabaseProvider.COLUMN_ISLUCID] == 1;
    isNightmare = map[DatabaseProvider.COLUMN_ISNIGHTMARE] == 1;
    isRecurrent = map[DatabaseProvider.COLUMN_ISRECURRENT] == 1;
    sleepParalysisOccured = map[DatabaseProvider.COLUMN_SLEEPPARALYSIS] == 1;
    falseAwakeningOccured = map[DatabaseProvider.COLUMN_FALSEAWAKENING] == 1;
    vividity = map[DatabaseProvider.COLUMN_VIVIDITY];
    lucidity = map[DatabaseProvider.COLUMN_LUCIDITY];
    String dateString = map[DatabaseProvider.COLUMN_DATE];
    date = dateFormat.parse(dateString);
  }
}
