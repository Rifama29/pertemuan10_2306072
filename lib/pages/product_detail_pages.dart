import 'package:flutter/material.dart';
import 'package:pertemuan10_2306072/models/product_model.dart';
import 'dart:convert';

class ProductDetailPage extends StatelessWidget {
  final ProductModel products;

  const ProductDetailPage({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Produk"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            products.image.isNotEmpty
                ? Image.memory(
                    base64Decode(products.image),
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.image,
                    size: 120,
                  ),

            const SizedBox(height: 20),

            Text(
              products.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text("Rp ${products.price}"),
            const SizedBox(height: 10),
            Text(products.description),
          ],
        ),
      ),
    );
  }
}