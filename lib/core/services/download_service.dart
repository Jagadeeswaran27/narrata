import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:narrata/features/stories/domain/models/story.dart';

part 'download_service.g.dart';

@Riverpod(keepAlive: true)
class DownloadedStories extends _$DownloadedStories {
  static const _prefsKey = 'downloaded_stories';
  SharedPreferences? _prefs;

  @override
  Map<String, Story> build() {
    _init();
    return {};
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final List<String>? saved = _prefs?.getStringList(_prefsKey);
    if (saved != null) {
      final Map<String, Story> loadedStories = {};
      for (final jsonStr in saved) {
        try {
          final map = jsonDecode(jsonStr) as Map<String, dynamic>;
          final story = Story.fromMap(map, map['id'] as String);
          loadedStories[story.id] = story;
        } catch (e) {
          debugPrint('Error decoding downloaded story: $e');
        }
      }
      state = loadedStories;
    } else {
      state = {};
    }
  }

  Future<bool> downloadStory(Story story) async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${docDir.path}/downloads');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      // Download Audio
      if (story.audioPath.isNotEmpty) {
        final audioFile = File('${downloadsDir.path}/${story.id}_audio.mp3');
        final audioRef = FirebaseStorage.instance.ref().child(story.audioPath);
        await audioRef.writeToFile(audioFile);
      }

      // Download Thumbnail
      if (story.thumbnailPath.isNotEmpty) {
        final thumbFile = File('${downloadsDir.path}/${story.id}_thumb.jpg');
        final thumbRef = FirebaseStorage.instance.ref().child(story.thumbnailPath);
        await thumbRef.writeToFile(thumbFile);
      }

      final newState = Map<String, Story>.from(state);
      newState[story.id] = story;
      state = newState;
      
      final jsonList = state.values.map((s) => jsonEncode(s.toMap())).toList();
      await _prefs?.setStringList(_prefsKey, jsonList);
      return true;
    } catch (e) {
      debugPrint('Download error: $e');
      return false;
    }
  }

  Future<void> removeStory(String storyId) async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final audioFile = File('${docDir.path}/downloads/${storyId}_audio.mp3');
      final thumbFile = File('${docDir.path}/downloads/${storyId}_thumb.jpg');

      if (await audioFile.exists()) await audioFile.delete();
      if (await thumbFile.exists()) await thumbFile.delete();

      final newState = Map<String, Story>.from(state)..remove(storyId);
      state = newState;
      
      final jsonList = state.values.map((s) => jsonEncode(s.toMap())).toList();
      await _prefs?.setStringList(_prefsKey, jsonList);
    } catch (e) {
      debugPrint('Remove error: $e');
    }
  }

  Future<String?> getLocalAudioPath(String storyId) async {
    final docDir = await getApplicationDocumentsDirectory();
    final audioFile = File('${docDir.path}/downloads/${storyId}_audio.mp3');
    if (await audioFile.exists()) return audioFile.path;
    return null;
  }

  Future<String?> getLocalThumbnailPath(String storyId) async {
    final docDir = await getApplicationDocumentsDirectory();
    final thumbFile = File('${docDir.path}/downloads/${storyId}_thumb.jpg');
    if (await thumbFile.exists()) return thumbFile.path;
    return null;
  }
}
