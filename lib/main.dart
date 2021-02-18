import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Tenor GIF API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String searchValue = "batman";
  List gifs = List(8);
  Future<void> getGif() async {
    var gifData = await http.get(
        "https://g.tenor.com/v1/search?q=$searchValue&key=LIVDSRZULELA&limit=8");
    var gifDataParsed = jsonDecode(gifData.body);
    setState(() {
      for (int i = 0; i < 8; i++) {
        gifs[i] = gifDataParsed["results"][i]["media"][0]["tinygif"]["url"];
      }
    });
  }

  _launchUrl() async {
    if (await canLaunch(gifs[0])) {
      await launch(gifs[0]);
    } else {
      throw "Couldnt launch";
    }
  }

  Future<void> waitAPI() async {
    await getGif();
  }

  @override
  void initState() {
    // TODO: implement initState
    waitAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text("Click the gif to download"),
            ),
              Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              width: 320,
              height: 62,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black38)),
              child: TextField(
              
                onChanged: (value) {
                  searchValue = value;
                },
                decoration: InputDecoration(
              hintText: "Search Gif",
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
            FlatButton(
              
              color: Colors.grey,
              onPressed: () {
                getGif();
              },
              child: Text("Get Gif"),
            ),
            gifs[0] == null
                ? SpinKitFadingCircle(
                    color: Colors.blue,
                    size: 50,
                  )
                : Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height,
                            child: ListView.separated(
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap:() {
                                    _launchUrl();
                                  },
                                  child: Image.network(
                                    gifs[index],
                                    fit: BoxFit.fitWidth,
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                  thickness: 5,
                                  height: 5,
                                  color: Colors.blue,
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
