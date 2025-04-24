import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/loader.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/modules/workers/worker_info_page.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkersPage extends StatefulWidget {
  const WorkersPage({super.key});

  @override
  State<WorkersPage> createState() => _WorkersPageState();
}

class _WorkersPageState extends State<WorkersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  StreamSubscription<List<UserData>>? _workersSubscription;
  List<UserData> _cachedWorkers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _setupRealTimeUpdates();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  void _setupRealTimeUpdates() {
    setState(() {
      _isLoading = true;
    });

    try {
      final workersStream = AppServices.getWorkersList();
      _workersSubscription = workersStream.listen((workers) {
        setState(() {
          _cachedWorkers = workers;
          _isLoading = false;
        });
      }, onError: (error) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshWorkers() async {
    await _workersSubscription?.cancel();
    _setupRealTimeUpdates();
  }

  @override
  void dispose() {
    _workersSubscription?.cancel();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(AppLocalizations.of(context)!.workers, context,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.filter_list,
                color: AppColor.black,
              ),
            )
          ],
          isCenter: true,
          isneedtopop: false,
          iswhite: true),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabSelector(),
          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [_buildNewWorkerTabContent(), _buildActiveWorkerTabContent()],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColor.green,
        labelPadding: EdgeInsets.zero,
        tabs: [
          _customTab(AppLocalizations.of(context)!.latest, 0),
          _customTab(AppLocalizations.of(context)!.active, 1),
        ],
      ),
    );
  }

  Widget _customTab(String text, int index) {
    bool isSelected = _tabController.index == index;
    return Tab(
      child: Container(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColor.black : AppColor.lightGrey400,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNewWorkerTabContent() {
    if (_isLoading) {
      return const Center(child: HandymanLoader());
    }

    final newWorkers =
        _cachedWorkers.where((worker) => worker.isVerified != true).toList();

    if (newWorkers.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.nonewworkersavailable),
            TextButton(
              onPressed: _refreshWorkers,
              child: Text(AppLocalizations.of(context)!.refresh),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshWorkers,
      child: ListView.builder(
        itemCount: newWorkers.length,
        itemBuilder: (context, index) {
          final worker = newWorkers[index];
          return _buildNewWorkerCard(worker);
        },
      ),
    );
  }

  Widget _buildNewWorkerCard(UserData worker) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WorkerInfoPage(
            workerData: worker,
          ),
        ));
      },
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 16),
        color: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColor.lightGrey300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColor.skyBlue,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 40),
              ),
              const SizedBox(width: 15),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HandyLabel(
                    text: worker.name ?? AppLocalizations.of(context)!.unknown,
                    isBold: true,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 10),
                  HandyLabel(
                    text: worker.experience ??
                        AppLocalizations.of(context)!.experienceunspecified,
                    isBold: false,
                    fontSize: 14,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveWorkerTabContent() {
    if (_isLoading) {
      return const Center(child: HandymanLoader());
    }

    final activeWorkers =
        _cachedWorkers.where((worker) => worker.isVerified == true).toList();

    if (activeWorkers.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.noactiveworkersavailable),
            TextButton(
              onPressed: _refreshWorkers,
              child: Text(AppLocalizations.of(context)!.refresh),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshWorkers,
      child: ListView.builder(
        itemCount: activeWorkers.length,
        itemBuilder: (context, index) {
          final worker = activeWorkers[index];
          return _buildActiveWorkerCard(worker);
        },
      ),
    );
  }

  Widget _buildActiveWorkerCard(UserData worker) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WorkerInfoPage(
            workerData: worker,
          ),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Card(
          elevation: 0,
          color: AppColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColor.lightGrey300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: AppColor.skyBlue,
                      ),
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 40),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              HandyLabel(
                                text: worker.name ??
                                    AppLocalizations.of(context)!.unknown,
                                isBold: true,
                                fontSize: 16,
                              ),
                              const SizedBox(width: 5),
                              _buildStatusIndicator(
                                  worker.isUserOnline ?? false),
                            ],
                          ),
                          const SizedBox(height: 10),
                          HandyLabel(
                            text: worker.experience ??
                                AppLocalizations.of(context)!
                                    .experienceunspecified,
                            isBold: false,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      constraints: const BoxConstraints(
                        minHeight: 50,
                        maxHeight: 50,
                        maxWidth: 50,
                        minWidth: 50,
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          AppColor.lightGreen,
                        ),
                      ),
                      onPressed: () {},
                      icon: Icon(
                        size: 30,
                        Icons.phone,
                        color: AppColor.green,
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                _detailRow(AppLocalizations.of(context)!.totaljobs, "0"),
                const SizedBox(height: 10),
                _detailRow(AppLocalizations.of(context)!.jobsinqueue, "0"),
                const SizedBox(height: 10),
                const Divider(thickness: 1),
                Row(
                  children: [
                    const HandyLabel(
                      text: "0.0",
                      isBold: true,
                      fontSize: 16,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: RatingBar.builder(
                        initialRating: 0.0,
                        minRating: 0.5,
                        maxRating: 5.0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        unratedColor: AppColor.lightGrey300,
                        itemCount: 5,
                        itemSize: 20,
                        ignoreGestures: true,
                        itemPadding: EdgeInsets.zero,
                        itemBuilder: (context, _) =>
                            Icon(Icons.star, color: AppColor.yellow),
                        onRatingUpdate: (rating) {},
                      ),
                    ),
                    HandyLabel(
                      text: "0 ${AppLocalizations.of(context)!.reviews}",
                      isBold: false,
                      fontSize: 16,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(bool isOnline) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: isOnline ? AppColor.green : AppColor.red,
        ),
        const SizedBox(width: 5),
        HandyLabel(
          text: isOnline
              ? AppLocalizations.of(context)!.available
              : AppLocalizations.of(context)!.offline,
          textcolor: isOnline ? AppColor.green : AppColor.greyDark,
        )
      ],
    );
  }

  Widget _detailRow(String title, String content) {
    return Row(
      children: [
        Expanded(
          child: HandyLabel(
            text: title,
            isBold: false,
            fontSize: 14,
          ),
        ),
        HandyLabel(
          textcolor: AppColor.lightGrey500,
          text: content,
          isBold: false,
          fontSize: 14,
        )
      ],
    );
  }
}
