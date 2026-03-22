import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/supabase_config.dart';
import '../appointment/appointment_form_screen.dart';

class HospitalFinderScreen extends StatefulWidget {
  const HospitalFinderScreen({super.key});

  @override
  State<HospitalFinderScreen> createState() => _HospitalFinderScreenState();
}

class _HospitalFinderScreenState extends State<HospitalFinderScreen> {
  List<dynamic> hospitals = [];
  bool isLoading = true;
  String errorMessage = "";

  static const fallbackHospitals = [
    {
      'hospital_id': 'fallback-1',
      'name': 'City Hospital',
      'address': 'Central Solapur',
      'lat': 17.6599,
      'lng': 75.9064,
      'contact_number': '102',
    },
    {
      'hospital_id': 'fallback-2',
      'name': 'Government Medical Center',
      'address': 'North Solapur',
      'lat': 17.6715,
      'lng': 75.8942,
      'contact_number': '108',
    },
  ];

  @override
  void initState() {
    super.initState();
    loadNearbyHospitals();
  }

  Future<Position> getUserLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are OFF");
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied");
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<List<dynamic>> fetchHospitals() async {
    try {
      final data = await supabase.from('hospitals').select();
      if ((data as List<dynamic>).isNotEmpty) return data;
    } catch (_) {}

    try {
      final rpcData = await supabase.rpc('get_hospitals_with_coords');
      if ((rpcData as List<dynamic>).isNotEmpty) return rpcData;
    } catch (_) {}

    return fallbackHospitals;
  }

  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  Future<void> loadNearbyHospitals() async {
    try {
      final userPosition = await getUserLocation();
      final data = await fetchHospitals();

      final tempList = data.map((h) {
        final lat = ((h['lat'] ?? h['latitude']) as num?)?.toDouble() ?? 17.6599;
        final lng = ((h['lng'] ?? h['longitude']) as num?)?.toDouble() ?? 75.9064;
        final distance = calculateDistance(
          userPosition.latitude,
          userPosition.longitude,
          lat,
          lng,
        );

        return {
          ...h,
          'lat': lat,
          'lng': lng,
          'distance': distance,
        };
      }).toList();

      tempList.sort((a, b) => a['distance'].compareTo(b['distance']));

      if (!mounted) return;
      setState(() {
        hospitals = tempList;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> openMaps(double lat, double lng) async {
    final url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng",
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch maps");
    }
  }

  Future<void> callHospital(String phone) async {
    final url = Uri.parse("tel:$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 54, 20, 56),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0EA5E9),
                  Color(0xFF2563EB),
                  Color(0xFF4F46E5),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A2563EB),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nearby Hospitals',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Find nearby facilities and book appointments quickly',
                  style: TextStyle(
                    color: Color(0xD9FFFFFF),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: hospitals.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final h = hospitals[index];
                          return _HospitalCard(
                            hospital: h,
                            onDirections: () => openMaps(
                              (h['lat'] as num).toDouble(),
                              (h['lng'] as num).toDouble(),
                            ),
                            onBook: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AppointmentFormScreen(
                                    appointmentType: "general",
                                    selectedHospitalId: h['hospital_id'],
                                  ),
                                ),
                              );
                            },
                            onCall: h['contact_number'] != null
                                ? () => callHospital(h['contact_number'].toString())
                                : null,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _HospitalCard extends StatelessWidget {
  const _HospitalCard({
    required this.hospital,
    required this.onDirections,
    required this.onBook,
    required this.onCall,
  });

  final Map hospital;
  final VoidCallback onDirections;
  final VoidCallback onBook;
  final VoidCallback? onCall;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onDirections,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x140F172A),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hospital['name']?.toString() ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hospital['address']?.toString() ?? 'Address not available',
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF667085),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${(hospital['distance'] as num).toStringAsFixed(2)} km away',
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onDirections,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('Directions'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onBook,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('Book'),
                    ),
                  ),
                  if (onCall != null) ...[
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: onCall,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.call,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
