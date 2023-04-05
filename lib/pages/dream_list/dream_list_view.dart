import 'package:dream_journal/pages/dream_list/widgets/list_dream.dart';
import 'package:dream_journal/pages/dream_list/widgets/list_month.dart';
import 'package:dream_journal/shared/utils/database_provider.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:dream_journal/shared/models/dream.dart';
import 'package:flutter/material.dart';
import '../dream/dream_view.dart';

class DreamList extends StatefulWidget {
  const DreamList({Key? key}) : super(key: key);

  @override
  State<DreamList> createState() => _DreamListState();
}

class _DreamListState extends State<DreamList> {
  UniqueKey _refreshKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _refreshKey,
      appBar: AppBar(
        title: const Text('Dreams'),
      ),
      body: FutureBuilder(
        future: DatabaseProvider.db.getDreamsByMonth(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                for (DateTime month in snapshot.data!.keys)
                  SliverStickyHeader(
                    header: MonthListElement(month: month),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          Dream dream = snapshot.data![month]![index];
                          return DreamListElement(dream: dream, onChanged: () => setState(() {}));
                        },
                        childCount: snapshot.data![month]!.length,
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
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
            setState(() {
              _refreshKey = UniqueKey();
            });
          }
        },
      ),
    );
  }
}
