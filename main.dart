
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class AppState extends ChangeNotifier {
  Map<String, dynamic> data = {};
  int points = 0;
  String name = '';
  String kelas = '';
  String birth = '';
  String avatar = 'robot';

  Future<void> loadOfflineData() async {
    final jsonStr = await rootBundle.loadString('assets/offline_data.json');
    data = json.decode(jsonStr);
    notifyListeners();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    kelas = prefs.getString('kelas') ?? '';
    birth = prefs.getString('birth') ?? '';
    points = prefs.getInt('points') ?? 0;
    notifyListeners();
  }

  Future<void> saveProfile(String n, String k, String b) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', n);
    await prefs.setString('kelas', k);
    await prefs.setString('birth', b);
    name = n; kelas = k; birth = b;
    notifyListeners();
  }

  void addPoints(int p) {
    points += p;
    SharedPreferences.getInstance().then((prefs) => prefs.setInt('points', points));
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'CHUENLAY Belajar',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color(0xFF0B1020),
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    appState.loadOfflineData().then((_) => appState.loadProfile()).then((_) {
      Future.delayed(Duration(milliseconds: 800), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('CHUENLAY Belajar', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          CircleAvatar(child: Icon(Icons.person)),
          SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(app.name.isEmpty ? 'Hai, Siswa!' : app.name, style: TextStyle(fontSize: 16)),
            Text(app.kelas.isEmpty ? 'Belum pilih kelas' : app.kelas, style: TextStyle(fontSize: 12))
          ])
        ]),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MainButton(icon: Icons.book, label: 'Materi', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MateriListScreen()))),
                _MainButton(icon: Icons.quiz, label: 'Soal', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SoalListScreen()))),
                _MainButton(icon: Icons.language, label: 'Sunda', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SundaScreen()))),
              ],
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.auto_stories),
              title: Text('Komik Edukasi'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => KomikListScreen())),
            ),
            ListTile(
              leading: Icon(Icons.music_note),
              title: Text('Musik Belajar'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('ChatGPT Mini'),
              onTap: () {},
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                // simple demo: add points
                Provider.of<AppState>(context, listen: false).addPoints(10);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dapat 10 poin!')));
              },
              child: Text('Dapatkan Poin Demo +10'),
            )
          ],
        ),
      ),
    );
  }
}

class _MainButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MainButton({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF00B4FF), Color(0xFF7B61FF)]),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.purpleAccent.withOpacity(0.4), blurRadius: 12, spreadRadius: 1)],
            ),
            child: Icon(icon, size: 36, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(label)
        ],
      ),
    );
  }
}

class MateriListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final materials = app.data['materials'] as List<dynamic>? ?? [];
    return Scaffold(
      appBar: AppBar(title: Text('Materi')),
      body: ListView.builder(
        itemCount: materials.length,
        itemBuilder: (_, i) {
          final m = materials[i];
          return ListTile(
            title: Text('${m['mapel']} - ${m['judul']}'),
            subtitle: Text('${m['jenjang']} Kelas ${m['kelas']}'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MateriDetailScreen(m))),
          );
        },
      ),
    );
  }
}

class MateriDetailScreen extends StatelessWidget {
  final Map<String, dynamic> mat;
  MateriDetailScreen(this.mat);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${mat['judul']}')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text(mat['ringkasan'] ?? ''),
      ),
    );
  }
}

class SoalListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final soal = app.data['soal'] as List<dynamic>? ?? [];
    return Scaffold(
      appBar: AppBar(title: Text('Bank Soal')),
      body: ListView.builder(
        itemCount: soal.length,
        itemBuilder: (_, i) {
          final s = soal[i];
          return ListTile(
            title: Text('${s['mapel']} - ${s['soal']}'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SoalDetailScreen(s))),
          );
        },
      ),
    );
  }
}

class SoalDetailScreen extends StatefulWidget {
  final Map<String, dynamic> soal;
  SoalDetailScreen(this.soal);
  @override
  _SoalDetailScreenState createState() => _SoalDetailScreenState();
}

class _SoalDetailScreenState extends State<SoalDetailScreen> {
  String selected = '';
  @override
  Widget build(BuildContext context) {
    final s = widget.soal;
    final choices = (s['pilihan'] as List<dynamic>).cast<String>();
    return Scaffold(
      appBar: AppBar(title: Text('Soal')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s['soal'] ?? ''),
            SizedBox(height: 12),
            for (var c in choices) ChoiceTile(text: c, onTap: () {
              setState(() => selected = c);
            }, selected: selected==c),
            Spacer(),
            ElevatedButton(onPressed: () {
              final correct = s['jawaban'];
              final app = Provider.of<AppState>(context, listen: false);
              if (selected == correct) {
                app.addPoints(5);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Jawaban benar! +5 poin')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Jawaban salah.')));
              }
            }, child: Text('Submit')),
          ],
        ),
      ),
    );
  }
}

class ChoiceTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool selected;
  ChoiceTile({required this.text, required this.onTap, required this.selected});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom:8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selected ? Colors.blueAccent.withOpacity(0.2) : Colors.white10,
        ),
        child: Text(text),
      ),
    );
  }
}

class SundaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final vocab = app.data['sunda_vocab'] as List<dynamic>? ?? [];
    return Scaffold(
      appBar: AppBar(title: Text('Bahasa Sunda')),
      body: ListView.builder(
        itemCount: vocab.length,
        itemBuilder: (_, i) {
          final v = vocab[i];
          return ListTile(
            title: Text(v['kata_sunda']),
            subtitle: Text(v['arti']),
            trailing: Icon(Icons.volume_up),
            onTap: () {},
          );
        },
      ),
    );
  }
}

class KomikListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final comics = app.data['comics'] as List<dynamic>? ?? [];
    return Scaffold(
      appBar: AppBar(title: Text('Komik')),
      body: ListView.builder(
        itemCount: comics.length,
        itemBuilder: (_, i) {
          final c = comics[i];
          return ListTile(
            title: Text(c['judul']),
            subtitle: Text(c['kategori']),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => KomikDetailScreen(c))),
          );
        },
      ),
    );
  }
}

class KomikDetailScreen extends StatelessWidget {
  final Map<String, dynamic> comic;
  KomikDetailScreen(this.comic);
  @override
  Widget build(BuildContext context) {
    final pages = (comic['pages'] as List<dynamic>).cast<String>();
    return Scaffold(
      appBar: AppBar(title: Text(comic['judul'])),
      body: ListView(
        children: pages.map((p) => Image.asset('assets/images/'+p, height: 400, fit: BoxFit.contain)).toList(),
      ),
    );
  }
}
