import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace2/features/store/data/models/store_model.dart';
import 'package:marketplace2/features/store/data/repositories/mock_store_repository.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MockStoreRepository _storeRepository = MockStoreRepository();
  List<StoreModel> _allStores = [];
  List<StoreModel> _foundStores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllStores();
  }

  void _loadAllStores() async {
    final stores = await _storeRepository.getAllStores();
    if (mounted) {
      setState(() {
        _allStores = stores;
        _foundStores = stores;
        _isLoading = false;
      });
    }
  }

  void _runFilter(String enteredKeyword) {
    List<StoreModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allStores;
    } else {
      results = _allStores
          .where((store) =>
              store.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundStores = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) => _runFilter(value),
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Ketik nama toko...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => context.go('/'),
        behavior: HitTestBehavior.translucent,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _foundStores.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _foundStores.length,
                    itemBuilder: (context, index) {
                      final store = _foundStores[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: ListTile(
                          leading: const Icon(Icons.storefront_outlined),
                          title: Text(store.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(store.category),
                          onTap: () {
                            context.push('/stores/${store.id}');
                          },
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'Toko tidak ditemukan.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
      ),
    );
  }
}