import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:konter_hp/controllers/product_controller.dart';
import 'package:konter_hp/models/product_model.dart';

class ProductScreen extends StatefulWidget {
  final ValueNotifier<bool> updateNotifier;

  ProductScreen({required this.updateNotifier});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<Product>> futureProducts;
  final ProductController _productController = ProductController();

  @override
  void initState() {
    super.initState();
    futureProducts = _productController.fetchProducts();
    widget.updateNotifier.addListener(_fetchData);
  }

  @override
  void dispose() {
    widget.updateNotifier.removeListener(_fetchData);
    super.dispose();
  }

  void _fetchData() {
    setState(() {
      futureProducts = _productController.fetchProducts();
    });
  }

  void _deleteStock(String id) async {
    try {
      await _productController.deleteProduct(id);
      _fetchData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus product: $e'),
          backgroundColor: Color.fromRGBO(73, 54, 244, 1),
        ),
      );
    }
  }

  String formatRupiah(num number) {
    final formatter = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return formatter.format(number);
  }

  void _showEditDialog(Product product) {
    final TextEditingController _nameController =
        TextEditingController(text: product.name);
    final TextEditingController _priceController =
        TextEditingController(text: product.price.toString());
    final TextEditingController _qtyController =
        TextEditingController(text: product.qty.toString());
    final TextEditingController _attrController =
        TextEditingController(text: product.attr);
    final TextEditingController _weightController =
        TextEditingController(text: product.weight.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: _priceController,
                decoration:
                    InputDecoration(labelText: 'Harga', prefix: Text('Rp. ')),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _qtyController,
                decoration: InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _attrController,
                decoration: InputDecoration(labelText: 'Satuan'),
              ),
              TextField(
                controller: _weightController,
                decoration:
                    InputDecoration(labelText: 'Berat', suffix: Text('Kg')),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(0, 255, 255, 1)),
                foregroundColor: WidgetStatePropertyAll(Colors.black),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              onPressed: () async {
                try {
                  await _productController.updateProduct(
                    id: product.id,
                    name: _nameController.text,
                    price: num.parse(_priceController.text),
                    qty: num.parse(_qtyController.text),
                    attr: _attrController.text,
                    weight: num.parse(_weightController.text),
                    issuer: product.issuer,
                  );
                  Navigator.of(context).pop();
                  _fetchData();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal memperbarui product: $e'),
                      backgroundColor: Color.fromRGBO(83, 8, 3, 1),
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.updateNotifier,
      builder: (context, value, child) {
        return Container(
          color: Color.fromRGBO(221, 240, 248, 1),
          child: Center(
            child: FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<Product> products = snapshot.data!;
                  List<Product> filteredProducts = products
                      .where((product) => product.issuer == 'Fahmihp00')
                      .toList();
                  return ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      Product product = filteredProducts[index];
                      return Container(
                        margin:
                            EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 6, 6, 1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ListTile(
                          leading: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          title: Text(product.name),
                          subtitle: Text(
                              '${formatRupiah(product.price)} || sisa ${product.qty.toString()} ${product.attr}'),
                          trailing: IconButton(
                            onPressed: () => _deleteStock(product.id),
                            icon: Icon(Icons.delete, color: Color.fromRGBO(63, 12, 9, 1)),
                          ),
                          contentPadding: EdgeInsets.only(right: 5, left: 15),
                          onTap: () => _showEditDialog(product),
                        ),
                      );
                    },
                  );
                }
                return Text('Tidak ada data');
              },
            ),
          ),
        );
      },
    );
  }
}
