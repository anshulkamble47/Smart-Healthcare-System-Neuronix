import 'package:flutter/material.dart';

import '../../config/supabase_config.dart';
import 'update_details_screen.dart';

class CommunityUpdatesScreen extends StatefulWidget {
  const CommunityUpdatesScreen({super.key});

  @override
  State<CommunityUpdatesScreen> createState() => _CommunityUpdatesScreenState();
}

class _CommunityUpdatesScreenState extends State<CommunityUpdatesScreen> {
  late final Future<List<Map<String, String>>> _updatesFuture = _fetchUpdates();

  Future<List<Map<String, String>>> _fetchUpdates() async {
    try {
      final data = await supabase
          .from('community_updates')
          .select()
          .order('created_at', ascending: false);

      final items = (data as List<dynamic>).map((item) {
        final map = item as Map<String, dynamic>;
        return {
          'title': (map['title'] ?? map['headline'] ?? 'Update').toString(),
          'description':
              (map['description'] ?? map['content'] ?? '').toString(),
        };
      }).where((item) => item['title']!.isNotEmpty).toList();

      if (items.isNotEmpty) return items;
    } catch (_) {}

    return const [
      {
        'title': 'Vaccination Drive',
        'description': 'Free vaccination camp at Solapur PHC on 12 May',
      },
      {
        'title': 'Health Camp',
        'description': 'Free diabetes screening camp at City Hospital',
      },
      {
        'title': 'Health Advisory',
        'description': 'Heatwave advisory issued for Solapur region',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _updatesFuture,
        builder: (context, snapshot) {
          final updates = snapshot.data ?? const <Map<String, String>>[];

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
                      'Community Updates',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Latest health campaigns, advisories and local updates',
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
                        itemCount: updates.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = updates[index];
                          return _UpdateCard(
                            title: item['title'] ?? '',
                            description: item['description'] ?? '',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateDetailsScreen(
                                    title: item['title'] ?? '',
                                    description: item['description'] ?? '',
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

class _UpdateCard extends StatelessWidget {
  const _UpdateCard({
    required this.title,
    required this.description,
    required this.onTap,
  });

  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.campaign_outlined, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF667085),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Read More',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
