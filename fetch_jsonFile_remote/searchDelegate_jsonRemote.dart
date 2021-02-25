import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//This is in javascript the ajax request
Future<List<Post>> fetchPosts(http.Client client) async {
  final response = await client
      .get('https://website.com/test.json');
  //sending the body to be parsed , sent as string
  return parsePosts(response.body);
}

List<Post> parsePosts(String responseBody) {
  //parse using json decode
  final parsed = json.decode(responseBody);
  //we need to use the parsed code to make a map (object in dart)
  //-------------------------------------
  Map<String, dynamic> toObject = parsed["content"];
  List tricks = [];
  //get each id/value and save the values in a new array (in flutter called list)
  toObject.forEach((k,v){
    Map<String, dynamic> trick = v;
    tricks.add(trick);

  });

  return tricks.map<Post>((json) => Post.fromJson(json)).toList();

}

class Post {
  String title;
  String youtubeid;
  String time_start;
  String time_end;
  String desc;
  int level;

  Post({this.title, this.youtubeid, this.time_start, this.time_end, this.desc, this.level});

  Post.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    youtubeid = json['youtubeid'];
    time_start = json['time_start'];
    time_end = json['time_end'];
    desc = json['desc'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['youtubeid'] = this.youtubeid;
    data['time_start'] = this.time_start;
    data['time_end'] = this.time_end;
    data['desc'] = this.desc;
    data['level'] = this.level;
    return data;
  }
}

Future<List<Post>> _search() async {
 List posts = await fetchPosts(http.Client());
 return posts;
}


class DataSearch extends SearchDelegate<List>{
  @override
  ThemeData appBarTheme(BuildContext context) {
      return ThemeData(
        primaryColor: appTheme.bgLight,
      );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
      // TODO: implement buildActions
      return [IconButton(icon: Icon(Icons.clear), onPressed: () {
        query="";
      },)];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      // TODO: implement buildLeading
      return IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
        close(context, null);
      });
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // TODO: implement buildResults
      throw UnimplementedError();
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return FutureBuilder<List<Post>>(
      future: _search(),
      builder: (context, snapshot) {
        //depnding on the state of the response we show something
        switch (snapshot.connectionState){
          case ConnectionState.none:
            return Text('none');
          case ConnectionState.active:
            return Text('active');
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            //get the data from the stream futurebuilder and see if the text exist or not
            var dt = snapshot.data.where((p)=> p.title.toLowerCase().contains(query.toLowerCase())).toList();
            return dt.isEmpty? Text("No results found...", style: TextStyle(color: Colors.red)) : ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  if(query.isEmpty){
                    return ListTile(
                      minVerticalPadding: 0,
                      contentPadding: EdgeInsets.all(0),
                      leading: Wrap(
                        children: [
                          Container(
                            height: 100.0,
                            child: Image.network("https://img.youtube.com/vi/${snapshot.data[index].youtubeid}/2.jpg", fit: BoxFit.cover),
                        ),
                        ],
                      ),
                      title: Container(
                        padding: EdgeInsets.symmetric(vertical: sizeBuild(context,"height", 10)),
                        height: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: appTheme.dark, fontSize: fontSizeBuild(context,"body"), fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height:5,
                            ),
                            Text(
                              snapshot.data[index].desc,
                              style: TextStyle(color: appTheme.grey, fontSize: fontSizeBuild(context,"small")),
                            ),
                            SizedBox(
                              height:5,
                            ),
                            Text(
                              "Lv: ${snapshot.data[index].level.toString()}",
                              style: TextStyle(color: appTheme.grey, fontSize: fontSizeBuild(context,"small")),
                            ),
                          ],
                        ),
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(right:sizeBuild(context,"width", 5)),
                        child: ClipOval(
                            child: Container(
                              height: sizeBuild(context,"height", 22),
                              width: sizeBuild(context,"width", 50),
                              color: appTheme.grey.withOpacity(.7),
                              alignment: Alignment.center,
                              child: Text(
                                dt[index].level.toString(),
                                style: TextStyle(color: appTheme.text, fontSize: fontSizeBuild(context,"h6")),
                              ),
                            ),
                          ),

                      ), 
                      onTap: () {

                      },
                    );
                  }else{
                    return ListTile(
                      leading: Container(
                        child: Image.network("https://img.youtube.com/vi/${snapshot.data[index].youtubeid}/0.jpg", fit: BoxFit.cover),
                      ),
                      title:  Container(
                        padding: EdgeInsets.symmetric(vertical: sizeBuild(context,"height", 10)),
                        height: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: appTheme.dark, fontSize: fontSizeBuild(context,"body"), fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height:5,
                            ),
                            Text(
                              snapshot.data[index].desc,
                              style: TextStyle(color: appTheme.grey, fontSize: fontSizeBuild(context,"small")),
                            ),
                            SizedBox(
                              height:5,
                            ),
                            Text(
                              "Lv: ${snapshot.data[index].level.toString()}",
                              style: TextStyle(color: appTheme.grey, fontSize: fontSizeBuild(context,"small")),
                            ),
                          ],
                        ),
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(right:sizeBuild(context,"width", 5)),
                        child: ClipOval(
                            child: Container(
                              height: sizeBuild(context,"height", 22),
                              width: sizeBuild(context,"width", 50),
                              color: appTheme.dark,
                              alignment: Alignment.center,
                              child: Text(
                                dt[index].level.toString(),
                                style: TextStyle(color: appTheme.text, fontSize: fontSizeBuild(context,"h6")),
                              ),
                            ),
                          ),

                      ), 
                      onTap: () {
                        //use the below code to close the searchdelegate
                        // close(context, snapshot.data[index]);
                      },
                    );
                  }
                },
                itemCount: dt.length,
              );
        }
      },
    );
  }

}