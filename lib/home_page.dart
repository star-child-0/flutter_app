import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'history.dart';
import 'favorites.dart';
import 'settings.dart';

class MyHomePage extends StatefulWidget {
	@override
	State<MyHomePage> createState() => _MyHomePageState();
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
			case 2:
				page = SettingsPage();
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
										NavigationRailDestination(
											icon: Icon(Icons.settings),
											label: Text('Settings'),
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

class GeneratorPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		var appState = context.watch<MyAppState>();
		var pair = appState.current;
		IconData favIcon;

		if (appState.favorites.contains(pair)) {
			favIcon = Icons.favorite;
		} else {
			favIcon = Icons.favorite_border;
		}

		return Center(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					Expanded(
						flex: 3,
						child: HistoryList(),
					),
					SizedBox(height: 10),
					BigCard(pair: pair),
					SizedBox(height: 10),
					Row(
						mainAxisSize: MainAxisSize.min,
						children: [
							ElevatedButton.icon(
								onPressed: () {
									appState.toggleFavorite();
								},
								icon: Icon(favIcon),
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
					Spacer(flex: 2,)
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
