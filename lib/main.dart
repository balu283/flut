import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_shell.dart';
import 'services/app_state.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  try {
    await state.load();
  } catch (e) {
    debugPrint('Failed to load data: $e');
  }
  runApp(ChangeNotifierProvider.value(value: state, child: const RoadmapQuestApp()));
}

class RoadmapQuestApp extends StatelessWidget {
  const RoadmapQuestApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Roadmap Quest',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const MainShell(),
      );
}
