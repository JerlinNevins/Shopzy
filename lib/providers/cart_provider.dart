import 'package:flutter_riverpod/flutter_riverpod.dart';
 import 'package:hive_flutter/hive_flutter.dart';

 import '../models/cart_item.dart';
 import '../models/product.dart';
 import '../provider/cart_provider.dart';

 const cartBoxName = 'cart';

 /// Cart state shared by every screen, saved to Hive after each change.
 class CartNotifier extends Notifier<List<CartItem>> {
   Box get _box => Hive.box(cartBoxName);

   @override
   List<CartItem> build() {
   final saved = _box.get('items', defaultValue: []) as List; // load on start
   return saved.map((e) => CartItem.fromJson(e as Map)).toList();
   }

   void _save() => _box.put('items', state.map((i) => i.toJson()).toList());

   void add(Product p) {
   final index = state.indexWhere((i) => i.product.id == p.id);
   if (index == -1) {
   state = [...state, CartItem(p, 1)];
   } else {
   state = [
   for (final i in state) i.product.id == p.id ? i.copyWith(qty: i.qty + 1) : i,
   ];
   }
   _save();
   }

   /// Quantity - 1; removes the item when it reaches 0.
   void decrease(int productId) {
   state = [
   for (final i in state)
   if (i.product.id != productId)
   i
   else if (i.qty > 1)
   i.copyWith(qty: i.qty - 1),
   ];
   _save();
   }

   void remove(int productId) {
   state = state.where((i) => i.product.id != productId).toList();
   _save();
   }

   void clear() {
   state = [];
   _save();
   }
   }

 final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);

 // Derived providers - recalculate automatically when the cart changes
 final cartCountProvider =
 Provider<int>((ref) => ref.watch(cartProvider).fold(0, (sum, i) => sum + i.qty));

 final cartTotalProvider = Provider<double>(
 (ref) => ref.watch(cartProvider).fold(0.0, (sum, i) => sum + i.subtotal));