import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/supabase_config.dart';
import '../screens/risk/ward_risk_details_screen.dart';

class WardRiskIndicator extends StatefulWidget {
  const WardRiskIndicator({super.key});

  @override
  State<WardRiskIndicator> createState() => _WardRiskIndicatorState();
}

class _WardRiskIndicatorState extends State<WardRiskIndicator> {

  Future<Map<String,dynamic>?> getWardRisk() async {

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id");

    if (userId == null) return null;

    // get citizen ward
    final citizen = await supabase
        .from('citizens')
        .select()
        .eq('user_id', userId)
        .single();

    final wardNumber = citizen['ward_number'];

    // get risk
    final risk = await supabase
        .from('health_index_results')
        .select()
        .eq('ward_number', wardNumber)
        .single();

    return {
      "ward": wardNumber,
      "risk": risk['risk_level']
    };
  }

  Color riskColor(String risk) {

    switch(risk.toLowerCase()) {

      case "high":
        return Colors.red;

      case "moderate":
        return Colors.orange;

      case "low":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWardRisk(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!;
        final ward = data["ward"];
        final risk = data["risk"];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WardRiskDetailsScreen(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Ward Status",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey.shade600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Ward $ward",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF12284C),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: riskColor(risk).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          "Risk: $risk",
                          style: TextStyle(
                            color: riskColor(risk),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF4FF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.local_hospital_rounded,
                    color: riskColor(risk),
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
