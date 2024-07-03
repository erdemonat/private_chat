import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privatechat/model/my_list_tile_model.dart';

class EditableListTile extends StatefulWidget {
  final ListModel model;
  final Function(ListModel listModel)? onChanged;
  final String hintText;
  final int maxLength;

  const EditableListTile({
    super.key,
    required this.model,
    this.onChanged,
    required this.hintText,
    required this.maxLength,
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
      leading: Transform.translate(
        offset: const Offset(-4, -7),
        child: Icon(
          model.icon,
          size: 28,
        ),
      ),
      title: Text(model.title),
      subtitle: _isEditingMode ? _subTitleTextField : Text(model.subTitle),
      trailing: _isEditingMode ? _saveButton : _editButton,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  Widget get _subTitleTextField {
    return TextField(
      inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
      controller: _subTitleEditingController,
      style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.75)),
      decoration: InputDecoration(
        hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.4)),
        hintText: widget.hintText,
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
