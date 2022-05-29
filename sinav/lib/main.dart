import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final firestore = FirebaseFirestore.instance.collection("deneme");

List<String> keys = ["veri3", "veri4", "veri5"];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("FireBase'e bağlanıldı.");
  runApp(MaterialApp(
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Password Storage", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                        Text("Store your passwords in Firebase database.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 10),
                        Center(
                          child: CircularProgressIndicator(
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Opacity(
                    child: Image.asset(
                      "assets/splash-screen.jpg",
                      fit: BoxFit.fill,
                    ),
                    opacity: 0.6,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController veriAdi = TextEditingController();
  TextEditingController veri = TextEditingController();
  var sayi;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          focusColor: Colors.blue,
          child: Image.asset(
            "assets/add.png",
            width: 20,
          ),
          backgroundColor: Colors.teal,
          onPressed: () async {
            var response = await firestore.get();
            sayi = response.docs.length + 1;
            firestore.doc("sifre$sayi").set({"sifreYeri" : ""});
            firestore.doc("sifre$sayi").set({"sifre" : ""});
            firestore.doc("sifre$sayi").update({"sifre": veri.text});
            firestore.doc("sifre$sayi").update({"sifreYeri": veriAdi.text});
          },
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: SizedBox(),
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Password Storage"),
                centerTitle: true,
                background: Image.asset(
                  "assets/appbar-background.jpg",
                  fit: BoxFit.fill,
                ),
              ),
              pinned: true,
              backgroundColor: Colors.teal[300],
              expandedHeight: 180,
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Column(
                  children: [
                    Container(
                      child: TextFormField(
                        controller: veriAdi,
                        cursorColor: Colors.cyan,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter the label categorizes password",
                          prefixIcon: Icon(Icons.alternate_email,
                              color: Colors.grey, size: 20),
                        ),
                      ),
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20,
                              color: Colors.blueGrey,
                              blurStyle: BlurStyle.outer,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.transparent),
                    ),
                    Container(
                      child: TextFormField(
                        controller: veri,
                        cursorColor: Colors.cyan,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter password",
                          prefixIcon: Icon(Icons.lock_outline,
                              color: Colors.grey, size: 20),
                        ),
                      ),
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20,
                              color: Colors.blueGrey,
                              blurStyle: BlurStyle.outer,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.transparent),
                    ),
                    SizedBox(
                        child: Center(
                          child: Text(
                            "Your passwords",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan),
                          ),
                        ),
                        height: 60),
                    StreamBuilder(
                        stream: firestore.snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot asyncSnapshot) {
                          List listOfDocSnap = asyncSnapshot.data.docs;
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            child: ListView(
                              children: [
                                for (int i = 0; i < listOfDocSnap.length; i++)
                                  Card(
                                    color: Colors.blueGrey[200],
                                    child: ListTile(
                                      title: Text(
                                        "${i + 1} - ${listOfDocSnap[i].data()["sifreYeri"]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        "Password: ${listOfDocSnap[i].data()["sifre"]}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        })
                  ],
                );
              },
              childCount: 1,
            ))
          ],
        ),
      ),
    );
  }
}