import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';


class FavoritesPage extends StatefulWidget {
	@override
	State<FavoritesPage> createState() => _FavoritesPageState();
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
