import 'package:flutter/material.dart';
import 'package:thanawat_shop/database.dart';
import 'package:thanawat_shop/page/createpage.dart';
import 'package:thanawat_shop/page/updatepage.dart';
import 'package:thanawat_shop/product.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Product product = Product();
  List<Product> productlist = [];
  DatabaseSQL dbHelper = DatabaseSQL();


  //ตัวแปรใน listview
  late int updateIndex;
  late String pdName;
  late int pdQuan;
  late double pdPrice;
  late double pdTotal;
  late bool pdStatus;

  @override
  void initState(){
    super.initState();
    product.status = false;
    _refreshList();
  }

  _refreshList() async{
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
     
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
         
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildLisView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)  => CreatePage())).then((value) {
            setState(() {
              _refreshList();
            });
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }

  Widget buildLisView(){
    return  Expanded(
      child: Scrollbar(child: ListView.builder(itemBuilder: (context,index){
        pdName = productlist[index].name!;  // `!` หมายถึง name เป็นค่า null
        pdQuan = productlist[index].qty!;
        pdPrice = productlist[index].price!;
        pdTotal = productlist[index].total!;
        pdStatus = productlist[index].status!;
        return ListTile(
          title: Text(pdName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('จำนวน : $pdQuan'),
              Text('ราคาต่อหน่วย : $pdPrice'),
              Text('ยอดรวม : $pdTotal'),
              Text('สต๊อกสินค้า : ${pdStatus ? 'มี' : 'ไม่มี'}'),
            ],
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)  => UpdatePage(productlist[index]))).then((value) => {
                    setState(() {
                      _refreshList();
                    })
                   });
                }, icon:  Icon(Icons.edit, color: Colors.blue,)),
                IconButton(onPressed: (){
                  dbHelper.deleteProduct(productlist[index].id!).then((value){
                    setState(() {
                      _refreshList();
                    });
                  });
                }, icon:  Icon(Icons.delete, color: Colors.red,))
              ],
            ),
          ),
        );
      },
      itemCount: productlist.isEmpty ? 0 : productlist.length,
      )),
    );
  }

}
