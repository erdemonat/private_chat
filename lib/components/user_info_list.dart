import 'package:flutter/material.dart';
import 'package:privatechat/components/my_list_tile.dart';
import 'package:privatechat/model/my_list_tile_model.dart';

class UserInfoList extends StatelessWidget {
  final String username;
  final String status;
  final String email;
  final ValueChanged<ListModel> onUpdateUsername;
  final ValueChanged<ListModel> onUpdateStatus;
  final ValueChanged<ListModel> onUpdateEmail;

  const UserInfoList({
    required this.username,
    required this.status,
    required this.email,
    required this.onUpdateUsername,
    required this.onUpdateStatus,
    required this.onUpdateEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          EditableListTile(
            model: ListModel(title: 'Username', subTitle: username),
            onChanged: onUpdateUsername,
            hintText: 'Enter username (max 12 chars)',
            maxLength: 12,
          ),
          EditableListTile(
            model: ListModel(title: 'Status', subTitle: status),
            onChanged: onUpdateStatus,
            hintText: 'Enter status (max 20 chars)',
            maxLength: 20,
          ),
          EditableListTile(
            model: ListModel(title: 'Email', subTitle: email),
            onChanged: onUpdateEmail,
            hintText: '232',
            maxLength: 20,
          ),
        ],
      ),
    );
  }
}
