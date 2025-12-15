import 'dart:async';

import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

import '../../../models/login/user_model.dart';
import '../../../view_models/controller/user_preference/user_preference_view_model.dart';

bool isOnCallScreen = false;

class CallScreen extends StatefulWidget {
  final String channelName;
  final String uid;
  final String appId;
  final String token;
  final bool isFromNotification;

  const CallScreen({
    super.key,
    required this.channelName,
    required this.appId,
    required this.token,
    required this.isFromNotification,
    required this.uid,
  });

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late final RtcEngine _engine;
  bool _engineInitialized = false;
  bool _isJoined = false;
  bool _isMuted = false;
  bool _isSpeakerOn = true;
  bool _isAudioOnly = false;
  bool _isProximityActive = false;
  int? _remoteUid;
  final List<int> _remoteUsers = [];
  StreamSubscription<int>? _proximitySubscription;

  // we pick uid deterministically for testing; in production pass explicit uid/token per user
  int get _localUid => widget.isFromNotification ? 2 : 1;

  @override
  void initState() {
    super.initState();
    _initEngine();
    _setupProximitySensor();
  }

  @override
  void dispose() {
    isOnCallScreen = false;

    _proximitySubscription?.cancel();
    _disposeEngine();

    super.dispose();
  }

  String? uid;
  Future<void> _initEngine() async {
    isOnCallScreen = true;

    if (widget.uid == "") {
      UserModel? user = await UserPreference().getUser();
      uid = user!.userLogin!.id.toString();
    } else {
      uid = widget.uid;
    }
    // Request microphone permission
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      debugPrint('[CallScreen] Microphone permission denied');
      // You might want to show a dialog or pop the screen
      return;
    }

    try {
      _engine = createAgoraRtcEngine();
      await _engine.initialize(RtcEngineContext(appId: widget.appId));
      _engineInitialized = true;
      debugPrint('[CallScreen] Agora engine initialized');

      // Register event handlers
      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint(
                '[CallScreen] onJoinChannelSuccess: channel=${connection.channelId} uid=${connection.localUid}');
            setState(() {
              _isJoined = true;
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint('[CallScreen] onUserJoined: uid=$remoteUid');
            setState(() {
              _remoteUid = remoteUid;
              if (!_remoteUsers.contains(remoteUid)) {
                _remoteUsers.add(remoteUid);
              }
            });
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            debugPrint(
                '[CallScreen] onUserOffline: uid=$remoteUid reason=$reason');
            setState(() {
              if (_remoteUid == remoteUid) _remoteUid = null;
              _remoteUsers.remove(remoteUid);
            });
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            debugPrint(
                '[CallScreen] onLeaveChannel: channel=${connection.channelId}');
            setState(() {
              _isJoined = false;
              _remoteUid = null;
              _remoteUsers.clear();
            });
          },
          onError: (ErrorCodeType err, String message) {
            debugPrint('[CallScreen] Agora Error: $err, $message');
          },
        ),
      );

      // Enable/prepare audio
      await _engine.enableAudio();
      // Make speakerphone default to true so audio is audible
      await _engine.setDefaultAudioRouteToSpeakerphone(true);
      // await _engine.setEnableSpeakerphone(_isSpeakerOn);

      debugPrint(
          '[CallScreen] joining channel: ${widget.channelName} uid: $_localUid token: ${"[PROVIDED]"}');

      // Join channel (audio only). ChannelMediaOptions explicitly set for communication.
      await _engine.joinChannel(
        token: widget.token,
        channelId: widget.channelName,
        uid: int.parse(uid ?? '0'),
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );

