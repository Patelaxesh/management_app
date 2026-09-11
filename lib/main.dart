import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'screens/login_screen.dart';
import 'screens/product_list_screen.dart';
import 'storage/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final token = await LocalStorage.getToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()..loadCart()),
      ],
      child: ManagementApp(isLoggedIn: token != null && token.isNotEmpty),
    ),
  );
}

class ManagementApp extends StatelessWidget {
  final bool isLoggedIn;

  const ManagementApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Management App',
      theme: ThemeData(useMaterial3: true),
      home: isLoggedIn ? const ProductListScreen() : const LoginScreen(),
    );
  }
}
