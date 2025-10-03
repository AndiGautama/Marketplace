import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace2/features/home/presentation/widgets/more_options_bottom_sheet.dart';

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/cart')) return 1;
    if (location.startsWith('/add')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0; // Default to home
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/cart');
        break;
      case 3:
        context.go('/add');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: widget.child,
      floatingActionButton: FloatingActionButton(
        // --- PASTIKAN BAGIAN INI SUDAH BENAR ---
        onPressed: () {
          // Tampilkan Modal Bottom Sheet saat FAB ditekan
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (BuildContext context) {
              return const MoreOptionsBottomSheet();
            },
          );
        },
        // ------------------------------------
        child: const Icon(Icons.list),
        elevation: 2.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: selectedIndex == 0 ? Theme.of(context).primaryColor : Colors.grey),
              onPressed: () => _onItemTapped(0, context),
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart, color: selectedIndex == 1 ? Theme.of(context).primaryColor : Colors.grey),
              onPressed: () => _onItemTapped(1, context),
            ),
            const SizedBox(width: 48), // Ruang untuk FAB
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: selectedIndex == 3 ? Theme.of(context).primaryColor : Colors.grey),
              onPressed: () => _onItemTapped(3, context),
            ),
            IconButton(
              icon: Icon(Icons.person, color: selectedIndex == 4 ? Theme.of(context).primaryColor : Colors.grey),
              onPressed: () => _onItemTapped(4, context),
            ),
          ],
        ),
      ),
    );
  }
}