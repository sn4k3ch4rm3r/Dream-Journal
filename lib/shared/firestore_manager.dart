import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_journal/shared/models/dream.dart';
import 'package:dream_journal/shared/models/mood.dart';
import 'package:dream_journal/shared/models/tag.dart';
import 'package:dream_journal/shared/models/time_of_day.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreManager {
  static DocumentReference get userReference => FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
  static CollectionReference get tagsReference => userReference.collection('tags');
  static CollectionReference get dreamsReference => userReference.collection('dreams');

  static Future<List<Dream>> getDreams() async {
    QuerySnapshot queryResult = await dreamsReference.orderBy('date', descending: true).get();
    List<Dream> dreams = [];
    for (var dream in queryResult.docs) {
      dreams.add(await _dreamFromSnapshot(dream.id, dream.data() as Map<String, dynamic>));
    }
    return dreams;
  }

  static Future<Map<DateTime, List<Dream>>> getDreamsByMonth() async {
    List<Dream> dreams = await getDreams();
    Map<DateTime, List<Dream>> months = {};
    for (var dream in dreams) {
      DateTime month = DateTime(dream.date.year, dream.date.month);
      if (months.containsKey(month)) {
        months[month]!.add(dream);
      } else {
        months[month] = [
          dream
        ];
      }
    }

    return months;
  }

  static Future<Dream> _dreamFromSnapshot(String id, Map<String, dynamic> data) async {
    Mood? mood;
    TimeOfDayEnum? time;
    if (data['mood'] != null) {
      mood = Mood.values.firstWhere((element) => element.name == data['mood']);
    }
    if (data['time'] != null) {
      time = TimeOfDayEnum.values.firstWhere((element) => element.name == data['time']);
    }

    List<Tag> tags = [];
    List<Tag> allTags = await getTags();
    for (String tagName in data['tags']) {
      tags.add(allTags.firstWhere((element) => element.name == tagName));
    }

    return Dream(
      firebaseId: id,
      dream: data['description'],
      isNightmare: data['isNightmare'],
      isRecurrent: data['isRecurrent'],
      sleepParalysisOccured: data['sleepParalysis'],
      falseAwakeningOccured: data['falseAwakening'],
      isLucid: data['isLucid'],
      vividity: data['vividity'],
      lucidity: data['lucidity'],
      date: data['date'].toDate(),
      favourite: data['favourite'],
      mood: mood,
      time: time,
      tags: tags,
    );
  }

  static Future<void> saveDream(Dream dream) async {
    WriteBatch tagsBatch = tagsReference.firestore.batch();
    for (Tag tag in dream.tags) {
      tagsBatch.set(
        tagsReference.doc(tag.name),
        {
          'type': tag.type.name,
        },
      );
    }
    tagsBatch.commit();

    DocumentReference dreamRef = dream.firebaseId == null ? dreamsReference.doc() : dreamsReference.doc(dream.firebaseId);
    dream.firebaseId = dreamRef.id;

    dreamRef.set({
      'description': dream.dream,
      'isLucid': dream.isLucid,
      'isNightmare': dream.isNightmare,
      'sleepParalysis': dream.sleepParalysisOccured,
      'isRecurrent': dream.isRecurrent,
      'falseAwakening': dream.falseAwakeningOccured,
      'vividity': dream.vividity,
      'lucidity': dream.lucidity,
      'date': dream.date,
      'favourite': dream.favourite,
      'time': dream.time?.name,
      'mood': dream.mood?.name,
      'tags': dream.tags.map((e) => e.name).toList(),
    });
  }

  static Future<void> deleteDream(String id) async {
    await dreamsReference.doc(id).delete();
  }

  static Future<List<Tag>> getTags() async {
    QuerySnapshot tags = await tagsReference.get();
    return tags.docs.map((e) => Tag(e.id, TagType.values.firstWhere((element) => element.name == (e.data()! as Map<String, dynamic>)['type']))).toList();
  }
}
