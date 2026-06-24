import 'package:flutter/material.dart';
import 'package:pertemuan10_2306072/models/product_model.dart';
import 'package:pertemuan10_2306072/pages/product_detail_pages.dart';
import 'package:pertemuan10_2306072/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Produk berhasil dihapus")),
    );
  }

  void showForm({ProductModel? product, int? index}) {
    TextEditingController nameController =
        TextEditingController(text: product?.name ?? "");
    TextEditingController descriptionController =
        TextEditingController(text: product?.description ?? "");
    TextEditingController priceController =
        TextEditingController(text: product?.price.toString() ?? "");

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
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final newProduct = ProductModel(
                name: nameController.text,
                description: descriptionController.text,
                price: int.tryParse(priceController.text) ?? 0,
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
        title: Text("Produk", style: TextStyle(
          color: Colors.white,
          fontWeight: .bold
        ),
        ),
        backgroundColor: const Color.fromARGB(255, 9, 16, 201),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.chevron_left, 
            color: Colors.white
          )),
      ),

      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: ()=> showForm(), 
                    child: const Text("Tambah Produk"),
                    ),
                    ),
              ],
            ),
            Expanded(
                    child: products.isEmpty
                        ? const Center(child: Text("Belum ada produk"))
                        : ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return ProductCard(
                                product: product,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailPage(products: product),
                      ),
                    ), onEdit: () {  }, onDelete: () {  },
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