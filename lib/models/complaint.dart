enum ComplaintStatus {
  pending,
  inProgress,
  resolved,
  closed,
}

enum ComplaintPriority {
  low,
  medium,
  high,
  urgent,
}

class Complaint {
  final int? id;
  final int? userId;
  final String title;
  final String complaint;
  final ComplaintPriority priority;
  final ComplaintStatus status;
  final String? email;
  final String? name;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  Complaint({
    this.id,
    this.userId,
    required this.title,
    required this.complaint,
    this.priority = ComplaintPriority.medium,
    this.status = ComplaintStatus.pending,
    this.email,
    this.name,
    this.phoneNumber,
    DateTime? createdAt,
    this.resolvedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert Complaint to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'complaint': complaint,
      'priority': priority.name,
      'status': status.name,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'created_at': createdAt.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
    };
  }

  // Create Complaint from Map (database result)
  factory Complaint.fromMap(Map<String, dynamic> map) {
    return Complaint(
      id: map['id']?.toInt(),
      userId: map['user_id']?.toInt(),
      title: map['title'] ?? '',
      complaint: map['complaint'] ?? '',
      priority: ComplaintPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => ComplaintPriority.medium,
      ),
      status: ComplaintStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ComplaintStatus.pending,
      ),
      email: map['email'],
      name: map['name'],
      phoneNumber: map['phone_number'],
      createdAt: DateTime.parse(map['created_at']),
      resolvedAt: map['resolved_at'] != null ? DateTime.parse(map['resolved_at']) : null,
    );
  }

  // Create a copy of Complaint with updated fields
  Complaint copyWith({
    int? id,
    int? userId,
    String? title,
    String? complaint,
    ComplaintPriority? priority,
    ComplaintStatus? status,
    String? email,
    String? name,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? resolvedAt,
  }) {
    return Complaint(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      complaint: complaint ?? this.complaint,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  // Get priority display name
  String get priorityDisplayName {
    switch (priority) {
      case ComplaintPriority.low:
        return 'Low';
      case ComplaintPriority.medium:
        return 'Medium';
      case ComplaintPriority.high:
        return 'High';
      case ComplaintPriority.urgent:
        return 'Urgent';
    }
  }

  // Get status display name
  String get statusDisplayName {
    switch (status) {
      case ComplaintStatus.pending:
        return 'Pending';
      case ComplaintStatus.inProgress:
        return 'In Progress';
      case ComplaintStatus.resolved:
        return 'Resolved';
      case ComplaintStatus.closed:
        return 'Closed';
    }
  }

  // Get priority color
  String get priorityColor {
    switch (priority) {
      case ComplaintPriority.low:
        return 'success';
      case ComplaintPriority.medium:
        return 'warning';
      case ComplaintPriority.high:
        return 'error';
      case ComplaintPriority.urgent:
        return 'error';
    }
  }

  // Get status color
  String get statusColor {
    switch (status) {
      case ComplaintStatus.pending:
        return 'warning';
      case ComplaintStatus.inProgress:
        return 'info';
      case ComplaintStatus.resolved:
        return 'success';
      case ComplaintStatus.closed:
        return 'secondary';
    }
  }

  @override
  String toString() {
    return 'Complaint{id: $id, title: $title, priority: $priority, status: $status}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Complaint &&
        other.id == id &&
        other.title == title &&
        other.complaint == complaint &&
        other.priority == priority &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        complaint.hashCode ^
        priority.hashCode ^
        status.hashCode;
  }
}
