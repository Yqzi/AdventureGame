/// Subscription tiers and their associated perks.
///
/// The tier data lives in Supabase (`user_subscriptions` table) and is
/// fetched by [SubscriptionService]. Everything here is pure data –
/// no network calls.

// ─────────────────────────────────────────────────────────────
//  TIER ENUM
// ─────────────────────────────────────────────────────────────

enum SubscriptionTier { free, adventurer, champion }

extension SubscriptionTierX on SubscriptionTier {
  String get id {
    switch (this) {
      case SubscriptionTier.free:
        return 'free';
      case SubscriptionTier.adventurer:
        return 'adventurer';
      case SubscriptionTier.champion:
        return 'champion';
    }
  }

  String get label {
    switch (this) {
      case SubscriptionTier.free:
        return 'The Forsaken';
      case SubscriptionTier.adventurer:
        return 'The Blood-Sworn';
      case SubscriptionTier.champion:
        return 'The Eldritch Weaver';
    }
  }

  String get tagline {
    switch (this) {
      case SubscriptionTier.free:
        return 'The world owes you nothing';
      case SubscriptionTier.adventurer:
        return 'Bound by oath and blade';
      case SubscriptionTier.champion:
        return 'The story bends to your will';
    }
  }

  /// Monthly price in USD. 0 = free.
  double get priceUsd {
    switch (this) {
      case SubscriptionTier.free:
        return 0;
      case SubscriptionTier.adventurer:
        return 4.99;
      case SubscriptionTier.champion:
        return 9.99;
    }
  }

  String get priceLabel => this == SubscriptionTier.free
      ? 'Free'
      : '\$${priceUsd.toStringAsFixed(2)}';

  /// AI model identifier sent to the Edge Function.
  String get aiModel {
    switch (this) {
      case SubscriptionTier.free:
        return 'gemini-2.5-flash';
      case SubscriptionTier.adventurer:
        return 'gemini-3-flash';
      case SubscriptionTier.champion:
        return 'gemini-3.1-pro';
    }
  }

  String get aiModelLabel {
    switch (this) {
      case SubscriptionTier.free:
        return 'Gemini 2.5 Flash';
      case SubscriptionTier.adventurer:
        return 'Gemini 3 Flash';
      case SubscriptionTier.champion:
        return 'Gemini 3.1 Pro';
    }
  }

  /// Gemini generation temperature — higher = more creative prose.
  double get temperature {
    switch (this) {
      case SubscriptionTier.free:
        return 0.7;
      case SubscriptionTier.adventurer:
        return 0.75;
      case SubscriptionTier.champion:
        return 0.85;
    }
  }

  /// Max output tokens per response — controls response length/detail.
  int get maxOutputTokens {
    switch (this) {
      case SubscriptionTier.free:
        return 400;
      case SubscriptionTier.adventurer:
        return 600;
      case SubscriptionTier.champion:
        return 1000;
    }
  }

  /// Maximum monthly credits for this tier.
  int get maxCredits {
    switch (this) {
      case SubscriptionTier.free:
        return 30;
      case SubscriptionTier.adventurer:
        return 150;
      case SubscriptionTier.champion:
        return 500;
    }
  }

  /// Number of full (unsummarised) AI exchanges kept in context.
  /// `null` means unlimited (full memory).
  int? get memoryWindow {
    switch (this) {
      case SubscriptionTier.free:
        return 5; // 10 messages
      case SubscriptionTier.adventurer:
        return 30; // 60 messages
      case SubscriptionTier.champion:
        return null; // full memory
    }
  }

  /// Whether older turns beyond [memoryWindow] are summarised (true)
  /// or simply dropped (false). Champion doesn't need this (unlimited).
  bool get summarizesOlderTurns {
    switch (this) {
      case SubscriptionTier.free:
        return false; // older turns just dropped
      case SubscriptionTier.adventurer:
        return true; // older turns summarised
      case SubscriptionTier.champion:
        return false; // N/A — unlimited
    }
  }

  /// Whether the full player context (inventory, equipment details,
  /// status effects, gold) is sent to the AI. Free tier gets basics only.
  bool get sendsFullPlayerContext {
    switch (this) {
      case SubscriptionTier.free:
        return false;
      case SubscriptionTier.adventurer:
        return true;
      case SubscriptionTier.champion:
        return true;
    }
  }

