class Product {
   final int id;
   final String title;
   final double price;
   final String description;
   final String category;
   final String image;
   final double rating;

   const Product({
   required this.id,
   required this.title,
   required this.price,
   required this.description,
   required this.category,
   required this.image,
   required this.rating,
   });

   factory Product.fromJson(Map<String, dynamic> j) => Product(
   id: j['id'] as int,
   title: j['title'] as String,
   price: (j['price'] as num).toDouble(),
   description: j['description'] as String? ?? '',
   category: j['category'] as String,
   image: j['image'] as String,
   rating: ((j['rating']?['rate'] ?? 0) as num).toDouble(),
   );

   /// Same shape as the API JSON, so fromJson can read it back from Hive.
   Map<String, dynamic> toJson() => {
   'id': id,
   'title': title,
   'price': price,
   'description': description,
   'category': category,
   'image': image,
   'rating': {'rate': rating},
   };
   }