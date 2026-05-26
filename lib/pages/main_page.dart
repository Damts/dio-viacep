import 'package:dio_viacep/pages/cep_history.dart';
import 'package:dio_viacep/pages/consulta_cep.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final String title;
  const MainPage({super.key, required this.title});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController pageController = PageController(initialPage: 0);
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        drawer: null,
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                onPageChanged: (value) {
                  setState(() {
                    selectedPage = value;
                  });
                },
                children: [
                  ConsultaCep(),
                  CepHistory(),
                ],
              ),
            ),
             BottomNavigationBar(
              // type: BottomNavigationBarType.fixed,
              currentIndex: selectedPage,
              onTap: (value) {
                setState(() {
                  pageController.jumpToPage(value);
                });
              },
              items: [
                BottomNavigationBarItem(
                  label: "CEP",
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: "Historico",
                  icon: Icon(Icons.history),
                )
              ],
             )
          ],
        ),
      ),
    );
  }
}