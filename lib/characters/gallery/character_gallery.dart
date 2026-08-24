import 'package:flutter/material.dart';

import '../characters.dart';

class CharactersGalleryApp extends StatelessWidget {
  const CharactersGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flavor Folk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF6E9),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE0472F)),
      ),
      home: const FlavorFolkGalleryScreen(),
    );
  }
}

class FlavorFolkGalleryScreen extends StatefulWidget {
  const FlavorFolkGalleryScreen({super.key});

  @override
  State<FlavorFolkGalleryScreen> createState() =>
      _FlavorFolkGalleryScreenState();
}

class _FlavorFolkGalleryScreenState extends State<FlavorFolkGalleryScreen> {
  bool live = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 40),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Flavor Folk',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF33251D),
                    ),
                  ),
                ),
                const Text(
                  'Live',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0x9933251D),
                  ),
                ),
                Switch(
                  value: live,
                  activeTrackColor: const Color(0xFFE0472F),
                  onChanged: (v) => setState(() => live = v),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${allFoodCharacters.length} hand-drawn characters, 5 moods each',
              style: const TextStyle(fontSize: 14, color: Color(0x9933251D)),
            ),
            const SizedBox(height: 18),
            for (final family in characterFamilies) ...[
              _FamilyHeader(family: family),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.74,
                ),
                itemCount: family.members.length,
                itemBuilder: (context, index) => _CharacterCard(
                  character: family.members[index],
                  live: live,
                ),
              ),
              const SizedBox(height: 26),
            ],
          ],
        ),
      ),
    );
  }
}

class _FamilyHeader extends StatelessWidget {
  const _FamilyHeader({required this.family});

  final CharacterFamily family;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            family.name,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: Color(0xFF33251D),
            ),
          ),
          Text(
            family.tagline,
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: Color(0x8C33251D),
            ),
          ),
        ],
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  const _CharacterCard({required this.character, required this.live});

  final FoodCharacter character;
  final bool live;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              CharacterDetailScreen(character: character, live: live),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0x2E33251D), width: 1.4),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1433251D),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: FittedBox(
                child: live
                    ? AnimatedFoodCharacterView(
                        character: character,
                        size: 110,
                        fps: 8,
                      )
                    : FoodCharacterView(character: character, size: 110),
              ),
            ),
            Text(
              character.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF33251D),
              ),
            ),
            Text(
              character.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: Color(0x8C33251D)),
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterDetailScreen extends StatefulWidget {
  const CharacterDetailScreen({
    super.key,
    required this.character,
    this.live = true,
  });

  final FoodCharacter character;
  final bool live;

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  CharacterMood mood = CharacterMood.signature;

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF33251D),
        title: Text(
          '${character.name} · ${character.family}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 40),
          children: [
            Center(
              child: widget.live
                  ? AnimatedFoodCharacterView(
                      character: character,
                      mood: mood,
                      size: 290,
                      fps: 12,
                      interactive: true,
                    )
                  : FoodCharacterView(
                      character: character,
                      mood: mood,
                      size: 290,
                    ),
            ),
            if (widget.live)
              const Center(
                child: Text(
                  'tap to perform · drag to tease · hold for a yum',
                  style: TextStyle(fontSize: 12, color: Color(0x7333251D)),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final m in CharacterMood.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ChoiceChip(
                      label: Text(
                        m.label,
                        style: const TextStyle(fontSize: 12),
                      ),
                      selected: mood == m,
                      selectedColor: character.accent.withValues(alpha: 0.32),
                      onSelected: (_) => setState(() => mood = m),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                character.moodLore[mood] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Color(0xB833251D),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              character.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF33251D),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              character.story,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Color(0xD933251D),
              ),
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final m in CharacterMood.values)
                  GestureDetector(
                    onTap: () => setState(() => mood = m),
                    child: Container(
                      decoration: BoxDecoration(
                        color: mood == m
                            ? character.accent.withValues(alpha: 0.18)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: mood == m
                              ? character.accent
                              : const Color(0x2133251D),
                        ),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: FoodCharacterView(
                        character: character,
                        mood: m,
                        size: 54,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
