import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/receipt_provider.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.hasProfile) {
          return const DashboardScreen();
        }

        return const OnboardingScreen();
      },
    );
  }
}
