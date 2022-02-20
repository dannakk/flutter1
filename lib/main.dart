import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void main(){
  runApp(App());
}

class Categories {
  final List<String> categories;
  Categories({required this.categories});

  factory Categories.fromJson(List<dynamic> json) {
    return Categories(
      categories: new List<String>.from(json),
    );
  }

  List<dynamic> get() {
    return this.categories;
  }
}

class oneMeme {
  final List<String> categories;
  final String id;
  final String url;
  final String value;
  oneMeme(this.categories, this.id, this.url, this.value);


  }


class ApiProvider {
  final String baseUrl = "https://api.chucknorris.io/";

  Future<dynamic> get(String url) async {
    var responseJson;
    final response = await http.get(Uri.parse(baseUrl + url));
    responseJson = _response(response);
    return responseJson;
  }

  dynamic _response(http.Response response) {
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    } else {
      print("error");
    }
  }
}

class memes {
  ApiProvider _provider = ApiProvider();
  Future<oneMeme> fetchChuckJoke(String category) async {
    final response = await _provider.get("jokes/random?category=" + category);
    return response;
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memes',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: memesHome(title: 'Memes'),
    );
  }
}

class memesHome extends StatefulWidget {
  memesHome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _memesState createState() => _memesState();
}

class _memesState extends State<memesHome> {
  List<oneMeme> jokes = [];
  Future <List<oneMeme>> _getJokes() async {
    var data = await http.get(
        Uri.parse("https://api.chucknorris.io/jokes/random"));

    var jsonJokes = json.decode(data.body);
    print(jsonJokes[0]["value"]);

    for (var joke in jsonJokes["random"]) {
      oneMeme newone = oneMeme(joke["categories"],joke["id"], joke["url"], joke["value"]);
      jokes.add(newone);
      print(newone.value);
    }

    return jokes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container (
            child: FutureBuilder(
              future: _getJokes(),
              builder: (BuildContext context, AsyncSnapshot<List<oneMeme>> snapshot) {
                if(snapshot.data == null) {
                  return Padding(padding: EdgeInsets.all(40),
                    child: Text("sorry not loading"),);
                } else {
                  return ListTile(
                    title: Text(snapshot.data![0].value),
                  );
                }
              },
            )
        )
        );
  }
}



