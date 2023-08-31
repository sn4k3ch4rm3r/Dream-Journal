import 'package:dream_journal/shared/database_provider.dart';
import 'package:dream_journal/shared/models/statisticsdata.dart';
import 'package:flutter/material.dart';
import 'package:dream_journal/shared/models/dream.dart';
import 'widgets/statistics_card.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({Key? key}) : super(key: key);

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  Future<StatisticsData> getData() async {
    List<Dream> dreams = await DatabaseProvider.db.getDreams();
    int count = dreams.length;
    List<Dream> lucidDreams = dreams.where((element) => element.isLucid).toList();
    return StatisticsData(
      count: count,
      lucidCount: dreams.where((element) => element.isLucid).length,
      nightmareCount: dreams.where((element) => element.isNightmare).length,
      recurrentCount: dreams.where((element) => element.isRecurrent).length,
      paralysisCount: dreams.where((element) => element.sleepParalysisOccured).length,
      falseAwakeningCount: dreams.where((element) => element.falseAwakeningOccured).length,
      vividityAvg: dreams.fold(0, (int previousValue, element) => previousValue + element.vividity) / count,
      lucidityAvg: lucidDreams.fold(0, (int previousValue, element) => previousValue + element.lucidity) / lucidDreams.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, AsyncSnapshot<StatisticsData> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StatisticsCard(
                      name: "Dreams",
                      value: snapshot.data!.count,
                    ),
                    StatisticsCard(
                      name: "Lucid Dreams",
                      value: snapshot.data!.lucidCount,
                    ),
                    StatisticsCard(
                      name: "Nightmares",
                      value: snapshot.data!.nightmareCount,
                    ),
                    StatisticsCard(
                      name: "Recurrent Dreams",
                      value: snapshot.data!.recurrentCount,
                    ),
                    StatisticsCard(
                      name: "Sleep Paralysis",
                      value: snapshot.data!.paralysisCount,
                    ),
                    StatisticsCard(
                      name: "False Awakening",
                      value: snapshot.data!.falseAwakeningCount,
                    ),
                    StatisticsCard(
                      name: "Average Vividity",
                      value: double.parse(snapshot.data!.vividityAvg.toStringAsFixed(1)),
                    ),
                    StatisticsCard(
                      name: "Average Lucidity",
                      value: double.parse(snapshot.data!.lucidityAvg.toStringAsFixed(1)),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
