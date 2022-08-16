import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:patterns_set_state/pages/detail_page.dart';
import 'package:patterns_set_state/services/network_service.dart';

import '../model/post_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> items = [];
  bool isLoading = false;

  void apiPostList() async {
    isLoading = true;
    setState(() {});
    String? response =
        await Network.GET(Network.API_LIST, Network.paramsEmpty());
    if (response != null) {
      items = Network.parsePostList(response);
    } else {
      items = [];
    }
    isLoading = false;

    setState(() {});
  }

  void apiPostDelete(Post post) async {
    isLoading = true;
    setState(() {});
    String? response = await Network.DEL(
        Network.API_DELETE + post.id.toString(), Network.paramsEmpty());
    if (response != null) {
      apiPostList();
    }
    isLoading = false;
    setState(() {});
  }

  void goToDetailPage() async {
    String? response =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const DetailPage(
        state: DetailState.create,
      );
    }));
    if (response == "add") {
      apiPostList();
    }
  }
  void goToDetailPageUpdate(Post post) async {
    String? response =
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return DetailPage(
        post: post,
        state: DetailState.update,
      );
    }));
    if (response == "refresh") {
      apiPostList();
    }
  }

  @override
  void initState() {
    super.initState();
    apiPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return itemsOfPost(items[index]);
              }),
          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          goToDetailPage();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget itemsOfPost(Post post) {
    return Slidable(
      key: ValueKey(post),
      startActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              goToDetailPageUpdate(post);
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.update,
          ),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              apiPostDelete(post);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [
            Text(
              post.title.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              post.body,
              style: const TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
