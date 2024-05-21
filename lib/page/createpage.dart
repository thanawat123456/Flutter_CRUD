import 'package:flutter/material.dart';
import 'package:thanawat_shop/database.dart';
import 'package:thanawat_shop/product.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  Product product = Product();
  List<Product> productlist = [];
  DatabaseSQL dbHelper = DatabaseSQL();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    product.status = false;
    _refreshList();
  }

  _refreshList() async {
    List<Product> lists = await dbHelper.readProduct();
    setState(() {
      productlist = lists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('เพิ่มรายการสินค้า'),
      ),
      body: bildForm(),
    );
  }

  Widget bildForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
          key: _formKey,
          child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'ชื่อสินค้า'),
            validator: (value) => value!.isEmpty ? 'คุณไม่ได้ป้อนชื่อสินค้า' : null,
            onSaved: (value) => setState(() {
              product.name = value!;
            }),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'จำนวนสินค้า'),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? 'คุณไม่ได้ป้อนจำนวนสินค้า' : null,
            onSaved: (value) => setState(() {
              product.qty = int.parse(value!);
            }),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'ราคาต่อหน่วย'),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? 'คุณไม่ได้ป้อนราคาสินค้า' : null,
            onSaved: (value) => setState(() {
              product.price = double.parse(value!);
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('มีอยู่ในสต็อกหรือไม่ ? '),
                Checkbox(value: false, onChanged: (value) {
                  setState(() {
                    product.status = value!;
                  });
                })
              ],
            ),
          ),
          ElevatedButton(onPressed: () {
            saveToDB();
          }, child: const Text('บันทึก'))
        ],
      )),
    );
  }


  saveToDB() async{
    _formKey.currentState!.save();
    product.total = product.qty! * product.price!;
    product = Product(
      name: product.name,
      qty: product.qty,
      price: product.price,
      total: product.total,
      status: product.status
    );
    await dbHelper.createProduct(product);
    _formKey.currentState!.reset();
    setState(() {
      product.status = false;
    });
  }
}
