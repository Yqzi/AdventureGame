import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:Questborne/colors.dart';
import 'package:Questborne/components/top_bar.dart';
import 'package:Questborne/models/subscription.dart';
import 'package:Questborne/services/subscription_service.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final SubscriptionService _subService = SubscriptionService();
  bool _loading = true;
  late UserSubscription _subscription;
  SubscriptionTier _selectedTier = SubscriptionTier.free;

  // ── Styling constants ─────────────────────────────────────

  static const _bgColor = Color.fromARGB(255, 41, 26, 20);
  static const _cardBase = Color.fromARGB(255, 30, 18, 14);
  static const _creamText = Color(0xFFE3D5B8);
  static const _goldAccent = Color(0xFFD4A846);
  static const _champGlow = Color(0xFFB44AFF);

  @override
  void initState() {
    super.initState();
    _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    final sub = await _subService.fetch();
    if (mounted) {
      setState(() {
        _subscription = sub;
        _selectedTier = sub.effectiveTier;
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
        title: 'SUBSCRIPTION',
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                // ── Current plan badge ──────────────────────
                _currentPlanBadge(),
                const SizedBox(height: 28),

                // ── Tier cards ──────────────────────────────
                ..._buildTierCards(),

                const SizedBox(height: 28),

                // ── FAQ ─────────────────────────────────────
                _sectionHeader('FAQ'),
                const SizedBox(height: 12),
                _faqTile(
                  'How do credits work?',
                  'Each quest turn (player action + AI response) costs 1 credit. '
                      'Credits reset on the 1st of every month.',
                ),
                const SizedBox(height: 8),
                _faqTile(
                  'What is story memory?',
                  'Story memory determines how much of the conversation the AI '
                      'remembers. On the free tier, older turns are summarised to '
                      'save space. Higher tiers keep more — or all — of the story intact.',
                ),
                const SizedBox(height: 8),
                _faqTile(
                  'Can I cancel anytime?',
                  'Yes. Your perks stay active until the end of the billing '
                      'period, then it reverts to Free.',
                ),
                const SizedBox(height: 8),
                _faqTile(
                  'What AI model do I get?',
                  'Free and Adventurer use Gemini 2.5 Flash — fast and creative. '
                      'Champion unlocks Gemini 2.5 Pro for richer, more detailed narratives.',
                ),

                const SizedBox(height: 40),
              ],
            ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  CURRENT PLAN BADGE
  // ─────────────────────────────────────────────────────────

  Widget _currentPlanBadge() {
    final tier = _subscription.effectiveTier;
    final accentColor = _accentFor(tier);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBase,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_iconFor(tier), color: accentColor, size: 22),
              const SizedBox(width: 10),
              Text(
                'CURRENT PLAN',
                style: GoogleFonts.epilogue(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.white54,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            tier.label.toUpperCase(),
            style: GoogleFonts.epilogue(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: accentColor,
              letterSpacing: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            tier.tagline,
            style: GoogleFonts.epilogue(fontSize: 13, color: Colors.white60),
          ),
          const SizedBox(height: 16),

          // Credits bar
          _creditsBar(),
        ],
      ),
    );
  }

  Widget _creditsBar() {
    final used = _subscription.maxCredits - _subscription.creditsRemaining;
    final pct = _subscription.maxCredits > 0
        ? used / _subscription.maxCredits
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_subscription.creditsRemaining} / ${_subscription.maxCredits} credits remaining',
              style: GoogleFonts.epilogue(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Resets ${_formatResetDate(_subscription.creditsResetAt)}',
              style: GoogleFonts.epilogue(fontSize: 11, color: Colors.white38),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: pct.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation(
              pct > 0.85 ? redText : _accentFor(_subscription.effectiveTier),
            ),
          ),
        ),
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
    return SubscriptionTier.values.map((tier) {
      final isCurrentTier = tier == _subscription.effectiveTier;
      final isSelected = tier == _selectedTier;
      final accent = _accentFor(tier);

      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: GestureDetector(
          onTap: () => setState(() => _selectedTier = tier),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isSelected
                  ? _cardBase.withOpacity(0.95)
                  : _cardBase.withOpacity(0.6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? accent : Colors.white10,
                width: isSelected ? 1.5 : 0.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: accent.withOpacity(0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(_iconFor(tier), color: accent, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          tier.label.toUpperCase(),
                          style: GoogleFonts.epilogue(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: accent,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    if (isCurrentTier)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: accent.withOpacity(0.3)),
                        ),
                        child: Text(
                          'CURRENT',
                          style: GoogleFonts.epilogue(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: accent,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  tier.tagline,
                  style: GoogleFonts.epilogue(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 14),

                // Price
                Text(
                  tier.priceLabel,
                  style: GoogleFonts.epilogue(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 14),

                // Feature list
                ...tier.features.map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_rounded, color: accent, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            f,
                            style: GoogleFonts.epilogue(
                              fontSize: 13,
                              color: Colors.white70,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Memory row with tappable info icon
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.check_rounded, color: accent, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${tier.memoryTag} Memory',
                        style: GoogleFonts.epilogue(
                          fontSize: 13,
                          color: Colors.white70,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _showMemoryInfo(tier),
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: 15,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ),

                // Subscribe button (only if not current)
                if (!isCurrentTier && tier != SubscriptionTier.free) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => _handleSubscribe(tier),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'SUBSCRIBE',
                        style: GoogleFonts.epilogue(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  // ─────────────────────────────────────────────────────────
  //  FAQ
  // ─────────────────────────────────────────────────────────

  Widget _faqTile(String question, String answer) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBase,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 14,
          ),
          iconColor: Colors.white38,
          collapsedIconColor: Colors.white24,
          title: Text(
            question,
            style: GoogleFonts.epilogue(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          children: [
            Text(
              answer,
              style: GoogleFonts.epilogue(
                fontSize: 12,
                color: Colors.white54,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
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
        decoration: BoxDecoration(
          color: _cardBase,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: const Border(
            top: BorderSide(color: Colors.white12, width: 0.5),
            left: BorderSide(color: Colors.white12, width: 0.5),
            right: BorderSide(color: Colors.white12, width: 0.5),
          ),
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
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Icon(Icons.psychology_outlined, color: accent, size: 32),
                const SizedBox(height: 12),
                Text(
                  '${tier.memoryTag.toUpperCase()} MEMORY',
                  style: GoogleFonts.epilogue(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: accent,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  tier.memoryExplanation,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.epilogue(
                    fontSize: 13,
                    color: Colors.white60,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white10,
                      foregroundColor: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'GOT IT',
                      style: GoogleFonts.epilogue(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
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

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: GoogleFonts.epilogue(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: _creamText,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Color _accentFor(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return Colors.white60;
      case SubscriptionTier.adventurer:
        return _goldAccent;
      case SubscriptionTier.champion:
        return _champGlow;
    }
  }

  IconData _iconFor(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return Icons.person_outline;
      case SubscriptionTier.adventurer:
        return Icons.shield_outlined;
      case SubscriptionTier.champion:
        return Icons.auto_awesome;
    }
  }

  void _handleSubscribe(SubscriptionTier tier) {
    // TODO: Integrate with platform IAP (RevenueCat / in_app_purchase).
    // For now show a placeholder bottom sheet.
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _subscribePlaceholder(ctx, tier),
    );
  }

  Widget _subscribePlaceholder(BuildContext ctx, SubscriptionTier tier) {
    final accent = _accentFor(tier);
    return Container(
      decoration: const BoxDecoration(
        color: _cardBase,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: Colors.white12, width: 0.5),
          left: BorderSide(color: Colors.white12, width: 0.5),
          right: BorderSide(color: Colors.white12, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Icon(_iconFor(tier), color: accent, size: 48),
              const SizedBox(height: 16),
              Text(
                'UPGRADE TO ${tier.label.toUpperCase()}',
                style: GoogleFonts.epilogue(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: accent,
                  letterSpacing: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tier.priceLabel,
                style: GoogleFonts.epilogue(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'In-app purchases are coming soon.\n'
                'This will connect to Apple / Google subscriptions.',
                textAlign: TextAlign.center,
                style: GoogleFonts.epilogue(
                  fontSize: 13,
                  color: Colors.white54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'GOT IT',
                    style: GoogleFonts.epilogue(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
