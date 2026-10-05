import 'package:flutter/material.dart';

enum ServiceCondition { operational, attention, planned }

class CityService {
  const CityService({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.details,
    required this.icon,
    required this.color,
    required this.condition,
    required this.statusMessage,
    required this.contact,
    required this.responseTime,
  });

  final String id;
  final String title;
  final String category;
  final String description;
  final String details;
  final IconData icon;
  final Color color;
  final ServiceCondition condition;
  final String statusMessage;
  final String contact;
  final String responseTime;

  String get conditionLabel => switch (condition) {
        ServiceCondition.operational => 'Operational',
        ServiceCondition.attention => 'Service notice',
        ServiceCondition.planned => 'Planned',
      };
}
