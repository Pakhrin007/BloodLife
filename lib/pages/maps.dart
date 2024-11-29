import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  LatLng? _currentPosition;
  String? _mapStyle;
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _hospitals = [
    {
      "name": "Patan Hospital",
      "location": LatLng(27.678456, 85.318793),
      "address": "Lagankhel Satdobato Rd, Lalitpur 44700",
      "contact": "01-5522295",
      "distance": null,
    },
    {
      "name": "Norvic Hospital",
      "location": LatLng(27.692293, 85.319038),
      "address": "Thapathali Rd, Kathmandu",
      "contact": "01-4258554",
      "distance": null,
    },
    {
      "name": "Grande Hospital",
      "location": LatLng(27.732658, 85.328911),
      "address": "Tokha, Kathmandu",
      "contact": "01-4951000",
      "distance": null,
    },
  ];

  List<Map<String, dynamic>> _filteredHospitals = [];

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _getCurrentLocation();
    _filteredHospitals = List.from(_hospitals);
  }

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style.json');
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _calculateDistances();
    });
  }

  void _calculateDistances() {
    for (var hospital in _hospitals) {
      final distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        hospital["location"].latitude,
        hospital["location"].longitude,
      );
      hospital["distance"] = (distance / 1000).toStringAsFixed(2); // Distance in km
    }
    _hospitals.sort((a, b) => (a["distance"] ?? 0).compareTo(b["distance"] ?? 0));
    _filteredHospitals = List.from(_hospitals);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_mapStyle != null) {
      _mapController.setMapStyle(_mapStyle);
    }
    if (_currentPosition != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLng(_currentPosition!),
      );
    }
  }

  void _filterHospitals(String query) {
    setState(() {
      _filteredHospitals = _hospitals
          .where((hospital) =>
          hospital["name"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _getDirections(LatLng destination) {
    // Code to get and display directions goes here
    print("Navigate to: $destination");
  }

  Widget _buildHospitalCard(Map<String, dynamic> hospital) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(
                Icons.local_hospital,
                color: Colors.redAccent,
                size: 30,
              ),
            ),
            const SizedBox(width: 16.0),
            // Hospital Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospital["name"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    hospital["address"] ?? "No address available",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    hospital["contact"] ?? "No contact available",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "${hospital["distance"]} km away",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentPosition!,
              zoom: 14,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _hospitals.map((hospital) {
              return Marker(
                markerId: MarkerId(hospital["name"]),
                position: hospital["location"],
                infoWindow: InfoWindow(
                  title: hospital["name"],
                  snippet: "${hospital["distance"]} km away",
                ),
              );
            }).toSet(),
          ),
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              child: TextField(
                controller: _searchController,
                onChanged: _filterHospitals,
                decoration: const InputDecoration(
                  hintText: "Search hospitals...",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              height: 250,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Nearest Hospitals",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredHospitals.length,
                      itemBuilder: (context, index) {
                        final hospital = _filteredHospitals[index];
                        return GestureDetector(
                          onTap: () {
                            _getDirections(hospital["location"]);
                          },
                          child: _buildHospitalCard(hospital),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
