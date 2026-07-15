import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:narrata/core/network/connectivity_provider.dart';
import 'package:narrata/core/router/app_router.dart';

class ConnectivityWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const ConnectivityWrapper({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends ConsumerState<ConnectivityWrapper> {
  bool _isOffline = false;
  bool _showBackOnline = false;
  bool _isDismissed = false;
  Timer? _backOnlineTimer;

  @override
  void dispose() {
    _backOnlineTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<InternetStatus>>(connectivityProvider, (previous, next) {
      final wasOffline = previous?.value == InternetStatus.disconnected;
      final isNowOffline = next.value == InternetStatus.disconnected;
      final isNowOnline = next.value == InternetStatus.connected;

      if (isNowOffline) {
        setState(() {
          _isOffline = true;
          _showBackOnline = false;
          _isDismissed = false;
        });
        _backOnlineTimer?.cancel();
      } else if (wasOffline && isNowOnline) {
        setState(() {
          _isOffline = false;
          _showBackOnline = true;
        });
        
        _backOnlineTimer?.cancel();
        _backOnlineTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showBackOnline = false;
            });
          }
        });
      }
    });

    final bool showBanner = (!_isDismissed && _isOffline) || _showBackOnline;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            bottom: showBanner ? 40 : -150,
            left: 24,
            right: 24,
            child: SafeArea(
              bottom: true,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: _isOffline 
                        ? Theme.of(context).colorScheme.errorContainer
                        : Colors.green.shade100, // Success color for back online
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isOffline ? Icons.cloud_off : Icons.cloud_done_outlined,
                        color: _isOffline 
                            ? Theme.of(context).colorScheme.onErrorContainer
                            : Colors.green.shade800,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isOffline ? 'You are offline.' : 'Back online!',
                          style: TextStyle(
                            color: _isOffline 
                                ? Theme.of(context).colorScheme.onErrorContainer
                                : Colors.green.shade800,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (_isOffline)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isDismissed = true;
                            });
                            ref.read(appRouterProvider).push('/downloads');
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            backgroundColor: Theme.of(context).colorScheme.onErrorContainer.withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Downloads'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

