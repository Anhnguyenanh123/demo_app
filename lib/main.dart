import 'package:flutter/material.dart';
import 'services/deep_link_service.dart';
import 'services/install_referrer_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final deepLinkService = DeepLinkService();
  deepLinkService.init();

  final referrerData = await InstallReferrerService.getReferrer();

  runApp(MyApp(deepLinkService: deepLinkService, referrerData: referrerData));
}

class MyApp extends StatelessWidget {
  final DeepLinkService deepLinkService;
  final Map<String, String?> referrerData;

  const MyApp({
    super.key,
    required this.deepLinkService,
    required this.referrerData,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attribution Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(
        deepLinkService: deepLinkService,
        referrerData: referrerData,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final DeepLinkService deepLinkService;
  final Map<String, String?> referrerData;

  const HomeScreen({
    super.key,
    required this.deepLinkService,
    required this.referrerData,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String?>> _events = [];

  @override
  void initState() {
    super.initState();

    // Add install referrer data
    _events.add(widget.referrerData);

    // Listen for deep links
    widget.deepLinkService.onDeepLink.listen((data) {
      if (mounted) {
        setState(() {
          _events.insert(0, data); // Newest on top
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attribution Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade700, Colors.purple.shade400],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.track_changes,
                    size: 40,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'UTM Tracking',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${_events.length} event(s) captured',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Event list
            Expanded(
              child: _events.isEmpty
                  ? const Center(
                      child: Text(
                        'Waiting for deep link or install referrer...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        final event = _events[index];
                        return _buildEventCard(event, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, String?> event, int index) {
    final isDeepLink = event['type']?.contains('EXISTING') ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDeepLink ? Colors.blue.shade900 : Colors.green.shade900,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDeepLink ? Colors.blue : Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                event['type'] ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // UTM data
            _buildRow('utm_source', event['utm_source']),
            _buildRow('utm_campaign', event['utm_campaign']),
            _buildRow('utm_medium', event['utm_medium']),

            // Full link (if deep link)
            if (event['full_link'] != null) ...[
              const Divider(color: Colors.white24),
              Text(
                event['full_link']!,
                style: const TextStyle(fontSize: 11, color: Colors.white38),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'null',
              style: TextStyle(
                color: value != null ? Colors.white : Colors.white38,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
