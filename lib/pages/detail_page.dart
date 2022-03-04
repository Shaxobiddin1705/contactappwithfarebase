import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import '../models/contact_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../services/store_service.dart';
import '../services/real_time_database.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.message, required this.index}) : super(key: key);
  static const String id = 'detail_page';
  final String? index;
  final String? message;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  File? _image;
  bool onPressed = false;
  bool isLoading = false;

  Future<void> getImage({required ImageSource source}) async{
    // Navigator.pop(context);
    final image = await ImagePicker().pickImage(source: source);
    if(image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _addPost() {
    String name = nameController.text.trim().toString();
    String phoneNumber = phoneNumberController.text.trim().toString();
    final FirebaseAuth  _auth = FirebaseAuth.instance;
    // final _database = FirebaseDatabase.instance.ref();
    setState(() {
      isLoading = true;
    });
    StoreService.uploadImage(_image!).then((value) => {
      RTDService.addContact(Contact(name: name,phoneNumber: phoneNumber,imageUrl: value!)).then((value) {
        setState(() {
          isLoading = false;
        });
        _goHomePage();
      }),
    });
  }

  void _updatePost() {
    String name = nameController.text.trim().toString();
    String phoneNumber = phoneNumberController.text.trim().toString();

    setState(() {
      isLoading = true;
    });

    RTDService.updateContact(name: name, phoneNumber: phoneNumber, key: contacts[int.parse(widget.index!)].key, imageUrl: contacts[int.parse(widget.index!)].imageUrl).then((value) {
      setState(() {
        isLoading = false;
      });
      _goHomePage();
    });
  }

  void _goHomePage() {
    Navigator.pop(context, 'done');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if(widget.message == 'edit') {
      nameController = TextEditingController(text: contacts[int.parse(widget.index!)].name);
      phoneNumberController = TextEditingController(text: contacts[int.parse(widget.index!)].phoneNumber);
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: widget.message == 'new' ? Text("Create new contact") : Text(''),
        actions: [
          IconButton(
              onPressed: (){
                widget.message == 'new' ? _addPost() : _updatePost();
              },
              icon: Icon(Icons.done_outline_rounded)
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50,),
                  GestureDetector(
                    onTap: () {
                      getImage(source: ImageSource.gallery);
                    },
                    child: GestureDetector(
                      onTap: () {
                        if(widget.message == 'new') {
                          getImage(source: ImageSource.gallery);
                        }
                      },
                      child: Container(
                        height: 180,
                        width: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: widget.message == 'edit' && contacts[int.parse(widget.index!)].imageUrl != null ? CachedNetworkImage(
                            imageUrl: contacts[int.parse(widget.index!)].imageUrl, fit: BoxFit.cover,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ) :
                          _image != null ? Image(image: FileImage(File(_image!.path)), fit: BoxFit.cover,) : Image.asset('assets/images/download.png'),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15,),

                  //#Name
                  TextField(
                    controller: nameController,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(color: CupertinoColors.systemGrey2),
                        border: InputBorder.none
                    ),
                  ),

                  //#PhoneNumber
                  TextField(
                    controller: phoneNumberController,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                        hintText: 'PhoneNumber',
                        hintStyle: TextStyle(color: CupertinoColors.systemGrey2),
                        border: InputBorder.none
                    ),
                  ),
                ],
              ),
            ),
          ),

          isLoading ? Center(child: Lottie.asset('assets/animations/loading_2.json', height: 280, animate: true)) : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
