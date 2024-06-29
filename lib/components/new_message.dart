import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final Function(String) onSendMessage;

  const NewMessage({super.key, required this.onSendMessage});

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final TextEditingController _controller = TextEditingController();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isComposing = _controller.text.isNotEmpty;
    });
  }

  void _sendMessage() {
    if (_isComposing) {
      final messageText = _controller.text;
      widget.onSendMessage(messageText);
      _controller.clear();
      setState(() {
        _isComposing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    decoration: TextDecoration.none),
                cursorColor: Theme.of(context).colorScheme.inversePrimary,
                controller: _controller,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                        borderRadius: BorderRadius.circular(15)),
                    suffixIcon: _isComposing
                        ? IconButton(
                            icon: Icon(Icons.send_rounded),
                            onPressed: _sendMessage,
                          )
                        : null,
                    prefixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.emoji_emotions)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).colorScheme.inversePrimary)),
                    fillColor: Theme.of(context).colorScheme.primary,
                    filled: true,
                    hintText: 'Message',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.6))),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
