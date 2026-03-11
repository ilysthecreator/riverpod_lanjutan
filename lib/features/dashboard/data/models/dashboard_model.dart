class DashboardStats {
  final String title;
  final String value;
  final String subtitle;

  DashboardStats({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      title: json['title'] ?? '',
      value: json['value'] ?? '0',
      subtitle: json['subtitle'] ?? '',
    );
  }   

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "value": value,
      "subtitle": subtitle,
    };
  }
}

class DashboardData {
  final List<DashboardStats> stats;
  final String userName;
  final DateTime lastUpdate;

  DashboardData({
    required this.stats,
    required this.userName,
    required this.lastUpdate,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      stats: 
        (json['stats'] as List?)
            ?.map((e) => DashboardStats.fromJson(e))
            .toList() ?? 
        [],
      userName: json['userName'] ?? 'User',
      lastUpdate: DateTime.tryParse(
            json['lastUpdate'] ?? DateTime.now().toString(),
          ) ?? 
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "stats": stats.map((e) => e.toJson()).toList(),
      "userName": userName,
      "lastUpdate": lastUpdate.toIso8601String(),
    };
  }

  // Copy with method
  DashboardData copyWith({
    List<DashboardStats>? stats,
    String? userName,
    DateTime? lastUpdate,
  }) {
    return DashboardData(
      stats: stats ?? this.stats,
      userName: userName ?? this.userName,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
