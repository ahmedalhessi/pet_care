import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/preferences/shared_pref_controller.dart';
import '/widgets/home_drawer/home_drawer_tile.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 140,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFEB4747),
                  Color(0xFFEB4747),
                  Colors.orangeAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              'Welcome ${SharedPrefController().getValueFor<String>(key: 'name')}',
              style: GoogleFonts.nunito(
                fontSize: 24,
                color: const Color(0xFFFFDEDE),
              ),
            ),
          ),
          // DrawerHeader(

          //   padding: const EdgeInsetsDirectional.only(top: 32, start: 24),
          //   decoration: const BoxDecoration(
          //     // borderRadius: BorderRadius.only(
          //     //   bottomRight: Radius.circular(165),
          //     // ),
          //     color: Color(0xFFEB4747),
          //   ),
          //   child: Text(
          //     'Welcome ${SharedPrefController().getValueFor<String>(key: 'name')}',
          //     style: GoogleFonts.nunito(
          //       fontSize: 24,
          //       color: const Color(0xFFFFDEDE),
          //     ),
          //   ),
          // ),
          DrawerTile(
            title: 'Explore Pets',
            onPressed: () {
              Navigator.pushNamed(context, '/explore_pets');
            },
          ),
          DrawerDivider(),
          DrawerTile(
            title: 'Control Pet Vaccines',
            onPressed: () {
              Navigator.pushNamed(context, '/all_vaccines_screen');
            },
          ),
          DrawerDivider(),
          DrawerTile(
            title: 'Control Pet Tools',
            onPressed: () {
              Navigator.pushNamed(context, '/all_tools_screen');
            },
          ),
          DrawerDivider(),
          DrawerTile(title: 'Logout', onPressed: () async => _logout(context)),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await SharedPrefController().logout();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login_screen',
      (route) => false,
    );
  }
}

class DrawerDivider extends StatelessWidget {
  const DrawerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(indent: 25, endIndent: 25, color: Color(0xFFEB4747));
  }
}
