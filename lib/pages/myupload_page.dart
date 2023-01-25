import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/servis_pages/db_service.dart';
import 'package:instagram_clone/servis_pages/file_service.dart';
import '../models/post_model.dart';

class MyUploadPage extends StatefulWidget {
  final PageController? pageController;
  const MyUploadPage({Key? key, this.pageController}) : super(key: key);

  @override
  State<MyUploadPage> createState() => _MyUploadPageState();
}

class _MyUploadPageState extends State<MyUploadPage> {

  File? _image;
  final ImagePicker _picker = ImagePicker();
  TextEditingController captionController = TextEditingController();
  bool isloading = false;

  void doUpload() {
    String caption = captionController.text;
    if (caption.isEmpty || _image == null) {
      return;
    } else {
      print(caption);
      setState(() {
        isloading = true;
      });
      FileService.uploadMemberImage(_image!).then((value) => {
        resPostImage(value),
      });
      // _image = null;
      // captionController.clear();
      // widget.pageController?.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    }
  }

  void resPostImage( String downloadUrl) async {
    String caption = captionController.text.trim();
    print(caption);
    Post post = Post(caption : caption, imgPost: downloadUrl);
    await DataService.storePost(post);
    setState(() {
      isloading = false;
    });
    _image = null;
    captionController.clear();
    widget.pageController?.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            title: Text("Upload", style: TextStyle(fontFamily: "billabong", fontSize: 28, color: Colors.black),),
            actions: [
              IconButton(
                onPressed: doUpload,
                icon: Icon(Icons.add_photo_alternate_outlined, color: Colors.purple),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      (_image == null) ?
                      GestureDetector(
                        onTap: _showPicker,
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width,
                          color: Colors.grey.withOpacity(.4),
                          child: Center(
                            child: Icon(Icons.add_a_photo, size: 45),
                          ),
                        ),
                      ) :
                      Stack(
                        children: [
                          Image.file(
                            _image!,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: (){
                                setState(() {
                                  _image = null;
                                });
                              },
                              icon: Icon(Icons.highlight_remove, color: Colors.black,),
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: captionController,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: "Caption",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        (isloading) ?
        Scaffold(
          backgroundColor: Colors.grey.withOpacity(.3),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ) : SizedBox(),
      ],
    );
  }
  void _showPicker(){
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Pick Photo"),
                onTap: (){
                  _imgFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text("Take Photo"),
                onTap: (){
                  _imgFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _imgFromGallery() async {
    XFile? image = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    setState(() {
      _image = File(image!.path);
    });
  }

  void _imgFromCamera() async {
    XFile? image = await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      _image = File(image!.path);
    });
  }


}
