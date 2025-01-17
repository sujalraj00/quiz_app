import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Flutter Quiz'),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Quiz'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
                onPressed: () {})
          ],
        ),
      ),
    );
  }
}
