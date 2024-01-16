import 'package:artyom/data/contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  bool isSearchedBar = false;
  TextEditingController textEditingController = TextEditingController();

  List<Contacts> filteredContactsList = contactsList;

  void changeAppBar() {
    setState(() {
      isSearchedBar = !isSearchedBar;
    });
  }

  AppBar regularAppBar() => AppBar(
          title: const Text("Звонки"),
          surfaceTintColor: Colors.black54,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                changeAppBar();
              },
            )
          ]);

  AppBar searchAppBar() => AppBar(
        leading: const Icon(Icons.search),
        title: TextField(
          controller: textEditingController,
          autofocus: true,
          onChanged: (value) {
            setState(() {
              textEditingController.text.isEmpty
                  ? filteredContactsList = contactsList
                  : filteredContactsList.first;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              changeAppBar();
              textEditingController.text = "";
            },
          )
        ],
      );

  ListView contactListView(List<Contacts> filteredContactsList) => ListView(
        physics: const BouncingScrollPhysics(),
        children: filteredContactsList
            .map((e) => ListTile(
                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () async {
                      await Clipboard.setData(
                              ClipboardData(text: e.phoneNumber!))
                          .then((value) => ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text("Номер сохранен"))));
                    },
                  ),
                  leading: const Icon(Icons.phone_iphone_rounded),
                  title: Text(e.name!),
                  subtitle: Text(e.phoneNumber!),
                  onTap: () {},
                ))
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearchedBar ? searchAppBar() : regularAppBar(),
      body: contactListView(filteredContactsList),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.access_alarms_sharp), label: "Главная"),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_alarms_sharp), label: "Не главная"),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
