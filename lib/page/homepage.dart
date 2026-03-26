import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_application/page/calendarpage.dart';
import 'package:travel_application/page/exporepage.dart';
import 'package:travel_application/page/settingpage.dart';
import 'package:travel_application/page/whiltelistpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  late final List<Widget> Page;

  void initState() {
    Page = [
      const ExplorePage(),
      const WhitelistPage(),
      const CalendarPage(),
      const SettingPage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 5,
        iconSize: 32,
        selectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.onPrimaryContainer.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.compass,
              color:
                  selectedIndex == 0
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer.withOpacity(0.5),
            ),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.solidHeart,
              color:
                  selectedIndex == 1
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer.withOpacity(0.5),
            ),
            label: "Whitelist",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.calendar,
              color:
                  selectedIndex == 2
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer.withOpacity(0.5),
            ),
            label: "Trips",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.cog,
              color:
                  selectedIndex == 4
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer.withOpacity(0.5),
            ),
            label: "Setting",
          ),
        ],
      ),
      body: Page[selectedIndex],
    );
  }
}
