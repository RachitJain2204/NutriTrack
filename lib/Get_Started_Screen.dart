import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Ensure the background is black
      body: Column(
        children: [
          Expanded(
            flex: 1, // Set to 1 for a 50/50 split
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/Image_1.png', // Kept your original Image.asset
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.8),
                        ],
                        stops: [0.0, 0.7, 0.85, 0.95, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1, // Set to 1 for a 50/50 split
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0), // Reverted to your original padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        height: 0.9,
                      ),
                      children: [
                        TextSpan(
                          text: 'Nutri',
                          style: TextStyle(
                            color: Color(0xFFE6A70B),
                            fontSize: 58,
                          ),
                        ),
                        TextSpan(
                          text: 'Track',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 47,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Easily Track and Plan Your Diet',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                  Spacer(flex: 1),
                  TextButton(
                    onPressed: () {
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Let's get started",
                          style: TextStyle(
                            color: Color(0xFF6ABF4B),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: Color(0xFF6ABF4B),
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

