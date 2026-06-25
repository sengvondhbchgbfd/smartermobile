import 'package:flutter/material.dart';

enum SearchCategory {
  module,
  setting,
  staff,
  product,
  invoice,
  supplier,
  customer,
  user;

  String get label => switch (this) {
    module => 'Module',
    setting => 'Setting',
    staff => 'Staff',
    product => 'Product',
    invoice => 'Invoice',
    supplier => 'Supplier',
    customer => 'Customer',
    user => 'User',
  };
}

class SearchItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final SearchCategory category;
  final String route;
  final Object? extra;

  const SearchItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.category,
    required this.route,
    this.extra,
  });

  String get resolvedRoute {
    if (extra != null && route.contains(':id')) {
      return route.replaceFirst(':id', extra.toString());
    }
    return route;
  }
  

  bool get hasPathParam => route.contains(':id');
  static const _unset = Object();
  SearchItem copyWith({
    String? title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    SearchCategory? category,
    String? route,
    Object? extra = _unset,
  }) {
    return SearchItem(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      category: category ?? this.category,
      route: route ?? this.route,
      extra: identical(extra, _unset) ? this.extra : extra,
    );
  }

  bool matches(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return true;
    return title.toLowerCase().contains(q) ||
        subtitle.toLowerCase().contains(q) ||
        category.name.toLowerCase().contains(q) ||
        (extra?.toString().toLowerCase().contains(q) ?? false);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchItem &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          route == other.route &&
          category == other.category &&
          extra == other.extra;

  @override
  int get hashCode =>
      title.hashCode ^ route.hashCode ^ category.hashCode ^ extra.hashCode;
}
