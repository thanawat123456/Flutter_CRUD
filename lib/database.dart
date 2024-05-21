import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thanawat_shop/product.dart';

class DatabaseSQL {
  String DB_NAME = 'shop.sqlite3';
  String TABLE = 'Product';
  String ID = 'id';
  String NAME = 'name';
  String QTY = 'qty';
  String PRICE = 'price';
  String TOTAL = 'total';
  String STATUS = 'status';

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $TABLE (
            $ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $NAME TEXT,
            $QTY INTEGER,
            $PRICE REAL,
            $TOTAL REAL,
            $STATUS INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> createProduct(Product product) async {
    final Database db = await initDatabase();
    await db.insert(TABLE, product.toMap());
  }

  Future<List<Product>> readProduct() async {
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query(TABLE);
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i][ID],
        name: maps[i][NAME],
        qty: maps[i][QTY],
        price: maps[i][PRICE],
        total: maps[i][TOTAL],
        status: maps[i][STATUS] == 1,
      );
    });
  }

  Future<void> updateProduct(Product product) async {
    final Database db = await initDatabase();
    await db.update(TABLE, product.toMap(), where: '$ID = ?', whereArgs: [product.id]);
  }

  Future<void> deleteProduct(int id) async {
    final Database db = await initDatabase();
    await db.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }
}
