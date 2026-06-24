import 'dart:convert';

class ProductModel {
  //inisialisasi variabel data product
  final String name;
  final String description;
  final int? price;

// constructor 
  ProductModel({
    required this.name,
    required this.description,
    required this.price,
  });

  
  //object ke map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }
  //map ke object 
  factory ProductModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return ProductModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
    );
  }
  
  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) {
    return ProductModel.fromMap(json.decode(source));
  }

}