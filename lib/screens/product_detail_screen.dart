import 'package:cached_network_image/cached_network_image.dart';
 import 'package:flutter/material.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';

 import '../models/product.dart';
 import '../providers/cart_provider.dart';
 import 'product_screen.dart' show CartButton;

class ProductDetailScreen extends ConsumerWidget {
   final Product product;

   const ProductDetailScreen({super.key, required this.product});

   @override
   Widget build(BuildContext context, WidgetRef ref) {
   return Scaffold(
   appBar: AppBar(title: Text(product.category), actions: const [CartButton()]),
   body: ListView(padding: const EdgeInsets.all(16), children: [
   SizedBox(
   height: 260,
   child: CachedNetworkImage(
   imageUrl: product.image,
   placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
   errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 80),
   ),
   ),
   const SizedBox(height: 16),
   Text(product.title, style: Theme.of(context).textTheme.titleLarge),
   const SizedBox(height: 8),
   Row(children: [
   const Icon(Icons.star, color: Colors.amber),
   Text(' ${product.rating}'),
   const Spacer(),
   Text('\$${product.price.toStringAsFixed(2)}',
   style: Theme.of(context).textTheme.headlineSmall),
   ]),
   const SizedBox(height: 12),
   Text(product.description),
   ]),
   bottomNavigationBar: SafeArea(
   child: Padding(
   padding: const EdgeInsets.all(16),
   child: FilledButton.icon(
   icon: const Icon(Icons.add_shopping_cart),
   label: const Text('Add to cart'),
   onPressed: () {
   ref.read(cartProvider.notifier).add(product);
   ScaffoldMessenger.of(context)
   ..hideCurrentSnackBar()
   ..showSnackBar(const SnackBar(
   content: Text('Added to cart'), duration: Duration(seconds: 1)));
   },
   ),
   ),
   ),
   );
   }
   }