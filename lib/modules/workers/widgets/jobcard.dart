import 'dart:developer';

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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  UserData? workerData;
  bool isLoading = true;
  Stream<UserData?>? _userStream;

  @override
  void initState() {
    _setupUserDataStream();
    _setupWorkerDataStream();
    super.initState();
  }

  void _setupUserDataStream() {
    if (widget.bookingData.uid != null && widget.bookingData.uid!.isNotEmpty) {
      _userStream = AppServices.getUserStream(widget.bookingData.uid!);
      AppServices.getUserById(uid: widget.bookingData.uid!).then((user) {
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

  void _setupWorkerDataStream() {
    AppServices.getUserById(uid: AppServices.uid ?? "", isWorkerData: true)
        .then((user) {
      if (mounted) {
        setState(() {
          workerData = user;
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
    } else if (widget.bookingData.status == "A") {
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
      builder: (context, snapshot) {
        log(snapshot.data.toString());
        final UserData? streamUserData = snapshot.data;

        if (streamUserData != null && streamUserData != userData) {
          userData = streamUserData;
        }

        return GestureDetector(
          onTap: (widget.bookingData.status != "A" &&
                  widget.bookingData.status != "W")
              ? () {}
              : () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailsPage(
                          isWorkerHistory: widget.isHistoryPage ?? false,
                          bookingModel: widget.bookingData,
                          userData: userData!,
                        ),
                      ));
                },
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
                    ? AppLocalizations.of(context)!.workinprogress
                    : (widget.bookingData.isUrgent ?? false)
                        ? AppLocalizations.of(context)!.urgent
                        : AppLocalizations.of(context)!.scheduled,
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
                            workerData: workerData ?? UserData(),
                            projectId: widget.bookingData.id ?? '',
                          ),
                        ),
                    style: const ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(60, 34)),
                      maximumSize: WidgetStatePropertyAll(Size(60, 34)),
                      backgroundColor: WidgetStatePropertyAll(AppColor.green),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.accept,
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
                    child: Text(
                      AppLocalizations.of(context)!.reject,
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
                  child: Text(
                    AppLocalizations.of(context)!.track,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ] else ...[
              if (widget.isAdmin ||
                  widget.bookingData.isUrgent == true &&
                      widget.bookingData.status == "no_workers")
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
                          ? AppLocalizations.of(context)!.assign
                          : (widget.bookingData.isWorkerAccept ?? false)
                              ? AppLocalizations.of(context)!.accepted
                              : AppLocalizations.of(context)!.waiting,
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
                Expanded(
                  child: HandyLabel(
                    text: "${AppLocalizations.of(context)!.customername}:",
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
                Expanded(
                  child: HandyLabel(
                    text: "${AppLocalizations.of(context)!.phone}:",
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
                Expanded(
                  child: HandyLabel(
                    text: "${AppLocalizations.of(context)!.email}:",
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
            HandyLabel(
              text: AppLocalizations.of(context)!.nouserdataavailable,
              fontSize: 14,
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: HandyLabel(
                  text: "${AppLocalizations.of(context)!.address}:",
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
          HandyLabel(
            text: AppLocalizations.of(context)!.issueDetails,
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
            widget.bookingData.issue ??
                AppLocalizations.of(context)!.nodescriptionprovided,
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
              text:
                  "${AppLocalizations.of(context)!.sar} ${widget.bookingData.totalFee ?? 'N/A'}",
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
            isUrgentRequest: widget.bookingData.status == "no_workers",
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
              ? "${AppLocalizations.of(context)!.completedon} ${getformattedDate(widget.bookingData.completedDateTime)}"
              : AppLocalizations.of(context)!.cancelled,
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
