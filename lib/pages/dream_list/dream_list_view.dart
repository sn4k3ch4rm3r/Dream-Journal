import 'package:dream_journal/shared/utils/database_provider.dart';
import 'package:dream_journal/shared/models/dream.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../dream/dream_view.dart';

class DreamList extends StatefulWidget {
  const DreamList({Key? key}) : super(key: key);

  @override
  State<DreamList> createState() => _DreamListState();
}

class _DreamListState extends State<DreamList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dreams'),
      ),
      body: const DreamListBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
        ),
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DreamView(isNew: true)),
          );
          if (result == 'success') {
            setState(() {});
          }
        },
      ),
    );
  }
}

class DreamListBody extends StatefulWidget {
  const DreamListBody({Key? key}) : super(key: key);

  @override
  State<DreamListBody> createState() => _DreamListBodyState();
}

class _DreamListBodyState extends State<DreamListBody> {
  Future<Widget> getDreams() async {
    List<Dream> dreams = await DatabaseProvider.db.getDreams();
    List<Widget> listElements = [];
    if (dreams.isNotEmpty) {
      dreams.sort((a, b) => a.date.millisecondsSinceEpoch.compareTo(b.date.millisecondsSinceEpoch));
      dreams = dreams.reversed.toList();
      DateTime prevDate = dreams.first.date;
      listElements.add(listViewMonth(prevDate));
      for (var dream in dreams) {
        if (dream.date.month != prevDate.month || dream.date.year != prevDate.year) {
          prevDate = dream.date;
          listElements.add(listViewMonth(prevDate));
        }
        listElements.add(listViewDream(dream));
      }
      return ListView(children: listElements);
    } else {
      return const Center(
        child: Text('You have not saved any dreams yet.'),
      );
    }
  }

  SizedBox listViewDream(Dream dream) {
    return SizedBox(
      height: 65,
      child: ListTile(
        leading: Text(
          dream.date.day.toString().padLeft(2, '0'),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        title: Text(
          dream.dream!,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DreamView(dream: dream, edit: false)),
          );
          if (result == 'edited' || result == 'deleted') {
            setState(() {});
          }
        },
      ),
    );
  }

  Ink listViewMonth(DateTime date) {
    DateFormat dateFormat = DateFormat('MMMM yyyy');
    return Ink(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        dense: true,
        title: Text(
          dateFormat.format(date),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDreams(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return snapshot.data;
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
