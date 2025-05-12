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

  // Track both initial and selected locations
  late LatLng initialLocation;
  late LatLng selectedLocation;

  // Marker icons
  BitmapDescriptor initialMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor selectedMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

  // Set of markers to display
  Set<Marker> markers = {};

  // Track 3D view state
  bool is3DViewEnabled = true;

  @override
  void initState() {
    super.initState();
    // Convert lat & lon from String to double
    double latitude = double.tryParse(widget.lat) ?? 23.83762;
    double longitude = double.tryParse(widget.lon) ?? 90.37012;

    // Set initial location and selected location to the same point at first
    initialLocation = LatLng(latitude, longitude);
    selectedLocation = initialLocation;

    // Set custom marker icons
    _setCustomMarkerIcons();

    // Initialize markers with the initial position
    _setupInitialMarker();
  }

  // Setup custom marker icons
  void _setCustomMarkerIcons() async {
    // Initial location marker - red color
    try {
      BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/pin_map.png',
      ).then((icon) {
        setState(() {
          initialMarkerIcon = icon;
          _setupInitialMarker(); // Refresh marker with new icon
        });
      }).catchError((_) {
        initialMarkerIcon = BitmapDescriptor.defaultMarker; // Red default
      });

      // Selected location marker - blue color
      BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/push_pin.png',
      ).then((icon) {
        setState(() {
          selectedMarkerIcon = icon;
          if (selectedLocation != initialLocation) {
            _updateSelectedMarker(); // Refresh if we have a selected location
          }
        });
      }).catchError((_) {
        selectedMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
      });
    } catch (e) {
      // Fallback to default markers if any errors
    }
  }

  // Setup the initial fixed marker
  void _setupInitialMarker() {
    setState(() {
      markers.clear();

      // Add initial position marker (fixed, non-draggable)
      markers.add(Marker(
        markerId: const MarkerId("initial-location"),
        position: initialLocation,
        icon: initialMarkerIcon,
        infoWindow: const InfoWindow(title: "Initial Location"),
      ));

      // If we already have a selected location different from initial, add that too
      if (selectedLocation != initialLocation) {
        _updateSelectedMarker();
      }
    });
  }

  // Update or add the selected location marker
  void _updateSelectedMarker() {
    // Remove old selected marker if it exists
    markers.removeWhere((marker) => marker.markerId.value == "selected-location");

    // Add new selected location marker
    markers.add(Marker(
      markerId: const MarkerId("selected-location"),
      position: selectedLocation,
      icon: selectedMarkerIcon,
      draggable: true,
      infoWindow: const InfoWindow(title: "Selected Location"),
      onDragEnd: (LatLng newPosition) {
        setState(() {
          selectedLocation = newPosition;
          _updateSelectedMarker();
        });
      },
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Calculate distance between two points in meters
  double _calculateDistance() {
    return Geolocator.distanceBetween(
        initialLocation.latitude,
        initialLocation.longitude,
        selectedLocation.latitude,
        selectedLocation.longitude
    );
  }

  // Format distance for display
  String _formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} meters';
    } else {
      double distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(2)} km';
    }
  }

  // Toggle 3D view (fixed version without getPosition)
  void _toggle3DView() {
    setState(() {
      is3DViewEnabled = !is3DViewEnabled;

      CameraPosition newPosition = CameraPosition(
        target: selectedLocation != initialLocation ? selectedLocation : initialLocation,
        zoom: 18.0,
        tilt: is3DViewEnabled ? 60.0 : 0.0,
        bearing: is3DViewEnabled ? 30.0 : 0.0,
      );

      mapController.animateCamera(CameraUpdate.newCameraPosition(newPosition));
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          // Add a button to toggle 3D view/tilt
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
        mapType: MapType.hybrid, // Set to hybrid for satellite view
        markers: markers,
        onTap: (LatLng position) {
          // When map is tapped, update selected location and marker
          setState(() {
            selectedLocation = position;
            _updateSelectedMarker();
          });
        },
        buildingsEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      // Show distance between markers if a new location is selected
      bottomNavigationBar: selectedLocation != initialLocation
          ? Container(
            height: 40,
            color: Colors.black87,
            child: Center(
              child: Text(
              'Distance: ${_formatDistance(_calculateDistance())}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      )
          : null,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // new location is selected
          FloatingActionButton.extended(
            heroTag: "confirm",
            label: const Text("OK"),
            icon: const Icon(Icons.check),
            onPressed: () {
              // Calculate and format distance
              double distance = _calculateDistance();
              String formattedDistance = _formatDistance(distance);

              // Copy to clipboard
              Clipboard.setData(ClipboardData(text: formattedDistance));
              controller.isLocationUpdated.value = true;
              // Show snackbar
              showTopSnackBar(context, "Distance copied: $formattedDistance. Use it if needed");
              // Get.snackbar(
              //     "Distance copied: $formattedDistance",
              //     'Use it if needed',
              //     snackPosition: SnackPosition.BOTTOM,
              //     margin: EdgeInsets.all(16),
              //     padding: EdgeInsets.all(16)
              // );

              // navigating back
              Get.back(result: selectedLocation);

            },
            backgroundColor: selectedLocation != initialLocation ? Colors.tealAccent : Colors.greenAccent,
          ),
        ],
      ),
    );
  }
}