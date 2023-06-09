import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/widgets/video_comments.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  final int index;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/video.mov");
  late final AnimationController _animationController;

  bool _isPaused = false;
  final Duration _animationDuration = const Duration(milliseconds: 200);

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.position ==
          _videoPlayerController.value.duration) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    // 브라우저에서는 화면 로딩과 동시에 음성이 들어간 영상을 재생할 수 없다. (새로고침시에 해당)
    // 사용자를 놀래키는 등의 문제 때문에 정책상 막아놨기 때문에 에러가 발생한다.
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    if (kIsWeb) {
      await _videoPlayerController.setVolume(0);
    }
    // _videoPlayerController.play();
    setState(() {});
    _videoPlayerController.addListener(_onVideoChange);
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onVisiblityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    await showModalBottomSheet(
      backgroundColor: Colors
          .transparent, // 배경을 투명색으로 지정해서 VideoComment의 Scaffold에 borderRadius 적용
      context: context,
      isScrollControlled:
          true, // bottomSheet의 사이즈를 바꿀 수 있게 & 안에서 ListView 사용 가능하게 해줌
      builder: (context) => const VideoComments(),
    );
    _onTogglePause();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisiblityChanged,
      child: Stack(children: [
        Positioned.fill(
          child: _videoPlayerController.value.isInitialized
              ? VideoPlayer(_videoPlayerController)
              : Container(
                  color: Colors.black,
                ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: _onTogglePause,
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animationController.value,
                    child: child,
                  );
                },
                child: AnimatedOpacity(
                  opacity: _isPaused ? 1 : 0,
                  duration: _animationDuration,
                  child: const FaIcon(
                    FontAwesomeIcons.play,
                    color: Colors.white,
                    size: Sizes.size52,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "@hyeribo",
                style: TextStyle(
                  fontSize: Sizes.size20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gaps.v10,
              Text(
                "This is my puppy Yamsoon!!!",
                style: TextStyle(
                  fontSize: Sizes.size16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          right: 10,
          child: Column(children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              foregroundImage: NetworkImage(
                "https://avatars.githubusercontent.com/u/29244883?v=4",
              ),
              child: Text("혜리"),
            ),
            Gaps.v24,
            VideoButton(
              icon: FontAwesomeIcons.solidHeart,
              text: S.of(context).likeCount(98798),
            ),
            Gaps.v24,
            GestureDetector(
              onTap: () => _onCommentsTap(context),
              child: VideoButton(
                icon: FontAwesomeIcons.solidComment,
                text: S.of(context).commentCount(65465),
              ),
            ),
            Gaps.v24,
            const VideoButton(
              icon: FontAwesomeIcons.share,
              text: "Share",
            ),
          ]),
        )
      ]),
    );
  }
}
