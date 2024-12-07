import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';

class ThemeSelector extends StatefulWidget {
  const ThemeSelector({super.key});

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeProvider>(context);
    bool isLightMode = themeChanger.themeMode == ThemeMode.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Theme",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black12,
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLightMode
                ? [Colors.blue.shade100, Colors.blue.shade400]
                : [Colors.grey.shade900, Colors.black87],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [


              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  isLightMode ? Icons.wb_sunny : Icons.nights_stay,
                  key: ValueKey(isLightMode),
                  size: 70,
                  color: isLightMode ? Colors.orange : Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isLightMode
                    ? "Bright and Cheerful 🌞"
                    : "Dark and Mysterious 🌙",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isLightMode
                      ? Colors.orange.shade800
                      : Colors.grey.shade300,
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  themeChanger.setTheme(
                      isLightMode ? ThemeMode.dark : ThemeMode.light);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15),
                  backgroundColor: isLightMode
                      ? Colors.white
                      : Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  isLightMode ? "Switch to Dark Mode" : "Switch to Light Mode",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
