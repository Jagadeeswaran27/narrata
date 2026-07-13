# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Just Audio & Audio Service
-keep class com.ryanheise.audioservice.** { *; }
-keep class com.ryanheise.just_audio.** { *; }

# ExoPlayer / Media3 (used by just_audio)
-keep class com.google.android.exoplayer2.** { *; }
-keep class androidx.media3.** { *; }

# Ignore missing Play Core classes for Flutter Deferred Components
-dontwarn com.google.android.play.core.**
