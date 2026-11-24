import 'package:lid/material.dart';

void main() => runApp(const MyanmarMathApp());

class MyanmarMathApp extends StatelessWidget {
  const MyanmarMathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'မြန်မာသင်္ချာလေ့လာရေး',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: null,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  final completed = <String>{};

  final levels = const [
    'မူလတန်းအဆင့်',
    'အလယ်တန်းအဆင့်',
    'အထက်တန်းအဆင့်',
    'အဆင့်မြင့်သင်္ချာ',
  ];

  final topics = const [
    'ကိန်းဂဏန်းများ',
    'ပေါင်းခြင်းနှင့် နုတ်ခြင်း',
    'မြှောက်ခြင်းနှင့် စားခြင်း',
    'အပိုင်းကိန်း',
    'ဒဿမကိန်း',
    'ရာခိုင်နှုန်း',
    'အက္ခရာသင်္ချာ',
    'ညီမျှခြင်း',
    'ဂျီဩမေတြီ',
    'ဧရိယာနှင့် ထုထည်',
    'ထောင့်များ',
    'စာရင်းအင်း',
    'ဖြစ်နိုင်ခြေ',
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      _lessonPage(),
      const QuizPage(),
      const CalculatorPage(),
      const AboutPage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('မြန်မာသင်္ချာလေ့လာရေး'),
        backgroundColor: Colors.green.shade100,
      ),
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'သင်ခန်းစာ'),
          NavigationDestination(icon: Icon(Icons.quiz), label: 'မေးခွန်း'),
          NavigationDestination(icon: Icon(Icons.calculate), label: 'တွက်စက်'),
          NavigationDestination(icon: Icon(Icons.info_outline), label: 'အကြောင်း'),
        ],
      ),
    );
  }

  Widget _lessonPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Colors.green.shade50,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'အဆင့်အလိုက် သင်္ချာကို လွယ်ကူစွာ လေ့လာနိုင်ပါသည်။',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...levels.map((level) => ExpansionTile(
              title: Text(level, style: const TextStyle(fontWeight: FontWeight.bold)),
              children: topics.map((topic) {
                final key = '$level-$topic';
                return ListTile(
                  leading: const Icon(Icons.calculate_outlined, color: Colors.green),
                  title: Text(topic),
                  trailing: Icon(
                    completed.contains(key) ? Icons.check_circle : Icons.chevron_right,
                    color: completed.contains(key) ? Colors.green : null,
                  ),
                  onTap: () => _showLesson(level, topic, key),
                );
              }).toList(),
            )),
      ],
    );
  }

  void _showLesson(String level, String topic, String key) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(topic),
        content: Text('$level\n\nဤသင်ခန်းစာတွင် $topic အကြောင်းကို ဥပမာများဖြင့် လေ့လာပါမည်။\n\nသင်ခန်းစာအကြောင်းအရာများကို နောက်ပိုင်းတွင် ထပ်မံဖြည့်စွက်နိုင်ပါသည်။'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => completed.add(key));
              Navigator.pop(context);
            },
            child: const Text('ပြီးဆုံးပြီ'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ပိတ်မည်'),
          ),
        ],
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final questions = const [
    ( '၂ + ၃ = ?', ['၄', '၅', '၆'], '၅' ),
    ( '၆ × ၂ = ?', ['၁၀', '၁၂', '၁၄'], '၁၂' ),
    ( '၁၀ − ၄ = ?', ['၅', '၆', '၇'], '၆' ),
  ];
  int index = 0;
  int score = 0;
  String? chosen;

  void select(String answer) {
    if (chosen != null) return;
    setState(() {
      chosen = answer;
      if (answer == questions[index].$3) score++;
    });
  }

  void next() {
    setState(() {
      if (index < questions.length - 1) {
        index++;
        chosen = null;
      } else {
        index = 0;
        score = 0;
        chosen = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[index];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('မေးခွန်း ${index + 1} / ${questions.length}',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          Text(q.$1, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...q.$2.map((answer) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(
                  onPressed: () => select(answer),
                  child: Text(answer, style: const TextStyle(fontSize: 20)),
                ),
              )),
          if (chosen != null) ...[
            Text(chosen == q.$3 ? 'မှန်ပါတယ်။' : 'အဖြေမှန်မှာ ${q.$3} ဖြစ်ပါတယ်။',
                style: const TextStyle(fontSize: 18)),
            TextButton(onPressed: next, child: const Text('ရှေ့ဆက်မည်')),
          ],
          const Spacer(),
          Text('ရမှတ်: $score', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final a = TextEditingController();
  final b = TextEditingController();
  String result = '';

  void calculate(String op) {
    final x = double.tryParse(a.text);
    final y = double.tryParse(b.text);
    if (x == null || y == null || (op == '÷' && y == 0)) {
      setState(() => result = 'ကိန်းဂဏန်း မှန်ကန်စွာ ဖြည့်ပါ။');
      return;
    }
    final value = switch (op) {
      '+' => x + y,
      '−' => x - y,
      '×' => x * y,
      _ => x / y,
    };
    setState(() => result = 'အဖြေ = $value');
  }

  @override
  void dispose() {
    a.dispose();
    b.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: a, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'ပထမကိန်း')),
            TextField(controller: b, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'ဒုတိယကိန်း')),
            const SizedBox(height: 16),
            Wrap(spacing: 8, children: ['+', '−', '×', '÷'].map((op) =>
              ElevatedButton(onPressed: () => calculate(op), child: Text(op))
            ).toList()),
            const SizedBox(height: 20),
            Text(result, style: const TextStyle(fontSize: 22)),
          ],
        ),
      );
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'မြန်မာသင်္ချာလေ့လာရေး App\n\nမြန်မာဘာသာဖြင့် သင်္ချာအခြေခံများကို လေ့လာရန် ရည်ရွယ်ထားသော စမ်းသပ်ဗားရှင်းဖြစ်ပါသည်။\n\nမှတ်ချက် - ဤဗားရှင်းတွင် အွန်လိုင်း Admin Panel၊ အကောင့်ဝင်ခြင်း၊ Live Chat နှင့် Push Notification များ မပါဝင်သေးပါ။',
          style: TextStyle(fontSize: 18),
        ),
      );
}
