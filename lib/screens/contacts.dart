import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/components/contact_list_builder.dart';
import 'package:privatechat/components/contacts_search_bar.dart';
import 'package:privatechat/components/no_contact_found_img.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

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
            child: ContactScreenSearchBar(
              searchController: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            )),
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
            return const NoContactsFound();
          } else {
            return ContactList(filteredUserDocs: filteredUserDocs);
          }
        },
      ),
    );
  }
}
