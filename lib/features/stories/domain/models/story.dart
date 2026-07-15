class WordTimestamp {
  final String word;
  final double startTime;
  final double endTime;

  const WordTimestamp({
    required this.word,
    required this.startTime,
    required this.endTime,
  });

  factory WordTimestamp.fromMap(Map<String, dynamic> map) {
    double parseTime(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) {
        final clean = value.replaceAll('s', '');
        return double.tryParse(clean) ?? 0.0;
      }
      return 0.0;
    }

    return WordTimestamp(
      word: map['word']?.toString() ?? '',
      startTime: parseTime(map['startTime'] ?? map['start'] ?? map['start_time']),
      endTime: parseTime(map['endTime'] ?? map['end'] ?? map['end_time']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

class Story {
  final String id;
  final String title;
  final String description;
  final String genre;
  final String audioPath;
  final String thumbnailPath;
  final String content;
  final int readingTime;
  final List<WordTimestamp> timestamps;
  final bool isDownloaded;

  const Story({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    required this.audioPath,
    required this.thumbnailPath,
    required this.content,
    required this.readingTime,
    this.timestamps = const [],
    this.isDownloaded = false,
  });

  factory Story.fromMap(Map<String, dynamic> map, String id) {
    return Story(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      genre: map['genre'] ?? '',
      audioPath: map['audioPath'] ?? '',
      thumbnailPath: map['thumbnailPath'] ?? '',
      content: map['content'] ?? '',
      readingTime: map['readingTime'] ?? 5,
      timestamps: (map['timestamps'] as List<dynamic>?)
              ?.map((e) => WordTimestamp.fromMap(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isDownloaded: map['isDownloaded'] ?? false,
    );
  }

  Story copyWith({
    String? id,
    String? title,
    String? description,
    String? genre,
    String? audioPath,
    String? thumbnailPath,
    String? content,
    int? readingTime,
    List<WordTimestamp>? timestamps,
    bool? isDownloaded,
  }) {
    return Story(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      genre: genre ?? this.genre,
      audioPath: audioPath ?? this.audioPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      content: content ?? this.content,
      readingTime: readingTime ?? this.readingTime,
      timestamps: timestamps ?? this.timestamps,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'genre': genre,
      'audioPath': audioPath,
      'thumbnailPath': thumbnailPath,
      'content': content,
      'readingTime': readingTime,
      'timestamps': timestamps.map((e) => e.toMap()).toList(),
      'isDownloaded': isDownloaded,
    };
  }
}
