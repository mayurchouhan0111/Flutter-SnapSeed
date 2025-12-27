import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "animation": "assets/animations/onboarding1.json",
      "title": "Welcome to PhotoCaro",
      "subtitle": "Unleash your creativity with professional editing tools.",
    },
    {
      "animation": "assets/animations/onboarding2.json",
      "title": "AI-Powered Magic",
      "subtitle": "Enhance your photos instantly with our smart AI algorithms.",
    },
    {
      "animation": "assets/animations/onboarding3.json",
      "title": "Your Studio Awaits",
      "subtitle": "Organize, edit, and share your masterpieces with the world.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090b),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Lottie.asset(
                          _pages[index]["animation"]!,
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 48),
                      Text(
                        _pages[index]["title"]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        child: Text(
                          _pages[index]["subtitle"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFa1a1aa),
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? const Color(0xFF6366f1) : const Color(0xFF27272a),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Navigate to Dashboard
                        context.go('/dashboard');
                      }
                    },
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    label: Text(_currentPage == _pages.length - 1 ? "Get Started" : "Next"),
                    icon: Icon(_currentPage == _pages.length - 1 ? Icons.check : Icons.arrow_forward),
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
