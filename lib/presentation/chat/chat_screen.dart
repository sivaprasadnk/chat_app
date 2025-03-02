import 'package:chatapp/models/chat_model.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/presentation/components/reply_message_card.dart';
import 'package:chatapp/presentation/components/sender_message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chatUser,
    required this.loginUser,
  });
  final ChatModel chatUser;
  final ChatModel loginUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool showEmojiPicker = false;
  bool showMic = true;

  final FocusNode focusNode = FocusNode();

  TextEditingController textEditingController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  late IO.Socket socket;

  List<MessageModel> messages = [];

  @override
  void initState() {
    // connect();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          showEmojiPicker = false;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      connect(context);
    });
    super.initState();
  }

  void connect(BuildContext context) async {
    var uri = 'https://chatappbackend-production-54a7.up.railway.app/';
    // var uri = 'http://192.168.29.162:3000';
    // ChatModel? chatModel = ChatModelProvider.of(context).chatModel;
    // socket = IO.io(uri, <String, dynamic>{
    //   "transports": ['websocket'],
    //   "autoConnect": false,
    // });
    socket = IO.io(
      uri,
      IO.OptionBuilder().setTransports(["websocket"]).setQuery({
        "username": widget.chatUser.name!,
      }).build(),
    );
    socket.connect();
    socket.emit('signin', widget.loginUser.id!);
    socket.onConnect((data) {
      debugPrint("connected");
      socket.on("message", (msg) {
        // setMessage('destination', msg['message']);
        var hr = DateTime.now().hour.toString();
        var min = DateTime.now().minute.toString();
        setMessage('destination', msg['message'], hr, min);
      });
    });
  }

  void sendMessage(String message, int sourceId, int targetId) {
    socket.emit('message', {
      "message": message,
      "sourceId": sourceId,
      "targetId": targetId,
    });
    var hr = DateTime.now().hour.toString();
    var min = DateTime.now().minute.toString();
    setMessage('source', message, hr, min);
  }

  void setMessage(String type, String message, String hr, String min) {
    var messageModel = MessageModel(
      message: message,
      type: type,
      hr: hr,
      min: min,
    );
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.easeIn,
    );
    setState(() {
      messages.add(messageModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuerySize = MediaQuery.of(context).size;
    var height = mediaQuerySize.height;
    var width = mediaQuerySize.width;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 70,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Icon(Icons.arrow_back, size: 24),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blueGrey,
                child: Center(
                  child: Text(widget.chatUser.name!.characters.first),
                ),
              ),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.chatUser.name!,
              style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold),
            ),
            if (!widget.chatUser.isGroup!)
              Text(
                'last seen at ${widget.chatUser.lastSeen}',
                style: TextStyle(fontSize: 13),
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              //
            },
            icon: Icon(Icons.videocam),
          ),
          IconButton(
            onPressed: () {
              //
            },
            icon: Icon(Icons.call),
          ),
        ],
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              setState(() {
                showEmojiPicker = false;
              });
            }
          },
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      return SizedBox(height: 70);
                    }
                    var item = messages[index];

                    return item.type == "source"
                        ? SenderMessageCard(
                          message: item.message,
                          time: "${item.hr}:${item.min}",
                        )
                        : ReplyMessageCard(
                          message: item.message,
                          time: "${item.hr}:${item.min}",
                        );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: width - 60,
                            child: Card(
                              margin: EdgeInsets.only(
                                left: 8,
                                right: 2,
                                bottom: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: TextFormField(
                                focusNode: focusNode,
                                controller: textEditingController,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                minLines: 1,
                                onChanged: (value) {
                                  if (value.trim().isEmpty) {
                                    setState(() {
                                      showMic = true;
                                    });
                                  } else {
                                    setState(() {
                                      showMic = false;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Type a message',
                                  border: InputBorder.none,
                                  // isDense: true,
                                  prefixIcon: IconButton(
                                    onPressed: () {
                                      focusNode.unfocus();
                                      focusNode.canRequestFocus = false;
                                      setState(() {
                                        showEmojiPicker = !showEmojiPicker;
                                      });
                                    },
                                    icon: Icon(Icons.emoji_emotions),
                                  ),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          //
                                        },
                                        icon: Icon(Icons.attach_file),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          //
                                        },
                                        icon: Icon(Icons.camera_alt_rounded),
                                      ),
                                    ],
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 2,
                              right: 2,
                              bottom: 8,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF128C7E),
                              radius: 25,
                              child:
                                  showMic
                                      ? IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.mic,
                                          color: Colors.white,
                                        ),
                                      )
                                      : IconButton(
                                        onPressed: () {
                                          sendMessage(
                                            textEditingController.text,
                                            widget.loginUser.id!,
                                            widget.chatUser.id!,
                                          );
                                          textEditingController.clear();
                                          setState(() {
                                            showMic = true;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.send,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                      showEmojiPicker ? emojiPicker() : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget emojiPicker() {
    return EmojiPicker(
      textEditingController: textEditingController,
      onEmojiSelected: (Category? category, Emoji emoji) {
        textEditingController.text = textEditingController.text + emoji.emoji;
        setState(() {});
      },
      onBackspacePressed: () {
        // Do something when the user taps the backspace button (optional)
        // Set it to null to hide the Backspace-Button
      },
      // textEditingController: textEditingController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
      config: Config(
        height: 256,
        // : const Color(0xFFF2F2F2),
        checkPlatformCompatibility: true,
        emojiViewConfig: EmojiViewConfig(
          // Issue: https://github.com/flutter/flutter/issues/28894
          emojiSizeMax:
              28 *
              (foundation.defaultTargetPlatform == TargetPlatform.iOS
                  ? 1.20
                  : 1.0),
        ),
        viewOrderConfig: const ViewOrderConfig(
          top: EmojiPickerItem.categoryBar,
          middle: EmojiPickerItem.emojiView,
          bottom: EmojiPickerItem.searchBar,
        ),
        skinToneConfig: const SkinToneConfig(),
        categoryViewConfig: const CategoryViewConfig(),
        bottomActionBarConfig: const BottomActionBarConfig(),
        searchViewConfig: const SearchViewConfig(),
      ),
    );
  }
}
