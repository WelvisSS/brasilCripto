import 'package:flutter/material.dart';

import '../../res/colors/colors.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController searchController;
  final Function onPressed;
  final Function onChanged;
  final String hintText;
  const SearchInput({
    super.key,
    required this.searchController,
    required this.onPressed,
    required this.onChanged,
    this.hintText = 'Pesquisar moeda...',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: AppColors.white),
      controller: searchController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.white),
        fillColor: AppColors.black,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: AppColors.secondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: AppColors.secondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: AppColors.secondary),
        ),
        prefixIcon: Icon(Icons.search, color: AppColors.secondary),
        suffixIcon: IconButton(
          iconSize: 20,
          icon: Icon(Icons.clear),
          color: AppColors.secondary,
          onPressed: () => onPressed(),
        ),
      ),
      onChanged: (value) => onChanged(value),
    );
  }
}
