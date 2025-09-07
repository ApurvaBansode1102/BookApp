import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:bookapp/features/books/controllers/home_controller.dart';
import 'package:bookapp/features/utils/responsive.dart';

class CustomSearchBar extends StatefulWidget {
  final void Function(String)? onSearch;
  const CustomSearchBar({super.key, this.onSearch});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch(HomeController controller) {
    _controller.clear();
    controller.books.clear();
    controller.filteredBooks.clear();
    setState(() {});
    widget.onSearch?.call('');
  }

  void _onSearchChanged(String query) {
    final homeController = Get.find<HomeController>();
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    homeController.isLoading.value = true;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch?.call(query);
      homeController.isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final isTablet = Responsive.isTablet(context);
    final fieldFontSize = Responsive.fontSize(context, mobile: 15, tablet: 20);
    final chipFontSize = Responsive.fontSize(context, mobile: 13, tablet: 16);
    final contentPadding = EdgeInsets.all(
        Responsive.padding(context, mobile: 16, tablet: 24));
    final borderRadius = BorderRadius.circular(isTablet ? 18 : 12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => TextField(
              controller: _controller,
              style: TextStyle(fontSize: fieldFontSize),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, size: isTablet ? 28 : 22),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.cancel,
                            color: Colors.grey, size: isTablet ? 28 : 22),
                        onPressed: () => _clearSearch(homeController),
                      ),
                    homeController.isLoading.value
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Icon(Icons.filter_list, size: isTablet ? 28 : 22),
                          )
                        : Icon(Icons.filter_list, size: isTablet ? 28 : 22),
                  ],
                ),
                hintText: 'Find Book',
                hintStyle: TextStyle(fontSize: fieldFontSize),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: contentPadding,
                border: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _onSearchChanged,
              onSubmitted: (query) {
                widget.onSearch?.call(query);
              },
            )),
        if (_controller.text.isEmpty)
          Builder(
            builder: (context) {
              if (homeController.searchHistory.isEmpty) return SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Searches:',
                          style: TextStyle(
                              fontSize: chipFontSize,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500)),
                      TextButton(
                        onPressed: () {
                          homeController.searchHistory.clear();
                          _controller.clear();
                          setState(() {});
                        },
                        child: Text('Clear',
                            style: TextStyle(
                                fontSize: chipFontSize, color: Colors.red)),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 12 : 6),
                  Wrap(
                    spacing: isTablet ? 12 : 8,
                    children: homeController.searchHistory
                        .take(5)
                        .map((query) => ActionChip(
                              label: Text(query,
                                  style: TextStyle(fontSize: chipFontSize)),
                              onPressed: () {
                                _controller.text = query;
                                setState(() {});
                                widget.onSearch?.call(query);
                              },
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 16 : 10,
                                vertical: isTablet ? 10 : 6,
                              ),
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(isTablet ? 12 : 8),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
