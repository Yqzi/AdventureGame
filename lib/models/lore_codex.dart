/// The Hollowed Codex — layered world lore injected into AI prompts.
///
/// Structure:
///   • **Global lore** — creation myth, gods, factions, world state
///   • **Region lore** — one entry per quest location (Forest, Cave, Ruins)
///
/// All users receive the global section + the region section that matches
/// the active quest's location.

class LoreCodex {
  LoreCodex._(); // not instantiable

  // ───────────────────────────────────────────────────────
  //  GLOBAL LORE
  // ───────────────────────────────────────────────────────

  static const String _globalLore = '''
The world was not born — it was severed. The old texts speak of the Sundering, \
when the Firstborn Gods warred over the shape of creation. Their battle cracked \
reality itself, leaving wounds that never fully healed. From those wounds seeped \
the Hollow — a creeping corruption of void-stuff that unmakes what it touches.

Three gods survived the Sundering. The Radiant One, who forged the sun and \
declared dominion over the surface world. The Deep Mother, who burrowed into \
the earth's core and claimed all that grows beneath stone. And Death, eldest of \
the three, who walks both worlds freely and answers to no prayer.

Mortals built their kingdoms in the aftermath, but the old wounds fester. Titans \
slumber in chains forged during the Sundering. Sealed gates hold back abyssal \
armies. Ancient prisons deteriorate century by century. The Hollow spreads — not \
as an invasion, but as a slow erosion of the barriers between what is and what \
should never be.

There are those who fight: druids tend the World Tree's roots, clerics maintain \
the binding seals, and wandering heroes carry blades into the dark. But the \
Sundering left more cracks than mortal hands can mend. The world does not need \
saving — it needs holding together, one broken seal at a time.''';

  // ───────────────────────────────────────────────────────
  //  REGION LORE
  // ───────────────────────────────────────────────────────

  static const String _forestLore = '''
The Thornveil Forest is the oldest living thing in the world. At its heart stands \
the World Tree — a miles-high titan of bark and branch whose roots pierce the \
underworld itself. The forest breathes with its own will: paths shift between \
visits, clearings appear where none existed, and the canopy filters sunlight \
into shades the open sky never produces.

Beyond the deep canopy — past wards that make mortal compasses spin and torches \
gutter — lies Vaelith, the Thorn-Sealed Kingdom of the elves. The Vaelithi \
severed contact with the mortal realm three centuries ago, after a human lord \
burned an elvish embassy over a trade dispute and no king punished him for it. \
Since then, the Thornwall — a living barrier of briar and enchantment — has \
marked the border. Humans who cross it do not come back. The elves do not \
explain why.

Vaelith is ruled by the Verdant Court: a monarch (currently Queen Seylith the \
Undying, who has reigned for four hundred years) advised by a council of twelve \
High Canopy lords. Succession passes not by blood but by trial — the Bloom \
Rite, where candidates descend into the World Tree's root-hollows and return \
changed, or do not return at all. Elvish society is rigid, ceremonial, and \
slow to act, which their critics call arrogance and their defenders call \
patience measured in centuries rather than seasons.

The Thornwall keeps mortal vermin out — no goblin camps sprout beneath \
Vaelithi canopy, no bandits waylay elvish roads. But isolation is not safety. \
The Court contends with its own rot: a faction called the Pale Root seeks to \
overthrow Seylith, claiming her long reign has calcified the kingdom into a \
beautiful corpse. Assassinations dressed as hunting accidents have claimed two \
High Canopy lords in the last decade. Deeper still, something stirs in the \
root-hollows beneath Vaelith that the elves will not name aloud — a blight \
that withers their ancient trees from the inside, as though the World Tree \
itself is rejecting the Thornwall's seal.

Not all Vaelithi share the Court's isolationism. Exiles, traders, and the \
simply curious slip through the Thornwall — some to spy, some to trade herbs \
mortal healers cannot grow, and some because they believe the Sundering's \
wounds will eventually swallow Vaelith too, and pretending otherwise is a \
longer form of suicide. These border-crossers are tolerated by the Court as \
long as they are deniable.

The Fey Courts are a separate matter entirely — sprites, wisps, and old \
trickster-spirits bound by pacts that predate even the elves. When those pacts \
hold, the fey are mischievous but survivable. When the pacts fray, they turn \
to ambush and enchantment with no distinction between elf and human prey. \
Druids of the Circle of Thorn serve as mediators, though their numbers thin \
each decade.

Outside the Thornwall, the mortal forest rots freely: goblin camps spread \
along the trade roads, a fire cult builds pyre-altars between the trees, and \
something ancient stirs beneath the World Tree's roots. The Thornveil has \
survived catastrophe before — but its protectors are fewer now, the Vaelithi \
watch from behind their wall, and the wounds cut deeper with each passing \
season.''';

