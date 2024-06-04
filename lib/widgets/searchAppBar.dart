// Создайте этот виджет SearchAppBar

import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextEditingController searchController;
  final Function(String) onSearch;

  const SearchAppBar({
    Key? key,
    required this.title,
    required this.searchController,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: SearchDelegateWidget(onSearch: onSearch),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 1.0);
}

class SearchDelegateWidget extends SearchDelegate<String> {
  final Function(String) onSearch;

  SearchDelegateWidget({required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Результаты поиска будут обновляться в реальном времени в StreamBuilder
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Предложения (результаты поиска) будут обновляться в реальном времени в StreamBuilder
    return Container();
  }
}
