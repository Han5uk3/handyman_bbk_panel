import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/models/booking_data.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/modules/jobs/job_details_page.dart';
import 'package:handyman_bbk_panel/modules/workers/bloc/workers_bloc.dart';
import 'package:handyman_bbk_panel/modules/workers/track_worker.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';
import 'package:handyman_bbk_panel/sheets/workers_list_sheet.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:intl/intl.dart';

class JobCard extends StatefulWidget {
  final BookingModel bookingData;
  final bool isAdmin;
  final bool? isHistoryPage;

  const JobCard({
    super.key,
    required this.bookingData,
    this.isAdmin = false,
    this.isHistoryPage = false,
  });

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  UserData? userData;
  bool isLoading = true;
  Stream<UserData?>? _userStream;

  @override
  void initState() {
    _setupUserDataStream();
    super.initState();
  }

  void _setupUserDataStream() {
    if (widget.bookingData.uid != null && widget.bookingData.uid!.isNotEmpty) {
      _userStream = AppServices.getUserStream(widget.bookingData.uid!);
      AppServices.getUserById(widget.bookingData.uid!).then((user) {
        if (mounted) {
          setState(() {
            userData = user;
            isLoading = false;
          });
        }
      }).catchError((_) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool get _shouldDisplay {
    if (widget.bookingData.isUrgent == true) {
      return true;
    } else if (widget.bookingData.status == "S") {
      return true;
    } else if (widget.bookingData.status == "W") {
      return true;
    } else if (widget.bookingData.status == "C") {
      return true;
    } else {
      return widget.bookingData.status == "P";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldDisplay) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<UserData?>(
      stream: _userStream,
      initialData: userData,
      builder: (context, snapshot) {
        final UserData? streamUserData = snapshot.data;

        if (streamUserData != null && streamUserData != userData) {
          userData = streamUserData;
        }

        return GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobDetailsPage(
                  isWorkerHistory: widget.isHistoryPage ?? false,
                  bookingModel: widget.bookingData,
                  userData: streamUserData!,
                ),
              )),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColor.lightGrey400),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  _buildBody(),
                  const Divider(thickness: 1),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.lightGrey200,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Text(
                widget.bookingData.status == "W"
                    ? "Work in progress"
                    : (widget.bookingData.isUrgent ?? false)
                        ? "Urgent"
                        : "Scheduled",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColor.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (!widget.isAdmin) ...[
              if (!(widget.bookingData.isWorkerAccept ?? false)) ...[
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: () => context.read<WorkersBloc>().add(
                          AcceptWorkEvent(
                            projectId: widget.bookingData.id ?? '',
                          ),
                        ),
                    style: const ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(60, 34)),
                      maximumSize: WidgetStatePropertyAll(Size(60, 34)),
                      backgroundColor: WidgetStatePropertyAll(AppColor.green),
                    ),
                    child: Text(
                      "Accept",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: () => context.read<WorkersBloc>().add(
                          RejectWorkEvent(
                            projectId: widget.bookingData.id ?? '',
                          ),
                        ),
                    style: const ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(60, 34)),
                      maximumSize: WidgetStatePropertyAll(Size(60, 34)),
                      backgroundColor: WidgetStatePropertyAll(AppColor.red),
                    ),
                    child: const Text(
                      "Reject",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ]
            ] else if (widget.bookingData.status == "W" &&
                (widget.bookingData.isWorkerAccept ?? false)) ...[
              Expanded(
                flex: 3,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackWorkerScreen(
                              bookingId: widget.bookingData.id ?? ''),
                        ));
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColor.yellow),
                  ),
                  child: const Text(
                    "Track",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ] else ...[
              if (widget.isAdmin && widget.bookingData.isUrgent != true)
                Expanded(
                  flex: 3,
                  child: TextButton(
                    onPressed: widget.bookingData.workerData == null
                        ? () {
                            _showWorkerAssignmentBottomSheet(context,
                                widget.bookingData.id ?? '', userData!);
                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          widget.bookingData.workerData == null
                              ? AppColor.blue
                              : (widget.bookingData.isWorkerAccept ?? false)
                                  ? AppColor.lightSplashBlue
                                  : AppColor.greyDark),
                    ),
                    child: Text(
                      widget.bookingData.workerData == null
                          ? "Assign"
                          : (widget.bookingData.isWorkerAccept ?? false)
                              ? "Accepted"
                              : "Waiting...",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
            (widget.bookingData.status == "C" &&
                    (widget.isHistoryPage ?? false))
                ? buildStatus(widget.bookingData.status ?? "")
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (userData != null) ...[
            Row(
              children: [
                const Expanded(
                  child: HandyLabel(
                    text: "Customer Name:",
                    fontSize: 14,
                  ),
                ),
                HandyLabel(
                  text: userData?.name ?? 'N/A',
                  fontSize: 14,
                )
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: HandyLabel(
                    text: "Phone:",
                    fontSize: 14,
                  ),
                ),
                HandyLabel(
                  text: userData?.phoneNumber ?? 'N/A',
                  fontSize: 14,
                )
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: HandyLabel(
                    text: "Email:",
                    fontSize: 14,
                  ),
                ),
                HandyLabel(
                  text: userData?.email ?? 'N/A',
                  fontSize: 14,
                )
              ],
            ),
          ] else
            const HandyLabel(
              text: "No user data available",
              fontSize: 14,
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(
                child: HandyLabel(
                  text: "Address:",
                  fontSize: 14,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  widget.bookingData.location?.address ?? 'N/A',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppColor.black,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          const HandyLabel(
            text: "Issue Details",
            fontSize: 14,
            isBold: true,
          ),
          const SizedBox(height: 5),
          if (widget.bookingData.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                widget.bookingData.imageUrl!,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 90,
                    height: 90,
                    color: AppColor.lightGrey200,
                    child: const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 90,
                    height: 90,
                    color: AppColor.lightGrey200,
                    child: const Icon(Icons.error_outline),
                  );
                },
              ),
            ),
          const SizedBox(height: 5),
          Text(
            widget.bookingData.issue ?? 'No description',
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
            ),
            const SizedBox(width: 4),
            HandyLabel(
              text: getformattedDate(widget.bookingData.date),
              fontSize: 14,
              isBold: true,
            ),
          ]),
          Container(
            width: 1,
            height: 40,
            color: AppColor.greyDark,
          ),
          Row(children: [
            const Icon(
              Icons.access_time,
              size: 18,
            ),
            const SizedBox(width: 4),
            HandyLabel(
              text: widget.bookingData.time ?? 'N/A',
              fontSize: 14,
              isBold: true,
            ),
          ]),
          Container(
            width: 1,
            height: 40,
            color: AppColor.greyDark,
          ),
          Row(children: [
            const Icon(
              Icons.attach_money,
              size: 18,
            ),
            const SizedBox(width: 4),
            HandyLabel(
              text: "\$ ${widget.bookingData.totalFee ?? 'N/A'}",
              fontSize: 14,
              isBold: true,
            ),
          ])
        ],
      ),
    );
  }

  void _showWorkerAssignmentBottomSheet(
      BuildContext context, String projectId, UserData workerData) {
    showModalBottomSheet<void>(
        context: context,
        isDismissible: false,
        backgroundColor: AppColor.white,
        isScrollControlled: true,
        builder: (context) {
          return WorkersListSheet(
            projectId: projectId,
          );
        });
  }

  Widget buildStatus(
    String status,
  ) {
    return Row(
      spacing: 3,
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: status == "C" ? AppColor.green : AppColor.red,
        ),
        HandyLabel(
          textcolor: status == "C" ? AppColor.green : AppColor.red,
          text: status == "C"
              ? "Completed on ${getformattedDate(widget.bookingData.completedDateTime)}"
              : "Cancelled",
          fontSize: 14,
        )
      ],
    );
  }
}

String getformattedDate(DateTime? date) {
  if (date == null) return 'N/A';
  DateFormat dateFormat = DateFormat("dd MMM");
  return dateFormat.format(date);
}
