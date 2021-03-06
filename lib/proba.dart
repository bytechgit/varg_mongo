import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moj_majstor/AppState.dart';
import 'package:moj_majstor/Majsor.dart';
import 'package:moj_majstor/ShimmerList.dart';
import 'package:moj_majstor/filter.dart';
import 'package:provider/provider.dart';
import 'SearchFilterDrawer.dart';
import 'homeHeaderDelegate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/*

Platform  Firebase App Id
android   1:206265439348:android:c4420e046c88e20e216d21
ios       1:206265439348:ios:1e9694a1a80e0064216d21

Learn more about using this file in the FlutterFire documentation:
 > https://firebase.flutter.dev/docs/cli

C:\Users\sgssa\AndroidStudioProjects\moj_majstor>

 */
class proba extends StatefulWidget {
  const proba({Key? key}) : super(key: key);
  @override
  State<proba> createState() => _probaState();
}

class _probaState extends State<proba> {
  final ScrollController _scrollController = ScrollController();
  final filterController = Get.find<Filter>();
  @override
  void initState() {
    super.initState();
    filterController.get(true);
  }

  bool p = true;

  Future<void> onRefresh() async {
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    int n = await filterController.get(false);
    if (n == 0) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SafeArea(
        child: FilterDrawer(),
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: SmartRefresher(
            controller: _refreshController,
            onRefresh: onRefresh,
            onLoading: _onLoading,
            enablePullDown: false,
            enablePullUp: true,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: _scrollController,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: HomeHeaderDelegate(openHeight: 200),
                ),
                Consumer<AppState>(builder: (context, appstate, child) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      child: Obx(
                        () => Column(
                          children: filterController.majstori.isNotEmpty
                              ? (filterController.majstori.map((e) {
                                  return Majstor(
                                    majstor: e,
                                  );
                                }).toList())
                              : [const ShimmerList()],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
