import 'package:flutter/material.dart';
import 'package:pertemuan10_2306072/models/product_model.dart';
import 'package:pertemuan10_2306072/pages/product_detail_pages.dart';
import 'package:pertemuan10_2306072/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<ProductModel> products = [];

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productList = prefs.getStringList('products') ?? [];
    setState(() {
      products = productList
          .map((item) => ProductModel.fromJson(item))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productList = products.map((item) => item.toJson()).toList();
    await prefs.setStringList('products', productList);
  }

  Future<void> addProduct(ProductModel product) async {
    setState(() {
      products.add(product);
    });
    await saveProducts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Produk berhasil ditambahkan")),
    );
  }

  Future<void> updateProduct(int index, ProductModel product) async {
    setState(() {
      products[index] = product;
    });
    await saveProducts();
  }

  Future<void> deleteProduct(int index) async {
    setState(() {
      products.removeAt(index);
    });
    await saveProducts();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Produk berhasil dihapus")));
  }

  // method untuk convert gambar
  Future<String> convertimageToBase64(XFile image) async {
    Uint8List bytes = await image.readAsBytes();

    return base64Encode(bytes);
  }

  void showForm({ProductModel? product, int? index}) {
    TextEditingController nameController = TextEditingController(
      text: product?.name ?? "",
    );
    TextEditingController descriptionController = TextEditingController(
      text: product?.description ?? "",
    );
    TextEditingController priceController = TextEditingController(
      text: product?.price.toString() ?? "",
    );
    TextEditingController imgController = TextEditingController(
      text: product?.image ?? "",
    );

    XFile? selectedImage;
    final ImagePicker picker = ImagePicker();

    // method untuk memilih gambar dari galeri
    Future<void> pickImage(StateSetter setDialogState) async {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setDialogState(() {
          selectedImage = image;
          imgController.text = image.path;
        });
      }
    }

    Widget previewImage() {
      if (selectedImage != null) {
        return FutureBuilder<Uint8List>(
          future: selectedImage!.readAsBytes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // loader ketika memilih gambar
              return const CircularProgressIndicator();
            }

            // jika sudah loadir maka tampilkan gambar dari memory
            return Image.memory(
              snapshot.data!,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            );
          },
        );
      }
      if (product?.image.isNotEmpty ?? false) {
        return Image.memory(
          base64Decode(product!.image),
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        );
      }
      return const SizedBox.shrink();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product == null ? "Tambah Produk" : "Edit Produk"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Harga"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => pickImage(setState),
              icon: const Icon(Icons.image),
              label: const Text("Pilih Gambar"),
            ),
            const SizedBox(height: 10),
            previewImage(),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              String imageBase64 = product?.image ?? "";
              if (selectedImage != null) {
                imageBase64 = await convertimageToBase64(selectedImage!);
              }

              final newProduct = ProductModel(
                name: nameController.text,
                description: descriptionController.text,
                price: int.tryParse(priceController.text) ?? 0,
                image: imageBase64,
              );
              if (product == null) {
                addProduct(newProduct);
              } else {
                updateProduct(index!, newProduct);
              }
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Produk",
          style: TextStyle(color: const Color.fromARGB(255, 237, 237, 237), fontWeight: .bold),
        ),
        backgroundColor: const Color.fromARGB(255, 43, 1, 197),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left, color: const Color.fromARGB(255, 251, 251, 251)),
        ),
      ),

      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => showForm(),
                    child: const Text("Tambah Produk"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Product list
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text("Belum ada produk"))
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          onDelete: () => deleteProduct(index),
                          onEdit: () =>
                              showForm(product: product, index: index),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(products: product),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}