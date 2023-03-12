
import 'package:blog_app/screens/add_content_screen.dart';
import 'package:blog_app/screens/log_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String search= "";
  //for fetch data create database reference
  final dbRef = FirebaseDatabase.instance.ref().child("posts");
  //Firebase auth for log out
  FirebaseAuth auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Write Your Blog"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddContentScreen()));
              },
              child: const Icon(Icons.add)),
          const SizedBox(width: 10,),
          InkWell(
              onTap: () {
                auth.signOut().then((value) => Navigator.push(context, 
                   MaterialPageRoute(builder: (context)=>const LogInScreen())));
              },
              child: const Icon(Icons.logout)),

          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller:_searchController,
              keyboardType: TextInputType.emailAddress,
              decoration:  InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50)
                  ),
                  labelText: 'Search',
                  hintText: 'Search By your Blog Title',
                  prefix: Icon(
                    Icons.search,
                    color: Colors.purple,
                  )),
              onChanged: (String value) {
                setState(() {

                });
              },

            ),
            Expanded(
                child: FirebaseAnimatedList(
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                //blog title assign in temporaray value so that it can chechk
                String tempTitle =snapshot.child("pTitle").value.toString();
                //creating condition for search
                if(_searchController.text.isEmpty){

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/home_logo.png",
                            image: snapshot.child("pImage").value.toString(),
                            height: MediaQuery.of(context).size.height/2,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,),
                        ),
                        const SizedBox(height: 5,),
                        Text(snapshot.child("pTitle").value.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),

                        ),
                        const SizedBox(height: 5,),
                        Text(snapshot.child("pDescription").value.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal
                          ),
                        ),

                      ],
                    ),
                  );
                }else if( tempTitle.toLowerCase().contains(_searchController.text.toString())){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/home_logo.png",
                            image: snapshot.child("pImage").value.toString(),
                            height: MediaQuery.of(context).size.height/2,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,),
                        ),
                        const SizedBox(height: 5,),
                        Text(snapshot.child("pTitle").value.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),

                        ),
                        const SizedBox(height: 5,),
                        Text(snapshot.child("pDescription").value.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal
                          ),
                        ),

                      ],
                    ),
                  );
                }else{
                  return Container();
                }


              },
              query: dbRef.child("Post List"),
            )),
          ],
        ),
      ),
    );
  }
}
