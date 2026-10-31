import 'product.dart';

 /// A product in the cart with its quantity. Immutable - change it with copyWith.
class CartItem {
   final Product product;
   final int qty;

   const CartItem(this.product, this.qty);

   double get subtotal => product.price * qty;

   CartItem copyWith({int? qty}) => CartItem(product, qty ?? this.qty);

   Map<String, dynamic> toJson() => {'product': product.toJson(), 'qty': qty};

   /// Hive returns Map<dynamic, dynamic>, so convert before Product.fromJson.
   factory CartItem.fromJson(Map j) => CartItem(
   Product.fromJson(Map<String, dynamic>.from(j['product'] as Map)),
   j['qty'] as int,
   );
   }