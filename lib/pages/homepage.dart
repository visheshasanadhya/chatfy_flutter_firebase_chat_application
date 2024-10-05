import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realtime_chat_app/dataModel/userprofile.dart';
import 'package:realtime_chat_app/database_services.dart';
import 'package:realtime_chat_app/pages/chat.dart';
import 'package:realtime_chat_app/pages/chatTile.dart';
import 'package:realtime_chat_app/pages/userauth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance;
  final currentuser = FirebaseAuth.instance.currentUser;
  final Database _database = Database();

  UserProfile? _profile;
  bool _isLoading = true;

  Future<void> _loadimg() async {
    if (currentuser != null) {
      final userprofile = await _database.getprofileimg(currentuser!.uid);
      setState(() {
        _profile = userprofile;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadimg();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 4.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Conversations",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          leading:Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(

                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: _profile?.pfpURL != null
                      ? NetworkImage(
                    _profile!.pfpURL!,
                  )
                      : null,
                  child: _profile?.pfpURL == null
                      ? const Icon(Icons.person)
                      : null,
                ),
              ),
            ),
          actions: [
            IconButton(
                onPressed: () {
                  user.signOut();
                  Get.off(() => const UserAuth());
                },
                icon: const Icon(
                  Icons.logout,
                  size: 30,
                  color: Colors.black,
                ))
          ],
        ),



        // Add Drawer here
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(_profile?.name ?? 'User'),
                accountEmail: Text(currentuser?.email ?? 'Email not available'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: _profile?.pfpURL != null
                      ? NetworkImage(_profile!.pfpURL!)
                      : null,
                  child: _profile?.pfpURL == null
                      ? const Icon(Icons.person)
                      : null,
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Handle settings tap
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  user.signOut();
                  Get.off(() => const UserAuth());
                },
              ),
            ],
          ),
        ),
        body: Chatlist(context),
      );
    }
  }

  Widget Chatlist(BuildContext context) {
    return StreamBuilder(
        stream: _database.getuserProfiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            final users = snapshot.data!.docs;
            if (users.isEmpty) {
              return const Center(
                child: Text('No Users Found!!'),
              );
            }
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  UserProfile userProfile = users[index].data();
                  return ChatTile(
                      userProfile: userProfile,
                      ontap: () async {
                        final chatexists = await _database.checkuserid(
                            user.currentUser!.uid, userProfile.uid!);
                        if (!chatexists) {
                          await _database.createnewchat(
                              user.currentUser!.uid, userProfile.uid!);
                        }
                        Get.to(() => Chatpage(
                          userProfile: userProfile,
                        ));
                      });
                });
          }
          return const Center(
            child: Text('No Data Found'),
          );
        });
  }
}
