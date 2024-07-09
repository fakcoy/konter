import 'package:flutter/material.dart';
import 'package:konter_hp/controllers/sales_controller.dart';
import 'package:konter_hp/models/sales_model.dart';

class SalesScreen extends StatefulWidget {
  final ValueNotifier<bool> updateNotifier;

  SalesScreen({required this.updateNotifier});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  late Future<List<Sales>> futuresales;
  final saleController _saleController = saleController();

  @override
  void initState() {
    super.initState();
    futuresales = _saleController.fetchsales();
    widget.updateNotifier.addListener(_fetchData);
  }

  @override
  void dispose() {
    widget.updateNotifier.removeListener(_fetchData);
    super.dispose();
  }

  void _fetchData() {
    setState(() {
      futuresales = _saleController.fetchsales();
    });
  }

  void _deletesale(String id) async {
    try {
      await _saleController.deletesale(id);
      _fetchData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus stok: $e'),
          backgroundColor: Color.fromRGBO(223, 217, 217, 1),
        ),
      );
    }
  }

  void _showEditDialog(Sales sale) {
    final TextEditingController _buyerController =
        TextEditingController(text: sale.buyer);
    final TextEditingController _phoneController =
        TextEditingController(text: sale.phone);
    final TextEditingController _dateController =
        TextEditingController(text: sale.date);
    String? _selectedStatus = sale.status;

    Future<void> _selectDate(BuildContext context) async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        setState(() {
          _dateController.text = "${picked.toLocal()}".split(' ')[0];
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Edit Sale'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _buyerController,
                  decoration: InputDecoration(labelText: 'Pembeli'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(labelText: 'Tanggal'),
                    ),
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Status',
                  ),
                  items: ['Pending', 'Done'].map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedStatus = newValue;
                    });
                  },
                ),
              ],
            ),
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
                backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 154, 250, 0)),
                foregroundColor: WidgetStatePropertyAll(Color.fromRGBO(233, 4, 4, 1)),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              onPressed: () async {
                try {
                  await _saleController.updatesale(
                    id: sale.id,
                    buyer: _buyerController.text,
                    phone: _phoneController.text,
                    date: _dateController.text,
                    status: _selectedStatus ?? '',
                    issuer: sale.issuer,
                  );
                  Navigator.of(context).pop();
                  _fetchData();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal memperbarui stok: $e'),
                      backgroundColor: Color.fromRGBO(12, 107, 233, 1),
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
          color: Color(0xFFC90677),
          child: Center(
            child: FutureBuilder<List<Sales>>(
              future: futuresales,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<Sales> sales = snapshot.data!;
                  List<Sales> filteredsales =
                      sales.where((sale) => sale.issuer == 'Fahmihp00').toList();
                  if (filteredsales.isNotEmpty) {
                    return ListView.builder(
                      itemCount: filteredsales.length,
                      itemBuilder: (context, index) {
                        Sales sale = filteredsales[index];
                        return Container(
                          margin: EdgeInsets.only(
                              top: 10.0, left: 16.0, right: 16.0),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(210, 253, 19, 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ListTile(
                            leading: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            title: Text(sale.buyer),
                            subtitle: Text('${sale.date} || ${sale.status}'),
                            trailing: IconButton(
                              onPressed: () => _deletesale(sale.id),
                              icon: Icon(Icons.delete, color: Color.fromRGBO(16, 218, 150, 1)),
                            ),
                            contentPadding: EdgeInsets.only(right: 5, left: 15),
                            onTap: () => _showEditDialog(sale),
                          ),
                        );
                      },
                    );
                  } else {
                    return Text(
                      'Tidak ada data'
                        '\n'
                        'Silahkan tambahkan data terlebih dahulu'
                        '\n'
                        'Klik tombol tambah dibawah ini',
                        );
                  }
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
