import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/item.dart';

class ItemDatabase {
  final CollectionReference itemsRef = FirebaseFirestore.instance.collection('items');

  Future<void> addItem(Item item) async { //creates
    await itemsRef.add(item.toMap());
  }

  Stream<List<Item>> streamItems() { //read from real-time stream
    return itemsRef.snapshots().map(
          (snap) => snap.docs
              .map((d) =>
                  Item.fromMap(d.id, d.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  Future<void> updateItem(Item item) async { //update
    await itemsRef.doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String id) async {
    await itemsRef.doc(id).delete();
  }
}

