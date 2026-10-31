 import 'package:flutter_riverpod/flutter_riverpod.dart';

 import '../data/product_repository.dart';
 import '../models/product.dart';

 /// Repository as a provider - easy to replace with a fake in tests.
 final productRepositoryProvider = Provider((ref) => ProductRepository());

 /// Loads the products once (AsyncValue: loading / data / error).
 final productsProvider = FutureProvider<List<Product>>(
 (ref) => ref.watch(productRepositoryProvider).fetchAll());

 /// Selected category filter (null = all).
 class CategoryFilter extends Notifier<String?> {
 @override
 String? build() => null;

 void select(String? c) => state = c;
 }

 final categoryProvider = NotifierProvider<CategoryFilter, String?>(CategoryFilter.new);

 /// Derived: products filtered by the selected category.
 final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
 final category = ref.watch(categoryProvider);
 return ref.watch(productsProvider).whenData((list) =>
 category == null ? list : list.where((p) => p.category == category).toList());
 });