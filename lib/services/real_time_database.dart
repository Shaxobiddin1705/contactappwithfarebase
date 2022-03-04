import 'package:firebase_database/firebase_database.dart';

import '../models/contact_model.dart';

class RTDService {
  static final _database = FirebaseDatabase.instance.ref();

  static Future<Stream> addContact(Contact contact) async {
    _database.child('contacts').push().set(contact.toJson());
    return _database.onChildAdded;
  }

  static Future<Stream> updateContact({required name, required phoneNumber, required key, required imageUrl}) async{
    await _database.child('contacts').child(key).update({
      'name' : name,
      'phoneNumber': phoneNumber,
      'imageUrl' : imageUrl
    });
    return _database.onChildAdded;
  }

  static Future<void> deleteContact({required key}) async{
    await _database.child('contacts').child(key).remove();
  }

  static Future<List<Contact>> getContacts() async {
    List<Contact> items = [];
    Query _query = _database.child('contacts').orderByChild('key');
    var result = await _query.once();

    items = result.snapshot.children.map((e) {
      Map<String, dynamic> contact = Map<String, dynamic>.from(e.value as Map);
      contact['key'] = e.key;
      return Contact.fromJson(contact);
    }).toList();
    return items;
  }
}
