import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_application/data/model/traveleventmodel.dart';

class CalendarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  Future<Map<DateTime, List<TravelEvent>>> getEvents() async {
    if (_userId == null) return {};

    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('events')
              .orderBy('date')
              .get();

      final events = <DateTime, List<TravelEvent>>{};

      for (final doc in snapshot.docs) {
        final event = TravelEvent.fromJson(doc.data());
        final date = DateTime(
          event.date.year,
          event.date.month,
          event.date.day,
        );

        if (events[date] == null) {
          events[date] = [];
        }
        events[date]!.add(event);
      }

      return events;
    } catch (e) {
      print('❌ Error loading events: $e');
      return {};
    }
  }

  Future<void> addEvent(TravelEvent event) async {
    if (_userId == null) throw Exception('User not logged in');

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('events')
          .doc(event.id)
          .set(event.toJson());

      print('✅ Event added: ${event.title}');
    } catch (e) {
      print('❌ Error adding event: $e');
      rethrow;
    }
  }

  Future<void> addEventFromPlace({
    required String placeId,
    required String placeName,
    required DateTime date,
    String? location,
    String? description,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? notes,
  }) async {
    DateTime? startDateTime;
    DateTime? endDateTime;

    if (startTime != null) {
      startDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        startTime.hour,
        startTime.minute,
      );
    }

    if (endTime != null) {
      endDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        endTime.hour,
        endTime.minute,
      );
    }

    final event = TravelEvent(
      id: '${placeId}_${DateTime.now().millisecondsSinceEpoch}',
      title:
          description?.isNotEmpty == true
              ? description!
              : 'เที่ยวชม $placeName',
      description: description,
      date: date,
      startTime: startDateTime,
      endTime: endDateTime,
      location: location,
      placeId: placeId,
      type: EventType.visit,
      notes: notes,
      createdAt: DateTime.now(),
    );

    await addEvent(event);
  }

  Future<void> removeEvent(String eventId) async {
    if (_userId == null) throw Exception('User not logged in');

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('events')
          .doc(eventId)
          .delete();

      print('✅ Event removed: $eventId');
    } catch (e) {
      print('❌ Error removing event: $e');
      rethrow;
    }
  }

  Future<void> updateEvent(TravelEvent event) async {
    if (_userId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('events')
          .doc(event.id)
          .update(event.toJson());

      print('✅ Event updated: ${event.title}');
    } catch (e) {
      print('❌ Error updating event: $e');
      rethrow;
    }
  }

  Future<List<TravelEvent>> getEventsForDate(DateTime date) async {
    if (_userId == null) return [];

    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot =
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('events')
              .where(
                'date',
                isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
              )
              .where('date', isLessThan: endOfDay.toIso8601String())
              .orderBy('date')
              .get();

      return snapshot.docs
          .map((doc) => TravelEvent.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('❌ Error loading events for date: $e');
      return [];
    }
  }
}
