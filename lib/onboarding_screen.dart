import 'package:flutter/material.dart';
import 'main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> _pages = [
    {
      "title": "Welcome to Sat-Rakshak",
      "desc": "Satellite-based flood verification system for Farmers. Accurate & Fast.",
      "icon": Icons.satellite_alt_rounded,
      "color": const Color(0xFF1B5E20),
      "textColor": Colors.white,
    },
    {
      "title": "Enter Gat Number",
      "desc": "Just enter your 7/12 Gat Number. Our AI locates your farm instantly.",
      "icon": Icons.edit_location_alt_rounded,
      "color": const Color(0xFFE8F5E9),
      "textColor": Color(0xFF1B5E20),
    },
    {
      "title": "Get PDF Certificate",
      "desc": "Download official flood assessment report verified by Sentinel-1 Radar.",
      "icon": Icons.picture_as_pdf_rounded,
      "color": const Color(0xFF2E7D32),
      "textColor": Colors.white,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 35).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onNext() async {
    if (_currentPage == _pages.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FloodCheckScreen()),
      );
    } else {
      await _animationController.forward();
      setState(() {
        _currentPage++;
      });
      _animationController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLastPage = _currentPage == _pages.length - 1;
    var activePage = _pages[_currentPage];
    var nextPage = (_currentPage < _pages.length - 1) ? _pages[_currentPage + 1] : _pages[_currentPage];

    return Scaffold(
      backgroundColor: activePage['color'], 
      body: Stack(
        children: [
          _buildPageContent(activePage),

          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _animationController.isAnimating ? nextPage['color'] : Colors.transparent,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _animationController.isAnimating ? null : _onNext,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, spreadRadius: 2)
                    ],
                  ),
                  child: Icon(
                    isLastPage ? Icons.check_rounded : Icons.arrow_forward_rounded,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(Map<String, dynamic> data) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Padding(
        key: ValueKey(data['title']),
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(data['icon'], size: 80, color: data['textColor']),
            ),
            const SizedBox(height: 50),
            Text(
              data['title'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: data['textColor'], letterSpacing: 1.2),
            ),
            const SizedBox(height: 20),
            Text(
              data['desc'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: data['textColor'].withOpacity(0.8), height: 1.5),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}