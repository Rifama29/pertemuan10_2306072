import 'package:flutter/material.dart';
import 'package:pertemuan10_2306072/models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel products; 

  const ProductDetailPage({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Produk"),),
      body: Padding(
        padding: .all(20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              products.name,
              style: TextStyle(fontSize: 24, fontWeight: .bold),
            ),
            const SizedBox(height: 10,),
            Text("Rp ${products.price}"),
            const SizedBox(height: 10,),
            Text(products.description),
          ],
        ),
        ),
    );
  }
}