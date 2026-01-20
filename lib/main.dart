import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'onboarding_screen.dart'; 

void main() {
  runApp(const SatRakshakApp());
}

class SatRakshakApp extends StatelessWidget {
  const SatRakshakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sat-Rakshak',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B5E20)),
      ),
      home: const OnboardingScreen(),
    );
  }
}

class FloodCheckScreen extends StatefulWidget {
  const FloodCheckScreen({super.key});

  @override
  State<FloodCheckScreen> createState() => _FloodCheckScreenState();
}

class _FloodCheckScreenState extends State<FloodCheckScreen> {
  
  // TODO: Update with actual server URL
  final String _serverUrl = "YOUR_NGROK_SERVER_LINK_HERE";

  final TextEditingController _gatController = TextEditingController(text: "501");
  final TextEditingController _dateStartController = TextEditingController(text: "2020-10-14");
  final TextEditingController _dateEndController = TextEditingController(text: "2020-10-20");

  bool _isLoading = false;
  
  String _selectedVillage = "Ichalkaranji";

  final List<String> _villageList = [
    "Ichalkaranji",
    "Shirol",
    "Jath",
    "Miraj",
    "Walsang"
  ];

  Future<void> _downloadReport() async {
    if (_serverUrl.contains("YOUR_NGROK")) {
      _showSnackBar("Please paste Ngrok link in main.dart!", isError: true);
      return;
    }
    setState(() { _isLoading = true; });

    final gat = _gatController.text;
    final start = _dateStartController.text;
    final end = _dateEndController.text;
    
    final String apiUrl = "$_serverUrl/check_flood_by_gat?gat_no=$gat&start_date=$start&end_date=$end";

    try {
      final Uri url = Uri.parse(apiUrl);
      if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
        throw 'Could not launch server link';
      }
    } catch (e) {
      _showSnackBar('Connection Error: Check Server', isError: true);
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [Icon(isError ? Icons.error : Icons.check_circle, color: Colors.white), const SizedBox(width: 10), Expanded(child: Text(message))]),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0xFF1B5E20), Color(0xFF4CAF50), Color(0xFF81C784)],
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(offset: Offset(0, -20 * (1 - value)), child: child),
                        );
                      },
                      child: Column(
                        children: [
                           Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]),
                            child: const Icon(Icons.satellite_alt_rounded, size: 50, color: Color(0xFF1B5E20)),
                          ),
                          const SizedBox(height: 15),
                          const Text("SAT-RAKSHAK", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
                          const Text("AI-Powered Flood Verification", style: TextStyle(color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),

                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: const Offset(0, 10))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           const Text("🚜 Farmer Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                           const Divider(),
                           const SizedBox(height: 20),
                           
                           DropdownButtonFormField(
                             value: _selectedVillage,
                             decoration: InputDecoration(
                               labelText: "Select Village",
                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                               prefixIcon: const Icon(Icons.location_city, color: Colors.green),
                             ),
                             items: _villageList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                             onChanged: (v) => setState(() => _selectedVillage = v!),
                           ),
                           const SizedBox(height: 15),

                           _buildTextField(label: "Gat Number (e.g. 501)", icon: Icons.tag, controller: _gatController, isNum: true),
                           const SizedBox(height: 15),
                           
                           Row(children: [
                             Expanded(child: _buildTextField(label: "Start Date", icon: Icons.calendar_today, controller: _dateStartController)),
                             const SizedBox(width: 10),
                             Expanded(child: _buildTextField(label: "End Date", icon: Icons.event, controller: _dateEndController)),
                           ]),
                           const SizedBox(height: 30),

                           SizedBox(
                             width: double.infinity,
                             height: 55,
                             child: ElevatedButton(
                               onPressed: _isLoading ? null : _downloadReport,
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: const Color(0xFFC62828), 
                                 foregroundColor: Colors.white,
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                 elevation: 5,
                               ),
                               child: _isLoading 
                                 ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(color: Colors.white), SizedBox(width: 10), Text("Processing...")])
                                 : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.download), SizedBox(width: 10), Text("GENERATE REPORT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
                             ),
                           ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Powered by ESA Sentinel-1 Data", style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required IconData icon, required TextEditingController controller, bool isNum = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}