
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/wishlist_provider.dart';

import 'screens/login_screen.dart';
import 'screens/product_list_screen.dart';

import 'storage/local_storage.dart';

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();

final token = await LocalStorage.getToken();
final username = await LocalStorage.getUsername();

runApp(
MultiProvider(
providers: [
ChangeNotifierProvider(
create: (_) => AuthProvider(),
),

ChangeNotifierProvider(
create: (_) => ProductProvider(),
),

ChangeNotifierProvider(
create: (_) => CartProvider(),
),

ChangeNotifierProvider(
create: (_) => WishlistProvider(),
),
],
child: ManagementApp(
isLoggedIn:
token != null &&
token.isNotEmpty &&
username != null &&
username.isNotEmpty,
username: username,
),
),
);
}

class ManagementApp extends StatefulWidget {
final bool isLoggedIn;
final String? username;

const ManagementApp({
super.key,
required this.isLoggedIn,
required this.username,
});

@override
State<ManagementApp> createState() => _ManagementAppState();
}

class _ManagementAppState extends State<ManagementApp> {
@override
void initState() {
super.initState();

if (widget.isLoggedIn &&
widget.username != null) {
Future.microtask(() async {
await context
    .read<CartProvider>()
    .setUser(widget.username!);

await context
    .read<WishlistProvider>()
    .setUser(widget.username!);
});
}
}

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Management App',
theme: ThemeData(
useMaterial3: true,
),
home: widget.isLoggedIn
? const ProductListScreen()
    : const LoginScreen(),
);
}
}