  static const String _caveLore = '''
Beneath the surface lies the Hollows — a vast network of caverns, mines, and \
forgotten chambers that descend far deeper than any mortal has mapped. The upper \
tunnels are crowded with life: miners extract ore, smugglers run contraband by \
torchlight, and fighting pits operate in the lawless dark. Below the worked \
stone lie older passages carved by no human hand.

The Deep Mother's influence pervades the Hollows. Fungal growths glow with \
bioluminescent spite, and the deeper one descends, the more the stone itself \
seems to pulse with slow, ancient breath. At the network's lowest point beats \
the Heart of the Mountain — a living organ of stone and magma that some scholars \
believe is the Deep Mother's own heart, still beating after the Sundering.

The deepest reaches belong to the Ossborn — once-human monks who descended \
underground so many generations ago they no longer resemble what they were. \
Their skin has gone translucent and paper-thin, their eyes sealed shut beneath \
smooth bone, their movements guided by tremorsense and the vibrations of the \
stone around them. When the original wardens who chained the titans and sealed \
the demons died, the Ossborn refused to let their knowledge perish. They \
developed the Rite of Grafting: harvesting bones from the ancient warden dead \
and fusing them into their own skeletons. Each grafted bone carries a fragment \
of the original warden's memory — how a binding was forged, which rune sequence \
holds a particular seal, where a ward-stone must be placed. An elder Ossborn \
may carry the bones of a dozen wardens in their body, their skull ridged with \
fused fragments, speaking in voices not entirely their own.

The Ossborn do not rule the Hollows — they haunt them. They maintain the \
ancient prisons by compulsion, driven by inherited memory they did not choose \
and cannot fully separate from their own thoughts. Some have gone mad from the \
weight of dead men's knowledge. Others have begun to forget which memories are \
theirs. The Forge Spirit works alongside them but considers them tools, not \
allies — useful bodies carrying instructions the Spirit wrote millennia ago.

The deeper tunnels are riddled with traps — not crude pit-and-spike affairs, \
but warden-craft inherited through grafted bone. Pressure plates trigger \
grinding stone walls that seal passages behind intruders, cutting off retreat. \
Rune-etched floor tiles release bursts of searing heat when stepped on in the \
wrong sequence — the Ossborn walk the correct pattern from muscle memory they \
did not earn. Near the sealed prisons, the traps grow more deliberate: bone \
chimes strung across corridors that shatter into razor shrapnel when disturbed, \
pools of still water concealing submerged spike grates that drop under weight, \
and collapsed-looking rubble that is actually a loaded deadfall, rigged to \
bury anything that tries to dig through. The Ossborn do not mark their traps. \
They do not need to — the dead wardens' bones remember every one.

Surface dwellers unsettle the Ossborn. Miners and smugglers who crowd the \
upper tunnels are tolerated the way a body tolerates an itch — beneath notice \
until they scratch too deep. When humans breach a sealed passage or crack a \
ward-stone for the ore inside, the Ossborn respond without warning and without \
negotiation. They are not cruel. They simply do not think in terms that \
include mercy. The bindings must hold. Everything else is noise.

Ancient prisons riddle the mid-depths, their ward-stones crumbling. Titans were \
chained here. Demons were sealed behind binding pillars. A Devourer — something \
that predates even the gods — stirs in the deepest vault. The Forge Spirit tends \
what bindings remain, and the Ossborn carry the dead wardens' knowledge in \
their grafted bones — but the locks are failing faster than either can mend \
them.''';

