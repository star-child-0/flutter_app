import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';


class SettingsPage extends StatefulWidget {
	@override
	State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
	@override
	Widget build(BuildContext context) {
		var appState = context.watch<MyAppState>();
		appState.color = Colors.red;

		return Center(
			child: Text('Settings'),
		);
	}
}
