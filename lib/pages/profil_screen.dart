import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'login_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      //thanks for watching
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xffB81736),
              Color(0xff281537),
            ]),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 60.0, left: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    image:
                        DecorationImage(image: AssetImage('assets/avatar.jpg')),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'Hana',
                      style: TextStyle(fontSize: 28),
                    ),
                    Text(
                      'Hana@gmail.com',
                      style: TextStyle(fontSize: 13),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      child: MaterialButton(
                        onPressed: () {
                          //  pushNewScreenWithRouteSettings(context,
                          //     screen: EditProfil(),
                          //    settings: RouteSettings(),
                          //  withNavBar: false,
                          // pageTransitionAnimation: PageTransitionAnimation.cupertino);
                        },
                        child: ListTile(
                          title: Text("Modifier Profile"),
                          leading: Icon(Icons.edit_document),
                          trailing: Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    child: MaterialButton(
                      onPressed: () {},
                      child: ListTile(
                        title: Text("Historique"),
                        leading: Icon(Icons.edit_document),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    child: MaterialButton(
                      onPressed: () {
                        //  pushNewScreenWithRouteSettings(context,
                        //      screen: EditProfil(),
                        //     settings: RouteSettings(),
                        //    withNavBar: false,
                        //   pageTransitionAnimation: PageTransitionAnimation.cupertino);
                      },
                      child: ListTile(
                        title: Text("Modifier Votre Boutique"),
                        leading: Icon(Icons.edit_document),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    child: MaterialButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                                maintainState: false));
                      },
                      child: ListTile(
                        title: Text("LogOut"),
                        leading: Icon(Icons.exit_to_app),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
