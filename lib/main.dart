import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'providers/inventory_provider.dart';
import 'views/inventory_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(const InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InventoryProvider()..init(),
      child: MaterialApp(
        title: 'Inventory Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.teal,
          useMaterial3: true,
        ),
        home: const InventoryDashboard(),
      ),
    );
  }
}
