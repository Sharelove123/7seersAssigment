import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';
import '../../../models/guide_model.dart';
import '../../../models/community_post_model.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(FirebaseFirestore.instance);
});

class HomeRepository {
  final FirebaseFirestore _firestore;

  HomeRepository(this._firestore) {
    try {
      _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    } catch (_) {}
  }

  Stream<UserModel?> getUserProfile() {
    return _firestore.collection('users').doc('harsh_profile').snapshots().map((
      snap,
    ) {
      if (snap.exists && snap.data() != null) {
        return UserModel.fromMap(snap.data()!, snap.id);
      }
      return null;
    });
  }

  Future<void> updateCheckInStatus(bool completed) async {
    await _firestore.collection('users').doc('harsh_profile').update({
      'completedCheckIn': completed,
      'lastCheckInDate': completed ? FieldValue.serverTimestamp() : null,
    });
  }

  Future<void> updateFirstTimeStatus(bool isFirstTime) async {
    await _firestore.collection('users').doc('harsh_profile').update({
      'isFirstTime': isFirstTime,
    });
  }

  Stream<List<GuideModel>> getGuides() {
    return _firestore
        .collection('guides')
        .orderBy('order')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => GuideModel.fromMap(d.data(), d.id)).toList(),
        );
  }

  Stream<List<CommunityPostModel>> getCommunityPosts() {
    return _firestore
        .collection('community_posts')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => CommunityPostModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }
}
