import 'package:flutter/material.dart';
import '../screens/alerts/alert_details_screen.dart';

class HealthAlertBanner extends StatelessWidget {
  const HealthAlertBanner({super.key});

  static const Map<String, dynamic> _bannerAlert = {
    'title': 'Dengue Alert - Ward 3',
    'description':
        'Dengue Alert: Increased cases reported in Ward 3. Tap to view details.',
    'details':
        'Several dengue cases have been reported in Ward 3 over the past week. Residents are advised to take necessary precautions.',
    'prevention_tips': [
      'Avoid stagnant water around homes',
      'Use mosquito repellents',
      'Wear full sleeve clothing',
      'Keep surroundings clean',
    ],
    'affected_area': 'Ward 3, Solapur',
    'issued_by': 'Solapur Municipal Corporation',
    'date': '10 March 2026',
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AlertDetailsScreen(
              alert: _bannerAlert,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFA726),
              Color(0xFFFB8C00),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1FFF9800),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Health Alert",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Dengue Alert: Increased cases reported in Ward 3. Tap to view details.",
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
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
}
