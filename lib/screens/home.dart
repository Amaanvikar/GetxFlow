import 'package:flutter/material.dart';
import 'package:getxflow/common/widget/bottom_nav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'HomeScreen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('This is an HomeScreen')],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
