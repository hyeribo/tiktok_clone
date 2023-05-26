import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/video_preview_screen.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

// 두개 이상의 애니메이션 컨트롤러가 필요할땐 TickerProviderStateMixin
class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _deniedPermissions = false;
  bool _isSelfieMode = false;
  bool _preparedDispose =
      false; // controller를 dispose하기전에 CameraPreview 위젯을 렌더트리에서 제거해야함
  late FlashMode _flashMode;

  late CameraController _cameraController;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0, // 애니메이션의 최소값
    upperBound: 1.0, // 애니메이션의 최대값
  );

  late final Animation<double> _buttonAnimation = Tween(
    begin: 1.0,
    end: 1.3,
  ).animate(_buttonAnimationController);

  @override
  void initState() {
    super.initState();
    initPermissions();

    // 유저가 앱을 벗어나면 알게해줌
    WidgetsBinding.instance.addObserver(this);

    // value가 바뀐걸 알려줌
    _progressAnimationController.addListener(() {
      setState(() {});
    });

    // 애니메이션 상태가 바뀐걸 알려줌
    _progressAnimationController.addStatusListener((status) {
      // 10초가 지나고 애니메이션이 끝나면 stopRecording 메서드 호출
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_hasPermission || !_cameraController.value.isInitialized) return;

    if (state == AppLifecycleState.paused) {
      _preparedDispose = true;
      setState(() {});
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _preparedDispose = false;
      initCamera();
    }
    // if (state == AppLifecycleState.resumed) {
    //   initPermissions();
    // }
  }

  Future<void> initCamera() async {
    // 기기가 가진 카메라의 목록을 가져온다. (전면, 후면)
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();

    // iOS에서만 필요. iOS에서는 가끔 영상과 오디오의 싱크가 맞지 않는 경우가 생기기 때문
    await _cameraController.prepareForVideoRecording();

    _flashMode = _cameraController.value.flashMode;

    setState(() {});
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      initCamera();
    } else {
      _deniedPermissions = true;
    }
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    initCamera();
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _startRecording(TapDownDetails _) async {
    if (_cameraController.value.isRecordingVideo) {
      return;
    }

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) {
      return;
    }
    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController.stopVideoRecording();
    // print(video.name);
    // print(video.path);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: false,
        ),
      ),
    );
    // await _cameraController.takePicture(); // 마찬가지로 file 받을 수 있음
  }

  Future<void> _onPickVideoPressed() async {
    // iOS 내장 카메라로 영상 촬영
    // final video = await ImagePicker().pickVideo(source: ImageSource.camera);

    // 갤러리에서 영상 선택. 간단하지만 영상 촬영 길이를 제한할 수 없음.
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video == null) return;

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _progressAnimationController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission || !_cameraController.value.isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Initializing camera...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Sizes.size16,
                    ),
                  ),
                  Gaps.v20,
                  CircularProgressIndicator.adaptive(),
                ],
              )
            : _cameraController.value.isInitialized
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      if (!_preparedDispose) CameraPreview(_cameraController),
                      Positioned(
                        top: Sizes.size20,
                        right: Sizes.size20,
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: _toggleSelfieMode,
                              color: Colors.white,
                              icon: const Icon(Icons.cameraswitch),
                            ),
                            Gaps.v10,
                            IconButton(
                              onPressed: () => _setFlashMode(FlashMode.off),
                              color: _flashMode == FlashMode.off
                                  ? Colors.amber.shade300
                                  : Colors.white,
                              icon: const Icon(Icons.flash_off_rounded),
                            ),
                            Gaps.v10,
                            IconButton(
                              onPressed: () => _setFlashMode(FlashMode.always),
                              color: _flashMode == FlashMode.always
                                  ? Colors.amber.shade300
                                  : Colors.white,
                              icon: const Icon(Icons.flash_on_rounded),
                            ),
                            Gaps.v10,
                            IconButton(
                              onPressed: () => _setFlashMode(FlashMode.auto),
                              color: _flashMode == FlashMode.auto
                                  ? Colors.amber.shade300
                                  : Colors.white,
                              icon: const Icon(Icons.flash_auto_rounded),
                            ),
                            Gaps.v10,
                            IconButton(
                              onPressed: () => _setFlashMode(FlashMode.torch),
                              color: _flashMode == FlashMode.torch
                                  ? Colors.amber.shade300
                                  : Colors.white,
                              icon: const Icon(Icons.flashlight_on_rounded),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        width: MediaQuery.of(context).size.width,
                        bottom: Sizes.size40,
                        child: Row(
                          children: [
                            const Spacer(), // 변형 가능한 공간을 만들어줌
                            GestureDetector(
                              onTapDown: _startRecording,
                              onTapUp: (details) => _stopRecording(),
                              child: ScaleTransition(
                                scale: _buttonAnimation,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: Sizes.size80 + Sizes.size14,
                                      height: Sizes.size80 + Sizes.size14,
                                      child: CircularProgressIndicator(
                                        value:
                                            _progressAnimationController.value,
                                        color: Colors.red.shade400,
                                        strokeWidth: Sizes.size6,
                                      ),
                                    ),
                                    Container(
                                      width: Sizes.size80,
                                      height: Sizes.size80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: _onPickVideoPressed,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.image,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : null,
      ),
    );
  }
}
