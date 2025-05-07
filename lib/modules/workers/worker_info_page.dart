import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/loader.dart';
import 'package:handyman_bbk_panel/common_widget/snakbar.dart';
import 'package:handyman_bbk_panel/models/review_model.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/modules/workers/bloc/workers_bloc.dart';
import 'package:handyman_bbk_panel/modules/workers/worker_rating_page.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkerInfoPage extends StatefulWidget {
  final UserData workerData;
  const WorkerInfoPage({super.key, required this.workerData});

  @override
  State<WorkerInfoPage> createState() => _WorkerInfoPageState();
}

class _WorkerInfoPageState extends State<WorkerInfoPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkersBloc, WorkersState>(
      listener: (context, state) {
        if (state is WorkersVerificationSuccess) {
          setState(() {
            isLoading = false;
          });
          HandySnackBar.show(
              context: context,
              message: AppLocalizations.of(context)!.verifiedsuccessfully,
              isTrue: true);
          Navigator.pop(context);
          return;
        }
        if (state is WorkersVerificationFailure) {
          setState(() {
            isLoading = false;
          });
          HandySnackBar.show(
              context: context, message: state.error, isTrue: false);
          return;
        }
        if (state is DeactivateWorkerSuccess) {
          setState(() {
            isLoading = false;
          });
          HandySnackBar.show(
              context: context,
              message: AppLocalizations.of(context)!.deactivatedsuccessfully,
              isTrue: true);
          Navigator.pop(context);
          return;
        }
        if (state is DeactivateWorkerFailure) {
          setState(() {
            isLoading = false;
          });
          HandySnackBar.show(
              context: context, message: state.error, isTrue: false);
          return;
        }
      },
      builder: (context, state) {
        if (state is WorkersVerificationLoading) {
          isLoading = true;
        } else {
          isLoading = false;
        }
        if (state is DeactivateWorkerLoading) {
          isLoading = true;
        } else {
          isLoading = false;
        }
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 28),
            child: HandymanButton(
              isLoading: isLoading,
              text: !(widget.workerData.isVerified ?? false)
                  ? AppLocalizations.of(context)!.verifyid
                  : AppLocalizations.of(context)!.deactivateworker,
              onPressed: !(widget.workerData.isVerified ?? false)
                  ? () => context.read<WorkersBloc>().add(
                      VerifyWorkerEvent(workerId: widget.workerData.uid ?? ""))
                  : () => context.read<WorkersBloc>().add(DeactivateWorkerEvent(
                      workerId: widget.workerData.uid ?? "")),
              color: !(widget.workerData.isVerified ?? false)
                  ? AppColor.black
                  : AppColor.red,
            ),
          ),
          appBar: handyAppBar(
              widget.workerData.name ??
                  AppLocalizations.of(context)!.workerDetails,
              context,
              isneedtopop: true,
              isCenter: true,
              iswhite: true),
          body: _buildBody(context),
        );
      },
    );
  }

  Widget _buildBody(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildWorkerCard(),
          !(widget.workerData.isVerified ?? false)
              ? _buildNewInfoSection(context)
              : _buildActiveInfoSection(context),
        ],
      ),
    );
  }

  Widget _buildWorkerCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColor.skyBlue,
            ),
            child: widget.workerData.profilePic != null &&
                    widget.workerData.profilePic!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      imageUrl: widget.workerData.profilePic!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const HandymanLoader(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.person),
                    ),
                  )
                : const Icon(Icons.person, size: 40),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HandyLabel(
                  text: AppLocalizations.of(context)!.worker,
                  isBold: false,
                  fontSize: 16,
                ),
                const SizedBox(height: 10),
                HandyLabel(
                  text: widget.workerData.name ??
                      AppLocalizations.of(context)!.unknown,
                  isBold: true,
                  fontSize: 18,
                ),
              ],
            ),
          ),
          IconButton(
            constraints: const BoxConstraints(
                minHeight: 60, maxHeight: 60, maxWidth: 60, minWidth: 60),
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
              AppColor.lightGreen,
            )),
            onPressed: () {},
            icon: Icon(
              size: 32.5,
              Icons.phone,
              color: AppColor.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewInfoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _detailRow(
              AppLocalizations.of(context)!.gender,
              _getLocalizedtext(widget.workerData.gender) ??
                  AppLocalizations.of(context)!.notSpecified),
          const SizedBox(height: 8),
          _detailRow(
              AppLocalizations.of(context)!.servicetype,
              _getLocalizedtext(widget.workerData.service) ??
                  AppLocalizations.of(context)!.notSpecified),
          const SizedBox(height: 8),
          _detailRow(
              AppLocalizations.of(context)!.yearsofexperience,
              _getLocalizedtext(widget.workerData.experience) ??
                  AppLocalizations.of(context)!.notSpecified),
          const SizedBox(height: 8),
          _detailRow(
              AppLocalizations.of(context)!.email,
              widget.workerData.email ??
                  AppLocalizations.of(context)!.notSpecified),
          const SizedBox(height: 8),
          _detailRow(
              AppLocalizations.of(context)!.address,
              widget.workerData.address ??
                  AppLocalizations.of(context)!.notSpecified),
          const SizedBox(height: 8),
          _detailRow(AppLocalizations.of(context)!.idproof, ""),
          const SizedBox(height: 13),
          if (widget.workerData.idProof != null &&
              widget.workerData.idProof!.isNotEmpty)
            GestureDetector(
              onTap: () =>
                  _showEnlargedImage(context, widget.workerData.idProof!),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: Container(
                  color: AppColor.shammaam,
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.48,
                  child: CachedNetworkImage(
                    imageUrl: widget.workerData.idProof!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const HandymanLoader(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            )
          else
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.48,
              decoration: BoxDecoration(
                color: AppColor.lightGrey200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(AppLocalizations.of(context)!.noidproofavailable),
              ),
            ),

          // _detailRow("Registered On", workerData. ?? "Not available"),
        ],
      ),
    );
  }

  void _showEnlargedImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        const Center(child: HandymanLoader()),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error, size: 50, color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String title, String? content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: HandyLabel(
            text: title,
            isBold: false,
            fontSize: 14,
          ),
        ),
        HandyLabel(
          textcolor: AppColor.lightGrey500,
          text: content ?? AppLocalizations.of(context)!.notavailable,
          isBold: false,
          fontSize: 14,
        ),
      ],
    );
  }

  Widget _buildActiveInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(thickness: 1),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WorkerRatingPage(workerId: widget.workerData.uid ?? ''),
                ),
              );
            },
            child: StreamBuilder<List<ReviewModel>>(
              stream: AppServices.getWorkerReviews(widget.workerData.uid ?? ''),
              builder: (context, snapshot) {
                double averageRating = 0.0;
                int reviewCount = 0;

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final reviews = snapshot.data!;
                  reviewCount = reviews.length;
                  double totalRating = 0.0;
                  for (var review in reviews) {
                    totalRating += review.rating;
                  }
                  averageRating = totalRating / reviewCount;
                }

                return Row(
                  children: [
                    HandyLabel(
                      text: averageRating.toStringAsFixed(1),
                      isBold: true,
                      fontSize: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RatingBar.builder(
                        initialRating: averageRating,
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
                      text:
                          "$reviewCount ${AppLocalizations.of(context)!.reviews}",
                      isBold: false,
                      fontSize: 16,
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // _detailRow("Total Jobs", workerData.totalJobs?.toString() ?? "0"),
          const SizedBox(height: 16),
          // _detailRow("Jobs In Queue", workerData.queuedJobs?.toString() ?? "0"),
          const SizedBox(height: 16),
          // _detailRow("Joined On", workerData.registeredDate ?? "Not available"),
          const SizedBox(height: 20),
          if (widget.workerData.idProof != null &&
              widget.workerData.idProof!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HandyLabel(
                  text: AppLocalizations.of(context)!.idproof,
                  isBold: true,
                  fontSize: 16,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () =>
                      _showEnlargedImage(context, widget.workerData.idProof!),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: Container(
                      color: AppColor.shammaam,
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.48,
                      child: CachedNetworkImage(
                        imageUrl: widget.workerData.idProof!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const HandymanLoader(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  _getLocalizedtext(String? text) {
    if (text == "Male") {
      return AppLocalizations.of(context)!.male;
    } else if (text == "Less than 1 year") {
      return AppLocalizations.of(context)!.lessthan1year;
    } else if (text == "1-3 year") {
      return AppLocalizations.of(context)!.year1to3;
    } else if (text == "3-5 years") {
      return AppLocalizations.of(context)!.year3to5;
    } else if (text == "5+ years") {
      return AppLocalizations.of(context)!.year5plus;
    } else if (text == "Female") {
      return AppLocalizations.of(context)!.female;
    } else if (text == "Other") {
      return AppLocalizations.of(context)!.other;
    } else if (text == "Electricity") {
      return AppLocalizations.of(context)!.electricity;
    } else if (text == "Plumbing") {
      return AppLocalizations.of(context)!.plumbing;
    }
  }
}
