import 'dart:math';

import 'package:flutter/material.dart';
import 'package:patterns_set_state/model/post_model.dart';
import 'package:patterns_set_state/services/network_service.dart';

enum DetailState { create, update }

class DetailPage extends StatefulWidget {
  final Post? post;
  final DetailState state;

  const DetailPage({Key? key, this.post, this.state = DetailState.create})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  bool isLoading = false;

  void init() {
    if (widget.state == DetailState.update) {
      titleController = TextEditingController(text: widget.post!.title);
      bodyController = TextEditingController(text: widget.post!.body);
    }
  }

  void updatePost() async {
    String title = titleController.text.trim();
    String body = bodyController.text.trim();
    Post post = Post(
        id: Random().nextInt(100),
        title: title,
        body: body,
        userId: Random().nextInt(100));
    isLoading = true;
    setState(() {});
    Network.PUT(Network.API_UPDATE, post.toJson()).then((value) {
      Navigator.pop(context, "refresh");
    });
    isLoading = false;
    setState(() {});
  }

  void addPage() async {
    String title = titleController.text.trim();
    String body = bodyController.text.trim();
    Post post = Post(
        id: Random().nextInt(100),
        title: title,
        body: body,
        userId: Random().nextInt(100));
    isLoading = true;
    setState(() {});
    Network.POST(Network.API_UPDATE, post.toJson()).then((value) {
      Navigator.pop(context, "add");
    });
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: widget.state == DetailState.create
            ? const Text("Add post")
            : const Text("Update post"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: titleController,
                  decoration: InputDecoration(
                      label: const Text("Title"),
                      hintText: "Title",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                      border: const OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: bodyController,
                  decoration: InputDecoration(
                      label: const Text("Body"),
                      hintText: "Body",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 20,),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    if (widget.state == DetailState.create) {
                      addPage();
                    } else {
                      updatePost();
                    }
                  },
                  child: const Text("Submit Text"),
                )
              ],
            ),
          ),
          Visibility(
            visible: isLoading,
            child: const CircularProgressIndicator(
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
