import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseSeeder {
  static Future<void> seedIfNeeded() async {
    try {
      final db = FirebaseFirestore.instance;

      final userDoc = await db.collection('users').doc('harsh_profile').get();
      if (!userDoc.exists) {
        await db.collection('users').doc('harsh_profile').set({
          'name': 'Harsh',
          'isFirstTime': true,
          'completedCheckIn': false,
          'lastCheckInDate': null,
        });
      }

      final guidesCollection = db.collection('guides');
      final batch = db.batch();

      batch.set(guidesCollection.doc('sleepless_month'), {
        'title': 'The first sleepless month',
        'description': 'A short read on what no one tells you. 6 min.',
        'imageUrl': 'https://images.unsplash.com/photo-1544124499-58912cbddaad?w=600&auto=format&fit=crop',
        'category': "THIS WEEK'S GUIDE",
        'tag': null,
        'order': 1,
      }, SetOptions(merge: true));

      batch.set(guidesCollection.doc('struggle_love'), {
        'title': 'You can love it and\nstill struggle',
        'description': 'Pick up where you left off',
        'imageUrl': 'https://images.unsplash.com/photo-1516627145497-ae6968895b74?w=600&auto=format&fit=crop',
        'category': 'PICK UP WHERE YOU LEFT OFF',
        'tag': null,
        'order': 2,
      }, SetOptions(merge: true));

      batch.set(guidesCollection.doc('how_to_be_there'), {
        'title': "How to be there\nwhen you don't know how",
        'description': "This week's guide for first-time users",
        'imageUrl': 'https://images.unsplash.com/photo-1536640712-4d4c36ff0e4e?w=600&auto=format&fit=crop',
        'category': "THIS WEEK'S GUIDE",
        'tag': 'Paid Guide',
        'order': 3,
      }, SetOptions(merge: true));

      batch.set(guidesCollection.doc('talking_it_out'), {
        'title': 'First-time dads\ntalking it out',
        'description': 'From your guides',
        'imageUrl': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=600&auto=format&fit=crop',
        'category': 'FROM YOUR GUIDES',
        'tag': 'FREE',
        'order': 4,
      }, SetOptions(merge: true));

      await batch.commit();

      final postsSnap = await db.collection('community_posts').limit(1).get();
      if (postsSnap.docs.isEmpty) {
        await db.collection('community_posts').doc('marcus_post').set({
          'author': 'Marcus',
          'authorInitial': 'M',
          'text': "Slept through tonight's feed. Felt like winning.",
          'group': '2 dads',
          'timestamp': '35 minutes ago',
        });
      }
    } catch (e) {
      debugPrint('Seeder error: $e');
    }
  }
}
