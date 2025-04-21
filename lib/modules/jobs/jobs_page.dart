import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/snakbar.dart';
import 'package:handyman_bbk_panel/modules/workers/bloc/workers_bloc.dart';
import 'package:handyman_bbk_panel/modules/workers/widgets/jobcard.dart';
import 'package:handyman_bbk_panel/models/booking_data.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class JobsPage extends StatefulWidget {
  final bool isAdmin;
  const JobsPage({super.key, required this.isAdmin});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkersBloc, WorkersState>(
      listener: (context, state) {
        if (state is RejectWorkSuccess) {
          HandySnackBar.show(
              context: context, message: "Rejected", isTrue: false);
          return;
        }
        if (state is RejectWorkFailure) {
          HandySnackBar.show(
              context: context, message: state.error, isTrue: false);
          return;
        }
        if (state is AcceptWorkSuccess) {
          HandySnackBar.show(
              context: context, message: "Accepted", isTrue: true);
          return;
        }
        if (state is AcceptWorkFailure) {
          HandySnackBar.show(
              context: context, message: state.error, isTrue: false);
          return;
        }
      },
      child: Scaffold(
        appBar: handyAppBar(
          widget.isAdmin ? "Admin Jobs Assign" : "Jobs",
          context,
          isCenter: true,
          isneedtopop: false,
        ),
        body: _buildBody(),
      ),
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
        children: [
          _pendingTabContent(),
          _scheduledTabContent(),
          _urgentTabContent(),
        ],
      ),
    );
  }

  Widget _urgentTabContent() {
    return StreamBuilder<List<BookingModel>>(
      stream: AppServices.getBookingsStream(
        isUrgent: true,
        status: null,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 48, color: AppColor.greyDark),
                const SizedBox(height: 16),
                const Text(
                  'No urgent jobs available',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        final urgentJobs = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            itemCount: urgentJobs.length,
            itemBuilder: (context, index) {
              final job = urgentJobs[index];
              return JobCard(
                bookingData: job,
                isAdmin: widget.isAdmin,
              );
            },
          ),
        );
      },
    );
  }

  Widget _pendingTabContent() {
    return StreamBuilder<List<BookingModel>>(
      stream: widget.isAdmin
          ? AppServices.getBookingsStream(
              isUrgent: false,
              status: "P",
            )
          : AppServices.getBookingsByWorkerId(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 48, color: AppColor.greyDark),
                const SizedBox(height: 16),
                const Text(
                  'No pending jobs available',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        final scheduledJobs = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            itemCount: scheduledJobs.length,
            itemBuilder: (context, index) {
              final job = scheduledJobs[index];
              return JobCard(
                bookingData: job,
                isAdmin: widget.isAdmin,
              );
            },
          ),
        );
      },
    );
  }

  Widget _scheduledTabContent() {
    return StreamBuilder<List<BookingModel>>(
      stream: AppServices.getBookingsStream(isUrgent: false, status: "S",secondStatus: "W"),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.engineering, size: 48, color: AppColor.greyDark),
                const SizedBox(height: 16),
                const Text(
                  'No scheduled jobs available',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }
        final scheduledWork = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            itemCount: scheduledWork.length,
            itemBuilder: (context, index) {
              final job = scheduledWork[index];
              return JobCard(
                bookingData: job,
                isAdmin: widget.isAdmin,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTabSelector() {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: widget.isAdmin ? AppColor.blue : AppColor.green,
        labelPadding: EdgeInsets.zero,
        tabs: [
          _customTab("Pending", 0),
          _customTab("Scheduled", 1),
          _customTab("Urgent", 2),
        ],
      ),
    );
  }

  Widget _customTab(String text, int index) {
    bool isSelected = _tabController.index == index;
    return Tab(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? (widget.isAdmin
                  ? AppColor.blue.withOpacity(0.1)
                  : AppColor.green.withOpacity(0.1))
              : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected
                ? (widget.isAdmin ? AppColor.blue : AppColor.green)
                : AppColor.lightGrey400,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
