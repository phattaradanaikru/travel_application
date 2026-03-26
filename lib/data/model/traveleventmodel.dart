import 'package:flutter/material.dart';

class TravelEvent {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? location;
  final String? placeId;
  final EventType type;
  final String? notes;
  final DateTime createdAt;

  TravelEvent({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    this.startTime,
    this.endTime,
    this.location,
    this.placeId,
    this.type = EventType.general,
    this.notes,
    required this.createdAt,
  });

  factory TravelEvent.fromJson(Map<String, dynamic> json) {
    return TravelEvent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      startTime:
          json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      location: json['location'],
      placeId: json['placeId'],
      type: EventType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => EventType.general,
      ),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'location': location,
      'placeId': placeId,
      'type': type.name,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  TravelEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? placeId,
    EventType? type,
    String? notes,
    DateTime? createdAt,
  }) {
    return TravelEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      placeId: placeId ?? this.placeId,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum EventType {
  visit('เที่ยวชม', Icons.place, Colors.blue),
  activity('กิจกรรม', Icons.local_activity, Colors.orange),
  food('อาหาร', Icons.restaurant, Colors.green),
  accommodation('ที่พัก', Icons.hotel, Colors.purple),
  transport('เดินทาง', Icons.directions_car, Colors.red),
  general('ทั่วไป', Icons.event, Colors.grey);

  const EventType(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
}
