import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/home_repository.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../models/user_model.dart';
import '../../../models/guide_model.dart';
import '../../../models/community_post_model.dart';

class HomeState {
  final UserModel? userProfile;
  final List<GuideModel> guides;
  final List<CommunityPostModel> communityPosts;
  final bool isNetworkConnected;
  final String simulatedTimeOfDay;
  final bool? simulatedFirstTime;
  final bool? simulatedOffline;

  HomeState({
    this.userProfile,
    this.guides = const [],
    this.communityPosts = const [],
    this.isNetworkConnected = true,
    this.simulatedTimeOfDay = 'Auto',
    this.simulatedFirstTime,
    this.simulatedOffline,
  });

  bool get isOffline => simulatedOffline ?? !isNetworkConnected;

  bool get isFirstTime => simulatedFirstTime ?? (userProfile?.isFirstTime ?? false);

  bool get completedCheckIn {
    if (isFirstTime) return false;
    if (simulatedTimeOfDay == 'Evening') return true;
    if (simulatedTimeOfDay == 'Morning') return false;
    return userProfile?.completedCheckIn ?? false;
  }

  String get greetingText {
    final name = userProfile?.name ?? 'Harsh';
    if (isFirstTime) return 'Welcome,\n$name.';
    return effectiveTimeOfDay == 'Morning' ? 'Morning, $name.' : 'Evening, $name.';
  }

  String get accentText {
    if (isFirstTime) return 'glad you came.';
    return effectiveTimeOfDay == 'Morning' ? "it's a quiet one." : 'good work today.';
  }

  String get effectiveTimeOfDay {
    if (simulatedTimeOfDay != 'Auto') return simulatedTimeOfDay;
    final hour = DateTime.now().hour;
    return (hour >= 5 && hour < 17) ? 'Morning' : 'Evening';
  }

  HomeState copyWith({
    UserModel? userProfile,
    List<GuideModel>? guides,
    List<CommunityPostModel>? communityPosts,
    bool? isNetworkConnected,
    String? simulatedTimeOfDay,
    bool? Function()? simulatedFirstTime,
    bool? Function()? simulatedOffline,
  }) {
    return HomeState(
      userProfile: userProfile ?? this.userProfile,
      guides: guides ?? this.guides,
      communityPosts: communityPosts ?? this.communityPosts,
      isNetworkConnected: isNetworkConnected ?? this.isNetworkConnected,
      simulatedTimeOfDay: simulatedTimeOfDay ?? this.simulatedTimeOfDay,
      simulatedFirstTime: simulatedFirstTime != null ? simulatedFirstTime() : this.simulatedFirstTime,
      simulatedOffline: simulatedOffline != null ? simulatedOffline() : this.simulatedOffline,
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

  HomeController(this._repo, this._connectivityStream) : super(HomeState()) {
    _init();
  }

  void _init() {
    _userSub = _repo.getUserProfile().listen(
      (user) => state = state.copyWith(userProfile: user),
      onError: (_) {},
    );

    _guidesSub = _repo.getGuides().listen(
      (list) => state = state.copyWith(guides: list),
      onError: (_) {},
    );

    _postsSub = _repo.getCommunityPosts().listen(
      (list) => state = state.copyWith(communityPosts: list),
      onError: (_) {},
    );

    _connectSub = _connectivityStream.listen(
      (connected) => state = state.copyWith(isNetworkConnected: connected),
    );
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

  void setSimulatedTimeOfDay(String value) => state = state.copyWith(simulatedTimeOfDay: value);

  void setSimulatedFirstTime(bool? value) => state = state.copyWith(simulatedFirstTime: () => value);

  void setSimulatedOffline(bool? value) => state = state.copyWith(simulatedOffline: () => value);

  @override
  void dispose() {
    _userSub?.cancel();
    _guidesSub?.cancel();
    _postsSub?.cancel();
    _connectSub?.cancel();
    super.dispose();
  }
}

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>((ref) {
  final repo = ref.watch(homeRepositoryProvider);
  final stream = ref.watch(connectivityServiceProvider).onConnectionChanged;
  return HomeController(repo, stream);
});
