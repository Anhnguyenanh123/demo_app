import 'package:flutter/material.dart';
import '../services/attribution_service.dart';
import '../models/attribution_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final attributionService = AttributionService();
  await attributionService.init();

  runApp(MyApp(attributionService: attributionService));
}

class MyApp extends StatelessWidget {
  final AttributionService attributionService;

  const MyApp({super.key, required this.attributionService});

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
      home: HomeScreen(attributionService: attributionService),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final AttributionService attributionService;

  const HomeScreen({super.key, required this.attributionService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AttributionData _data;

  @override
  void initState() {
    super.initState();
    _data = widget.attributionService.currentData;
    widget.attributionService.attributionStream.listen((newData) {
      if (mounted) {
        setState(() {
          _data = newData;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attribution Data (JSON)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Received Parameters:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _data.toJsonString(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Re-display current data or refresh if needed
                  setState(() {
                    _data = widget.attributionService.currentData;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh View'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
