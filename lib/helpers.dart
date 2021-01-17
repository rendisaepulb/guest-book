const String guestBookBoxName = 'guest_book';
const String TABLENAME = 'guest_book';

// class Helpers {
//   static Future<Database> database() async {
//     return await openDatabase(
//       join(await getDatabasesPath(), 'guest_book_database.db'),
//       onCreate: (db, version) {
//         return db.execute(
//           "CREATE TABLE $TABLENAME(id INTEGER PRIMARY KEY, name TEXT, address TEXT, arrival_date INTEGER)",
//         );
//       },
//       // Set the version. This executes the onCreate function and provides a
//       // path to perform database upgrades and downgrades.
//       version: 1,
//     );
//   }

//   static Future<List<GuestModel>> guestList() async {
//     final db = await database();

//     final maps = await db.query(TABLENAME);

//     return maps.map((e) => GuestModel.fromJson(e)).toList();
//   }

//   static Future<void> insertGuest(GuestModel guest) async {
//     final db = await database();

//     await db.transaction((txn) async {
//       final args = guest.toMap().entries.map((e) => e.value).toList();
//       await txn.rawInsert(
//         'INSERT INTO $TABLENAME(name, address, arrival_date) VALUES(?, ?, ?)',
//         args,
//       );
//     });
//   }

//   static Future<void> updateGuest(GuestModel guest) async {
//     final db = await database();

//     await db.update(
//       TABLENAME,
//       guest.toMap(),
//       where: "id = ?",
//       // whereArgs: [guest.id],
//     );
//   }

//   static Future<void> deleteGuest(int id) async {
//     final db = await database();

//     await db.delete(
//       TABLENAME,
//       where: "id = ?",
//       whereArgs: [id],
//     );
//   }
// }
