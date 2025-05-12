import 'package:flutter/material.dart';

class RoutingScreen extends StatefulWidget {
  const RoutingScreen({super.key});

  @override
  State<RoutingScreen> createState() => _RoutingScreenState();
}

class _RoutingScreenState extends State<RoutingScreen> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  String selectedCategory = 'All';

  final List<String> recentRoutes = [
    'E-07-06 to B-05-06',
    'Cafeteria to Main Entrance',
    'B-04-05 to Library',
    'G-01 to F-03-03',
  ];

  final List<String> categories = ['All', 'Saved', 'Events', 'Food', 'Parking'];

  final Map<String, List<String>> categoryContent = {
    'Events': [
      'Blood Donation - Auditorium 1',
      'AI Talk - Auditorium 3',
      'Club Fair - Level 3 Main Entrance',
    ],
    'Food': [
      'Western Site - Level 3 Cafeteria',
      'Asian Cuisines - Level 3 Cafeteria',
      'Mamak Stall - Outdoor Cafeteria',
    ],
    'Parking': [
      'Indoor Parking - level 1&2 Basement',
      'Outdoor Parking - Outside Main Entrance',
    ],
  };

  void showRouteSteps(String route) {
    List<String> steps;
    if (route.contains('E-07-06')) {
      steps = [
        'Start from E-07-06',
        'Walk down to 5th floor',
        'Pass through corridor near Block D',
        'Arrive at B-05-06',
      ];
    } else if (route.contains('Cafeteria')) {
      steps = [
        'Start at Cafeteria',
        'Exit towards central path',
        'Continue walking 100m',
        'Arrive at Main Entrance',
      ];
    } else {
      steps = [
        'Start navigation from origin',
        'Follow signs',
        'Arrive at destination',
      ];
    }

    showModalBottomSheet(
      context: context,
      builder:
          (_) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🧭 Route Steps',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...steps.asMap().entries.map(
                  (e) => Text('${e.key + 1}. ${e.value}'),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Routing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Enter Custom Route',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: fromController,
              decoration: const InputDecoration(labelText: 'From'),
            ),
            TextField(
              controller: toController,
              decoration: const InputDecoration(labelText: 'To'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final from = fromController.text.trim();
                final to = toController.text.trim();
                if (from.isNotEmpty && to.isNotEmpty) {
                  final route = '$from to $to';
                  setState(() {
                    if (!recentRoutes.contains(route)) {
                      recentRoutes.insert(0, route);
                      if (recentRoutes.length > 10) {
                        recentRoutes.removeLast();
                      }
                    }
                  });
                  showRouteSteps(route);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter both From and To locations'),
                    ),
                  );
                }
              },
              child: const Text('Save & View Route'),
            ),
            const Text(
              'Category Filters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children:
                  categories
                      .map(
                        (cat) => ChoiceChip(
                          label: Text(cat),
                          selected: selectedCategory == cat,
                          onSelected:
                              (_) => setState(() => selectedCategory = cat),
                        ),
                      )
                      .toList(),
            ),
            if (categoryContent.containsKey(selectedCategory)) ...[
              const SizedBox(height: 20),
              ...categoryContent[selectedCategory]!.map(
                (item) => ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(item),
                ),
              ),
            ],
            const SizedBox(height: 30),
            const Text(
              'Recent Routes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...recentRoutes.map(
              (route) => ListTile(
                leading: const Icon(Icons.directions),
                title: Text(route),
                trailing: IconButton(
                  icon: const Icon(Icons.navigation),
                  onPressed: () => showRouteSteps(route),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
