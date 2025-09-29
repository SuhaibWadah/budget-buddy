import 'package:expense_tracker/data/db/database_helper.dart';
import 'package:expense_tracker/data/models/settings_adabter.dart';
import 'package:expense_tracker/data/repositories/categories_repo.dart';
import 'package:expense_tracker/data/repositories/transactions_repo.dart';
import 'package:expense_tracker/firebase_options.dart';
import 'package:expense_tracker/providers/auth_provider.dart';
import 'package:expense_tracker/providers/settings_provider.dart';
import 'package:expense_tracker/screens/auth_wrapper.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/services/auth_service.dart';
import 'package:expense_tracker/services/category_service.dart';
import 'package:expense_tracker/services/transaction_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/providers/category_provider.dart';
import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await DatabaseHelper().db;
  await Hive.initFlutter();
  Hive.registerAdapter(SettingsModelAdapter());
  runApp(ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final transService = TransactionService();
    final catService = CategoryService();
    final transRepo = TransactionsRepo();
    final catRepo = CategoriesRepo();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProviders>(
          create: (_) => AuthProviders(authService),
        ),

        // TransactionProvider depends on AuthProvider
        ChangeNotifierProxyProvider<AuthProviders, TransactionProvider>(
          create: (_) => TransactionProvider(transRepo, transService),
          update: (_, authProvider, transProvider) =>
              transProvider!..updateAuth(authProvider),
        ),

        ChangeNotifierProvider(create: (_) => SettingsProvider()..init()),

        // CategoryProvider also depends on AuthProvider
        ChangeNotifierProxyProvider<AuthProviders, CategoryProvider>(
          create: (_) => CategoryProvider(catRepo, catService),
          update: (_, authProvider, catProvider) =>
              catProvider!..updateAuth(authProvider),
        ),
      ],
      child:
          MaterialApp(debugShowCheckedModeBanner: false, home: AuthWrapper()),
    );
  }
}
