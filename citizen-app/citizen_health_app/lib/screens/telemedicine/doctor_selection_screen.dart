import 'package:flutter/material.dart';

import '../../config/supabase_config.dart';
import 'consultation_screen.dart';

class DoctorSelectionScreen extends StatefulWidget {
  final String department;

  const DoctorSelectionScreen({
    super.key,
    required this.department,
  });

  @override
  State<DoctorSelectionScreen> createState() => _DoctorSelectionScreenState();
}

class _DoctorSelectionScreenState extends State<DoctorSelectionScreen> {
  late final Future<List<Map<String, dynamic>>> _doctorsFuture = _fetchDoctors();

  Future<List<Map<String, dynamic>>> _fetchDoctors() async {
    try {
      final data = await supabase
          .from('hospital_staff')
          .select('''
            name,
            department,
            doctors (
              specialization
            )
          ''')
          .eq('role', 'doctor')
          .eq('department', widget.department);

      final doctors = (data as List<dynamic>).map((item) {
        final map = item as Map<String, dynamic>;
        final doctorMeta = map['doctors'];
        String specialization = widget.department;
        if (doctorMeta is List && doctorMeta.isNotEmpty) {
          specialization =
              doctorMeta.first['specialization']?.toString() ?? widget.department;
        } else if (doctorMeta is Map<String, dynamic>) {
          specialization =
              doctorMeta['specialization']?.toString() ?? widget.department;
        }

        return {
          'name': map['name']?.toString() ?? 'Doctor',
          'specialization': specialization,
          'experience': '8+ years',
          'rating': '4.8',
          'languages': 'English, Hindi, Marathi',
        };
      }).toList();

      if (doctors.isNotEmpty) return doctors;
    } catch (_) {}

    return [
      {
        'name': 'Dr. Sharma',
        'specialization': widget.department,
        'experience': '9+ years',
        'rating': '4.8',
        'languages': 'English, Hindi',
      },
      {
        'name': 'Dr. Patel',
        'specialization': widget.department,
        'experience': '7+ years',
        'rating': '4.7',
        'languages': 'English, Marathi',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _doctorsFuture,
        builder: (context, snapshot) {
          final doctors = snapshot.data ?? const <Map<String, dynamic>>[];

          return Column(
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
                      Color(0xFF7C3AED),
                      Color(0xFF4F46E5),
                      Color(0xFF2563EB),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.department,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Available doctors for consultation',
                      style: TextStyle(
                        color: Color(0xD9FFFFFF),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: doctors.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final doctor = doctors[index];
                          return _DoctorCard(
                            doctor: doctor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConsultationScreen(
                                    doctorName: doctor['name'].toString(),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({
    required this.doctor,
    required this.onTap,
  });

  final Map<String, dynamic> doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.person_outline, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor['name'].toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  doctor['specialization'].toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF667085),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _DoctorMeta(text: doctor['experience'].toString()),
                    _DoctorMeta(text: '${doctor['rating']} rating'),
                    _DoctorMeta(text: doctor['languages'].toString()),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Consult'),
          ),
        ],
      ),
    );
  }
}

class _DoctorMeta extends StatelessWidget {
  const _DoctorMeta({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF667085),
      ),
    );
  }
}
