import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chatapp/core/constants.dart';
// import 'package:agora_rtc_engine/';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({
    super.key,
    required this.channelname,
    required this.clientRoleType,
  });
  final String channelname;
  final ClientRoleType clientRoleType;

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late RtcEngine engine;
  bool _localUserJoined = false;
  bool initialsed = false;
  int? _remoteUid;

  @override
  void initState() {
    debugPrint("## joined as ${widget.clientRoleType}");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAgora();
    });
  }

  @override
  void dispose() {
    _cleanupAgoraEngine();
    super.dispose();
  }

  // Leaves the channel and releases resources
  Future<void> _cleanupAgoraEngine() async {
    await engine.leaveChannel();
    await engine.release();
  }

  Future<void> _requestPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  Future<void> _setupLocalVideo() async {
    // The video module and preview are disabled by default.
    await engine.enableVideo();
    await engine.startPreview();
  }

  // Register an event handler for Agora RTC
  void _setupEventHandlers() {
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
          setState(() => _localUserJoined = true);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("Remote user $remoteUid joined");
          setState(() => _remoteUid = remoteUid);
        },
        onUserOffline: (
          RtcConnection connection,
          int remoteUid,
          UserOfflineReasonType reason,
        ) {
          debugPrint("Remote user $remoteUid left");
          setState(() => _remoteUid = null);
        },
      ),
    );
  }

  initAgora() async {
    await _requestPermissions();
    await _initializeAgoraVideoSDK();
    await _setupLocalVideo();
    _setupEventHandlers();
    await _joinChannel();
  }

  Future<void> _initializeAgoraVideoSDK() async {
    engine = createAgoraRtcEngine();
    setState(() {
      initialsed = true;
    });
    await engine.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
  }

  // Join a channel
  Future<void> _joinChannel() async {
    await engine.joinChannel(
      token: token,
      channelId: channel,
      options: ChannelMediaOptions(
        autoSubscribeVideo:
            true, // Automatically subscribe to all video streams
        autoSubscribeAudio:
            true, // Automatically subscribe to all audio streams
        publishCameraTrack: true, // Publish camera-captured video
        publishMicrophoneTrack: true, // Publish microphone-captured audio
        // Use clientRoleBroadcaster to act as a host or clientRoleAudience for audience
        clientRoleType: widget.clientRoleType,
      ),
      uid: 0,
    );
  }

  // Displays the local user's video view using the Agora engine.
  Widget _localVideo() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: engine, // Uses the Agora engine instance
        canvas: const VideoCanvas(
          uid: 0, // Specifies the local user
          renderMode:
              RenderModeType.renderModeHidden, // Sets the video rendering mode
        ),
      ),
    );
  }

  // If a remote user has joined, render their video, else display a waiting message
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: engine, // Uses the Agora engine instance
          canvas: VideoCanvas(uid: _remoteUid), // Binds the remote user's video
          connection: const RtcConnection(
            channelId: channel,
          ), // Specifies the channel
        ),
      );
    } else {
      return const Text(
        'Waiting for remote user to join...',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Video Call')),
      body:
          !initialsed
              ? ColoredBox(color: Colors.black)
              : Stack(
                children: [
                  // if (widget.clientRoleType ==
                  //     ClientRoleType.clientRoleAudience)
                  Center(child: _remoteVideo()),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 100,
                      height: 150,
                      child: Center(
                        child:
                            _localUserJoined
                                ? _localVideo()
                                : const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
