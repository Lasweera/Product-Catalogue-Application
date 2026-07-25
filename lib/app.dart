import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/product_repository.dart';
import 'providers/favourites_provider.dart';
import 'providers/product_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/product_list_screen.dart';
import 'theme/app_theme.dart';

class ProductCatalogueApp extends StatelessWidget {
  const ProductCatalogueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ProductRepository>(create: (_) => ProductRepository()),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) =>
              ProductProvider(context.read<ProductRepository>()),
        ),
        ChangeNotifierProvider<FavouritesProvider>(
          create: (_) => FavouritesProvider()..load(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider()..load(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Product Catalogue',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            home: const ProductListScreen(),
          );
        },
      ),
    );
  }
}