import 'package:flutter/material.dart';
import 'package:Questborne/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:Questborne/colors.dart';
import 'package:Questborne/components/top_bar.dart';
import 'package:Questborne/models/subscription.dart';
import 'package:Questborne/services/purchase_service.dart';
import 'package:Questborne/services/subscription_service.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final SubscriptionService _subService = SubscriptionService();
  final PurchaseService _purchaseService = PurchaseService();
  bool _loading = true;
  bool _purchasing = false;
  late UserSubscription _subscription;

  // ── Styling constants ─────────────────────────────────────

  static const _bgColor = Color.fromARGB(255, 41, 26, 20);
  static const _cardBase = Color.fromARGB(255, 30, 18, 14);
  static const _creamText = Color(0xFFE3D5B8);
  static const _champGlow = Color(0xFFB44AFF);

  // Muted, warm accent colors
  static const _freeAccent = Color(0xFF8A7E6E);
  static const _advAccent = Color(0xFFC2955A);
  static const _champAccent = Color(0xFF9B6ED4);

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _purchaseService.init();
    _purchaseService.onPurchaseResult = _onPurchaseResult;
    // Verify subscription with server (checks expiry, syncs state)
    await _subService.verify();
    await _loadSubscription();
  }

  @override
  void dispose() {
    _purchaseService.onPurchaseResult = null;
    super.dispose();
  }

  void _onPurchaseResult(SubscriptionTier tier, bool success, String? error) {
    if (!mounted) return;
    setState(() => _purchasing = false);
    if (success) {
      _loadSubscription();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _accentFor(tier).withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(
            'Upgraded to ${tier.label}!',
            style: GoogleFonts.epilogue(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else if (error != null && error != 'Purchase cancelled') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: redText.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(
            error,
            style: GoogleFonts.epilogue(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  Future<void> _loadSubscription() async {
    final sub = await _subService.fetch();
    if (mounted) {
      setState(() {
        _subscription = sub;
        _loading = false;
      });
    }
  }

  // ─────────────────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: TopBar(
        title: AppLocalizations.of(context).subscriptionPlans,
        textStyle: GoogleFonts.epilogue(
          color: _creamText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          height: 1.25,
          fontStyle: FontStyle.italic,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: _creamText,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: redText, strokeWidth: 2),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              children: [
                // ── Credits overview ────────────────────────
                _creditsSection(),
                const SizedBox(height: 32),

                // ── Tier cards ──────────────────────────────
                ..._buildTierCards(),

                // ── Manage subscription (always visible) ───
                Center(
                  child: TextButton(
                    onPressed: () => _openManageSubscription(),
                    child: Text(
                      AppLocalizations.of(context).subscriptionManageGooglePlay,
                      style: GoogleFonts.epilogue(
                        fontSize: 13,
                        color: Colors.white38,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white38,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  CREDITS SECTION
  // ─────────────────────────────────────────────────────────

  Widget _creditsSection() {
    final tier = _subscription.effectiveTier;
    final isDailyTier = _subscription.dailyCredits > 0;
    final pct = (!isDailyTier && _subscription.maxCredits > 0)
        ? (_subscription.maxCredits - _subscription.creditsRemaining) /
              _subscription.maxCredits
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_subscription.creditsRemaining}',
              style: GoogleFonts.epilogue(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _accentFor(tier).withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tier.label,
                style: GoogleFonts.epilogue(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _accentFor(tier),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          isDailyTier
              ? AppLocalizations.of(
                  context,
                ).subscriptionCreditsDaily(_subscription.dailyCredits)
              : AppLocalizations.of(
                  context,
                ).subscriptionCreditsRemaining(_subscription.maxCredits),
          style: GoogleFonts.epilogue(fontSize: 13, color: Colors.white38),
        ),
        if (!isDailyTier) ...[
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: Colors.white.withOpacity(0.06),
              valueColor: AlwaysStoppedAnimation(
                pct > 0.85 ? redText : _accentFor(tier).withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).subscriptionResets(
              _formatResetDate(_subscription.creditsResetAt),
            ),
            style: GoogleFonts.epilogue(fontSize: 11, color: Colors.white24),
          ),
        ],
      ],
    );
  }

  String _formatResetDate(DateTime date) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month]} ${date.day}';
  }

  // ─────────────────────────────────────────────────────────
  //  TIER CARDS
  // ─────────────────────────────────────────────────────────

  List<Widget> _buildTierCards() {
    const order = [
      SubscriptionTier.champion,
      SubscriptionTier.adventurer,
      SubscriptionTier.free,
    ];
    return order.map((tier) {
      final isCurrentTier = tier == _subscription.effectiveTier;
      final accent = _accentFor(tier);
      final isChampion = tier == SubscriptionTier.champion;

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isChampion
                ? _champGlow.withOpacity(0.06)
                : _cardBase.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_iconFor(tier), color: accent, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tier.label,
                          style: GoogleFonts.epilogue(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        Text(
                          tier.tagline,
                          style: GoogleFonts.epilogue(
                            fontSize: 12,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isCurrentTier)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        AppLocalizations.of(context).subscriptionCurrent,
                        style: GoogleFonts.epilogue(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: accent,
                        ),
                      ),
                    ),
                  if (!isCurrentTier)
                    Text(
                      _purchaseService.storePriceFor(tier) ?? tier.priceLabel,
                      style: GoogleFonts.epilogue(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white54,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 18),

              // Features — compact rows
              _featureRow(
                Icons.bolt_outlined,
                tier.dailyCredits > 0
                    ? '${tier.dailyCredits} credits / day'
                    : '${tier.maxCredits} credits / month',
                accent,
              ),
              const SizedBox(height: 8),
              _featureRow(Icons.memory_outlined, tier.aiModelLabel, accent),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showMemoryInfo(tier),
                child: Row(
                  children: [
                    Icon(
                      Icons.psychology_outlined,
                      color: accent.withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${tier.memoryTag} memory',
                      style: GoogleFonts.epilogue(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.info_outline_rounded,
                      size: 13,
                      color: Colors.white24,
                    ),
                  ],
                ),
              ),

              // Action button
              if (!isCurrentTier) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: TextButton(
                    onPressed: () => _handleSubscribe(tier),
                    style: TextButton.styleFrom(
                      backgroundColor: accent.withOpacity(0.12),
                      foregroundColor: accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      tier == SubscriptionTier.free
                          ? 'Manage in Play Store'
                          : tier.index > _subscription.effectiveTier.index
                          ? 'Upgrade to ${tier.label}'
                          : 'Switch to ${tier.label}',
                      style: GoogleFonts.epilogue(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
              if (isCurrentTier && tier != SubscriptionTier.free) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: TextButton(
                    onPressed: () => _handleSubscribe(tier),
                    style: TextButton.styleFrom(
                      backgroundColor: accent.withOpacity(0.12),
                      foregroundColor: accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Change Billing Period',
                      style: GoogleFonts.epilogue(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _featureRow(IconData icon, String text, Color accent) {
    return Row(
      children: [
        Icon(icon, color: accent.withOpacity(0.7), size: 16),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.epilogue(fontSize: 13, color: Colors.white60),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  //  MEMORY INFO BOTTOM SHEET
  // ─────────────────────────────────────────────────────────

  void _showMemoryInfo(SubscriptionTier tier) {
    final accent = _accentFor(tier);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: _cardBase,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Icon(Icons.psychology_outlined, color: accent, size: 28),
                const SizedBox(height: 12),
                Text(
                  '${tier.memoryTag} Memory',
                  style: GoogleFonts.epilogue(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  tier.memoryExplanation,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.epilogue(
                    fontSize: 13,
                    color: Colors.white54,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.06),
                      foregroundColor: Colors.white60,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Got it',
                      style: GoogleFonts.epilogue(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  HELPERS
  // ─────────────────────────────────────────────────────────

  void _openManageSubscription() {
    launchUrl(
      Uri.parse('https://play.google.com/store/account/subscriptions'),
      mode: LaunchMode.externalApplication,
    );
  }

  Color _accentFor(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return _freeAccent;
      case SubscriptionTier.adventurer:
        return _advAccent;
      case SubscriptionTier.champion:
        return _champAccent;
    }
  }

  IconData _iconFor(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return Icons.explore_outlined;
      case SubscriptionTier.adventurer:
        return Icons.shield_outlined;
      case SubscriptionTier.champion:
        return Icons.auto_awesome;
    }
  }

  void _handleSubscribe(SubscriptionTier tier) {
    if (_purchasing) return;

    // Free tier = just show info, no purchase needed.
    if (tier == SubscriptionTier.free) {
      // Nothing to buy — user is already on free or can cancel via Play Store.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _freeAccent.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(
            'Manage your subscription in the Play Store to downgrade.',
            style: GoogleFonts.epilogue(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
      return;
    }

    // Show the Play Store purchase sheet.
    final storePrice = _purchaseService.storePriceFor(tier);
    _showPurchaseSheet(tier, storePrice);
  }

  void _showPurchaseSheet(SubscriptionTier tier, String? storePrice) {
    final accent = _accentFor(tier);
    final basePlans = tier.basePlanIds;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: _cardBase,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Icon(_iconFor(tier), color: accent, size: 32),
                const SizedBox(height: 12),
                Text(
                  tier.label,
                  style: GoogleFonts.epilogue(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose a plan',
                  style: GoogleFonts.epilogue(
                    fontSize: 13,
                    color: Colors.white38,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Duration options ──
                _planOption(
                  ctx: ctx,
                  tier: tier,
                  accent: accent,
                  label: '1 Month',
                  months: 1,
                  basePlanId: basePlans[1]!,
                ),
                const SizedBox(height: 10),
                _planOption(
                  ctx: ctx,
                  tier: tier,
                  accent: accent,
                  label: '6 Months',
                  months: 6,
                  basePlanId: basePlans[6]!,
                  badge: 'Save 15%',
                ),
                const SizedBox(height: 10),
                _planOption(
                  ctx: ctx,
                  tier: tier,
                  accent: accent,
                  label: '12 Months',
                  months: 12,
                  basePlanId: basePlans[12]!,
                  badge: 'Best deal',
                  highlighted: true,
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white38,
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.epilogue(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _planOption({
    required BuildContext ctx,
    required SubscriptionTier tier,
    required Color accent,
    required String label,
    required int months,
    required String basePlanId,
    String? badge,
    bool highlighted = false,
  }) {
    final storePrice = _purchaseService.priceForBasePlan(tier, basePlanId);
    final perMonth = tier.priceForMonths(months);
    final total = perMonth * months;

    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        setState(() => _purchasing = true);
        final started = _purchaseService.buyBasePlan(tier, basePlanId);
        if (!started) {
          setState(() => _purchasing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: redText.withOpacity(0.9),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: Text(
                'Product not available. Try again later.',
                style: GoogleFonts.epilogue(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: highlighted
              ? accent.withOpacity(0.08)
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.epilogue(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge,
                            style: GoogleFonts.epilogue(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: accent,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    storePrice != null
                        ? '$storePrice / $months mo'
                        : '\$${perMonth.toStringAsFixed(2)} / mo',
                    style: GoogleFonts.epilogue(
                      fontSize: 12,
                      color: Colors.white30,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              storePrice ?? '\$${total.toStringAsFixed(2)}',
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: highlighted ? accent : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
