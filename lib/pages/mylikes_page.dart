// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/post_model.dart';
import '../servis_pages/db_service.dart';
import 'package:http/http.dart' as http;

import '../servis_pages/utils_service.dart';

class MyLikesPage extends StatefulWidget {
  const MyLikesPage({Key? key}) : super(key: key);

  @override
  State<MyLikesPage> createState() => _MyLikesPageState();
}

class _MyLikesPageState extends State<MyLikesPage> {


  List<Post> items = [];
  bool isLoading = false;
  List<Map<String, dynamic>> likedPosts = [];

  void loadPosts() async {
    setState(() {
      isLoading = true;
    });
    List<Post> posts = await DataService.loadLikes();
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  void loadFeeds() async {
    setState(() {
      isLoading = true;
    });
    List<Post> posts = await DataService.loadPosts();
    posts.addAll(await DataService.loadFeeds());
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  void removePost(Post post) async {
    bool isYes = await Utils.commonDialog(context, "Postni o'chirish", "Ushbu postni o'chirasizmi?", "Ha", "Yo'q", false);
    if (isYes) {
      await DataService.removePost(post);
      loadFeeds();
    }
  }

  @override
  void initState() {
    loadFeeds();
    loadPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            title: Text("Likes", style: TextStyle(fontFamily: "billabong", color: Colors.black, fontSize: 28),),
          ),
          body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _itemOfPost(items[index]);
            },
          ),
        ),
        (isLoading) ?
        Scaffold(
          backgroundColor: Colors.grey.withOpacity(.3),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ) : SizedBox(),
      ],
    );
  }

  Widget _itemOfPost(Post post) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Divider(),
          // #user info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: (post.imgUser!.isEmpty) ?
                        Image(
                          height: 40,
                          width: 40,
                          image: AssetImage("assets/images/ic_userImage.png"),
                        ) :
                        Image.network(
                          post.imgUser.toString(),
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        )
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.fullName!, style: TextStyle(fontWeight: FontWeight.bold,),),
                        Text(post.date!),
                      ],
                    )
                  ],
                ),
                (post.mine) ?
                IconButton(
                  onPressed: (){
                    removePost(post);
                  },
                  icon: Icon(Icons.more_horiz),
                ) : SizedBox(),
              ],
            ),
          ),
          // #post image
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            imageUrl: post.imgPost.toString(),
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
          ),
          // #buttons
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                    await DataService.likePost(post, false);
                    loadPosts();
                  },
                  icon: Icon(FontAwesome.heart, color: Colors.red,),
                ),
                SizedBox(width: 10,),
                IconButton(
                  onPressed: () async {

                    final uri = Uri.parse(post.imgPost.toString());
                    final response = await http.get(uri);
                    final bytes = response.bodyBytes;
                    final temp = await getTemporaryDirectory();
                    final path = '${temp.path}/image.jpg';
                    File(path).writeAsBytesSync(bytes);
                    await Share.shareFiles([path], text:'User: ${post.fullName}\nPost sanasi: ${post.date}\nContent: ${post.caption}');
                  },
                  icon: Icon(FontAwesome.paper_plane),
                ),
              ],
            ),
          ),
          // #caption
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(10),
            child: Text(post.caption!),
          ),
        ],
      ),
    );
  }

}