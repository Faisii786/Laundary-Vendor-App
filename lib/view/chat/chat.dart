import 'dart:convert';
import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_app/models/login/user_model.dart';
// import '../../model/laundryment_search_model.dart';
import '../../repository/notification_repo/notification_repo.dart';
import '../../utils/Colors.dart';
import '../../view_models/controller/user_preference/user_preference_view_model.dart';
import 'call_screen/call_screen.dart';
import 'chat_box.dart';
import 'chat_model.dart';
import 'custom_round_button.dart';
import 'send_recieve_bubble.dart';

class ChatWithCustomer extends StatefulWidget {
  final String customerId;
  final String customerName;
  const ChatWithCustomer(
      {super.key, required this.customerId, required this.customerName});
  @override
  State<ChatWithCustomer> createState() => _ChatWithCustomerState();
}

class _ChatWithCustomerState extends State<ChatWithCustomer> {
  String? vendorId;
  List<ConvModel> conversationModel = [];
  final _controller = TextEditingController();
  var icon = Icons.mic_rounded;
  final _node = FocusNode();
  final chatref = FirebaseFirestore.instance.collection('chats');

  @override
  void initState() {
    callback();

    super.initState();
  }

  Future<void> callback() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // vendorId = prefs.getString('customer_id');
    SharedPreferences sp = await SharedPreferences.getInstance();

    // Convert UserModel to JSON and save it

    String? userJson = sp.getString('user_data');
    if (userJson != null) {
      UserModel userData = UserModel.fromJson(json.decode(userJson));
      vendorId = userData.userLogin?.id;
      listenData();
    }
  }

  Future<void> listenData() async {
    dev.log("${widget.customerId}_$vendorId");

    chatref
        .doc("${widget.customerId}_$vendorId")
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) async {
      if (mounted) {
        for (var change in snapshot.docChanges) {
          final mapData = change.doc.data();
          final messageId = change.doc.id;
          if (mapData == null) continue;
          final index = conversationModel
              .indexWhere((msg) => msg.timestamp == mapData['timestamp']);
          if (index != -1 && mapData['senderId'] != vendorId) {
            conversationModel[index] = ConvModel(
              isSender: mapData['senderId'] == vendorId ? true : false,
              senderid: mapData['senderId'],
              message: mapData['message'],
              status: mapData['status'],
              messageType: mapData['messagetype'] ?? 'txt',
              timestamp: mapData['timestamp'],
            );
          } else {
            if (index != -1 &&
                mapData['senderId'] != vendorId &&
                mapData['status'] != "seen") {
              chatref
                  .doc("${widget.customerId}_$vendorId")
                  .collection('messages')
                  .doc(messageId)
                  .update({'status': 'seen'});
            } else if (index != -1 && mapData['status'] == "seen") {
              conversationModel[index] = ConvModel(
                isSender: mapData['senderId'] == vendorId ? true : false,
                senderid: mapData['senderId'],
                message: mapData['message'],
                status: "seen",
                messageType: mapData['messagetype'] ?? 'txt',
                timestamp: mapData['timestamp'],
              );
            }
            if (index == -1) {
              conversationModel.add(
                ConvModel(
                  isSender: mapData['senderId'] == vendorId ? true : false,
                  senderid: mapData['senderId'],
                  message: mapData['message'],
                  status: mapData['status'],
                  messageType: mapData['messagetype'] ?? 'txt',
                  timestamp: mapData['timestamp'],
                ),
              );
              if (mapData['senderId'] != vendorId &&
                  mapData['status'] != "seen") {
                chatref
                    .doc("${widget.customerId}_$vendorId")
                    .collection('messages')
                    .doc(messageId)
                    .update({'status': 'seen'});
              }
            }
          }
          //   break;

          // default:
          //   break;
          // }
        }

        if (mounted) setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: primeryColor),
            onPressed: () => Get.back(),
          ),
          title: Text(
            widget.customerName,
            style: TextStyle(
              color: primeryColor,
              fontSize: width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.call,
                color: primeryColor,
              ),
              onPressed: () async {
                UserModel? user = await UserPreference().getUser();

                // int rand = Random().nextInt(400);
                final res = await NotificationRepo.sendNotification(
                    channelName: "myCoolChannel",
                    targetid: widget.customerId,
                    role: "vendor",
                    uid: user?.userLogin?.id?.toString() ?? "",
                    touserType: "customer");
                print(res);
                if (res != null) {
                  Get.to(() => CallScreen(
                        uid: user?.userLogin?.id?.toString() ?? "",
                        isFromNotification: false,
                        appId: res['appID']?.toString() ?? '',
                        channelName: res['channelName'],
                        token: res['rtcToken'],
                      ));
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            buildChat(),
            Row(
              children: [
                ChatBox(
                  focusNode: _node,
                  controller: _controller,
                ),
                const SizedBox(width: 5.0),
                CustomRoundButton(
                  onTap: () async {
                    if (_controller.text.isNotEmpty) {
                      String date =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      chatref
                          .doc("${widget.customerId}_$vendorId")
                          .collection("messages")
                          .add({
                        "message": _controller.text,
                        "isSender": true,
                        "senderId": vendorId,
                        "messagetype": "txt",
                        "timestamp": date,
                        "status": "sent",
                      });
                      _controller.clear();

                      setState(() {});
                    }
                  },
                  icon: Icons.send_rounded,
                  iconSize: 25.0,
                  padding: 10.0,
                )
              ],
            ),
          ],
        ),
      );
    });
  }

  Expanded buildChat() {
    final chats = conversationModel.reversed.toList();
    return Expanded(
        child: ListView.builder(
            itemCount: chats.length,
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (itemBuilder, index) {
              final user = chats[index];
              return user.isSender
                  ? SendBubble(
                      message: user.messageType == "txt"
                          ? (user.message ?? '')
                          : "Media Attached ",
                      messagetype: user.messageType ?? '',
                      timestamp:
                          formatDuration(int.parse(user.timestamp ?? "0")),
                      status: user.status == "seen"
                          ? TickStatus.seen
                          : TickStatus.sent,
                      isSender: true)
                  : GestureDetector(
                      onLongPress: () async {},
                      child: RecieveChatBubble(
                          message: user.messageType == "txt"
                              ? (user.message ?? '')
                              : "Media Attached",
                          messagetype: user.messageType ?? '',
                          timestamp:
                              formatDuration(int.parse(user.timestamp ?? "0")),
                          status: user.status == "seen"
                              ? TickStatus.seen
                              : TickStatus.sent,
                          isSender: false),
                    );
            }));
  }
}

String formatDuration(int milliseconds) {
  // Convert to DateTime
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

  // Format it
  String formattedTime = DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);

  return (formattedTime); // Output: Dec 18, 2025 04:25 PM
}
