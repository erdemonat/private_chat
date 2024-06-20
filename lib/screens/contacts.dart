import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/constants.dart';
import 'package:privatechat/screens/chat.dart';

class ContactsScreen extends StatefulWidget {
  ContactsScreen({super.key});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  var db = FirebaseFirestore.instance;
  final authenticatedUser = FirebaseAuth.instance.currentUser!;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('An error occurred'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No contacts found'));
          }

          var userDocs = snapshot.data!.docs;
          var filteredUserDocs = userDocs.where((doc) {
            var username = doc['username'].toString().toLowerCase();
            return username.contains(searchQuery.toLowerCase());
          }).toList();

          if (filteredUserDocs.any((doc) =>
              doc['username'].toString().toLowerCase() !=
              searchController.text.toLowerCase())) {
            return Center(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: SizedBox(
                      height: 150,
                      child: Image.asset(
                        'assets/images/ghost.png',
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No contact here',
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: ListView.separated(
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                itemCount: filteredUserDocs.length,
                itemBuilder: (context, index) {
                  var user = filteredUserDocs[index];

                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              recipientUserId: user.id,
                              recipientUsername: user['username'],
                            ),
                          ));
                    },
                    title: Text(
                      user['username'],
                      style: kUsernameTextStyle(context),
                    ),
                    subtitle: Text(
                      user['status'],
                      style: kSubTextStyle(context),
                    ),
                    leading: CircleAvatar(
                      radius: 24,
                      child: ClipOval(
                        child: Image.network(
                          width: 48,
                          height: 48,
                          user['image_url'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
