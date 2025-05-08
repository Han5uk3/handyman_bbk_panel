import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/loader.dart';
import 'package:handyman_bbk_panel/common_widget/svgicon.dart';
import 'package:handyman_bbk_panel/helpers/hive_helpers.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/modules/banners/ad_page.dart';
import 'package:handyman_bbk_panel/modules/home/bloc/location_bloc.dart';
import 'package:handyman_bbk_panel/modules/login/login_page.dart';
import 'package:handyman_bbk_panel/modules/notifications/notifications_page.dart';
import 'package:handyman_bbk_panel/modules/workers/bloc/workers_bloc.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';
import 'package:handyman_bbk_panel/sheets/localization_sheet.dart';
import 'package:handyman_bbk_panel/sheets/logout_sheet.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  final bool isAdmin;
  final UserData userData;

  const HomePage({super.key, required this.isAdmin, required this.userData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showGrid = true;
  late LocationBloc _locationBloc;

  Stream<int>? _workersCountStream;
  Stream<int>? _scheduledBookingsStream;
  Stream<int>? _urgentBookingsStream;
  Stream<dynamic>? _productsStream;

  Stream<List<Map<String, dynamic>>>? _topWorkersStream;
  bool _isLoadingTopWorkers = true;
  List<Map<String, dynamic>> _topWorkers = [];

  @override
  void initState() {
    super.initState();
    _initializeStreams();
    _locationBloc = BlocProvider.of<LocationBloc>(context);
    _locationBloc.add(FetchLocation());
  }

  void _initializeStreams() {
    if (widget.isAdmin) {
      _workersCountStream = AppServices.getWorkersCount();
      _scheduledBookingsStream = AppServices.getScheduleUrgentCount();
      _urgentBookingsStream =
          AppServices.getScheduleUrgentCount(isUrgent: true);
      _productsStream = AppServices.getProductsCount();
      _topWorkersStream = AppServices.getTopWorkersList();
      _listenToTopWorkersStream();
    } else {
      _workersCountStream = AppServices.getWorkerTotalJobsCount();
      _scheduledBookingsStream = AppServices.getWorkerScheduledJobsCount();
      _urgentBookingsStream = AppServices.getWorkerUrgentJobsCount();

      _productsStream = AppServices.getProductsCount();
    }
  }

  void _toggleGrid() {
    setState(() {
      _showGrid = !_showGrid;
    });
  }

  void _listenToTopWorkersStream() {
    _topWorkersStream?.listen((workers) {
      setState(() {
        _topWorkers = workers.take(4).toList(); // Limit to top 4 workers
        _isLoadingTopWorkers = false;
      });
    }, onError: (error) {
      print('Error fetching top workers: $error');
      setState(() {
        _isLoadingTopWorkers = false;
      });
    });
  }

  void _showLogoutPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AdminLogoutPopup(
        onLogout: () async {
          await HiveHelper.removeUID();
          await FirebaseAuth.instance.signOut();
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
          AppServices.uid = null;
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _navigateToAdPage(bool isHomeBanner) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AdPage(isHomeBanner: isHomeBanner)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(
        widget.isAdmin
            ? AppLocalizations.of(context)!.dashboard
            : "${AppLocalizations.of(context)!.welcome} ${widget.userData.name}",
        context,
        isCenter: false,
        iswhite: false,
        textColor: AppColor.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: AppColor.white),
            onPressed: () => Localization.showLanguageDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColor.white),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const NotificationsPage()),
            ),
          ),
          if (widget.isAdmin)
            IconButton(
              icon: const Icon(Icons.logout, color: AppColor.white),
              onPressed: () => _showLogoutPopup(context),
            ),
        ],
      ),
      body: (widget.userData.isVerified ?? false)
          ? _buildBody()
          : _buildWaitingForVerification(),
    );
  }

  Widget _buildWaitingForVerification() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: HandyLabel(
          text: AppLocalizations.of(context)!
              .pleasewaitforadmintoverifyyouraccount,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _showGrid ? _buildCardsGrid() : const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          if (widget.isAdmin) _buildAdminSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (widget.isAdmin) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GestureDetector(
          onTap: _toggleGrid,
          child: SizedBox(
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HandyLabel(
                  text: AppLocalizations.of(context)!.dashboard,
                  fontSize: 14,
                  isBold: false,
                ),
                Icon(
                  _showGrid
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  size: 14,
                  color: AppColor.black,
                ),
              ],
            ),
          ),
        ),
      );
    } else if (widget.userData.isVerified ?? false) {
      return BlocBuilder<WorkersBloc, WorkersState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HandyLabel(
                  text: AppLocalizations.of(context)!.online,
                  fontSize: 18,
                  isBold: true,
                ),
                Switch(
                  value: widget.userData.isUserOnline ?? false,
                  onChanged: (value) {
                    final workersBloc = context.read<WorkersBloc>();
                    final workerId = AppServices.uid ?? "";

                    if (value) {
                      workersBloc.add(SwitchToOnlineEvent(workerId: workerId));
                    } else {
                      workersBloc.add(SwitchToOfflineEvent(workerId: workerId));
                    }
                  },
                  activeColor: AppColor.white,
                  inactiveThumbColor: AppColor.black,
                  activeTrackColor: AppColor.green,
                  inactiveTrackColor: AppColor.white,
                ),
              ],
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildCardsGrid() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          childAspectRatio: 2.1,
        ),
        itemCount: 4,
        itemBuilder: (context, index) => _buildGridItem(index),
      ),
    );
  }

  Widget _buildGridItem(int index) {
    if (widget.isAdmin) {
      switch (index) {
        case 0:
          return _buildStreamCard(
            stream: _workersCountStream,
            title: AppLocalizations.of(context)!.totalworkers,
            color: AppColor.yellow,
            icon: "assets/icons/worker.svg",
          );
        case 1:
          return _buildStreamCard(
            stream: _productsStream,
            title: AppLocalizations.of(context)!.productslisted,
            color: AppColor.purple,
            icon: "assets/icons/power_drill.svg",
          );
        case 2:
          return _buildStreamCard(
            stream: _scheduledBookingsStream,
            title: AppLocalizations.of(context)!.scheduled,
            color: AppColor.pink,
            icon: "assets/icons/calendar_clock.svg",
          );
        case 3:
          return _buildStreamCard(
            stream: _urgentBookingsStream,
            title: AppLocalizations.of(context)!.urgent,
            color: AppColor.skyBlue,
            icon: "assets/icons/urgent.svg",
          );
        default:
          return const SizedBox.shrink();
      }
    } else {
      switch (index) {
        case 0:
          return _buildStreamCard(
            stream: _workersCountStream,
            title: AppLocalizations.of(context)!.totaljobs,
            color: AppColor.yellow,
            icon: "assets/icons/worker.svg",
          );
        case 1:
          return _buildStreamCard(
            stream: _productsStream,
            title: AppLocalizations.of(context)!.earnings,
            color: AppColor.green,
            icon: "assets/icons/earnings.svg",
            formatter: (dynamic value) =>
                "${AppLocalizations.of(context)!.sar} ${(value as num).toStringAsFixed(2)}",
          );
        case 2:
          return _buildStreamCard(
            stream: _urgentBookingsStream,
            title: AppLocalizations.of(context)!.urgent,
            color: AppColor.skyBlue,
            icon: "assets/icons/urgent.svg",
          );
        case 3:
          return _buildStreamCard(
            stream: _scheduledBookingsStream,
            title: AppLocalizations.of(context)!.scheduled,
            color: AppColor.pink,
            icon: "assets/icons/calendar_clock.svg",
          );
        default:
          return const SizedBox.shrink();
      }
    }
  }

  Widget _buildStreamCard<T>({
    required Stream<T>? stream,
    required String title,
    required Color color,
    required String icon,
    String Function(T)? formatter,
  }) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        String count;
        if (snapshot.hasData) {
          count = formatter != null
              ? formatter(snapshot.data as T)
              : snapshot.data.toString();
        } else {
          count = title == AppLocalizations.of(context)!.earnings
              ? "${AppLocalizations.of(context)!.sar} 0"
              : "0";
        }

        return _buildGridCard(
          title: title,
          count: count,
          color: color,
          icon: icon,
        );
      },
    );
  }

  Widget _buildGridCard({
    required String title,
    required String count,
    required Color color,
    required String icon,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColor.lightGrey200),
      ),
      elevation: 0,
      color: AppColor.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: AppColor.lightGrey200),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            padding: const EdgeInsets.all(10),
            child: loadsvg(icon),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              HandyLabel(
                text: title,
                isBold: false,
                fontSize: 14,
                textcolor: AppColor.greyDark,
              ),
              HandyLabel(
                text: count,
                isBold: true,
                fontSize: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: HandymanButton(
            text: AppLocalizations.of(context)!.advertisements,
            onPressed: _showAdTypeAlertDialog,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: HandyLabel(
            text: AppLocalizations.of(context)!.topworkers,
            fontSize: 18,
            isBold: true,
          ),
        ),
        const SizedBox(height: 16),
        _buildTopWorkersSection(),
      ],
    );
  }

  Widget _buildTopWorkersSection() {
    if (_isLoadingTopWorkers) {
      return Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0), child: HandymanLoader()),
      );
    }

    if (_topWorkers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('No top workers data available'),
        ),
      );
    }

    return Column(
      children: _topWorkers.map((worker) => _buildWorkerCard(worker)).toList(),
    );
  }

  Widget _buildWorkerCard(Map<String, dynamic> workerData) {
    log(workerData.toString());
    final worker = workerData['worker'] as UserData;
    final completedJobsCount = workerData['completedJobsCount'] as int;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColor.lightGrey200),
        ),
        elevation: 0,
        color: AppColor.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HandyLabel(
                      text: worker.name ?? '',
                      isBold: true,
                      fontSize: 16,
                    ),
                    HandyLabel(
                      text: worker.service ?? '',
                      isBold: false,
                      fontSize: 16,
                      textcolor: AppColor.lightGrey700,
                    ),
                  ],
                ),
              ),
              Text(
                "$completedJobsCount ${AppLocalizations.of(context)!.jobs}",
                style: TextStyle(color: AppColor.lightGrey700),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAdTypeAlertDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HandyLabel(
                    text: AppLocalizations.of(context)!.selectadtype,
                    isBold: true,
                    fontSize: 16,
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(2.5),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              _buildAdOption(
                  AppLocalizations.of(context)!.home, Icons.home, true),
              const Divider(thickness: 1),
              _buildAdOption(AppLocalizations.of(context)!.products,
                  Icons.shopping_bag, false),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdOption(String name, IconData icon, bool isHomeBanner) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        _navigateToAdPage(isHomeBanner);
      },
      child: SizedBox(
        height: 65,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColor.black,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: HandyLabel(
                    text: name,
                    isBold: false,
                    fontSize: 16,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColor.lightGrey700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
