import 'package:flutter/material.dart';

enum TickStatus { sent, delivered, seen }

class SendBubble extends StatelessWidget {
  final String message;
  final String messagetype;
  final String timestamp;
  final bool isSender;
  final TickStatus status;
  const SendBubble({
    super.key,
    required this.message,
    required this.messagetype,
    required this.isSender,
    required this.timestamp,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSender ? Colors.black.withOpacity(0.8) : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                messagetype != 'txt'
                    ? Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.file_open),
                      )
                    : const SizedBox.shrink(),
                messagetype != 'txt'
                    ? const SizedBox(
                        width: 10,
                      )
                    : const SizedBox.shrink(),
                Flexible(
                  child: Text(
                    message,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16,
                      decoration: messagetype == 'location'
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      color: messagetype == 'location'
                          ? Colors.blue
                          : isSender
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  timestamp,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSender ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(width: 5),
                isSender ? _getTickIcon(status) : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get the appropriate tick icon
  Widget _getTickIcon(TickStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case TickStatus.sent:
        icon = Icons.check; // Single tick: sent
        color = Colors.white70;
        break;
      case TickStatus.delivered:
        icon = Icons.done_all; // Double tick: delivered
        color = Colors.grey;
        break;
      case TickStatus.seen:
        icon = Icons.done_all; // Double blue tick: seen
        color = Colors.blue;
        break;
    }

    return Icon(
      icon,
      size: 18,
      color: color,
    );
  }
}

class RecieveChatBubble extends StatelessWidget {
  final String message;
  final String messagetype;
  final bool isSender;
  final String timestamp;
  final TickStatus status;
  const RecieveChatBubble({
    super.key,
    required this.message,
    required this.messagetype,
    required this.isSender,
    required this.timestamp,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSender ? Colors.greenAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: GestureDetector(
            child: Column(
          crossAxisAlignment:
              !isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                message,
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                  decoration: messagetype == 'location'
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  color: messagetype == 'location'
                      ? Colors.blue
                      : isSender
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Timestamp
                Text(
                  timestamp,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSender ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(width: 5),
                // Tick Status
                isSender ? _getTickIcon(status) : const SizedBox.shrink(),
              ],
            ),
          ],
        )),
      ),
    );
  }

  // Helper method to get the appropriate tick icon
  Widget _getTickIcon(TickStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case TickStatus.sent:
        icon = Icons.check; // Single tick: sent
        color = Colors.white70;
        break;
      case TickStatus.delivered:
        icon = Icons.done_all; // Double tick: delivered
        color = Colors.grey;
        break;
      case TickStatus.seen:
        icon = Icons.done_all; // Double blue tick: seen
        color = Colors.blue;
        break;
    }

    return Icon(
      icon,
      size: 18,
      color: color,
    );
  }
}

// Custom painter for the tail (triangle)
class TailPainter extends CustomPainter {
  final bool isSender;

  TailPainter({required this.isSender});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = isSender ? Colors.greenAccent : Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
