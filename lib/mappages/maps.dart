import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bloodlife/mappages/appointment.dart';  // Import the BloodDonationForm

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
  Set<Marker> _markers = {};

  final List<Map<String, dynamic>> _hospitals = [
    {
      "name": "Patan Hospital",
      "location": LatLng(27.668435004131467, 85.32061121169149),
      "distance": null,
      "address": "Lagankhel, Lalitpur",
      "contact": "01-5522278, 5522266, 5522295",
      "isExpanded": false,
    },
    {
      "name": "Bir Hospital",
      "location": LatLng(27.704957859623132, 85.31369431169267),
      "distance": null,
      "address": "Mahabouddha, Kathmandu",
      "contact": "01-4221119",
      "isExpanded": false,
    },
    {
      "name": "Nepal Mediciti Hospital",
      "location": LatLng(27.662043306804264, 85.30260735216893),
      "distance": null,
      "address": "Lalitpur, Bhaisepati",
      "contact": "+977-1-4217766",
      "isExpanded": false,
    },
    {
      "name": "Norvic International Hospital",
      "location": LatLng(27.690053977553674, 85.31888185216984),
      "distance": null,
      "address": "Kathmandu",
      "contact": "01-5970032",
      "isExpanded": false,
    },
    {
      "name": "Grande City Hospital",
      "location": LatLng(27.711186560634836, 85.31484911169291),
      "distance": null,
      "address": "Kanti Path, Kathmandu",
      "contact": "01-4163500",
      "isExpanded": false,
    },
    {
      "name": "Kathmandu Medical College and Teaching Hospital",
      "location": LatLng(27.696020769325337, 85.35328749449842),
      "distance": null,
      "address": "Sinamangal, Kathmandu",
      "contact": "01-4277033",
      "isExpanded": false,
    },
    {
      "name": "Teaching Hospital (IOM)",
      "location": LatLng(27.736210086435115, 85.33021658100719),
      "distance": null,
      "address": "Maharajgunj, Kathmandu",
      "contact": "01-4412303",
      "isExpanded": false,
    }
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
      hospital["distance"] = (distance / 1000).toStringAsFixed(2);
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
      if (query.isEmpty) {
        _filteredHospitals = List.from(_hospitals);
      } else {
        _filteredHospitals = _hospitals
            .where((hospital) =>
            hospital["name"].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showHospitalMarker(LatLng location, String name) {
    setState(() {
      _markers.clear(); // Clear previous markers
      _markers.add(Marker(
        markerId: MarkerId(name),
        position: location,
        infoWindow: InfoWindow(
          title: name,
          snippet: "Hospital location",
        ),
      ));
    });

    // Move the map to the selected hospital's location
    _mapController.animateCamera(
      CameraUpdate.newLatLng(location),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Invisible AppBar
          Container(
            height: 50.0,
            color: Colors.transparent,
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Hospitals...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onChanged: _filterHospitals,
            ),
          ),

          // Google Map Section
          Expanded(
            child: _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
            ),
          ),

          // Hospital List Section
          Expanded(
            child: ListView.builder(
              itemCount: _filteredHospitals.length,
              itemBuilder: (context, index) {
                final hospital = _filteredHospitals[index];
                return GestureDetector(
                  onTap: () {
                    // Toggle expansion of the card and show marker if expanded
                    setState(() {
                      hospital["isExpanded"] = !hospital["isExpanded"];
                    });

                    // Only mark the map if the hospital card is expanded
                    if (hospital["isExpanded"]) {
                      _showHospitalMarker(
                          hospital["location"],
                          hospital["name"]
                      );
                    } else {
                      // Clear markers when card is collapsed
                      setState(() {
                        _markers.clear();
                      });
                    }
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(
                          color: Color(0xFFF1C0C0), width: 1),
                    ),
                    elevation: 3,
                    color: const Color(0xFFFAF0F0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hospital["name"],
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                "Distance: ${hospital["distance"]} km",
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 18.0,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    hospital["address"],
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                    size: 18.0,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    "Contact: ${hospital["contact"]}",
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (hospital["isExpanded"])
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black, backgroundColor: Colors.white,
                                ),
                                child: const Text("Show Path"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BloodDonationForm(
                                        hospitalName: hospital["name"],
                                        hospitalAddress: hospital["address"],
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white, backgroundColor: Colors.red,
                                ),
                                child: const Text("Appoint a Date"),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
