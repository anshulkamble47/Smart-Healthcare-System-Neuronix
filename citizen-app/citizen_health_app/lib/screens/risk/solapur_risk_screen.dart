import 'package:flutter/material.dart';
import '../../config/supabase_config.dart';

class SolapurRiskScreen extends StatelessWidget {
  const SolapurRiskScreen({super.key});

  Future<List<dynamic>> getWardRisk() async {

    final data = await supabase
        .from('health_index_results')
        .select('''
          ward_number,
          risk_level,
          health_index,
          wards (
            ward_name
          )
        ''')
        .order('ward_number');

    return data;
  }

  Color riskColor(String risk) {

    switch (risk.toLowerCase()) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange;
      case "low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Solapur Risk Overview"),
      ),

      body: FutureBuilder(

        future: getWardRisk(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No ward data found"));
          }

          final wards = snapshot.data!;

          return ListView.builder(

            padding: const EdgeInsets.all(16),
            itemCount: wards.length,

            itemBuilder: (context, index) {

              final ward = wards[index];

              final wardName = ward['wards']?['ward_name'] ?? "Ward ${ward['ward_number']}";
              final risk = ward['risk_level'] ?? "Unknown";
              final healthIndex = ward['health_index'] ?? "-";

              return Card(
                child: ListTile(

                  leading: const Icon(
                    Icons.warning,
                    color: Colors.teal,
                  ),

                  title: Text(wardName),

                  subtitle: Text("Health Index: $healthIndex"),

                  trailing: Text(
                    risk.toString(),
                    style: TextStyle(
                      color: riskColor(risk.toString()),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}