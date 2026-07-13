// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_verification_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PhoneVerificationState)
final phoneVerificationStateProvider = PhoneVerificationStateProvider._();

final class PhoneVerificationStateProvider
    extends $NotifierProvider<PhoneVerificationState, PhoneVerificationData?> {
  PhoneVerificationStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'phoneVerificationStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$phoneVerificationStateHash();

  @$internal
  @override
  PhoneVerificationState create() => PhoneVerificationState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhoneVerificationData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhoneVerificationData?>(value),
    );
  }
}

String _$phoneVerificationStateHash() =>
    r'd10506032678fa08abed516de946574ba255a448';

abstract class _$PhoneVerificationState
    extends $Notifier<PhoneVerificationData?> {
  PhoneVerificationData? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<PhoneVerificationData?, PhoneVerificationData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PhoneVerificationData?, PhoneVerificationData?>,
              PhoneVerificationData?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
