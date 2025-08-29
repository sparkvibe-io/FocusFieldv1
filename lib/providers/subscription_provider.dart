import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/models/subscription_tier.dart';
import 'package:silence_score/services/subscription_service.dart';
import 'package:silence_score/services/hosted_paywall_service.dart';

// Subscription service provider
final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService.instance;
});

// Current subscription tier provider
final subscriptionTierProvider = StreamProvider<SubscriptionTier>((ref) {
  final subscriptionService = ref.watch(subscriptionServiceProvider);
  return subscriptionService.tierStream;
});

// Subscription tier state provider (latest value; stream already provides reactivity)
final subscriptionTierStateProvider = Provider<SubscriptionTier>((ref) {
  final service = ref.watch(subscriptionServiceProvider);
  // Ensure stream is listened to so updates propagate elsewhere if needed
  ref.watch(subscriptionTierProvider);
  return service.currentTier;
});

// Provider for checking if service is initialized
final subscriptionInitializedProvider = StateProvider<bool>((ref) {
  final subscriptionService = ref.watch(subscriptionServiceProvider);
  return subscriptionService.isInitialized;
});

// Feature access providers
final premiumAccessProvider = Provider<bool>((ref) {
  final tierAsync = ref.watch(subscriptionTierProvider);
  return tierAsync.maybeWhen(
    data: (tier) => tier != SubscriptionTier.free,
    orElse: () {
      // Fallback to current snapshot if stream not ready
      final service = ref.watch(subscriptionServiceProvider);
      return service.currentTier != SubscriptionTier.free;
    },
  );
});


// Session limits provider
final maxSessionMinutesProvider = Provider<int>((ref) {
  final tier = ref.watch(subscriptionTierStateProvider);
  return tier.maxSessionMinutes;
});

// History retention provider
final historyDaysProvider = Provider<int>((ref) {
  final tier = ref.watch(subscriptionTierStateProvider);
  return tier.historyDays;
});

// Feature access helper provider
final featureAccessProvider = Provider.family<bool, String>((ref, featureId) {
  final tierAsync = ref.watch(subscriptionTierProvider);
  return tierAsync.maybeWhen(
    data: (tier) => tier.hasFeatureAccess(featureId),
    orElse: () {
      final service = ref.watch(subscriptionServiceProvider);
      return service.currentTier.hasFeatureAccess(featureId);
    },
  );
});

// Subscription actions notifier
class SubscriptionActionsNotifier extends StateNotifier<AsyncValue<void>> {
  SubscriptionActionsNotifier(this._subscriptionService) : super(const AsyncValue.data(null));

  final SubscriptionService _subscriptionService;

  Future<void> initialize() async {
    state = const AsyncValue.loading();
    try {
      await _subscriptionService.initialize();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> purchasePremium({bool isYearly = false}) async {
    state = const AsyncValue.loading();
    try {
      final success = await _subscriptionService.purchasePremium(isYearly: isYearly);
      if (success) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error('Purchase was cancelled or failed', StackTrace.current);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }


  Future<void> restorePurchases() async {
    state = const AsyncValue.loading();
    try {
      final success = await _subscriptionService.restorePurchases();
      if (success) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error('No purchases found to restore', StackTrace.current);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Subscription actions provider
final subscriptionActionsProvider = StateNotifierProvider<SubscriptionActionsNotifier, AsyncValue<void>>((ref) {
  final subscriptionService = ref.watch(subscriptionServiceProvider);
  return SubscriptionActionsNotifier(subscriptionService);
});

// Hosted paywall provider (null if unavailable)
final hostedPaywallProvider = FutureProvider<Map<String, dynamic>?>(
  (ref) async {
    final service = ref.read(subscriptionServiceProvider);
    if (!service.isInitialized) {
      try {
        await service.initialize();
      } catch (_) {
        return null; // fallback silently
      }
    }
    return HostedPaywallService.instance.getHostedPaywall();
  },
);
