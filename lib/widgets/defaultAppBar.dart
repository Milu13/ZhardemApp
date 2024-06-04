import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    Key? key,
    required this.text,
    this.showBackButton = false, // Добавим параметр для отображения кнопки "назад"
  }) : super(key: key);

  final String text;
  final bool showBackButton; // Флаг для отображения кнопки "назад"

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white // Если тема темная, цвет текста белый
              : Colors.black, // Если тема светлая, цвет текста черный
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: showBackButton // Показать кнопку "назад", если showBackButton == true
          ? IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white // Цвет иконки "назад" для темной темы
              : Colors.black, // Цвет иконки "назад" для светлой темы
        ),
        onPressed: () {
          Navigator.of(context).pop(); // Вернуться на предыдущий экран при нажатии
        },
      )
          : null,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
