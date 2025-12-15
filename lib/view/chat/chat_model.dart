// final String message;
// final String messagetype;
// final String timestamp;
// final TickStatus tickStatus;
// final bool isSender;

class ConvModel {
  String? message;
  String? timestamp;
  String? senderid;
  String? messageType;
  String? status;
  bool isSender = false;

  ConvModel(
      {this.message,
      this.timestamp,
      this.senderid,
      this.messageType,
      this.status,
      required this.isSender});

  ConvModel.fromJson(Map<String, dynamic> json) {
    message = json['message'].toString();
    isSender = json['isSender'] ?? false;
    timestamp = json['timestamp'].toString();
    senderid = json['senderId'].toString();
    messageType = json['messagetype'].toString();
    status = json['status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['isSender'] = isSender;
    data['timestamp'] = timestamp;
    data['senderId'] = senderid;
    data['messagetype'] = messageType;
    data['status'] = status;
    return data;
  }
}
