import 'package:flutter/material.dart';
import 'package:thanawat_shop/database.dart';
import 'package:thanawat_shop/product.dart';

class UpdatePage extends StatefulWidget {
  final Product updateProduct;
  const UpdatePage(this.updateProduct, {super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late Product updateProduct;
  List<Product> productlist = [];
  DatabaseSQL dbHelper = DatabaseSQL();
  final _formKey = GlobalKey<FormState>();

  /// ตัวแปรที่ไปใช้ Form
  late int selectedID;
  late TextEditingController _pdNameController;
  late TextEditingController _pdQuantityController;
  late TextEditingController _pdPriceController;
  late double _updateTotal;
  late bool _updateStatus;

  @override
  void initState() {
    super.initState();
    // ดึงค่า id ที่ต้องการจะ update
    selectedID = widget.updateProduct.id!;
    // ดึงค่า widget จาก ListView หน้า homepage
    _pdNameController = TextEditingController(text: widget.updateProduct.name);
    _pdQuantityController = TextEditingController(text: widget.updateProduct.qty.toString());
    _pdPriceController = TextEditingController(text: widget.updateProduct.price.toString());
    _updateStatus = widget.updateProduct.status ?? false; // กำหนดค่าเริ่มต้น
    updateProduct = widget.updateProduct; // กำหนดค่า updateProduct
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('แก้ไขรายการสินค้า'),
      ),
      body: buildForm(),
    );
  }

  Widget buildForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'ชื่อสินค้า'),
              controller: _pdNameController,
              validator: (value) => value!.isEmpty ? 'คุณไม่ได้ป้อนชื่อสินค้า' : null,
              onSaved: (value) => setState(() {
                updateProduct.name = value!;
              }),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'จำนวนสินค้า'),
              controller: _pdQuantityController,
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'คุณไม่ได้ป้อนจำนวนสินค้า' : null,
              onSaved: (value) => setState(() {
                updateProduct.qty = int.parse(value!);
              }),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'ราคาต่อหน่วย'),
              controller: _pdPriceController,
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'คุณไม่ได้ป้อนราคาสินค้า' : null,
              onSaved: (value) => setState(() {
                updateProduct.price = double.parse(value!);
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('มีอยู่ในสต็อกหรือไม่ ? '),
                  Checkbox(
                    value: _updateStatus,
                    onChanged: (value) {
                      setState(() {
                        _updateStatus = value!;
                      });
                    },
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  updateToDB(context);
                }
              },
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }

  updateToDB(BuildContext context) async {
    _formKey.currentState!.save();
    _updateTotal = updateProduct.qty! * updateProduct.price!;
    updateProduct = Product(
      id: selectedID,
      name: updateProduct.name,
      qty: updateProduct.qty,
      price: updateProduct.price,
      total: _updateTotal,
      status: _updateStatus,
    );

    await dbHelper.updateProduct(updateProduct);

    // เช็คว่าข้อมูลถูกแก้ไขแล้ว
    bool isUpdate = true;
    if (isUpdate) {
      Navigator.pop(context, isUpdate);
    }
  }
}
