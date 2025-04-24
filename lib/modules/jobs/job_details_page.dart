import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/jobsummarycard.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/loader.dart';
import 'package:handyman_bbk_panel/common_widget/rating_display.dart';
import 'package:handyman_bbk_panel/common_widget/snakbar.dart';
import 'package:handyman_bbk_panel/helpers/collections.dart';
import 'package:handyman_bbk_panel/models/booking_data.dart';
import 'package:handyman_bbk_panel/models/review_model.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/modules/workers/bloc/workers_bloc.dart';
import 'package:handyman_bbk_panel/sheets/job_complete_sheet.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class JobDetailsPage extends StatefulWidget {
  final BookingModel bookingModel;
  final UserData userData;
  final bool isWorkerHistory;
  const JobDetailsPage({
    super.key,
    required this.bookingModel,
    required this.userData,
    required this.isWorkerHistory,
  });

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isAudioInitialized = false;
  String? _cachedFilePath;
  bool _isjobStartLoading = false;
  ReviewModel? reviewModel;
  Stream<PositionData>? _positionDataStream;

  @override
  void initState() {
    _initAudioPlayer();
    if (widget.isWorkerHistory) {
      _fetchReviewData();
    }
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _fetchReviewData() async {
    if (widget.bookingModel.id == null) return;
    try {
      final QuerySnapshot reviewSnapshot = await FirebaseCollections.reviews
          .where('bookingId', isEqualTo: widget.bookingModel.id)
          .limit(1)
          .get();
      if (reviewSnapshot.docs.isNotEmpty) {
        final doc = reviewSnapshot.docs.first;
        reviewModel = ReviewModel.fromDocument(
            doc.data() as Map<String, dynamic>, doc.id);
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error fetching review data: $e');
    }
  }

  Future<void> _initAudioPlayer() async {
    _positionDataStream =
        Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      _audioPlayer.positionStream,
      _audioPlayer.bufferedPositionStream,
      _audioPlayer.durationStream,
      (position, bufferedPosition, duration) => PositionData(
        position: position,
        bufferedPosition: bufferedPosition,
        duration: duration ?? Duration.zero,
      ),
    );

    _audioPlayer.playerStateStream.listen((playerState) {
      if (mounted) {
        setState(() {
          _isPlaying = playerState.playing;
          if (playerState.processingState == ProcessingState.completed) {
            _position = _duration;
            _isPlaying = false;
          }
        });
      }
    });

    if (widget.bookingModel.audioUrl?.isNotEmpty == true) {
      _preloadAudio();
    }
  }

  String _getFileNameFromUrl(String url) {
    String fileName =
        url.split('/').last.replaceAll(RegExp(r'[^\w\s\-\.]'), '_');
    if (fileName.isEmpty || !fileName.contains('.')) {
      fileName =
          'audio_${widget.bookingModel.id ?? DateTime.now().millisecondsSinceEpoch}.mp3';
    }
    return fileName;
  }

  Future<String?> _checkCachedFile() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final fileName = _getFileNameFromUrl(widget.bookingModel.audioUrl!);
      final file = File('${cacheDir.path}/$fileName');
      if (await file.exists() && (await file.length()) > 0) {
        return file.path;
      }
    } catch (e) {
      debugPrint('Error checking cached file: $e');
    }
    return null;
  }

  Future<String?> _downloadToCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final fileName = _getFileNameFromUrl(widget.bookingModel.audioUrl!);
      final file = File('${cacheDir.path}/$fileName');

      final httpClient = HttpClient();
      final request =
          await httpClient.getUrl(Uri.parse(widget.bookingModel.audioUrl!));
      final response = await request.close();

      if (response.statusCode == 200) {
        final bytes = await consolidateHttpClientResponseBytes(response);
        await file.writeAsBytes(bytes);
        return file.path;
      } else {
        debugPrint(
            'Failed to download audio file: HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error downloading audio file: $e');
    }
    return null;
  }

  Future<Uint8List> consolidateHttpClientResponseBytes(
      HttpClientResponse response) async {
    final chunks = <List<int>>[];
    int contentLength = 0;
    await for (final chunk in response) {
      chunks.add(chunk);
      contentLength += chunk.length;
    }
    final bytes = Uint8List(contentLength);
    int offset = 0;
    for (final chunk in chunks) {
      bytes.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    return bytes;
  }

  Future<void> _preloadAudio() async {
    if (_isAudioInitialized) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      _cachedFilePath = await _checkCachedFile();

      _cachedFilePath ??= await _downloadToCache();

      if (_cachedFilePath != null) {
        await _audioPlayer.setAudioSource(AudioSource.file(_cachedFilePath!));
      } else if (widget.bookingModel.audioUrl?.isNotEmpty == true) {
        await _audioPlayer.setAudioSource(
            AudioSource.uri(Uri.parse(widget.bookingModel.audioUrl!)));
      } else {
        throw Exception('No valid audio source available');
      }

      _duration = _audioPlayer.duration ?? Duration.zero;

      setState(() {
        _isAudioInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });

      await _tryFallbackAudioLoading();
    }
  }

  Future<void> _tryFallbackAudioLoading() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
      if (widget.bookingModel.audioUrl == null ||
          widget.bookingModel.audioUrl!.isEmpty) {
        throw Exception('Audio URL is empty or null');
      }

      await _audioPlayer.setUrl(widget.bookingModel.audioUrl!, preload: true);

      _duration = _audioPlayer.duration ?? Duration.zero;

      setState(() {
        _isAudioInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load audio. Please try again.';
      });
    }
  }

  Future<void> _playPause() async {
    if (!_isAudioInitialized) {
      await _preloadAudio();
      if (_hasError) return;
    }

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        if (_position >= _duration && _duration > Duration.zero) {
          await _audioPlayer.seek(Duration.zero);
        }
        await _audioPlayer.play();
      }
    } catch (e) {
      await _resetPlayer();
    }
  }

  Future<void> _resetPlayer() async {
    setState(() {
      _hasError = true;
      _isAudioInitialized = false;
      _errorMessage = 'Playback error. Tap to retry.';
    });

    try {
      await _audioPlayer.stop();
    } catch (_) {}
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void showJobCompletionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: JobCompletionBottomSheet(
          bookingId: widget.bookingModel.id ?? "",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String bookedDate = getformattedDate(widget.bookingModel.date);
    String todayDate = getformattedDate(DateTime.now());
    bool isStartButtonLocked = bookedDate == todayDate ? false : true;
    bool isWorkStarted = widget.bookingModel.status == "W";

    return BlocConsumer<WorkersBloc, WorkersState>(
      listener: (context, state) {
        if (state is StartJobFailure) {
          setState(() {
            _isjobStartLoading = false;
          });
          HandySnackBar.show(
              context: context, message: state.error, isTrue: false);
          return;
        }
        if (state is StartJobSuccess) {
          setState(() {
            _isjobStartLoading = false;
          });
          HandySnackBar.show(
              context: context,
              message: "Job started successfully",
              isTrue: true);
          return;
        }
      },
      builder: (context, state) {
        if (state is StartJobLoading) {
          _isjobStartLoading = true;
        }
        return Scaffold(
          appBar: handyAppBar("", context,
              isCenter: true, isneedtopop: true, iswhite: true),
          body: _buildBody(),
          bottomNavigationBar: widget.bookingModel.status == "C"
              ? SizedBox.shrink()
              : ((widget.bookingModel.workerData?.isVerified ?? false) &&
                      widget.bookingModel.workerData?.userType == "Worker")
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(16, 5, 16, 28),
                      child: HandymanButton(
                        text: isWorkStarted
                            ? "Mark as Completed"
                            : "Start Job ($bookedDate)",
                        isLoading: _isjobStartLoading,
                        onPressed: isStartButtonLocked
                            ? () {
                                HandySnackBar.show(
                                    context: context,
                                    message: "Only start on the scheduled date",
                                    isTrue: false);
                              }
                            : isWorkStarted
                                ? () => showJobCompletionSheet(context)
                                : () => context.read<WorkersBloc>().add(
                                      StartJobEvent(
                                        bookingId: widget.bookingModel.id ?? "",
                                      ),
                                    ),
                        color: isStartButtonLocked
                            ? AppColor.greyDark
                            : AppColor.black,
                      ),
                    )
                  : const SizedBox(height: 20),
        );
      },
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isWorkerHistory
              ? Container(
                  height: 30,
                  color: AppColor.green,
                  child: Center(
                    child: HandyLabel(
                      text: "Completed on 24 Feb",
                      isBold: false,
                      fontSize: 14,
                      textcolor: AppColor.white,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Jobsummarycard(
            paymentStatus: true,
            isInWorkerHistory: widget.isWorkerHistory,
            date: getformattedDate(widget.bookingModel.date),
            jobType: widget.bookingModel.name ?? "",
            price: widget.bookingModel.totalFee ?? 0,
            time: widget.bookingModel.time ?? "",
            userLocation: widget.bookingModel.location?.address ?? "",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HandyLabel(text: "Issue Details", isBold: true, fontSize: 16),
                const SizedBox(height: 10),
                SizedBox(
                  child: Text(
                    widget.bookingModel.issue ?? "",
                    textAlign: TextAlign.justify,
                  ),
                ),
                widget.isWorkerHistory
                    ? const SizedBox.shrink()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildVoiceNote(),
                          const SizedBox(height: 20),
                          _buildIssueImage(),
                          const SizedBox(height: 20),
                        ],
                      ),
              ],
            ),
          ),
          widget.isWorkerHistory
              ? _buildBeforeAfterImageSection()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: AppColor.lightGrey100,
                      height: 15,
                    ),
                    _buildCustomerCard(),
                  ],
                ),
          Container(
            color: AppColor.lightGrey100,
            height: 15,
          ),
          widget.isWorkerHistory
              ? _buildReviewDisplaySection()
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildVoiceNote() {
    if (widget.bookingModel.audioUrl == null ||
        widget.bookingModel.audioUrl!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HandyLabel(text: "Voice Note", isBold: true, fontSize: 16),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColor.lightGrey100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              if (_isLoading && _cachedFilePath == null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.blue.shade300,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Loading audio for faster playback...',
                          style: TextStyle(
                              color: Colors.blue.shade700, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_hasError)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _hasError = false;
                      _isAudioInitialized = false;
                    });
                    _preloadAudio();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Unable to play audio. Tap to retry.',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh,
                              color: Colors.red, size: 18),
                          onPressed: () {
                            setState(() {
                              _hasError = false;
                              _isAudioInitialized = false;
                            });
                            _preloadAudio();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data ??
                      PositionData(
                        position: _position,
                        bufferedPosition: Duration.zero,
                        duration: _duration,
                      );

                  return Row(
                    children: [
                      InkWell(
                        onTap: _isLoading
                            ? null
                            : () {
                                HapticFeedback.mediumImpact();
                                _playPause();
                              },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isLoading
                                ? AppColor.lightGrey300
                                : AppColor.green.withOpacity(0.2),
                          ),
                          child: _isLoading
                              ? const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColor.green,
                                    ),
                                  ),
                                )
                              : Icon(
                                  _isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: AppColor.green,
                                  size: 32,
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                  pressedElevation: 8,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 14),
                                activeTrackColor: AppColor.green,
                                inactiveTrackColor: AppColor.lightGrey300,
                                thumbColor: AppColor.green,
                                overlayColor: AppColor.green.withOpacity(0.2),
                              ),
                              child: Slider(
                                min: 0,
                                max: positionData.duration.inMilliseconds
                                            .toDouble() >
                                        0
                                    ? positionData.duration.inMilliseconds
                                        .toDouble()
                                    : 1.0,
                                value: positionData.position.inMilliseconds
                                    .toDouble()
                                    .clamp(
                                      0,
                                      positionData.duration.inMilliseconds
                                                  .toDouble() >
                                              0
                                          ? positionData.duration.inMilliseconds
                                              .toDouble()
                                          : 1.0,
                                    ),
                                onChanged: (!_isLoading &&
                                        positionData.duration.inMilliseconds >
                                            0)
                                    ? (value) {
                                        _audioPlayer.seek(Duration(
                                            milliseconds: value.toInt()));
                                      }
                                    : null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatTime(positionData.position),
                                    style: TextStyle(
                                      color: AppColor.lightGrey600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    _formatTime(positionData.duration),
                                    style: TextStyle(
                                      color: AppColor.lightGrey600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIssueImage() {
    if (widget.bookingModel.imageUrl == null ||
        widget.bookingModel.imageUrl!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HandyLabel(text: "Issue Image", isBold: true, fontSize: 16),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  insetPadding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Stack(
                      children: [
                        Center(
                          child: InteractiveViewer(
                            panEnabled: true,
                            boundaryMargin: const EdgeInsets.all(20),
                            minScale: 0.5,
                            maxScale: 3.0,
                            child: CachedNetworkImage(
                              imageUrl: widget.bookingModel.imageUrl!,
                              fit: BoxFit.contain,
                              placeholder: (context, url) =>
                                  const HandymanLoader(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.black45,
                            radius: 20,
                            child: IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.lightGrey300, width: 1),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.bookingModel.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => const HandymanLoader(),
                    errorWidget: (context, url, error) => Container(
                      color: AppColor.lightGrey100,
                      child: const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.zoom_in,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 90,
      color: AppColor.white,
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: widget.userData.profilePic ?? "",
              height: 55,
              width: 55,
              fit: BoxFit.cover,
              placeholder: (context, url) => const HandymanLoader(),
              errorWidget: (context, url, error) => Container(
                height: 55,
                width: 55,
                color: AppColor.lightGrey100,
                child: const Icon(
                  Icons.person,
                  size: 30,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HandyLabel(
                  text: "Customer Name",
                  isBold: false,
                  fontSize: 14,
                ),
                HandyLabel(
                  text: widget.userData.name ?? "",
                  isBold: true,
                  fontSize: 16,
                )
              ],
            ),
          ),
          IconButton(
            constraints: const BoxConstraints(
              minHeight: 55,
              maxHeight: 55,
              maxWidth: 55,
              minWidth: 55,
            ),
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                AppColor.lightGreen,
              ),
            ),
            onPressed: () {
              final phoneNumber = widget.userData.phoneNumber;
              if (phoneNumber != null && phoneNumber.isNotEmpty) {}
            },
            icon: const Icon(
              size: 26,
              Icons.phone,
              color: AppColor.green,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBeforeAfterImageSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        spacing: 25,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              HandyLabel(text: "Before", isBold: true, fontSize: 16),
              const SizedBox(height: 10),
              CachedNetworkImage(
                height: 100,
                width: 150,
                placeholder: (context, url) => HandymanLoader(),
                errorWidget: (context, url, error) => Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(),
                  child: Center(
                    child: Icon(Icons.error),
                  ),
                ),
                fit: BoxFit.cover,
                imageUrl: widget.bookingModel.imageUrl ?? "",
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              HandyLabel(text: "After", isBold: true, fontSize: 16),
              const SizedBox(height: 10),
              CachedNetworkImage(
                height: 100,
                width: 150,
                placeholder: (context, url) => HandymanLoader(),
                errorWidget: (context, url, error) => Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(),
                  child: Center(
                    child: Icon(Icons.error),
                  ),
                ),
                fit: BoxFit.cover,
                imageUrl: widget.bookingModel.imageAfterWork ?? "",
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewDisplaySection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HandyLabel(text: "Rating by Customer", isBold: true, fontSize: 16),
          const SizedBox(height: 24),
          RatingDisplay(
              rating: reviewModel?.rating ?? 0.0,
              reviewCount: 0,
              isInHistory: true),
          SizedBox(height: 12),
          HandyLabel(
            text: reviewModel?.review ?? "",
            isBold: false,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData({
    required this.position,
    required this.bufferedPosition,
    required this.duration,
  });
}

String getformattedDate(DateTime? date) {
  if (date == null) return 'N/A';
  DateFormat dateFormat = DateFormat("dd MMM");
  return dateFormat.format(date);
}
