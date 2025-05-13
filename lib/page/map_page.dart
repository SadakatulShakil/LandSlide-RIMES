import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lanslide_report/controller/survey/survey_question_controller.dart';

class MapPage extends StatefulWidget {
  final String lat, lon;

  MapPage(this.lat, this.lon, {Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final controller = Get.find<SurveyController>();

  late LatLng initialLocation;
  late LatLng selectedLocation;

  BitmapDescriptor initialMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor selectedMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

  Set<Marker> markers = {};
  bool is3DViewEnabled = true;

  @override
  void initState() {
    super.initState();
    double latitude = double.tryParse(widget.lat) ?? 23.83762;
    double longitude = double.tryParse(widget.lon) ?? 90.37012;
    initialLocation = LatLng(latitude, longitude);
    selectedLocation = initialLocation;
    _setCustomMarkerIcons();
    _setupInitialMarker();

    // Show instruction modal after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructionModal();
    });
  }

  // Show the snackBar at the top of the screen
  void showTopSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Below status bar
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove snackbar after 2 seconds
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  void _setCustomMarkerIcons() async {
    try {
      BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/pin_map.png',
      ).then((icon) {
        setState(() {
          initialMarkerIcon = icon;
          _setupInitialMarker();
        });
      });

      BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/push_pin.png',
      ).then((icon) {
        setState(() {
          selectedMarkerIcon = icon;
          if (selectedLocation != initialLocation) _updateSelectedMarker();
        });
      });
    } catch (_) {}
  }

  void _setupInitialMarker() {
    setState(() {
      markers.clear();
      markers.add(Marker(
        markerId: const MarkerId("initial-location"),
        position: initialLocation,
        icon: initialMarkerIcon,
        infoWindow: const InfoWindow(title: "My Location"),
      ));
      if (selectedLocation != initialLocation) _updateSelectedMarker();
    });
  }

  void _updateSelectedMarker() {
    markers.removeWhere((m) => m.markerId.value == "selected-location");
    markers.add(Marker(
      markerId: const MarkerId("selected-location"),
      position: selectedLocation,
      icon: selectedMarkerIcon,
      draggable: true,
      infoWindow: const InfoWindow(title: "Landslide Location"),
      onDragEnd: (newPosition) {
        setState(() {
          selectedLocation = newPosition;
          _updateSelectedMarker();
        });
        _showSelectionSummaryModal();
      },
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  double _calculateDistance() {
    return Geolocator.distanceBetween(
      initialLocation.latitude,
      initialLocation.longitude,
      selectedLocation.latitude,
      selectedLocation.longitude,
    );
  }

  String _formatDistance(double meters) {
    return meters < 1000
        ? '${meters.toStringAsFixed(0)} meters'
        : '${(meters / 1000).toStringAsFixed(2)} km';
  }

  void _toggle3DView() {
    setState(() {
      is3DViewEnabled = !is3DViewEnabled;
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: selectedLocation != initialLocation ? selectedLocation : initialLocation,
          zoom: 18.0,
          tilt: is3DViewEnabled ? 60.0 : 0.0,
          bearing: is3DViewEnabled ? 30.0 : 0.0,
        ),
      ));
    });
  }

  void _showInstructionModal() {
    Get.dialog(
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Instructions'),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Get.back(),
            ),
          ],
        ),
        content: const Text(
          'Select a place where the event happened.\n\nYou can tap on the map to select the location.\nYou can also drag the marker to fine-tune it.',
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showSelectionSummaryModal() {
    final lat = selectedLocation.latitude.toStringAsFixed(6);
    final lon = selectedLocation.longitude.toStringAsFixed(6);
    final distance = _formatDistance(_calculateDistance());

    Get.dialog(
      AlertDialog(
        title: const Text('Location Selected'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Latitude: $lat'),
            Text('Longitude: $lon'),
            const SizedBox(height: 10),
            Text('Distance from your location:\n$distance'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Again'),
            onPressed: () => Get.back(), // Close dialog, let user pick again
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: distance));
              controller.isLocationUpdated.value = true;
              showTopSnackBar(context, "Distance from your location being copied: $distance");
              Get.back(); // Close dialog
              Get.back(result: selectedLocation); // Return location
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: Icon(is3DViewEnabled ? Icons.view_in_ar : Icons.map),
            onPressed: _toggle3DView,
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 18.0,
          tilt: 45.0,
          bearing: 30.0,
        ),
        mapType: MapType.hybrid,
        markers: markers,
        onTap: (LatLng position) {
          setState(() {
            selectedLocation = position;
            _updateSelectedMarker();
          });
          _showSelectionSummaryModal();
        },
        buildingsEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}