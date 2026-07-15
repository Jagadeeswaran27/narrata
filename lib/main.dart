import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';

import 'package:narrata/core/router/app_router.dart';
import 'package:narrata/core/theme/app_theme.dart';
import 'package:narrata/core/widgets/connectivity_wrapper.dart';
import 'package:narrata/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidNotificationIcon: 'drawable/ic_notification',
  );
  
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.music());
  
  runApp(const ProviderScope(child: NarrataApp()));
}

class NarrataApp extends ConsumerWidget {
  const NarrataApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Narrata',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      builder: (context, child) {
        return ConnectivityWrapper(
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
