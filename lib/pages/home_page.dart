import 'package:cached_network_image/cached_network_image.dart';
import 'package:contactappwithfarebase/models/contact_model.dart';
import 'package:contactappwithfarebase/pages/detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../services/store_service.dart';
import '../services/hive_service.dart';
import '../services/real_time_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool onPressed = false;

  void _loadPosts() async{
    var _auth = FirebaseAuth.instance;
    // String uid = HiveDB.loadUserId();
    RTDService.getContacts().then((items) {
      _showResponse(items);
    });
  }

  _showResponse(List<Contact> items) {
    setState((
        ) {
      contacts = items;
    });
  }

  _deletePost({required key, required index}) {
    RTDService.deleteContact(key: key);
    StoreService.deleteImage(contacts[index].imageUrl);
    _loadPosts();
  }

  @override
  void initState() {
    _loadPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Contacts"),
      ),
      body: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return Slidable(
                endActionPane: ActionPane(
                  extentRatio: 0.4,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) async{
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(message: 'edit', index: index.toString(),))).then((value) {
                          if(value == 'done') {
                            setState(() {
                              _loadPosts();
                            });
                          }
                        });
                      },
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                    ),

                    SlidableAction(
                      onPressed: (_){
                        setState(() {
                          _deletePost(key: contacts[index].key, index: index);
                        });
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_rounded,
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () async{
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(message: 'edit', index: index.toString()))).then((value) {
                      if(value == 'done') {
                        setState(() {
                          _loadPosts();
                        });
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: contacts[index].imageUrl != null ? CachedNetworkImage(
                              imageUrl: contacts[index].imageUrl, fit: BoxFit.cover,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ) : Image.asset('assets/images/download.png'),
                          ),
                        ),
                        const SizedBox(width: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(contacts[index].name, style: const TextStyle(fontSize: 19),),
                            const SizedBox(height: 5,),
                            Text(contacts[index].phoneNumber, style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailPage(message: 'new', index: '0'))).then((value) {
            setState(() {
              _loadPosts();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
