import 'package:konter_hp/controllers/stock_controller.dart';
import 'package:konter_hp/models/stock_model.dart';
import 'package:flutter/material.dart';

class StockScreen extends StatefulWidget {
  final ValueNotifier<bool> updateNotifier;

  StockScreen({required this.updateNotifier});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  late Future<List<Stock>> futureStocks;
  final StockController _stockController = StockController();

  @override
  void initState() {
    super.initState();
    futureStocks = _stockController.fetchStocks();
    widget.updateNotifier.addListener(_fetchData);
  }

  @override
  void dispose() {
    widget.updateNotifier.removeListener(_fetchData);
    super.dispose();
  }

  void _fetchData() {
    setState(() {
      futureStocks = _stockController.fetchStocks();
    });
  }

  void _deleteStock(String id) async {
    try {
      await _stockController.deleteStock(id);
      _fetchData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus stok: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showEditDialog(Stock stock) {
    final TextEditingController _nameController =
        TextEditingController(text: stock.name);
    final TextEditingController _qtyController =
        TextEditingController(text: stock.qty.toString());
    final TextEditingController _attrController =
        TextEditingController(text: stock.attr);
    final TextEditingController _weightController =
        TextEditingController(text: stock.weight.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Edit Stock'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
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
                backgroundColor: WidgetStatePropertyAll(Colors.deepOrange[200]),
                foregroundColor: WidgetStatePropertyAll(Colors.black),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              onPressed: () async {
                try {
                  await _stockController.updateStock(
                    id: stock.id,
                    name: _nameController.text,
                    qty: int.parse(_qtyController.text),
                    attr: _attrController.text,
                    weight: int.parse(_weightController.text),
                    issuer: stock.issuer,
                  );
                  Navigator.of(context).pop();
                  _fetchData();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal memperbarui stok: $e'),
                      backgroundColor: Colors.red,
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
          color: Color(0xFFB1E007),
          child: Center(
            child: FutureBuilder<List<Stock>>(
              future: futureStocks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<Stock> stocks = snapshot.data!;
                  List<Stock> filteredStocks = stocks
                      .where((stock) => stock.issuer == 'Muhammad Faqih Hidayat')
                      .toList();
                  return ListView.builder(
                    itemCount: filteredStocks.length,
                    itemBuilder: (context, index) {
                      Stock stock = filteredStocks[index];
                      return Container(
                        margin:
                            EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                        decoration: BoxDecoration(
                          color: Color(0xFF06D829),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ListTile(
                          leading: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          title: Text(stock.name),
                          subtitle: Text(
                              'Sisa ${stock.qty.toString()} ${stock.attr}'),
                          trailing: IconButton(
                            onPressed: () => _deleteStock(stock.id),
                            icon: Icon(Icons.delete, color: Color(0xFFCA141D)),
                          ),
                          contentPadding: EdgeInsets.only(right: 5, left: 15),
                          onTap: () => _showEditDialog(stock),
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
