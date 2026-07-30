import 'package:flutter/material.dart';
import '../models/scale_registry.dart';
import '../helpers/subscription_helper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredScales = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredScales = ScaleRegistry.allScales;
  }

  void _filterScales(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredScales = ScaleRegistry.allScales;
      } else {
        _filteredScales = ScaleRegistry.allScales.where((scale) {
          final title = scale['title'].toString().toLowerCase();
          final subtitle = scale['subtitle'].toString().toLowerCase();
          final category = scale['category'].toString().toLowerCase();
          final searchLower = query.toLowerCase();
          return title.contains(searchLower) || 
                 subtitle.contains(searchLower) ||
                 category.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Escalas'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Digite o nome da escala...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterScales('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _filterScales,
            ),
          ),
          Expanded(
            child: _filteredScales.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma escala encontrada para "$_searchQuery"',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredScales.length,
                    itemBuilder: (context, index) {
                      final scale = _filteredScales[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (scale['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              scale['icon'] as IconData,
                              color: scale['color'] as Color,
                              size: 28,
                            ),
                          ),
                          title: Text(
                            scale['title'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(scale['subtitle'] as String),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  scale['category'] as String,
                                  style: TextStyle(fontSize: 10, color: Colors.grey[800]),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            if (scale['title'] == 'NIHSS') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => scale['screen'] as Widget,
                                ),
                              );
                            } else {
                              SubscriptionHelper.navigateToScale(
                                context: context,
                                scaleName: scale['scaleName'] as String,
                                screen: scale['screen'] as Widget,
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