  /// Tier-specific system prompt appended after the base persona.
  /// Free tier gets nothing extra. Higher tiers unlock richer AI behavior.
  String get tierPromptAppend {
    switch (this) {
      case SubscriptionTier.free:
        return '';
      case SubscriptionTier.adventurer:
        return '\n\n=== ADVANCED LORE SYSTEM ===\n'
            'You have access to the deep lore of this world. Weave history, '
            'factions, and ancient powers naturally into descriptions and NPC '
            'dialogue. Do not exposition dump — let the player feel the weight '
            'of history through subtle references and atmospheric detail. '
            'Environments should feel lived-in and layered with meaning. '
            'Reference events from the player\'s past actions when relevant.';
      case SubscriptionTier.champion:
        return '\n\n=== ELITE STORYTELLER DIRECTIVE ===\n'
            'You are running on an advanced reasoning engine. Elevate the prose '
            'to the level of a best-selling dark fantasy novel. Make the '
            'psychological dread deeper, the environments more vivid, and the '
            'NPCs devastatingly cunning. The player\'s actions from earlier in '
            'the story must ripple into the present with butterfly-effect '
            'consequences. Every NPC remembers. Every choice echoes. Write with '
            'the confidence of a master author — varied rhythm, gut-punch '
            'imagery, and silence used as a weapon.';
    }
  }

  /// Short memory tag shown on the card (e.g. "Basic").
  String get memoryTag {
    switch (this) {
      case SubscriptionTier.free:
        return 'Basic';
      case SubscriptionTier.adventurer:
        return 'Extended';
      case SubscriptionTier.champion:
        return 'Unlimited';
    }
  }

  /// Explanation shown when the user taps the memory info icon.
  String get memoryExplanation {
    switch (this) {
      case SubscriptionTier.free:
        return 'The AI remembers your last 5 turns. '
            'Older turns are forgotten — the story moves on, '
            'leaving the past behind.';
      case SubscriptionTier.adventurer:
        return 'The AI remembers your last 30 turns in detail. '
            'Older turns are automatically summarised so the story '
            'always has context — nothing important is lost.';
      case SubscriptionTier.champion:
        return 'The AI remembers your entire story — every choice, '
            'every detail. Nothing is ever summarised or forgotten.';
    }
  }

  /// Ordered feature list shown on the subscription page.
  /// Memory is rendered separately via [memoryTag] / [memoryExplanation].
  List<String> get features {
    switch (this) {
      case SubscriptionTier.free:
        return [
          '$maxCredits credits / month',
          aiModelLabel,
          'Short, focused responses',
          'Basic player tracking',
        ];
      case SubscriptionTier.adventurer:
        return [
          '$maxCredits credits / month',
          aiModelLabel,
          'Longer, richer responses',
          'Deep lore integration',
          'Full player state tracking',
        ];
      case SubscriptionTier.champion:
        return [
          '$maxCredits credits / month',
          aiModelLabel,
          'Novel-quality prose',
          'Butterfly-effect consequences',
          'Elite storytelling AI',
        ];
    }
  }

  static SubscriptionTier fromId(String id) {
    switch (id) {
      case 'adventurer':
        return SubscriptionTier.adventurer;
      case 'champion':
        return SubscriptionTier.champion;
      default:
        return SubscriptionTier.free;
    }
  }
}

// ─────────────────────────────────────────────────────────────
//  USER SUBSCRIPTION SNAPSHOT
// ─────────────────────────────────────────────────────────────

/// A read-only snapshot of the current user's subscription state.
class UserSubscription {
  final SubscriptionTier tier;
  final int creditsRemaining;
  final int maxCredits;
  final DateTime? expiresAt;
  final DateTime creditsResetAt;

  const UserSubscription({
    required this.tier,
    required this.creditsRemaining,
    required this.maxCredits,
    this.expiresAt,
    required this.creditsResetAt,
  });

  /// Whether the subscription is active (non-expired or free).
  bool get isActive =>
      tier == SubscriptionTier.free ||
      (expiresAt != null && expiresAt!.isAfter(DateTime.now()));

  /// Effective tier — falls back to free if expired.
  SubscriptionTier get effectiveTier => isActive ? tier : SubscriptionTier.free;

  /// Default state for a brand-new / unsigned-in user.
  factory UserSubscription.free() => UserSubscription(
    tier: SubscriptionTier.free,
    creditsRemaining: SubscriptionTier.free.maxCredits,
    maxCredits: SubscriptionTier.free.maxCredits,
    creditsResetAt: _nextMonthStart(),
  );

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    final tier = SubscriptionTierX.fromId(json['tier'] as String? ?? 'free');
    return UserSubscription(
      tier: tier,
      creditsRemaining: json['credits_remaining'] as int? ?? tier.maxCredits,
      maxCredits: json['max_credits'] as int? ?? tier.maxCredits,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      creditsResetAt: json['credits_reset_at'] != null
          ? DateTime.parse(json['credits_reset_at'] as String)
          : _nextMonthStart(),
    );
  }

  static DateTime _nextMonthStart() {
    final now = DateTime.now().toUtc();
    return DateTime.utc(now.year, now.month + 1, 1);
  }
}
