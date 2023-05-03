import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class HistoryList extends StatefulWidget {
	const HistoryList({Key? key}) : super(key: key);

	@override
	State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
	final _listKey = GlobalKey();
	static const Gradient gradient = LinearGradient(
		colors: [Colors.transparent, Colors.black],
		stops: [0.0, 0.5],
		begin: Alignment.topCenter,
		end: Alignment.bottomCenter,
	);

	@override
	Widget build(BuildContext context){
		final appState = context.watch<MyAppState>();
		appState.historyListKey = _listKey;

		return ShaderMask(
			shaderCallback: (bounds) => gradient.createShader(bounds),
			blendMode: BlendMode.dstIn,
			child: AnimatedList(
				key: _listKey,
				reverse: true,
				initialItemCount: appState.history.length,
				itemBuilder: (context, index, animation){
					final pair = appState.history[index];
					return SizeTransition(
						sizeFactor: animation,
						child: Center(
							child:TextButton.icon(
								onPressed: (){
									appState.toggleListFavorite(pair);
								},
								icon: appState.favorites.contains(pair) ? Icon(Icons.favorite, size: 12) : SizedBox(),
								label: Text(
									pair.asLowerCase,
									semanticsLabel: pair.asPascalCase,
								)
							)
						)
					);
				}
			)
		);
	}
}
