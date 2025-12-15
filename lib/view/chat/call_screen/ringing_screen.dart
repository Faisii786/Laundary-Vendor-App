import 'package:flutter/material.dart';

class CallerScreen extends StatelessWidget {
  final String callerName;
  final String token;
  final String appId;
  final String channel;
  final String? avatarUrl;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const CallerScreen({
    super.key,
    required this.callerName,
    this.avatarUrl,
    required this.onAccept,
    required this.onReject,
    required this.token,
    required this.appId,
    required this.channel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Caller avatar
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white10,
              backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: avatarUrl == null || avatarUrl!.isEmpty
                  ? const Icon(Icons.person, size: 70, color: Colors.white70)
                  : null,
            ),
            const SizedBox(height: 20),
            // Caller name
            Text(
              callerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "is calling you...",
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const Spacer(),
            // Accept / Reject Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Reject button
                  FloatingActionButton(
                    heroTag: "reject",
                    backgroundColor: Colors.redAccent,
                    onPressed: onReject,
                    child: const Icon(Icons.call_end, size: 30),
                  ),
                  // Accept button
                  FloatingActionButton(
                    heroTag: "accept",
                    backgroundColor: Colors.green,
                    onPressed: onAccept,
                    child: const Icon(Icons.call, size: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