      debugPrint('[CallScreen] joinChannel call returned');
    } catch (e, st) {
      debugPrint('[CallScreen] _initEngine error: $e\n$st');
    }
  }

  void _setupProximitySensor() async {
    try {
      _proximitySubscription = ProximitySensor.events.listen((int event) {
        final near = event > 0;
        if (near == _isProximityActive) return;
        setState(() {
          _isProximityActive = near;
        });
        _handleProximityChange();
      });
    } catch (e) {
      debugPrint("Proximity sensor not available: $e");
    }
  }

  void _handleProximityChange() {
    if (!_engineInitialized) return;
    if (_isProximityActive) {
      // Close to ear - switch to earpiece and audio-only mode
      _engine.setEnableSpeakerphone(false);
      setState(() {
        _isSpeakerOn = false;
        _isAudioOnly = true;
      });
      debugPrint('[CallScreen] Proximity near — speaker OFF, audio-only ON');
    } else {
      // Away from ear - restore speaker settings
      _engine.setEnableSpeakerphone(_isSpeakerOn);
      setState(() {
        _isAudioOnly = false;
      });
      debugPrint(
          '[CallScreen] Proximity far — speaker ${_isSpeakerOn ? "ON" : "OFF"}');
    }
  }

  void _toggleMute() {
    if (!_engineInitialized) return;
    setState(() => _isMuted = !_isMuted);
    _engine.muteLocalAudioStream(_isMuted);
    debugPrint('[CallScreen] Local mute: $_isMuted');
  }

  void _toggleSpeaker() {
    if (!_engineInitialized) return;
    setState(() => _isSpeakerOn = !_isSpeakerOn);
    _engine.setEnableSpeakerphone(_isSpeakerOn);
    debugPrint('[CallScreen] Speaker toggled: $_isSpeakerOn');
  }

  Future<void> _endCall() async {
    if (!_engineInitialized) {
      if (!widget.isFromNotification) {
        Navigator.of(context).pop();
      } else {
        Get.close(2);
      }
      return;
    }

    try {
      await _engine.leaveChannel();
    } catch (e) {
      debugPrint('[CallScreen] leaveChannel error: $e');
    }

    if (!widget.isFromNotification) {
      if (mounted) Navigator.of(context).pop();
    } else {
      // Close two routes if the incoming flow used Get.back stack
      try {
        Get.close(2);
      } catch (_) {
        Get.close(1);
      }
    }
  }

  Future<void> _disposeEngine() async {
    if (!_engineInitialized) return;
    try {
      await _engine.leaveChannel();
      await _engine.release();
      debugPrint('[CallScreen] Engine released');
    } catch (e) {
      debugPrint('[CallScreen] dispose error: $e');
    }
  }

  String _statusText() {
    if (_remoteUid != null) return 'Connected';
    if (_isJoined) return 'Waiting for others...';
    return 'Connecting...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildMainView()),
            _buildControlButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: _endCall,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'In Call',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.channelName,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (_isAudioOnly)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.audiotrack, color: Colors.white, size: 12),
                  SizedBox(width: 4),
                  Text(
                    'Audio Only',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainView() {
    if (_isAudioOnly) {
      return _buildAudioOnlyView();
    } else {
      return _buildVideoView();
    }
  }

  Widget _buildAudioOnlyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 60,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Audio Call',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _statusText(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          if (_remoteUsers.isNotEmpty)
            Text('Remote UIDs: ${_remoteUsers.join(", ")}',
                style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildVideoView() {
    return Stack(
      children: [
        _remoteUid != null
            ? AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: _engine,
                  canvas: VideoCanvas(uid: _remoteUid),
                  connection: RtcConnection(channelId: widget.channelName),
                ),
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Waiting for others to join...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
        if (_isJoined && !_isAudioOnly)
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 2),
              ),
              // local preview (uid 0 is local preview)
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _engine,
                  canvas: const VideoCanvas(uid: 0),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: _isMuted ? Icons.mic_off : Icons.mic,
            backgroundColor: _isMuted ? Colors.red : Colors.white24,
            onPressed: _toggleMute,
          ),
          _buildControlButton(
            icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
            backgroundColor: _isSpeakerOn ? Colors.blue : Colors.white24,
            onPressed: _toggleSpeaker,
          ),
          _buildControlButton(
            icon: Icons.call_end,
            backgroundColor: Colors.red,
            onPressed: _endCall,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
