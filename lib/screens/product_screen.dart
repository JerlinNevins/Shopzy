 import 'package:cached_network_image/cached_network_image.dart';
 import 'package:flutter/material.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';

 import '../models/product.dart';
 import '../providers/cart_provider.dart';
 import '../providers/product_providers.dart';
 import 'cart_screen.dart';
 import 'product_detail_screen.dart';

 const categories = ["electronics", "jewelery", "men's clothing", "women's clothing"];

 class ProductsScreen extends ConsumerWidget {
 const ProductsScreen({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
 final products = ref.watch(filteredProductsProvider);
 final selected = ref.watch(categoryProvider);

 return Scaffold(
 appBar: AppBar(title: const Text('ShopEasy'), actions: const [CartButton()]),
 body: Column(children: [
 // Category filter chips
 SizedBox(
 height: 56,
 child: ListView(
 scrollDirection: Axis.horizontal,
 padding: const EdgeInsets.all(8),
 children: [
 ChoiceChip(
 label: const Text('All'),
 selected: selected == null,
 onSelected: (_) => ref.read(categoryProvider.notifier).select(null),
 ),
 for (final c in categories)
 Padding(
 padding: const EdgeInsets.only(left: 8),
 child: ChoiceChip(
 label: Text(c),
 selected: selected == c,
 onSelected: (_) => ref.read(categoryProvider.notifier).select(c),
 ),
 ),
 ],
 ),
 ),
 // Product grid
 Expanded(
 child: products.when(
 loading: () => const Center(child: CircularProgressIndicator()),
 error: (e, _) => Center(
 child: TextButton(
 onPressed: () => ref.invalidate(productsProvider),
 child: Text('$e - tap to retry', textAlign: TextAlign.center),
 ),
 ),
 data: (list) => list.isEmpty
 ? const Center(child: Text('No products in this category'))
 : RefreshIndicator(
 onRefresh: () => ref.refresh(productsProvider.future),
 child: GridView.builder(
 padding: const EdgeInsets.all(8),
 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
 crossAxisCount: 2,
 childAspectRatio: 0.68,
 crossAxisSpacing: 8,
 mainAxisSpacing: 8),
 itemCount: list.length,
 itemBuilder: (_, i) => ProductTile(product: list[i]),
 ),
 ),
      ),
      ),
    ]),
      );
  }
  }

  /// Cart icon with a live item-count badge. Used on the products and details screens.
 class CartButton extends ConsumerWidget {
    const CartButton({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(cartCountProvider);
    return IconButton(
    tooltip: 'Cart',
    icon: Badge(
    isLabelVisible: count > 0,
    label: Text('$count'),
    child: const Icon(Icons.shopping_cart),
    ),
    onPressed: () =>
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
    );
    }
    }

  /// One card in the grid: image, title, price and quick "add to cart".
  class ProductTile extends ConsumerWidget {
    final Product product;

    const ProductTile({super.key, required this.product});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
    return Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
    onTap: () => Navigator.push(context,
    MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
    child: Padding(
    padding: const EdgeInsets.all(8),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Expanded(
    child: Center(
    child: CachedNetworkImage(
    imageUrl: product.image,
    placeholder: (_, __) => const CircularProgressIndicator(strokeWidth: 2),
    errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
    ),
    ),
    ),
    Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis),
    Row(children: [
    Text('\$${product.price.toStringAsFixed(2)}',
    style: const TextStyle(fontWeight: FontWeight.bold)),
    const Spacer(),
    IconButton(
    icon: const Icon(Icons.add_shopping_cart),
    onPressed: () {
    ref.read(cartProvider.notifier).add(product);
    ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(const SnackBar(
    content: Text('Added to cart'), duration: Duration(seconds: 1)));
    },
    ),
    ]),
    ]),
    ),
    ),
    );
    }
    }