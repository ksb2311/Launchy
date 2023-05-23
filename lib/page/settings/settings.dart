import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Function(String) onThemeChanged;
  const SettingsPage({Key? key, required this.onThemeChanged})
      : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedTheme = 'System Default';
  double _iconSize = 24;
  bool _showIcons = true;

  @override
  Widget build(BuildContext context) {
    // ThemeData getThemeData(String theme) {
    //   switch (theme) {
    //     case 'Light':
    //       return ThemeData.light();
    //     case 'Dark':
    //       return ThemeData.dark();
    //     default:
    //       return ThemeData.from(colorScheme: ColorScheme.light());
    //   }
    // }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            trailing: DropdownButton<String>(
              value: _selectedTheme,
              items: [
                DropdownMenuItem(
                    child: Text(
                      'System Default',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color!),
                    ),
                    value: 'System Default'),
                DropdownMenuItem(
                    child: Text('Light',
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color!)),
                    value: 'Light'),
                DropdownMenuItem(
                    child: Text('Dark',
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color!)),
                    value: 'Dark'),
              ],
              onChanged: (String? value) {
                setState(() {
                  _selectedTheme = value!;
                });
                widget.onThemeChanged(value!);
              },
            ),
          ),
          // ListTile(
          //   title: const Text('Icon Size'),
          //   trailing: Slider(
          //     value: _iconSize,
          //     min: 12,
          //     max: 48,
          //     onChanged: (double value) {
          //       setState(() {
          //         _iconSize = value;
          //       });
          //     },
          //   ),
          // ),
          ListTile(
            title: const Text('Show Icons'),
            trailing: Switch(
              value: _showIcons,
              onChanged: (bool value) {
                setState(() {
                  _showIcons = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Widgets'),
            onTap: () {
              // Navigate to Widgets settings page
            },
          ),
          ListTile(
            title: const Text('Set as Default'),
            onTap: () {
              // Navigate to Set as Default settings page
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('About'),
                    content: const Text('App version 1.0.0'),
                    actions: [
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
