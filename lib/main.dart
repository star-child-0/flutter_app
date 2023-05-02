import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		Color primary = Colors.greenAccent;
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

	void getNextWord() {
		current = WordPair.random();
		notifyListeners();
	}

	void toggleFavorite() {
		if (favorites.contains(current)) {
			favorites.remove(current);
		}
		else {
			favorites.add(current);
		}
		notifyListeners();
	}

	void removeFavorite(WordPair pair) {
		favorites.remove(pair);
		notifyListeners();
	}
}


class MyHomePage extends StatefulWidget {
	@override
	State<MyHomePage> createState() => _MyHomePageState();
}


class FavoritesPage extends StatefulWidget {
	@override
	State<FavoritesPage> createState() => _FavoritesPageState();
}


class _MyHomePageState extends State<MyHomePage> {
	var selectedIndex = 0;

	@override
	Widget build(BuildContext context) {
		Widget page;
		switch (selectedIndex) {
			case 0:
				page = GeneratorPage();
				break;
			case 1:
				page = FavoritesPage();
				break;
			default:
				throw Exception('Invalid index: $selectedIndex');
		}

		return LayoutBuilder(
			builder: (context, costraints) {
				return Scaffold(
					body: Row(
						children: [
							SafeArea(
								child: NavigationRail(
									extended: costraints.maxWidth >= 600,
									destinations: [
										NavigationRailDestination(
											icon: Icon(Icons.home),
											label: Text('WordMasher'),
										),
										NavigationRailDestination(
											icon: Icon(Icons.favorite),
											label: Text('Favorites'),
										),
									],
									selectedIndex: selectedIndex,
									onDestinationSelected: (value) {
										setState(() {
											selectedIndex = value;
										});
									},
								),
							),
							Expanded(
								child: Container(
									color: Theme.of(context).colorScheme.primaryContainer,
									child: page,
								),
							),
						],
					),
				);
			}
		);
	}
}


class _FavoritesPageState extends State<FavoritesPage> {
	@override
	Widget build(BuildContext context) {
		var appState = context.watch<MyAppState>();
		var favorites = appState.favorites;
		var favText = favorites.length == 1 ? 'favorite' : 'favorites';

		if (favorites.isEmpty) {
			return Center(
				child: Text('No favorites yet'),
			);
		}

		return ListView(
			children: [
				Padding(
					padding: const EdgeInsets.all(20.0),
					child: Text(
						// ignore: unnecessary_brace_in_string_interps
						'You have ${favorites.length} ${favText}',
						style: Theme.of(context).textTheme.titleLarge,
					),
				),

				for (var pair in favorites)
					ListTile(
						leading: Icon(Icons.delete),
						title: Text(pair.asLowerCase),
						onTap: () {
							appState.removeFavorite(pair);
						},
					),
			],
		);
	}
}


class GeneratorPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		var appState = context.watch<MyAppState>();
		var pair = appState.current;

		IconData icon;
		if (appState.favorites.contains(pair)) {
			icon = Icons.favorite;
		} else {
			icon = Icons.favorite_border;
		}

		return Center(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					BigCard(pair: pair),
					SizedBox(height: 10),
					Row(
						mainAxisSize: MainAxisSize.min,
						children: [
							ElevatedButton.icon(
								onPressed: () {
									appState.toggleFavorite();
								},
								icon: Icon(icon),
								label: Text('Like'),
							),
							SizedBox(width: 10),
							ElevatedButton(
								onPressed: () {
									appState.getNextWord();
								},
								child: Text('Next'),
							),
						],
					),
				],
			),
		);
	}
}


class BigCard extends StatelessWidget {
	const BigCard({
		super.key,
		required this.pair,
	});

	final WordPair pair;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final style = theme.textTheme.displayMedium!.copyWith(
			color: theme.colorScheme.onPrimary,
		);

		return Card(
			color: theme.colorScheme.primary,

			child: Padding(
				padding: const EdgeInsets.all(20.0),
				child: Text(
					pair.asLowerCase,
					style: style,
					semanticsLabel: "${pair.first} ${pair.second}",
				),

			),
		);
	}
}
