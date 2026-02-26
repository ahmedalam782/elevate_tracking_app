import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/helper/user_helper/user_helper.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/theme/app_images.dart';
import '../../../../../core/theme/app_videos.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  VideoPlayerController? _controller;
  bool _isVideoInitialized = false;
  bool _useFallback = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeSplash();
  }

  Future<void> _initializeSplash() async {
    try {
      _controller = VideoPlayerController.asset(AppVideos.videosSplash);
      await _controller!.initialize();
      _controller!.addListener(_checkVideoEnd);
      await _controller!.play();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        _startFallbackTimer();
      }
    }
  }

  void _checkVideoEnd() {
    if (_hasNavigated) return;
    if (_controller == null || !_controller!.value.isInitialized) return;

    final position = _controller!.value.position;
    final duration = _controller!.value.duration;

    // Check if video has finished (position is at or very close to duration)
    // Using a small buffer (100ms) to account for timing precision
    if (duration > Duration.zero &&
        position.inMilliseconds >= (duration.inMilliseconds - 100)) {
      _navigate();
    }
  }

  void _startFallbackTimer() {
    setState(() {
      _useFallback = true;
    });
    Timer(const Duration(seconds: 2), _navigate);
  }

  Future<void> _navigate() async {
    if (_hasNavigated) return;
    _hasNavigated = true;
    // Prevent multiple navigations
    _controller?.removeListener(_checkVideoEnd);
    if (!mounted) return;
    bool loggedIn = await UserHelper.isLogin();
    bool rememberMe = await UserHelper.isRememberMe() ?? false;
    if (loggedIn && rememberMe && mounted) {
      context.go(Routes.appLayout);
    } else {
      await UserHelper.clearUserData();
      if (mounted) {
        context.go(Routes.onBoarding);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show video when initialized
    if (_isVideoInitialized && !_useFallback && _controller != null) {
      return Scaffold(
        body: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.fill,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
        ),
      );
    }

    // Show blank screen while video is loading (prevents fallback flash)
    if (!_useFallback) {
      return const Scaffold();
    }

    // Fallback UI (Original Splash) - only when video fails to load
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: Image.asset(AppImages.imagesSplash, fit: BoxFit.fill),
        ),
      ),
    );
  }
}
