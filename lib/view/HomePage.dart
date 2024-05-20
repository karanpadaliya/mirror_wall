import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _popupMenuButton(),
          ),
        ],
      ),
      drawer: _drawer(),
      body: SafeArea(
        child: Container(
          color: Colors.red,
          child: Text("kuwyghbjkioduhjb sjxbhi kjhbv"),
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Drawer _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark_add),
            title: Text('Add Bookmark'),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.arrow_left_rounded),
            title: Text('Back'),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Refresh'),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.chevron_right_outlined),
            title: Text('Next'),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "Add Bookmark",
          icon: Icon(Icons.bookmark_add),
        ),
        BottomNavigationBarItem(
          label: "Back",
          icon: Icon(Icons.chevron_left_outlined),
        ),
        BottomNavigationBarItem(
          label: "Refresh",
          icon: Icon(Icons.refresh),
        ),
        BottomNavigationBarItem(
          label: "Next",
          icon: Icon(Icons.chevron_right_outlined),
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  PopupMenuButton _popupMenuButton() {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      icon: Icon(Icons.menu_open),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            onTap: () {},
            child: ListTile(
              leading: Icon(Icons.bookmark_added_rounded),
              title: Text("All Bookmarks"),
              trailing: Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          PopupMenuItem<String>(
            onTap: () {},
            child: StatefulBuilder(
              builder: (BuildContext context, setState) {
                return Column(
                  children: [
                    _PopUpSubMenu(),
                  ],
                );
              },
            ),
          ),
        ];
      },
    );
  }
}

class _PopUpSubMenu extends StatefulWidget {
  const _PopUpSubMenu({super.key});

  @override
  State<_PopUpSubMenu> createState() => _PopUpSubMenuState();
}

class _PopUpSubMenuState extends State<_PopUpSubMenu> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.search),
          title: Text("Search Engine"),
          trailing: isVisible
              ? Icon(Icons.keyboard_arrow_down_rounded)
              : Icon(Icons.chevron_right),
          onTap: () {
            setState(() {
              isVisible = !isVisible;
            });
          },
        ),
        Visibility(
          visible: isVisible,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.add),
                title: Text("Google"),
                onTap: () {
                  print("Google");
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text("Yahoo"),
                onTap: () {
                  print("Yahoo");
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text("Bing"),
                onTap: () {
                  print("Bing");
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text("Duck Duck Go"),
                onTap: () {
                  print("Duck Duck Go");
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
