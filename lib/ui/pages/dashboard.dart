import 'package:admin_peka/common/styles.dart';
import 'package:admin_peka/services/firebase/auth/auth.dart';
import 'package:admin_peka/ui/pages/login_page.dart';
import 'package:admin_peka/ui/pages/request_page.dart';
import 'package:flutter/material.dart';

import '../../common/navigation.dart';
import 'home_page.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';

  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentPage = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const RequestPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final admin =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return Row(children: [
      Container(
        color: kPrimaryColor,
        width: 231,
        child: Drawer(
          child: Container(
            color: kWhiteBgColor,
            child: ListView(
              children: [
                DrawerHeader(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            height: 130,
                          ),
                          Image.asset(
                            admin['admin'] == 'ridhoi'
                                ? "assets/icons/ridhoi.png"
                                : "assets/icons/nadia.png",
                            width: 56,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  admin['admin'] == 'ridhoi'
                                      ? 'Muhammad Ridhoi'
                                      : 'Nadia Miranti',
                                  style: blackTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: semiBold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Admin Kece',
                                  style: blackTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: regular,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: kWhiteBgColor,
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/icons/ic_home_active.png',
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    'Beranda',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _currentPage = 0;
                    });
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.description,
                    color: kPrimaryColor,
                  ),
                  title: Text(
                    'Permintaan',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _currentPage = 1;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      Expanded(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: kWhiteBgColor,
            automaticallyImplyLeading: MediaQuery.of(context).size.width < 600,
            title: _currentPage == 0
                ? Text(
                    'Beranda',
                    style: blackTextStyle.copyWith(
                        fontSize: 18, fontWeight: semiBold),
                  )
                : Text(
                    'Permintaan',
                    style: blackTextStyle.copyWith(
                        fontSize: 18, fontWeight: semiBold),
                  ),
            actions: <Widget>[
              IconButton(
                padding: const EdgeInsets.only(right: 24),
                icon: Icon(
                  Icons.exit_to_app,
                  color: kPrimaryColor,
                ),
                tooltip: 'Logout',
                onPressed: () {
                  Auth.firebaseAuth.signOut().then((value) {
                    Navigation.intentReplacement(LoginPage.routeName);
                  });
                },
              ),
            ],
          ),
          body: _pages[_currentPage],
        ),
      ),
    ]);
  }
}
