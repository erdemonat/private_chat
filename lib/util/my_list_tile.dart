import 'package:flutter/material.dart';
import 'package:privatechat/model/my_list_tile_model.dart';

class EditableListTile extends StatefulWidget {
  final ListModel model;
  final Function(ListModel listModel)? onChanged;

  const EditableListTile({
    super.key,
    required this.model,
    this.onChanged,
  });

  @override
  _EditableListTileState createState() => _EditableListTileState();
}

class _EditableListTileState extends State<EditableListTile> {
  late ListModel model;
  bool _isEditingMode = false;
  late TextEditingController _titleEditingController;
  late TextEditingController _subTitleEditingController;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    _titleEditingController = TextEditingController(text: model.title);
    _subTitleEditingController = TextEditingController(text: model.subTitle);
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _subTitleEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(model.title),
      subtitle: _isEditingMode ? _subTitleTextField : Text(model.subTitle),
      trailing: _isEditingMode ? _saveButton : _editButton,
    );
  }

  Widget get _titleTextField {
    return TextField(
      controller: _titleEditingController,
      decoration: const InputDecoration(
        hintText: 'Title',
      ),
    );
  }

  Widget get _subTitleTextField {
    return TextField(
      controller: _subTitleEditingController,
      decoration: const InputDecoration(
        hintText: 'Subtitle',
      ),
    );
  }

  Widget get _editButton {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: _toggleEditMode,
    );
  }

  Widget get _saveButton {
    return IconButton(
      icon: const Icon(Icons.check),
      onPressed: _saveChanges,
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditingMode = !_isEditingMode;
    });
  }

  void _saveChanges() {
    setState(() {
      model.subTitle = _subTitleEditingController.text;
      _isEditingMode = false;
    });

    widget.onChanged?.call(model);
  }
}
