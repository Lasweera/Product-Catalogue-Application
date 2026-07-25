import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritesProvider extends ChangeNotifier {
  static const _prefsKey = 'favourite_product_ids';

  Set<String> _favouriteIds = {};

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_prefsKey) ?? [];
    _favouriteIds = stored.toSet();
    notifyListeners();
  }

  bool isFavourite(String productId) => _favouriteIds.contains(productId);

  Future<void> toggleFavourite(String productId) async {
    if (_favouriteIds.contains(productId)) {
      _favouriteIds.remove(productId);
    } else {
      _favouriteIds.add(productId);
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _favouriteIds.toList());
  }
}
