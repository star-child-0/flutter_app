import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		Color primary = Colors.teal;
		Brightness theme = Brightness.dark;

		return ChangeNotifierProvider(
			create: (context) => MyAppState(),
			child: MaterialApp(
				title: 'Namer App',
				theme: ThemeData(
					useMaterial3: true,
					colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: theme),
				),
				home: MyHomePage(),
			),
		);
	}
}

class MyAppState extends ChangeNotifier {
	var current = WordPair.random();
	var favorites = <WordPair>[];
	var history = <WordPair>[];
	var color = Colors.blue;
	GlobalKey ? historyListKey;

	void getNextWord() {
		history.insert(0, current);
		var animatedList = historyListKey?.currentState as AnimatedListState?;
		animatedList?.insertItem(0);
		current = WordPair.random();
		notifyListeners();
	}

	void toggleFavorite() {
		favorites.contains(current)
			? removeFavorite(current) : addFavorite(current);
	}

	void toggleListFavorite(WordPair pair){
		favorites.contains(pair)
			? removeFavorite(pair) : addFavorite(pair);
	}

	void addFavorite(WordPair pair) {
		favorites.add(pair);
		notifyListeners();
	}

	void removeFavorite(WordPair pair) {
		favorites.remove(pair);
		notifyListeners();
	}
}
