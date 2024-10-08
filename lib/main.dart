import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'presentation/views/home_page.dart';
import 'presentation/views/favorite_page.dart';
import 'presentation/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'data/repositories/article_repository_impl.dart';
import 'data/services/api_service.dart';
import 'data/services/database_helper.dart';
import 'domain/repositories/article_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.lightBlue,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // init service, repo
  final apiService = ApiService();
  final databaseHelper = DatabaseHelper.instance;
  final articleRepository = ArticleRepositoryImpl(apiService, databaseHelper);

  // run app with domain/article_repository.dart
  runApp(
    Provider<ArticleRepository>.value(
      value: articleRepository,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter News App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.lightBlue,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // list of widget for bottom nav
  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const FavoritePage(),
  ];

  // handle bottom nav item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}
