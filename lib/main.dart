import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/receipt_provider.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure proper error handling for initialization
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter error: ${details.exception}');
  };

  runApp(const ReceiptQuestApp());
}

class ReceiptQuestApp extends StatelessWidget {
  const ReceiptQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReceiptProvider()..initialize(),
      child: MaterialApp(
        title: 'Receipt Quest',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const AppInitializer(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptProvider>(
      builder: (context, provider, child) {
        // Show loading indicator while initializing
        if (provider.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(height: 24),
                  Text(
                    'Loading Receipt Quest...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Navigate based on profile status
        if (provider.hasProfile) {
          return const DashboardScreen();
        }

        return const OnboardingScreen();
      },
    );
  }
}
