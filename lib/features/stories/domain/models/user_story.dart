class StoryProgress {
  final int positionInMilliseconds;
  final double percentage;
  final DateTime? lastReadAt;

  const StoryProgress({
    required this.positionInMilliseconds,
    required this.percentage,
    this.lastReadAt,
  });

  factory StoryProgress.fromMap(Map<String, dynamic> map) {
    return StoryProgress(
      positionInMilliseconds: map['positionInMilliseconds']?.toInt() ?? 0,
      percentage: (map['percentage'] ?? 0).toDouble(),
      lastReadAt: map['lastReadAt'] != null
          ? (map['lastReadAt']).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'positionInMilliseconds': positionInMilliseconds,
      'percentage': percentage,
      if (lastReadAt != null) 'lastReadAt': lastReadAt,
    };
  }
}

class UserStory {
  final String id;
  final bool isFavorite;
  final bool isDownloaded;
  final StoryProgress? progress;

  const UserStory({
    required this.id,
    this.isFavorite = false,
    this.isDownloaded = false,
    this.progress,
  });

  factory UserStory.fromMap(Map<String, dynamic> map, String id) {
    return UserStory(
      id: id,
      isFavorite: map['isFavorite'] ?? false,
      isDownloaded: map['isDownloaded'] ?? false,
      progress: map['progress'] != null && map['progress'].isNotEmpty
          ? StoryProgress.fromMap(map['progress'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isFavorite': isFavorite,
      'isDownloaded': isDownloaded,
      'progress': progress?.toMap() ?? {},
    };
  }
}
