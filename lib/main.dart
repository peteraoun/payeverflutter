import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My Application',
      theme: new ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: new MyHomePage(title: 'Users List'),
    );
  }
}

class MyHomePage extends StatefulWidget{
  MyHomePage({Key key, this.title}) : super (key:key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State <MyHomePage>{

  Future<int> _getPages() async{
    var data = await http.get("https://reqres.in/api/users?page=1");

    var jsonData = json.decode(data.body);

    int pages = jsonData["total_pages"];

    return(pages);
  }

  Future<List<User>> _getUsers() async{
    int i = await _getPages();
    List<User> users = [];
    for(int x= 1; x <= i; x++)
      {
        var data = await http.get("https://reqres.in/api/users?page=" + x.toString());
        var jsonData = json.decode(data.body);

        for(var u in jsonData["data"]){
          User user = User(u["id"],u["email"],u["first_name"],u["last_name"],u["avatar"]);
          users.add(user);
        }
      }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
          child:FutureBuilder(
              future: _getUsers(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.data==null){
                  return Container(
                    child: Center(
                      child: Text("Loading.."),
                    ),
                  );
                } else{
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(
                        contentPadding: EdgeInsets.all(10.0),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data[index].avatar),
                        ),
                        title: Text(snapshot.data[index].first_name + " " + snapshot.data[index].last_name,
                          style:
                            TextStyle(fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54) ,),
                        onTap: () {
                          Navigator.push(context, 
                          new MaterialPageRoute(builder: (context) => MoreInfo(snapshot.data[index])));
                        },
                      );
                      },
                  );
                }
              }
          )
      ),
    );
  }
}

class MoreInfo extends StatelessWidget {
  final User user;

  MoreInfo(this.user);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("User Profile"),
     ),
       body: new Stack(
         alignment: Alignment.center,
         children: <Widget>[
           Positioned(
               width: 250.0,
               child: Column(
                 children: <Widget>[
                   Container(
                       width: 250.0,
                       height: 250.0,
                       decoration: BoxDecoration(
                           color: Colors.red,
                           image: DecorationImage(
                               image: NetworkImage(
                                   user.avatar),
                               fit: BoxFit.cover),
                           borderRadius: BorderRadius.all(Radius.circular(75.0)),
                           boxShadow: [
                             BoxShadow(blurRadius: 7.0, color: Colors.black)
                           ])),
                   SizedBox(height: 90.0),
                   Container(
                       height: 60.0,
                       width: 200.0,
                       child: Material(
                         borderRadius: BorderRadius.circular(20.0),
                         shadowColor: Colors.lightBlueAccent,
                         color: Colors.blue,
                         elevation: 7.0,
                         child: Center(
                           child: Text(
                             user.first_name + " " + user.last_name,
                             style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 26.0),
                           ),
                         ),
                       )),
                   SizedBox(height: 25.0),
                   Container(
                       height: 30.0,
                       width: 95.0,
                       child: Material(
                         borderRadius: BorderRadius.circular(20.0),
                         shadowColor: Colors.greenAccent,
                         color: Colors.green,
                         elevation: 7.0,
                         child: Center(
                           child: Text(
                             "ID: " + user.id.toString(),
                             style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                           ),
                         ),
                       )),
                   SizedBox(height: 25.0),
                   Container(
                       height: 30.0,
                       width: 240,
                       child: Material(
                         borderRadius: BorderRadius.circular(20.0),
                         shadowColor: Colors.redAccent,
                         color: Colors.red,
                         elevation: 7.0,
                         child: Center(
                         child: Text(
                           "E-mail: " + user.email,
                           style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                         ),
                       ),
                       ))
                 ],
               ))
         ],
       )
   );
}
}


class User{
  int id;
  String email;
  String first_name;
  String last_name;
  String avatar;

  User(this.id, this.email, this.first_name, this.last_name, this.avatar);
}
