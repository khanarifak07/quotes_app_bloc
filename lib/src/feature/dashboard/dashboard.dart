import 'package:flutter/material.dart';
import 'package:quotes_app_bloc/src/feature/favorite_quotes/favorite_quotes_wrapper.dart';
import 'package:quotes_app_bloc/src/feature/quotes/quote_wrapper.dart';
import 'package:quotes_app_bloc/src/feature/search_quotes/screens/search_quotes_wrapper.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  // Key favoriteKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          QuoteWrapper(),
          SearchQuotesWrapper(),
          // FavoriteQuotes(key: favoriteKey),
          FavoriteQuotesWrapper(),
          SizedBox(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        currentIndex: currentIndex,
        onTap: (value) {
          // if (value == 2) {
          //   favoriteKey = UniqueKey();
          // }
          currentIndex = value;
          setState(() {});
        },
        selectedIconTheme: IconThemeData(color: Colors.red),
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        selectedLabelStyle: TextStyle(color: Colors.red),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Quotes'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
