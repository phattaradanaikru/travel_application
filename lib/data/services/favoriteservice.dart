import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_application/data/model/tatmodel.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  Future<void> addToFavorites(Data place) async {
    if (_userId == null) throw Exception('User not logged in');

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .doc(place.placeId.toString())
          .set(place.toJson());

      print('✅ Added to favorites: ${place.name}');
    } catch (e) {
      print('❌ Error adding to favorites: $e');
      rethrow;
    }
  }

  Future<void> removeFromFavorites(String placeId) async {
    if (_userId == null) throw Exception('User not logged in');

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .doc(placeId)
          .delete();

      print('✅ Removed from favorites: $placeId');
    } catch (e) {
      print('❌ Error removing from favorites: $e');
      rethrow;
    }
  }

  Future<List<Data>> getFavorites() async {
    if (_userId == null) return [];

    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('favorites')
              .get();

      final favorites =
          snapshot.docs.map((doc) => Data.fromJson(doc.data())).toList();

      print('✅ Loaded ${favorites.length} favorites');
      return favorites;
    } catch (e) {
      print('❌ Error loading favorites: $e');
      return [];
    }
  }

  Future<bool> isInFavorites(String placeId) async {
    if (_userId == null) return false;

    try {
      final doc =
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('favorites')
              .doc(placeId)
              .get();

      return doc.exists;
    } catch (e) {
      print('❌ Error checking favorites: $e');
      return false;
    }
  }


  Future<int> getFavoritesCount() async {
    if (_userId == null) return 0;

    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('favorites')
              .count()
              .get();

      return snapshot.count ?? 0;
    } catch (e) {
      print('❌ Error getting favorites count: $e');
      return 0;
    }
  }

  Future<void> addToFavoritesMap(
    String placeId,
    Map<String, dynamic> placeData,
  ) async {
    if (_userId == null) throw Exception('User not logged in');

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .doc(placeId)
          .set(placeData);

      print('✅ Added to favorites: ${placeData['name']}');
    } catch (e) {
      print('❌ Error adding to favorites: $e');
      rethrow;
    }
  }

}