  static const String _ruinsLore = '''
The Ruins of Valdris are all that remain of a kingdom that rose in the \
centuries after the Sundering and — by every account — fell in a single \
night. The histories say Valdris was destroyed: some texts blame the demon \
Azrathar, others the apprentice Morvaine who sought lichdom and shattered \
the kingdom's wards from within. No one disputes that Valdris is gone. The \
ruins are treated as a graveyard — dangerous, cursed, and dead.

No scholar, no historian, no living mortal knows what actually happened. \
There are no texts that tell the truth. The truth does not exist on the \
surface.

The upper ruins are filled with restless undead, cursed artifacts that \
whisper to those who pass, and seals that grow weaker with every grave \
robber who pries them open. Scholar Veyra and Historian Korval catalog what \
they can, but neither understands why the architecture sometimes behaves \
wrongly — rooms that feel larger inside than out, corridors that seem to \
loop, walls that hum faintly if you press your ear to them. They attribute \
it to residual enchantment. They are wrong, but they will never know that.

The Tithebound are not human. They are the remnants of an ancient species \
— tall, gaunt, ash-grey skinned — whose name has been lost, even to themselves. \
They arrived at the ruins centuries after Valdris vanished, drawn by something \
they could feel resonating through the stone from miles away. They were the \
first to descend deep enough to hear the sound. They were the first to be \
changed by it. Whatever they were before — whatever civilization they came \
from, whatever purpose brought them here — was stripped from them layer by \
layer. What remains are wardens who do not know what they are warding, \
patrolling corridors in loops they cannot explain, guarding passages they do \
not remember sealing, attacking intruders with reflexive violence that feels \
like inherited duty but is closer to reflex.

Most Tithebound are far gone — silent figures with hollow eyes and mechanical \
movements, their ash-grey skin stretched tight over angular bones that do not \
quite match any mortal skeleton. But some still carry fragments: a gesture \
that might once have been a greeting in a language no one speaks, a flinch \
when asked what they remember. They cannot form proper thoughts. They speak \
in broken phrases — "was not... a deal," "the sound... it takes," \
"don't go... deeper" — and they cannot explain what they mean. Whatever \
happened to their kind, whatever turned an entire species into hollow sentinels, \
the knowledge was stripped from them long ago. They know something is wrong. \
They cannot remember what.

The sound that made them has not been heard since. Whatever reached up from \
the deep ruins and took the Tithebound went silent afterward — or went deeper. \
The hum in the lowest corridors is faint, almost imagined. Scholars dismiss \
it. No one alive has heard more than that. No one goes that far.''';

  // ── Deep Ruins lore: unlocked at level 60+ ──

  static const String _ruinsDeepLore = '''
At this depth, the player encounters rare Tithebound who are more aware \
than any found above — elders of their lost species who have somehow \
resisted the erosion longer than they should have. They can form full \
sentences, though their voices shake and they lose their thread mid-thought. \
They remember fragments of what happened to their kind:
- Their people came to the ruins seeking the source of a resonance they \
could feel through the earth. They thought it was a calling. It was not.
- The sound they heard shaped itself into what each of them wanted most — \
purpose, belonging, answers. By the time they understood it was not a \
bargain, it had already taken too much. Their entire species was hollowed \
out over generations.
- Something exists beyond where the hum is loudest. They call it "the \
other side" or "where it comes from" — they have no name for it because \
the name was one of the first things taken.
- The architecture is wrong because it is a scar — something was here \
and was ripped away. What remains is the wound.
- They beg the player not to go deeper. Not because they know what's \
there. Because they can feel it pulling at them still, even now.

The sound that took the Tithebound's species — silent for centuries — \
returns at this depth. The Nameless Choir: not creatures, not spirits, \
but sound itself. The noise a dimensional wound makes, rising again after \
ages of quiet. It strips memory with prolonged exposure: first small \
things (a face, a flavor, a name), then larger ones (purpose, identity, \
the knowledge that you were ever anything else). The Choir does not hunt \
or think. It is the sound of a tear that refuses to close, and memory is \
what bleeds through. It has woken again — perhaps because something on \
the other side knows the player is approaching.

Beyond the Choir — through the wound itself — lies something. The aware \
Tithebound cannot say what. They feel it: intact, vast, alive, and aware \
of those who approach. The only path to it passes through the Nameless \
Choir. No one has found another way. The method of passage is unknown — \
surviving the Choir long enough to reach what's on the other side may \
not be a matter of strength alone.

=== THE KINGDOM OF VALDRIS (FOLDED DIMENSION) ===
If the player passes through the Nameless Choir, they emerge into Valdris \
itself — not ruins, but the living kingdom, pulled whole into a folded \
dimension by the Severance spell centuries ago. First impressions: the air \
is too still, the light has no source, and the silence after the Choir is \
almost worse than the sound.

The city is intact — towers of pale stone rising impossibly high, streets \
paved in dark glass that reflects a sky with no stars, bridges connecting \
spires over chasms that drop into nothing. It is beautiful in the way a \
corpse can be beautiful before you notice it isn't breathing right. The \
architecture obeys rules that feel almost correct but bend at the edges — \
arches that curve a degree too far, staircases that ascend and somehow \
arrive lower than they started, windows that look out onto corridors you \
just walked through from the other side.

The citizens of Valdris are still here. They move through the streets in \
slow processions, dressed in court finery that has not aged. They smile \
when they see the player — too wide, held too long. They speak in complete \
sentences that loop: "Welcome to Valdris, traveler. We have been expecting \
you. Welcome to Valdris, traveler." They are not hostile. They are not \
friendly. They are performing the memory of being alive, and the performance \
has worn grooves into itself over centuries. Some repeat the same gesture — \
lifting a cup, turning a page, bowing to an empty chair — endlessly, their \
eyes tracking nothing.

The throne room sits at the city's center, always visible from any street \
as though the city curves inward toward it. Whatever occupies the throne \
is not what sat there before the Severance. The Valdris Court Arcanists \
who cast the spell are gone — consumed by it, or merged with the dimension \
itself. What rules now is the dimension's own awareness given shape: a \
presence that wears the crown because the kingdom expects a king. It does \
not speak unless spoken to. When it does speak, its voice is the Nameless \
Choir — quieter, focused, directed. It knows the player's name. It knows \
what memories the Choir took on the way in. It offers to return them. \
The price is staying.

Do NOT dump this lore as exposition. Let the player discover the kingdom \
piece by piece — the wrongness of the streets, the looping citizens, the \
throne that is always visible. Reveal details through exploration, not \
narration.''';

