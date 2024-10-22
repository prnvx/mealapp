import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mealapp/screens/loginscreen.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    // Trigger animation after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isAnimated = true;
      });
    });
  }

  void _onButtonPressed() {
    // Navigate to the login screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Loginscreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/images/le-yien-WT8ap_-qmLc-unsplash.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Load Lottie animation from assets at the top center
            Positioned(
              top: 60,
              left: MediaQuery.of(context).size.width / 2 - 100,
              child: Lottie.asset(
                'asset/images/Animation - 1727675310463.json',
                height: 200,
                width: 200,
              ),
            ),
            // Positioned text and button at the bottom center
            Positioned(
              bottom: 100, // Adjust this value to move them lower
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Welcome text with lighter colors
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.lightBlueAccent.withOpacity(0.8), Colors.lightGreenAccent.withOpacity(0.8)],
                      tileMode: TileMode.clamp,
                    ).createShader(bounds),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Fresh Meals',
                          textStyle: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // This will be masked by the gradient
                            fontFamily: 'Roboto',
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                      totalRepeatCount: 4,
                      pause: const Duration(seconds: 1),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Stylish button with lighter colors
                  ElevatedButton(
                    onPressed: _onButtonPressed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blueGrey, Colors.white], // Lighter gradient colors
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 220, minHeight: 70),
                        alignment: Alignment.center,
                        child: const Text(
                          'Get Started',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23),
                        ),
                      ),
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
