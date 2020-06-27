import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberwidget_hack_20/components/tag_list.dart';
import 'package:cyberwidget_hack_20/components/top_navbar.dart';
import 'package:cyberwidget_hack_20/screens/chat_page/chat_page.dart';
import 'package:cyberwidget_hack_20/screens/home/components/postlist.dart';
import 'package:cyberwidget_hack_20/screens/home/components/tagslist.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List tags=Tags().get_the_listoftags();
  bool isloading=true;
  bool istagselected=false;
  var selectedtag;
  List<Widget> ls=[];
  getvalues(){
    setState(() {
      tags.forEach((element) {
        ls.add(
          GestureDetector(
               onTap: (){
                 setState(() {
                   istagselected=true;
                   selectedtag=element;
                 });
               },
              child: Taglist(element),
          ),
        );
      });
    });
  }
  

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getvalues();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        child: TopNavBar(
          iconLeft: Icons.arrow_back,
          iconRight: FontAwesomeIcons.paperPlane,
          fontAwesomeLeft: false,
          fontAwesomeRight: true,
          textButtonVisibility: false,
          centerTitle: true,
          title: Text(
            "CYBERWIDGET",
            //have to add font family "edo" or "cyberpunk" in pubspec and stylize this
          ),
          onTapLeft: () {
            setState(() {
              // here should be a function to exit the app
            });
          },
          onTapRight: () {
            setState(() {
              Navigator.of(context).pushNamed(ChatPage.routeName);
            });
          },
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          child: Column(
            children: [
              SizedBox(height: 15.0,),
              Container(
                width: width,
                height: 30.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ls,
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                width: width,
                height: height*0.9,
                child: istagselected?StreamBuilder(
//                  Firestore.instance.collection('POST').orderBy
//                    ('Time',descending: false).getDocuments().asStream(),
                  stream: Firestore.instance.collection('POST').
                    getDocuments().asStream(),
                  builder: (context,snapshot){
                    if(!snapshot.hasData || snapshot==null){
                      return Text('No post yet');
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context,index){
                          return Postlist(snapshot.data.documents[index],index);
                    });
                  },
                ):StreamBuilder(
                  stream: Firestore.instance.collection('POST').
                  where('Tag',isEqualTo: selectedtag).getDocuments().asStream(),
                  builder: (context,snapshot){
                    if(!snapshot.hasData || snapshot==null){
                      return Text('No post yet');
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context,index){
                          return Postlist(snapshot.data.documents[index],index);
                        });
                  },
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