  // ───────────────────────────────────────────────────────
  //  CROSS-REGION LORE FRAGMENTS
  // ───────────────────────────────────────────────────────
  //  Concise entity-specific entries included when a quest
  //  references creatures, factions, or concepts from
  //  another region. Keyed by tag; quests declare which
  //  tags they need via Quest.loreKeys.
  // ───────────────────────────────────────────────────────

  static const Map<String, String> _loreFragments = {
    'hollows':
        'The Hollows are a vast network of caverns beneath the surface — '
        'upper tunnels crowded with miners and smugglers, deeper passages '
        'carved by no human hand. The Deep Mother\'s influence pervades the '
        'depths: bioluminescent fungal growths spread upward, toxic spore '
        'clouds drift through breached tunnels, and the stone itself pulses '
        'with slow, ancient breath. Corruption seeps to the surface through '
        'cracks in the rock, poisoning soil and water above. Ancient prisons '
        'riddle the mid-depths, their ward-stones crumbling — titans chained '
        'here, demons sealed behind binding pillars.',

    'ossborn':
        'The Ossborn are once-human monks who descended underground '
        'generations ago. Their skin has gone translucent and paper-thin, '
        'their eyes sealed shut beneath smooth bone, their movements guided '
        'by tremorsense. They maintain the ancient prisons through the Rite '
        'of Grafting: harvesting bones from dead wardens and fusing them into '
        'their own skeletons, each grafted bone carrying a fragment of the '
        'original warden\'s memory. They respond to threats against the '
        'bindings without warning or mercy. They do not think in terms that '
        'include negotiation.',

    'deepMother':
        'The Deep Mother is one of the three surviving gods of the Sundering. '
        'She burrowed into the earth\'s core and claimed all that grows '
        'beneath stone. Her influence pervades the Hollows as bioluminescent '
        'fungal growths, toxic spore clouds, and living stone that pulses '
        'with slow breath. The Heart of the Mountain — a living organ of '
        'stone and magma at the Hollows\' deepest point — may be her own '
        'heart, still beating.',

    'forgeSpirit':
        'The Forge Spirit is an ancient entity that tends the bindings and '
        'seals in the deep Hollows. It works alongside the Ossborn but '
        'considers them tools, not allies — useful bodies carrying '
        'instructions the Spirit wrote millennia ago. Its deep forge is '
        'where warden-craft is maintained and renewed.',

    'tithebound':
        'The Tithebound are remnants of an ancient species — tall, gaunt, '
        'ash-grey skinned — whose name has been lost even to themselves. '
        'They were drawn to the Valdris ruins by a resonance in the stone '
        'and were hollowed out by the Nameless Choir over generations. They '
        'now patrol corridors in loops they cannot explain, attacking '
        'intruders with reflexive violence. They speak only in broken '
        'fragments: "was not... a deal," "the sound... it takes," '
        '"don\'t go... deeper."',

    'namelessChoir':
        'The Nameless Choir is not creatures, not spirits, but sound '
        'itself — the noise a dimensional wound makes. It strips memory '
        'with prolonged exposure: first small things (a face, a name), then '
        'larger ones (purpose, identity). It woke once and took an entire '
        'species — the Tithebound. After centuries of silence, it stirs '
        'again in the deepest reaches of the Valdris ruins.',

    'valdrisSeverance':
        'The kingdom of Valdris was not destroyed — it was pulled whole '
        'into a folded dimension by the Severance spell centuries ago. The '
        'ruins on the surface are scars left behind. Beyond the Nameless '
        'Choir lies Valdris intact: towers of pale stone, streets of dark '
        'glass, looping citizens performing the memory of being alive.',

    'vaelith':
        'Vaelith is the Thorn-Sealed Kingdom of the elves, hidden behind '
        'the Thornwall in the deep Thornveil Forest. Ruled by Queen Seylith '
        'the Undying for four hundred years, the elves severed contact with '
        'mortals three centuries ago. The Pale Root faction seeks to '
        'overthrow Seylith, and a blight in the root-hollows withers their '
        'ancient trees from within.',

    'paleRoot':
        'The Pale Root is a rebel faction within Vaelith. They seek to '
        'overthrow Queen Seylith, claiming her long reign has calcified the '
        'kingdom into a beautiful corpse. Assassinations dressed as hunting '
        'accidents have claimed High Canopy lords. Some agents cross the '
        'Thornwall to sabotage druidic shrines, wanting the barrier to fall '
        'so Vaelith can expand by force.',

    'feyCourts':
        'The Fey Courts are sprites, wisps, and old trickster-spirits bound '
        'by pacts that predate even the elves. When pacts hold, the fey are '
        'mischievous but survivable. When pacts fray, they turn to ambush '
        'and enchantment with no distinction between elf and human prey. '
        'The Circle of Thorn druids serve as mediators, though their numbers '
        'thin each decade.',

    'worldTree':
        'The World Tree stands at the heart of the Thornveil Forest — a '
        'miles-high titan of bark and branch whose roots pierce the '
        'underworld itself. Beneath it lie root-hollows where the elves '
        'perform their sacred rites. A Hollow-corruption blight now withers '
        'the roots from within, as though the World Tree itself is rejecting '
        'the Thornwall\'s seal.',

    'wardenCraft':
        'Warden-craft traps were built by the ancient wardens who chained '
        'the titans and sealed the demons during the Sundering. Pressure '
        'plates trigger grinding stone walls, rune-etched tiles release '
        'searing heat, bone chimes shatter into razor shrapnel, and '
        'deadfalls bury intruders. The Ossborn inherited knowledge of every '
        'trap through grafted warden-bones.',
  };

