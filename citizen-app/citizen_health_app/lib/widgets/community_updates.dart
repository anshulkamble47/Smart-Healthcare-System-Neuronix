import 'package:flutter/material.dart';

class CommunityUpdates extends StatelessWidget {
  const CommunityUpdates({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildUpdateCard(
          context,
          accentColor: const Color(0xFF43A047),
          title: "Vaccination Drive",
          description:
              "Free vaccination drive at Ward Office this Sunday for all residents.",
          date: "21 Mar 2026",
        ),
        const SizedBox(height: 16),
        _buildUpdateCard(
          context,
          accentColor: const Color(0xFF1E88E5),
          title: "Health Camp",
          description:
              "New health camps are scheduled this week. Tap to view detailed updates.",
          date: "20 Mar 2026",
        ),
      ],
    );
  }

  Widget _buildUpdateCard(
    BuildContext context, {
    required Color accentColor,
    required String title,
    required String description,
    required String date,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 132,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2B49),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey.shade500,
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
