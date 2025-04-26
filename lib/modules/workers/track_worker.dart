import 'dart:async';
import 'dart:math' as Math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/loader.dart';
import 'package:handyman_bbk_panel/helpers/collections.dart';
import 'package:handyman_bbk_panel/models/booking_data.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrackWorkerScreen extends StatefulWidget {
  final String bookingId;

  const TrackWorkerScreen({super.key, required this.bookingId});

  @override
  State<TrackWorkerScreen> createState() => _TrackWorkerScreenState();
}

class _TrackWorkerScreenState extends State<TrackWorkerScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  StreamSubscription<DocumentSnapshot>? _bookingSubscription;

  final String _googleApiKey = 'AIzaSyDO3IrPjtL4KUCEYozAM4gQr-w1e-XzbbM';
  final PolylinePoints _polylinePoints = PolylinePoints();

  LatLng? workerLatLng;
  LatLng? userLatLng;
  BookingModel? bookingData;
  String? distanceText;
  bool _isLoading = true;
  double? durationInMinutes;

  @override
  void initState() {
    super.initState();
    _listenToBooking();
  }

  @override
  void dispose() {
    _bookingSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _listenToBooking() {
    _bookingSubscription = FirebaseCollections.bookings
        .doc(widget.bookingId)
        .snapshots()
        .listen((snapshot) async {
      if (!snapshot.exists) return;
      final data = snapshot.data() as Map<String, dynamic>;
      if (data.isEmpty) return;
      bookingData = BookingModel.fromMap(data);
      if (bookingData?.location != null &&
          bookingData?.workerData?.latitude != null &&
          bookingData?.workerData?.longitude != null) {
        userLatLng = LatLng(
          bookingData?.location!.latitude ?? 0.0,
          bookingData?.location!.longitude ?? 0.0,
        );
        workerLatLng = LatLng(
          bookingData?.workerData!.latitude ?? 0.0,
          bookingData?.workerData!.longitude ?? 0.0,
        );

        _updateMarkers();
        await _drawPolyline();

        if (workerLatLng != null && userLatLng != null) {
          _moveCameraToFitBounds();
        }

        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _updateMarkers() {
    _markers.clear();

    if (userLatLng != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: userLatLng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow:
              InfoWindow(title: AppLocalizations.of(context)!.yourLocation),
        ),
      );
    }

    if (workerLatLng != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('worker'),
          position: workerLatLng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow:
              InfoWindow(title: AppLocalizations.of(context)!.workerLocation),
        ),
      );
    }

    setState(() {});
  }

  Future<void> _drawPolyline() async {
    if (workerLatLng == null || userLatLng == null) return;

    final result = await _polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: _googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(workerLatLng!.latitude, workerLatLng!.longitude),
        destination: PointLatLng(userLatLng!.latitude, userLatLng!.longitude),
        mode: TravelMode.driving,
      ),
    );
    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates =
          result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();

      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          color: Colors.blue,
          width: 5,
          points: polylineCoordinates,
        ),
      );

      double totalDistance = 0;
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      durationInMinutes = (totalDistance / 40) * 60;

      distanceText =
          "${totalDistance.toStringAsFixed(1)} ${AppLocalizations.of(context)!.km}";

      setState(() {});
    }
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double p = 0.017453292519943295;
    const double r = 6371;

    final double a = 0.5 -
        Math.cos((lat2 - lat1) * p) / 2 +
        Math.cos(lat1 * p) *
            Math.cos(lat2 * p) *
            (1 - Math.cos((lon2 - lon1) * p)) /
            2;

    return 2 * r * Math.asin(Math.sqrt(a));
  }

  void _moveCameraToFitBounds() {
    if (workerLatLng == null || userLatLng == null) return;

    final double south = min(workerLatLng!.latitude, userLatLng!.latitude);
    final double north = max(workerLatLng!.latitude, userLatLng!.latitude);
    final double west = min(workerLatLng!.longitude, userLatLng!.longitude);
    final double east = max(workerLatLng!.longitude, userLatLng!.longitude);

    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );

    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  double min(double a, double b) => a < b ? a : b;

  double max(double a, double b) => a > b ? a : b;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(AppLocalizations.of(context)!.trackWorker, context,
          isneedtopop: true, isCenter: true),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(20.5937, 78.9629),
              zoom: 5,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          if (_isLoading) const HandymanLoader(),
          if (distanceText != null)
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: workerMapCard(),
              ),
            ),
        ],
      ),
    );
  }

  Widget workerMapCard() {
    DateTime now = DateTime.now();
    DateTime arrivalTime = now.add(
      Duration(minutes: durationInMinutes?.toInt() ?? 0),
    );
    String timeArrival =
        "${arrivalTime.hour}:${arrivalTime.minute.toString().padLeft(2, '0')}";
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            spacing: 10,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: CachedNetworkImage(
                  imageUrl: bookingData?.workerData?.profilePic ?? '',
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(Icons.image),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HandyLabel(
                    text: AppLocalizations.of(context)!.worker,
                    fontSize: 14,
                    isBold: false,
                    textcolor: AppColor.lightGrey300,
                  ),
                  SizedBox(height: 5),
                  HandyLabel(
                    text: bookingData?.workerData?.name ?? '',
                    isBold: true,
                  ),
                ],
              ),
              Spacer(),
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColor.lightGreen,
                child: Icon(Icons.phone, color: AppColor.green, size: 32),
              ),
            ],
          ),
          Divider(color: AppColor.lightGrey400, thickness: 1),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 15,
                children: [
                  HandyLabel(
                    text: AppLocalizations.of(context)!.estimatedTimeOfArrival,
                    fontSize: 14,
                    isBold: false,
                    textcolor: AppColor.lightGrey600,
                  ),
                  HandyLabel(
                    text: timeArrival,
                    fontSize: 14,
                    isBold: false,
                    textcolor: AppColor.black,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HandyLabel(
                    text: AppLocalizations.of(context)!.distanceToReach,
                    fontSize: 14,
                    isBold: false,
                    textcolor: AppColor.lightGrey600,
                  ),
                  HandyLabel(
                    text: distanceText ?? '',
                    fontSize: 14,
                    isBold: false,
                    textcolor: AppColor.black,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
