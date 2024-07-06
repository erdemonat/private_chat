import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:google_fonts/google_fonts.dart';
import 'package:privatechat/components/emoji_categorized_view.dart';

class NewMessage extends StatefulWidget {
  final Function(String) onSendMessage;

  const NewMessage({super.key, required this.onSendMessage});

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final TextEditingController _controller = TextEditingController();
  bool _isComposing = false;
  late final FocusNode _focusNode;
  bool _emojiShowing = false;
  final bool isApple = [TargetPlatform.iOS, TargetPlatform.macOS]
      .contains(foundation.defaultTargetPlatform);
  late final ScrollController _scrollController;
  late final TextStyle _textStyle;

  @override
  void initState() {
    _controller.addListener(_onTextChanged);
    final fontSize = 24 * (isApple ? 1.2 : 1.0);
    // Define Custom Emoji Font & Text Style
    _textStyle = DefaultEmojiTextStyle.copyWith(
      fontFamily: GoogleFonts.notoColorEmoji().fontFamily,
      fontSize: fontSize,
    );
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    super.initState();
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
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onTap: () {
                          if (_emojiShowing) {
                            setState(() {
                              _emojiShowing = false;
                            });
                          }
                        },
                        scrollController: _scrollController,
                        focusNode: _focusNode,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            decoration: TextDecoration.none),
                        cursorColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        controller: _controller,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary),
                                borderRadius: BorderRadius.circular(15)),
                            suffixIcon: _isComposing
                                ? IconButton(
                                    icon: const Icon(Icons.send_rounded),
                                    onPressed: _sendMessage,
                                  )
                                : null,
                            prefixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _emojiShowing = !_emojiShowing;
                                  if (!_emojiShowing) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _focusNode.requestFocus();
                                    });
                                  } else {
                                    _focusNode.unfocus();
                                  }
                                });
                              },
                              icon: Icon(
                                _emojiShowing
                                    ? Icons.keyboard
                                    : Icons.emoji_emotions_rounded,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary)),
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
                  ),
                ],
              ),
              Offstage(
                offstage: !_emojiShowing,
                child: EmojiPicker(
                  textEditingController: _controller,
                  scrollController: _scrollController,
                  config: Config(
                    height: 256,
                    checkPlatformCompatibility: true,
                    emojiTextStyle: _textStyle,
                    emojiViewConfig: EmojiViewConfig(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    swapCategoryAndBottomBar: true,
                    skinToneConfig: const SkinToneConfig(),
                    categoryViewConfig: CategoryViewConfig(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      dividerColor: Theme.of(context).colorScheme.secondary,
                      indicatorColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      iconColorSelected:
                          Theme.of(context).colorScheme.onPrimary,
                      iconColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.8),
                      customCategoryView: (
                        config,
                        state,
                        tabController,
                        pageController,
                      ) {
                        return WhatsAppCategoryView(
                          config,
                          state,
                          tabController,
                          pageController,
                        );
                      },
                      categoryIcons: const CategoryIcons(
                        recentIcon: Icons.access_time_outlined,
                        smileyIcon: Icons.emoji_emotions_outlined,
                        animalIcon: Icons.cruelty_free_outlined,
                        foodIcon: Icons.coffee_outlined,
                        activityIcon: Icons.sports_soccer_outlined,
                        travelIcon: Icons.directions_car_filled_outlined,
                        objectIcon: Icons.lightbulb_outline,
                        symbolIcon: Icons.emoji_symbols_outlined,
                        flagIcon: Icons.flag_outlined,
                      ),
                    ),
                    bottomActionBarConfig: BottomActionBarConfig(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      buttonColor: Colors.transparent,
                      buttonIconColor: Theme.of(context).colorScheme.secondary,
                    ),
                    searchViewConfig: SearchViewConfig(
                      buttonIconColor: Theme.of(context).colorScheme.secondary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      customSearchView: (
                        config,
                        state,
                        showEmojiView,
                      ) {
                        return WhatsAppSearchView(
                          config,
                          state,
                          showEmojiView,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
