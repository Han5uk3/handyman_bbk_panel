import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/outline_button.dart';
import 'package:handyman_bbk_panel/common_widget/snakbar.dart';
import 'package:handyman_bbk_panel/helpers/collections.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/modules/workers/bloc/workers_bloc.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class WorkersListSheet extends StatefulWidget {
  final String projectId;
  final bool isUrgentRequest;
  const WorkersListSheet({
    super.key,
    required this.projectId,
    this.isUrgentRequest = false,
  });

  @override
  State<WorkersListSheet> createState() => _WorkersListSheetState();
}

class _WorkersListSheetState extends State<WorkersListSheet> {
  List<UserData> allWorkers = [];
  List<UserData> filteredWorkers = [];
  int? selectedWorkerIndex;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWorkers();
  }

  void _fetchWorkers() {
    FirebaseCollections.users.snapshots().listen((snapshot) {
      final workers = snapshot.docs
          .map((doc) => UserData.fromMap(doc.data() as Map<String, dynamic>))
          .where((user) => user.userType == "Worker")
          .toList();
      setState(() {
        allWorkers = workers;
        filteredWorkers = workers;
      });
    });
  }

  void _searchWorker(String query) {
    final searchResults = allWorkers.where((worker) {
      final name = worker.name?.toLowerCase() ?? '';
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredWorkers = searchResults;
    });
  }

  void _assignWorker(BuildContext context) {
    if (selectedWorkerIndex == null) {
      HandySnackBar.show(
        context: context,
        message: "Please select a worker.",
        isTrue: false,
      );
      return;
    }

    final selectedWorker = filteredWorkers[selectedWorkerIndex!];

    context.read<WorkersBloc>().add(
          AssignWorkerToAProjectEvent(
              projectId: widget.projectId,
              workerData: selectedWorker,
              isUrgentRequest: widget.isUrgentRequest),
        );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<WorkersBloc, WorkersState>(
      listener: (context, state) {
        if (state is AssignWorkerToAProjectSuccess) {
          Navigator.pop(context);
          HandySnackBar.show(
            context: context,
            message: "Worker Assigned Successfully",
            isTrue: true,
          );
        } else if (state is AssignWorkerToAProjectFailure) {
          Navigator.pop(context);
          HandySnackBar.show(
            context: context,
            message: state.error,
            isTrue: false,
          );
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: screenHeight * 0.65,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    _buildTitle("Search Worker"),
                    const SizedBox(height: 8),
                    const Divider(thickness: 1),
                    _buildSearchBar(),
                    const SizedBox(height: 15),
                    _buildTitle("Choose Worker", color: AppColor.green),
                    const SizedBox(height: 10),
                    _buildWorkersList(),
                    const SizedBox(height: 10),
                    _buildActionButtons(state is AssignWorkerToAProjectLoading),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: HandyLabel(
        text: text,
        isBold: true,
        fontSize: 16,
        textcolor: color,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 10),
      child: SearchBar(
        controller: searchController,
        onChanged: _searchWorker,
        elevation: const WidgetStatePropertyAll(0),
        constraints: const BoxConstraints(
          maxHeight: 40,
          minHeight: 40,
          maxWidth: double.infinity,
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        hintText: "Search Worker",
        hintStyle: const WidgetStatePropertyAll(
          TextStyle(color: AppColor.greyDark),
        ),
        leading: const Icon(Icons.search, color: AppColor.greyDark),
        backgroundColor: WidgetStatePropertyAll(AppColor.lightGrey200),
      ),
    );
  }

  Widget _buildWorkersList() {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: filteredWorkers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: HandyLabel(text: filteredWorkers[index].name ?? ""),
            trailing: Radio<int>(
              value: index,
              groupValue: selectedWorkerIndex,
              onChanged: (value) {
                setState(() {
                  selectedWorkerIndex = value;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: HandymanOutlineButton(
              text: "Cancel",
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: HandymanButton(
              text: "Assign",
              isLoading: isLoading,
              onPressed: () => _assignWorker(context),
            ),
          ),
        ],
      ),
    );
  }
}
