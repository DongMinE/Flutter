import 'package:flutter_riverpod/flutter_riverpod.dart';

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    print(
      '[provider Updated] provider: $provider / pv: $previousValue / nv: $newValue',
    );
  }

  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value,
      ProviderContainer container) {
    print(
      '[provider Added] provider: $provider / pv: $value',
    );
  }

  @override
  void didDisposeProvider(
      ProviderBase<Object?> provider, ProviderContainer container) {
    print(
      '[provider Dispose] provider: $provider',
    );
  }
}
