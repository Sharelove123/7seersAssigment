import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/home_repository.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../models/user_model.dart';
import '../../../models/guide_model.dart';
import '../../../models/community_post_model.dart';

enum HomeStatus { loading, successOnline, successOffline, error }

class HomeState {
  final UserModel? userProfile;
  final List<GuideModel> guides;
  final List<CommunityPostModel> communityPosts;
  final bool isNetworkConnected;
  final String simulatedTimeOfDay;
  final bool? simulatedFirstTime;
  final bool? simulatedOffline;
  final HomeStatus status;
  final HomeStatus? simulatedStatus;

  HomeState({
    this.userProfile,
    this.guides = const [],
    this.communityPosts = const [],
    this.isNetworkConnected = true,
    this.simulatedTimeOfDay = 'Auto',
    this.simulatedFirstTime,
    this.simulatedOffline,
    this.status = HomeStatus.loading,
    this.simulatedStatus,
  });

  bool get isOffline => simulatedOffline ?? !isNetworkConnected;

  bool get isFirstTime =>
      simulatedFirstTime ?? (userProfile?.isFirstTime ?? false);

  bool get completedCheckIn {
    if (isFirstTime) return false;
    if (simulatedTimeOfDay == 'Evening') return true;
    if (simulatedTimeOfDay == 'Morning') return false;
    return userProfile?.completedCheckIn ?? false;
  }

  String get greetingText {
    final name = userProfile?.name ?? 'Harsh';
    if (isFirstTime) return 'Welcome,\n$name.';
    return effectiveTimeOfDay == 'Morning'
        ? 'Morning, $name.'
        : 'Evening, $name.';
  }

  String get accentText {
    if (isFirstTime) return 'glad you came.';
    return effectiveTimeOfDay == 'Morning'
        ? "it's a quiet one."
        : 'good work today.';
  }

  String get effectiveTimeOfDay {
    if (simulatedTimeOfDay != 'Auto') return simulatedTimeOfDay;
    final hour = DateTime.now().hour;
    return (hour >= 5 && hour < 17) ? 'Morning' : 'Evening';
  }

  HomeStatus get effectiveStatus {
    if (simulatedStatus != null) return simulatedStatus!;
    return status;
  }

  HomeState copyWith({
    UserModel? userProfile,
    List<GuideModel>? guides,
    List<CommunityPostModel>? communityPosts,
    bool? isNetworkConnected,
    String? simulatedTimeOfDay,
    bool? Function()? simulatedFirstTime,
    bool? Function()? simulatedOffline,
    HomeStatus? status,
    HomeStatus? Function()? simulatedStatus,
  }) {
    return HomeState(
      userProfile: userProfile ?? this.userProfile,
      guides: guides ?? this.guides,
      communityPosts: communityPosts ?? this.communityPosts,
      isNetworkConnected: isNetworkConnected ?? this.isNetworkConnected,
      simulatedTimeOfDay: simulatedTimeOfDay ?? this.simulatedTimeOfDay,
      simulatedFirstTime: simulatedFirstTime != null
          ? simulatedFirstTime()
          : this.simulatedFirstTime,
      simulatedOffline: simulatedOffline != null
          ? simulatedOffline()
          : this.simulatedOffline,
      status: status ?? this.status,
      simulatedStatus: simulatedStatus != null
          ? simulatedStatus()
          : this.simulatedStatus,
    );
  }
}

class HomeController extends StateNotifier<HomeState> {
  final HomeRepository _repo;
  final Stream<bool> _connectivityStream;

  StreamSubscription? _userSub;
  StreamSubscription? _guidesSub;
  StreamSubscription? _postsSub;
  StreamSubscription? _connectSub;
  Timer? _timeoutTimer;

  bool _userLoaded = false;
  bool _guidesLoaded = false;
  bool _postsLoaded = false;

  HomeController(this._repo, this._connectivityStream) : super(HomeState()) {
    _init();
  }

  void _init() {
    _cancelSubscriptions();
    _userLoaded = false;
    _guidesLoaded = false;
    _postsLoaded = false;

    state = state.copyWith(status: HomeStatus.loading);

    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      if (state.status == HomeStatus.loading) {
        if (state.userProfile != null || state.guides.isNotEmpty) {
          state = state.copyWith(status: HomeStatus.successOffline);
        } else {
          state = state.copyWith(status: HomeStatus.error);
        }
      }
    });

    _userSub = _repo.getUserProfile().listen(
      (user) {
        _userLoaded = true;
        state = state.copyWith(userProfile: user);
        _checkLoadingSuccess();
      },
      onError: (err) {
        debugPrint('User stream error: $err');
        state = state.copyWith(status: HomeStatus.error);
      },
    );

    _guidesSub = _repo.getGuides().listen(
      (list) {
        _guidesLoaded = true;
        state = state.copyWith(guides: list);
        _checkLoadingSuccess();
      },
      onError: (err) {
        debugPrint('Guides stream error: $err');
        state = state.copyWith(status: HomeStatus.error);
      },
    );

    _postsSub = _repo.getCommunityPosts().listen(
      (list) {
        _postsLoaded = true;
        state = state.copyWith(communityPosts: list);
        _checkLoadingSuccess();
      },
      onError: (err) {
        debugPrint('Community posts stream error: $err');
        state = state.copyWith(status: HomeStatus.error);
      },
    );

    _connectSub = _connectivityStream.listen((connected) {
      state = state.copyWith(isNetworkConnected: connected);
      _updateOnlineOfflineStatus();
    });
  }

  void _checkLoadingSuccess() {
    if (_userLoaded && _guidesLoaded && _postsLoaded) {
      _timeoutTimer?.cancel();
      _updateOnlineOfflineStatus();
    }
  }

  void _updateOnlineOfflineStatus() {
    if (!_userLoaded || !_guidesLoaded || !_postsLoaded) return;

    if (state.isOffline) {
      state = state.copyWith(status: HomeStatus.successOffline);
    } else {
      state = state.copyWith(status: HomeStatus.successOnline);
    }
  }

  void retryLoading() {
    _init();
  }

  void _cancelSubscriptions() {
    _userSub?.cancel();
    _guidesSub?.cancel();
    _postsSub?.cancel();
    _connectSub?.cancel();
  }

  Future<void> completeCheckIn() async {
    try {
      if (state.isFirstTime) await _repo.updateFirstTimeStatus(false);
      await _repo.updateCheckInStatus(true);
    } catch (_) {}
  }

  Future<void> resetUserState() async {
    try {
      await _repo.updateFirstTimeStatus(false);
      await _repo.updateCheckInStatus(false);
    } catch (_) {}
  }

  Future<void> makeFirstTimeUser() async {
    try {
      await _repo.updateFirstTimeStatus(true);
      await _repo.updateCheckInStatus(false);
    } catch (_) {}
  }

  void setSimulatedTimeOfDay(String value) =>
      state = state.copyWith(simulatedTimeOfDay: value);

  void setSimulatedFirstTime(bool? value) =>
      state = state.copyWith(simulatedFirstTime: () => value);

  void setSimulatedOffline(bool? value) {
    state = state.copyWith(simulatedOffline: () => value);
    _updateOnlineOfflineStatus();
  }

  void setSimulatedStatus(HomeStatus? value) =>
      state = state.copyWith(simulatedStatus: () => value);

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _cancelSubscriptions();
    super.dispose();
  }
}

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) {
    final repo = ref.watch(homeRepositoryProvider);
    final stream = ref.watch(connectivityServiceProvider).onConnectionChanged;
    return HomeController(repo, stream);
  },
);
