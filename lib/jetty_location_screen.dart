import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class JettyLocationScreen extends StatefulWidget {
  final String initialJettyName;
  final List<Map<String, dynamic>> allJetties;
  final bool isPickup;

  const JettyLocationScreen({
    super.key,
    required this.initialJettyName,
    required this.allJetties,
    required this.isPickup,
  });

  @override
  State<JettyLocationScreen> createState() => _JettyLocationScreenState();
}

class _JettyLocationScreenState extends State<JettyLocationScreen> {
  late String _selectedJettyName;
  late Map<String, dynamic> _currentJetty;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _selectedJettyName = widget.initialJettyName;
    _updateCurrentJetty();
  }

  void _updateCurrentJetty() {
    _currentJetty = widget.allJetties.firstWhere(
      (element) => element['name'] == _selectedJettyName,
      orElse: () => widget.allJetties.first,
    );
    _updateMarkers();
    _moveCamera();
  }

  void _updateMarkers() {
    final lat = (_currentJetty['lat'] as num).toDouble();
    final lng = (_currentJetty['lng'] as num).toDouble();

    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId(_currentJetty['jettyId'].toString()),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: _currentJetty['name'],
            snippet: 'Jetty ${_currentJetty['jettyId']}',
          ),
        ),
      };
    });
  }

  void _moveCamera() {
    if (_mapController != null) {
      final lat = (_currentJetty['lat'] as num).toDouble();
      final lng = (_currentJetty['lng'] as num).toDouble();
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, lng), 18),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lat = (_currentJetty['lat'] as num).toDouble();
    final lng = (_currentJetty['lng'] as num).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPickup ? 'Confirm Pick-up' : 'Confirm Drop-off'),
        backgroundColor: const Color(0xFF0066CC),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, lng),
              zoom: 18,
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.isPickup ? 'Pick-up Location' : 'Drop-off Location',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedJettyName,
                          items: widget.allJetties.map((location) {
                            return DropdownMenuItem<String>(
                              value: location['name'],
                              child: Text(
                                'Jetty ${location['jettyId']} - ${location['name']}',
                                style: const TextStyle(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedJettyName = value;
                                _updateCurrentJetty();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, _selectedJettyName);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066CC),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Confirm Location',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
