import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/supabase_config.dart';
import 'appointment_confirmation_screen.dart';

class AppointmentFormScreen extends StatefulWidget {
  final String appointmentType;
  final String? selectedHospitalId;

  const AppointmentFormScreen({
    Key? key,
    required this.appointmentType,
    this.selectedHospitalId,
  }) : super(key: key);

  @override
  State<AppointmentFormScreen> createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  String? selectedHospitalId;
  String? selectedDepartment;
  String? selectedDoctorId;
  String? selectedDoctorName;
  DateTime? selectedDate;
  String? selectedTimeSlot;

  List<dynamic> hospitals = [];
  List<String> departments = [];
  List<dynamic> doctors = [];

  final List<Map<String, String>> fallbackHospitals = const [
    {'hospital_id': 'fallback-1', 'name': 'City Hospital'},
    {'hospital_id': 'fallback-2', 'name': 'SMC General Hospital'},
  ];

  final List<String> fallbackDepartments = const [
    'General Medicine',
    'Cardiology',
    'Dermatology',
  ];

  final timeSlots = [
    "10:00 AM - 11:00 AM",
    "11:00 AM - 12:00 PM",
    "02:00 PM - 03:00 PM",
    "03:00 PM - 04:00 PM",
  ];

  @override
  void initState() {
    super.initState();
    selectedHospitalId = widget.selectedHospitalId;
    fetchHospitals();

    if (selectedHospitalId != null) {
      fetchDepartments(selectedHospitalId!);
    }
  }

  String mapAppointmentType(String type) {
    switch (type.toLowerCase()) {
      case "doctor":
      case "department":
      case "general":
        return "in_person";
      case "telemedicine":
        return "telemedicine";
      case "emergency":
        return "emergency";
      default:
        return "in_person";
    }
  }

  Future<void> fetchHospitals() async {
    try {
      final data = await supabase.from('hospitals').select('hospital_id, name');
      final result = (data as List<dynamic>).isEmpty ? fallbackHospitals : data;
      if (!mounted) return;
      setState(() => hospitals = result);
    } catch (_) {
      if (!mounted) return;
      setState(() => hospitals = fallbackHospitals);
    }
  }

  Future<void> fetchDepartments(String hospitalId) async {
    try {
      final data = await supabase
          .from('hospital_staff')
          .select('department')
          .eq('hospital_id', hospitalId)
          .eq('role', 'doctor');

      final unique = data
          .map<String>((e) => e['department'].toString())
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();

      if (!mounted) return;
      setState(() => departments =
          unique.isEmpty ? fallbackDepartments : unique);
    } catch (_) {
      if (!mounted) return;
      setState(() => departments = fallbackDepartments);
    }
  }

  Future<void> fetchDoctors(String hospitalId, String department) async {
    try {
      final data = await supabase
          .from('hospital_staff')
          .select('''
          staff_uuid,
          name,
          department,
          doctors (
            specialization
          )
        ''')
          .eq('hospital_id', hospitalId)
          .eq('department', department)
          .eq('role', 'doctor');

      if (!mounted) return;
      setState(() => doctors = (data as List<dynamic>).isEmpty
          ? [
              {
                'staff_uuid': 'fallback-doctor',
                'name': 'General Consultant',
                'department': department,
              }
            ]
          : data);
    } catch (_) {
      if (!mounted) return;
      setState(() => doctors = [
            {
              'staff_uuid': 'fallback-doctor',
              'name': 'General Consultant',
              'department': department,
            }
          ]);
    }
  }

  Future<String?> getCitizenId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    if (userId == null) return null;

    final data = await supabase
        .from('citizens')
        .select('citizen_id')
        .eq('user_id', userId)
        .maybeSingle();