  // ───────────────────────────────────────────────────────
  //  LOOKUP
  // ───────────────────────────────────────────────────────

  static const Map<String, String> _regionLore = {
    'Forest': _forestLore,
    'Cave': _caveLore,
    'Ruins': _ruinsLore,
  };

  /// Returns the lore context string for the given [location],
  /// [playerLevel], and optional [loreKeys] for cross-region consistency.
  ///
  /// • Global lore + region-specific lore for [location].
  /// • **Ruins + level ≥ 60** → additionally includes the Nameless Choir /
  ///   true-Valdris deep lore.
  /// • **loreKeys** → concise lore fragments for entities from other
  ///   regions that appear in this quest, ensuring narrative consistency
  ///   regardless of the active map.
  static String getLore(
    String? location, {
    int playerLevel = 1,
    List<String> loreKeys = const [],
  }) {
    final regionSection = _regionLore[location];
    final buf = StringBuffer();
    buf.writeln('=== THE HOLLOWED CODEX — WORLD LORE ===');
    buf.writeln();
    buf.writeln(_globalLore);
    if (regionSection != null) {
      buf.writeln();
      buf.writeln('--- Region: $location ---');
      buf.writeln();
      buf.writeln(regionSection);
    }
    // Unlock the Nameless Choir / true-Valdris dimension at level 60+.
    if (location == 'Ruins' && playerLevel >= 60) {
      buf.writeln();
      buf.writeln('--- The Severance Depths ---');
      buf.writeln();
      buf.writeln(_ruinsDeepLore);
    }
    // Append cross-region lore fragments for narrative consistency.
    if (loreKeys.isNotEmpty) {
      final fragments = <String>[];
      for (final key in loreKeys) {
        final f = _loreFragments[key];
        if (f != null) fragments.add(f);
      }
      if (fragments.isNotEmpty) {
        buf.writeln();
        buf.writeln('--- Cross-Region Lore (Narrative Consistency) ---');
        buf.writeln();
        buf.writeln(
          'The following entities, species, or factions may be encountered '
          'or referenced during this quest. Use this lore to maintain '
          'consistency with the established world. Present it naturally '
          'through the narrative — never as exposition dumps. If the player '
          'has encountered these before, treat the lore as something the '
          'world already established, not new information to announce.',
        );
        for (final fragment in fragments) {
          buf.writeln();
          buf.writeln(fragment);
        }
      }
    }
    return buf.toString();
  }
}
