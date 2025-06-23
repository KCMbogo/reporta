enum FeedbackType {
  suggestion,
  bug,
  feature,
  general,
}

class UserFeedback {
  final int? id;
  final int? userId;
  final String feedback;
  final FeedbackType type;
  final int rating;
  final String? email;
  final String? name;
  final DateTime createdAt;

  UserFeedback({
    this.id,
    this.userId,
    required this.feedback,
    this.type = FeedbackType.general,
    this.rating = 5,
    this.email,
    this.name,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert UserFeedback to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'feedback': feedback,
      'type': type.name,
      'rating': rating,
      'email': email,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create UserFeedback from Map (database result)
  factory UserFeedback.fromMap(Map<String, dynamic> map) {
    return UserFeedback(
      id: map['id']?.toInt(),
      userId: map['user_id']?.toInt(),
      feedback: map['feedback'] ?? '',
      type: FeedbackType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => FeedbackType.general,
      ),
      rating: map['rating']?.toInt() ?? 5,
      email: map['email'],
      name: map['name'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Create a copy of UserFeedback with updated fields
  UserFeedback copyWith({
    int? id,
    int? userId,
    String? feedback,
    FeedbackType? type,
    int? rating,
    String? email,
    String? name,
    DateTime? createdAt,
  }) {
    return UserFeedback(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      feedback: feedback ?? this.feedback,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Get feedback type display name
  String get typeDisplayName {
    switch (type) {
      case FeedbackType.suggestion:
        return 'Suggestion';
      case FeedbackType.bug:
        return 'Bug Report';
      case FeedbackType.feature:
        return 'Feature Request';
      case FeedbackType.general:
        return 'General Feedback';
    }
  }

  // Get feedback type icon
  String get typeIcon {
    switch (type) {
      case FeedbackType.suggestion:
        return 'lightbulb';
      case FeedbackType.bug:
        return 'bug_report';
      case FeedbackType.feature:
        return 'new_releases';
      case FeedbackType.general:
        return 'feedback';
    }
  }

  @override
  String toString() {
    return 'UserFeedback{id: $id, type: $type, rating: $rating}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserFeedback &&
        other.id == id &&
        other.feedback == feedback &&
        other.type == type &&
        other.rating == rating;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        feedback.hashCode ^
        type.hashCode ^
        rating.hashCode;
  }
}