    return data?['citizen_id'] as String?;
  }

  Future<int> generateToken() async {
    final date = selectedDate!.toIso8601String().split('T')[0];

    final data = await supabase
        .from('appointments')
        .select('token_id')
        .eq('hospital_id', selectedHospitalId!)
        .eq('appointment_date', date)
        .eq('time_slot', selectedTimeSlot!)
        .order('token_id', ascending: false)
        .limit(1);

    if (data.isEmpty) return 1;
    return (data[0]['token_id'] ?? 0) + 1;
  }

  Future<void> bookAppointment() async {
    if (selectedHospitalId == null ||
        selectedDepartment == null ||
        selectedDate == null ||
        selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final citizenId = await getCitizenId();
    if (citizenId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not found")),
      );
      return;
    }

    final date = selectedDate!.toIso8601String().split('T')[0];

    try {
      final token = await generateToken();

      final response = await supabase
          .from('appointments')
          .insert({
            'citizen_id': citizenId,
            'hospital_id': selectedHospitalId,
            'doctor_id': selectedDoctorId,
            'appointment_type': mapAppointmentType(widget.appointmentType),
            'appointment_date': date,
            'time_slot': selectedTimeSlot,
            'token_id': token,
            'status': 'booked',
          })
          .select();

      if (response.isEmpty) {
        throw Exception("Insert failed");
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AppointmentConfirmationScreen(
            token: token,
            doctorName: selectedDoctorName ?? "General",
            date: date,
            timeSlot: selectedTimeSlot!,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 56),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4F46E5),
                    Color(0xFF2563EB),
                    Color(0xFF06B6D4),
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
                    'Book Appointment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Choose hospital, department, doctor and time slot',
                    style: TextStyle(
                      color: Color(0xD9FFFFFF),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _FormShell(
                    child: DropdownButtonFormField<String>(
                      value: selectedHospitalId,
                      decoration: _inputDecoration('Select Hospital'),
                      items: hospitals.map<DropdownMenuItem<String>>((h) {
                        return DropdownMenuItem<String>(
                          value: h['hospital_id'] as String,
                          child: Text(h['name'] as String),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedHospitalId = value;
                          selectedDepartment = null;
                          selectedDoctorId = null;
                          doctors = [];
                        });
                        fetchDepartments(value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FormShell(
                    child: DropdownButtonFormField<String>(
                      value: selectedDepartment,
                      decoration: _inputDecoration('Select Department'),
                      items: departments.map((d) {
                        return DropdownMenuItem<String>(
                          value: d,
                          child: Text(d),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDepartment = value;
                        });
                        fetchDoctors(selectedHospitalId!, value!);
                      },
                    ),
                  ),
                  if (widget.appointmentType == "doctor") ...[
                    const SizedBox(height: 16),
                    _FormShell(
                      child: DropdownButtonFormField<String>(
                        value: selectedDoctorId,
                        decoration: _inputDecoration('Select Doctor'),
                        items: doctors.map<DropdownMenuItem<String>>((doc) {
                          return DropdownMenuItem<String>(
                            value: doc['staff_uuid'] as String,
                            child: Text(doc['name'] as String),
                          );
                        }).toList(),
                        onChanged: (value) {
                          final doc =
                              doctors.firstWhere((e) => e['staff_uuid'] == value);
                          setState(() {
                            selectedDoctorId = value;
                            selectedDoctorName = doc['name'] as String?;
                          });
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  _FormShell(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );

                        if (picked != null) {
                          if (!mounted) return;
                          setState(() => selectedDate = picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: _inputDecoration('Select Date'),
                        child: Text(
                          selectedDate == null
                              ? 'Choose appointment date'
                              : selectedDate!.toString().split(' ')[0],
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Available Time Slots',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 14),
                  GridView.builder(
                    itemCount: timeSlots.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.6,
                    ),
                    itemBuilder: (context, index) {
                      final slot = timeSlots[index];
                      final selected = selectedTimeSlot == slot;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTimeSlot = slot;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            gradient: selected
                                ? const LinearGradient(
                                    colors: [Color(0xFF4F46E5), Color(0xFF2563EB)],
                                  )
                                : null,
                            color: selected ? null : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: selected
                                  ? Colors.transparent
                                  : const Color(0xFFDCE5F5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: selected
                                    ? const Color(0x224F46E5)
                                    : const Color(0x120F172A),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              slot,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: selected ? Colors.white : const Color(0xFF334155),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: bookAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        "Book Appointment",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF8FAFF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFDCE5F5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFDCE5F5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.4),
      ),
    );
  }
}

class _FormShell extends StatelessWidget {
  const _FormShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
