import 'package:flutter/material.dart';

void main() {
  runApp(const ScriviaApp());
}

class ScriviaApp extends StatelessWidget {
  const ScriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrivia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF08080F),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2;

  final List<Widget> _screens = [
    const StatsScreen(),
    const LessonsScreen(),
    const HomeScreen(),
    const WriteScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08080F),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: const Color(0xFF14141F),
        selectedItemColor: const Color(0xFF7B5EFF),
        unselectedItemColor: const Color(0xFF8888AA),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Leçons'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Écrire'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Réglages'),
        ],
      ),
    );
  }
}

// ─── ACCUEIL ─────────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08080F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bonjour, Lucas 👋',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                      Text('Continuons à progresser',
                          style: TextStyle(fontSize: 13, color: Color(0xFF8888AA))),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A1A60),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('🔥 7j', style: TextStyle(color: Color(0xFF9D7FFF), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Score card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B5EFF), Color(0xFF5A3FCC)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SCORE GLOBAL', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    const SizedBox(height: 8),
                    const Text('78%', style: TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.78,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00E5C3)),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Stats mini
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A28),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('FAUTES', style: TextStyle(color: Color(0xFF8888AA), fontSize: 11)),
                          SizedBox(height: 8),
                          Text('12', style: TextStyle(color: Color(0xFFFF4D6D), fontSize: 36, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A28),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LEÇONS', style: TextStyle(color: Color(0xFF8888AA), fontSize: 11)),
                          SizedBox(height: 8),
                          Text('5', style: TextStyle(color: Color(0xFF00E5C3), fontSize: 36, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Leçon du jour
              const Text('Leçon du jour', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A28),
                  borderRadius: BorderRadius.circular(14),
                  border: Border(left: BorderSide(color: const Color(0xFF7B5EFF), width: 4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PERSONNALISÉE POUR TOI', style: TextStyle(color: Color(0xFF9D7FFF), fontSize: 10)),
                        SizedBox(height: 6),
                        Text('Accord du participe passé', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('3 fautes détectées', style: TextStyle(color: Color(0xFF8888AA), fontSize: 12)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B5EFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Start', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── STATS ───────────────────────────────────────────────────
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08080F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Statistiques', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF1A1A28), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SCORE DE MAÎTRISE', style: TextStyle(color: Color(0xFF8888AA), fontSize: 11)),
                    const Text('78%', style: TextStyle(color: Color(0xFF00E5C3), fontSize: 44, fontWeight: FontWeight.w900)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.78,
                        backgroundColor: const Color(0xFF22223A),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00E5C3)),
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Top fautes', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...[
                ('Accord participe passé', 0.67, const Color(0xFFFF4D6D), '8x'),
                ('Accents é/è/à', 0.42, const Color(0xFF7B5EFF), '5x'),
                ('Conjugaison subjonctif', 0.33, const Color(0xFF9D7FFF), '4x'),
                ('Pluriel des noms', 0.25, const Color(0xFF00E5C3), '3x'),
              ].map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFF1A1A28), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f.$1, style: const TextStyle(color: Colors.white, fontSize: 13)),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: f.$2,
                                backgroundColor: const Color(0xFF22223A),
                                valueColor: AlwaysStoppedAnimation<Color>(f.$3),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(f.$4, style: TextStyle(color: f.$3, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── LEÇONS ──────────────────────────────────────────────────
class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08080F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Leçons', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B5EFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LEÇON DU JOUR', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    SizedBox(height: 8),
                    Text('Accord du participe passé', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Basée sur tes fautes récentes', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Toutes les leçons', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...[
                ('Participe passé avec avoir', '3 fautes', const Color(0xFFFF4D6D)),
                ('Accents é/è/à', '5 fautes', const Color(0xFF7B5EFF)),
                ('Subjonctif présent', '4 fautes', const Color(0xFF9D7FFF)),
                ('Pluriel des noms', '3 fautes', const Color(0xFF00E5C3)),
              ].map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF1A1A28), borderRadius: BorderRadius.circular(12),
                    border: Border(left: BorderSide(color: l.$3, width: 4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.$1, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          Text(l.$2, style: const TextStyle(color: Color(0xFF8888AA), fontSize: 12)),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Color(0xFF8888AA), size: 16),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── ÉCRIRE ──────────────────────────────────────────────────
class WriteScreen extends StatelessWidget {
  const WriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08080F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Écrire', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A28),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const TextField(
                  maxLines: 6,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Commence à écrire ici...',
                    hintStyle: TextStyle(color: Color(0xFF8888AA)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B5EFF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Analyser mes fautes', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── RÉGLAGES ────────────────────────────────────────────────
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08080F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Réglages', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF1A1A28), borderRadius: BorderRadius.circular(16)),
                child: const Row(
                  children: [
                    CircleAvatar(backgroundColor: Color(0xFF7B5EFF), child: Text('L', style: TextStyle(color: Colors.white))),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lucas Martin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text('lucas@email.com', style: TextStyle(color: Color(0xFF8888AA), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF7B5EFF), borderRadius: BorderRadius.circular(14)),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('⭐ Passer à Premium', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('4,99€/mois — Leçons illimitées', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ...[
                (Icons.notifications, 'Notifications', 'Rappel quotidien'),
                (Icons.keyboard, 'Clavier Scrivia', 'Actif dans toutes les apps'),
                (Icons.flag, 'Objectif', '3 leçons par jour'),
                (Icons.dark_mode, 'Thème sombre', 'Activé'),
              ].map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFF1A1A28), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Icon(item.$1, color: const Color(0xFF7B5EFF), size: 20),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.$2, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          Text(item.$3, style: const TextStyle(color: Color(0xFF8888AA), fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}