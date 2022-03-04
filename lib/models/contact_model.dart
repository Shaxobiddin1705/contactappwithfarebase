class Contact{

  late String name;
  late String phoneNumber;
  late String imageUrl;
  late String key;

  Contact({required this.name, required this.phoneNumber, required this.imageUrl});

  Contact.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    imageUrl = json['imageUrl'];
    key = json['key'];
  }

  Map<dynamic, dynamic> toJson() => {
    'name': name,
    'phoneNumber': phoneNumber,
    'imageUrl': imageUrl,
  };
}

List<Contact> contacts = [];
List<String> keys = [];
