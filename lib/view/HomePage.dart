import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mirror_wall/Controller/HomePageProvider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InAppWebViewController? inAppWebViewController;
  int _selectedIndex = 0;
  bool isVisible = false;

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("HomePage"),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _popupMenuButton(),
            ),
          ],
        ),
        // drawer: _drawer(),
        body: Consumer<HomePageProvider>(
          builder: (BuildContext context, HomePageProvider value, Widget? child) {
            return SafeArea(
              child: Column(
                children: [
                  Consumer<HomePageProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                      if (value.webProgress == 1) {
                        return SizedBox();
                      }
                      return LinearProgressIndicator(
                        value: value.webProgress,
                      );
                    },
                  ),
                  Consumer<HomePageProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                      return Expanded(
                        child: Container(
                          child: InAppWebView(
                            initialUrlRequest: URLRequest(
                              url: WebUri("https://google.com/"),
                            ),
                            onWebViewCreated: (controller) {
                              inAppWebViewController = controller;
                            },
                            onProgressChanged: (controller, progress) {
                              Provider.of<HomePageProvider>(context,
                                      listen: false)
                                  .onWebProgress(progress / 100);
                            },
                            onLoadStart: (controller, url) {
                              Provider.of<HomePageProvider>(context,
                                      listen: false)
                                  .onChangeLoad(true);
                            },
                            onLoadStop: (controller, url) {
                              Provider.of<HomePageProvider>(context,
                                      listen: false)
                                  .onChangeLoad(false);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    color: Colors.grey.withOpacity(0.2),
                    child: Consumer<HomePageProvider>(
                      builder:
                          (BuildContext context, searchValue, Widget? child) {
                        return TextFormField(
                          onFieldSubmitted: (value) {
                            if (searchValue.engine == "https://duckduckgo.com/") {
                              String search =
                                  "${searchValue.engine}?va=c&t=hl&q=$value";
                              inAppWebViewController?.loadUrl(
                                  urlRequest: URLRequest(url: WebUri(search)));
                            } else if (searchValue.engine ==
                                "https://search.yahoo.com/") {
                              String search =
                                  "${searchValue.engine}search?p=$value";
                              inAppWebViewController?.loadUrl(
                                  urlRequest: URLRequest(url: WebUri(search)));
                            } else if (searchValue.engine ==
                                "https://www.google.com/") {
                              String search =
                                  "${searchValue.engine}search?q=$value";
                              inAppWebViewController?.loadUrl(
                                  urlRequest: URLRequest(url: WebUri(search)));
                            } else if (searchValue.engine == "https://www.bing.com/"){
                              String search =
                                  "${searchValue.engine}search?q=$value";
                              inAppWebViewController?.loadUrl(
                                  urlRequest: URLRequest(url: WebUri(search)));
                            }
                          },
                          maxLines: 1,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
  }

  void _onItemTapped(int index) async {
    if (index == 0) {
      inAppWebViewController?.loadUrl(
        urlRequest: URLRequest(
          url: WebUri(
              Provider.of<HomePageProvider>(context, listen: false).engine ??
                  "google"),
        ),
      );
      print("Home");
    } else if (index == 1) {
      var url = await inAppWebViewController?.getUrl();
      var urlTitle = await inAppWebViewController?.getTitle();

      Map bookmark = {
        "url": url.toString(),
        "urlTitle": urlTitle,
      };

      if (url != null) {
        Provider.of<HomePageProvider>(context, listen: false)
            .addBookMark(bookmark);
      }
      // Add BookMark Details
      // Show dialog to confirm bookmark is added
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Bookmark Added"),
            content: Text("The page '${urlTitle}' has been bookmarked."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      print("Add BookMark ${url.toString()}");
    } else if (index == 2) {
      inAppWebViewController?.goBack();
      print("Back");
    } else if (index == 3) {
      inAppWebViewController?.reload();
      print("Refresh");
    } else if (index == 4) {
      inAppWebViewController?.goForward();
      print("Next");
    }
    setState(() {
      _selectedIndex = index;
    });
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
              onTap: () {
                Navigator.pop(context);
                Future.delayed(
                  Duration.zero,
                  () {
                    showModalBottomSheet(
                      backgroundColor: Color(0xfff4f4f4),
                      context: context,
                      builder: (context) {
                        final bookmarks = Provider.of<HomePageProvider>(context,
                                listen: false)
                            .bookMarks;
                        return Consumer<HomePageProvider>(
                          builder: (BuildContext context,
                              HomePageProvider value, Widget? child) {
                            return ListView.builder(
                              itemCount: value.bookMarks.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      value.bookMarks[index]["urlTitle"],
                                      maxLines: 1),
                                  subtitle: Text(
                                    value.bookMarks[index]["url"],
                                    maxLines: 1,
                                  ),
                                  trailing: InkWell(
                                    onTap: () {
                                      Provider.of<HomePageProvider>(context,
                                              listen: false)
                                          .deleteBookMark(index);
                                      print("Delete BookMarks!!!!");
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    inAppWebViewController?.loadUrl(
                                        urlRequest: URLRequest(
                                      url: WebUri(bookmarks[index]["url"]),
                                    ));
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
                print("All Bookmarks");
              },
            ),
          ),
          PopupMenuItem<String>(
            onTap: () {},
            child: StatefulBuilder(
              builder: (BuildContext context, setState) {
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.screen_search_desktop_outlined),
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
                            leading: SizedBox(
                              height: 25,
                              child: Image.asset("assets/images/google.png"),
                            ),
                            title: Text("Google"),
                            onTap: () {
                              inAppWebViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                      url: WebUri("https://www.google.com/")));

                              //send data to provider
                              Provider.of<HomePageProvider>(context,
                                      listen: false)
                                  .changeEngine("https://www.google.com/");
                              print("Google");
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: SizedBox(
                              height: 25,
                              child: Image.asset("assets/images/yahoo.png"),
                            ),
                            title: Text("Yahoo"),
                            onTap: () {
                              inAppWebViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                      url:
                                          WebUri("https://search.yahoo.com/")));
                              Provider.of<HomePageProvider>(context,
                                      listen: false)
                                  .changeEngine("https://search.yahoo.com/");
                              print("Yahoo");
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: SizedBox(
                              height: 25,
                              child: Image.asset("assets/images/bing.png"),
                            ),
                            title: Text("Bing"),
                            onTap: () {
                              inAppWebViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                      url: WebUri("https://www.bing.com/")));
                              Provider.of<HomePageProvider>(context,
                                      listen: false)
                                  .changeEngine("https://www.bing.com/");
                              print("Bing");
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: SizedBox(
                              height: 25,
                              child:
                                  Image.asset("assets/images/duckduckgo.png"),
                            ),
                            title: Text("Duck Duck Go"),
                            onTap: () {
                              inAppWebViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                      url: WebUri("https://duckduckgo.com/")));
                              Provider.of<HomePageProvider>(context,
                                      listen: false)
                                  .changeEngine("https://duckduckgo.com/");
                              print("Duck Duck Go");
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
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

// Drawer _drawer() {
//   return Drawer(
//     child: ListView(
//       padding: EdgeInsets.zero,
//       children: [
//         DrawerHeader(
//           decoration: BoxDecoration(
//             color: Colors.blue,
//           ),
//           child: Text(
//             'Menu',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//             ),
//           ),
//         ),
//         ListTile(
//           leading: Icon(Icons.home),
//           title: Text('Home'),
//           onTap: () {
//             // Handle the action here
//             Navigator.pop(context);
//           },
//         ),
//         ListTile(
//           leading: Icon(Icons.bookmark_add),
//           title: Text('Add Bookmark'),
//           onTap: () {
//             // Handle the action here
//             Navigator.pop(context);
//           },
//         ),
//         ListTile(
//           leading: Icon(Icons.arrow_left_rounded),
//           title: Text('Back'),
//           onTap: () {
//             // Handle the action here
//             Navigator.pop(context);
//           },
//         ),
//         ListTile(
//           leading: Icon(Icons.refresh),
//           title: Text('Refresh'),
//           onTap: () {
//             // Handle the action here
//             Navigator.pop(context);
//           },
//         ),
//         ListTile(
//           leading: Icon(Icons.chevron_right_outlined),
//           title: Text('Next'),
//           onTap: () {
//             // Handle the action here
//             Navigator.pop(context);
//           },
//         ),
//         ListTile(
//           leading: Icon(Icons.settings),
//           title: Text('Settings'),
//           onTap: () {
//             // Handle the action here
//             Navigator.pop(context);
//           },
//         ),
//       ],
//     ),
//   );
// }
