import 'package:dream_journal/pages/dream_list/widgets/list_dream.dart';
import 'package:dream_journal/pages/dream_list/widgets/list_month.dart';
import 'package:dream_journal/shared/database_provider.dart';
import 'package:dream_journal/shared/firestore_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:dream_journal/shared/models/dream.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import '../dream/dream_view.dart';

class DreamList extends StatefulWidget {
  const DreamList({Key? key}) : super(key: key);

  @override
  State<DreamList> createState() => _DreamListState();
}

class _DreamListState extends State<DreamList> {
  UniqueKey _refreshKey = UniqueKey();
  bool _authenticated = false;
  bool _dreamsHidden = true && !kIsWeb;
  final LocalAuthentication _auth = LocalAuthentication();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _refreshKey,
      appBar: AppBar(
        title: const Text('Dreams'),
        actions: [
          IconButton(
            icon: Icon(_dreamsHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined),
            onPressed: () async {
              if (!_authenticated) {
                bool result = await _auth.authenticate(
                  localizedReason: ' ',
                  options: const AuthenticationOptions(
                    stickyAuth: true,
                  ),
                  authMessages: [
                    const AndroidAuthMessages(
                      signInTitle: 'Authenticate to view dreams',
                      biometricHint: '',
                    ),
                  ],
                );
                if (result) {
                  setState(() {
                    _authenticated = true;
                  });
                }
              }

              if (_authenticated) {
                setState(() {
                  _dreamsHidden = !_dreamsHidden;
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirestoreManager.getDreamsByMonth(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                for (DateTime month in snapshot.data!.keys)
                  SliverStickyHeader(
                    header: MonthListElement(month: month),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          Dream dream = snapshot.data![month]![index];
                          return DreamListElement(
                            dream: dream,
                            onChanged: () => setState(() {}),
                            hidden: _dreamsHidden,
                          );
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
      floatingActionButton: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, _) {
          bool extended = !_scrollController.positions.isNotEmpty || _scrollController.position.pixels < 1;
          return FloatingActionButton.extended(
            label: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              reverseDuration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.horizontal,
                  child: child,
                ),
              ),
              child: extended
                  ? Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: extended ? 16.0 : 0),
                          child: const Icon(
                            Icons.add,
                          ),
                        ),
                        const Text("Add Dream"),
                      ],
                    )
                  : const Icon(Icons.add),
            ),
            extendedPadding: EdgeInsets.only(left: 16, right: extended ? 20 : 16),
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
          );
        },
      ),
    );
  }
}
