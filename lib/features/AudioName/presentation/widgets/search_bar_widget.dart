// // lib/features/AudioName/presentation/widgets/search_bar_widget.dart
// import 'package:flutter/material.dart';
//
// class SearchBarWidget extends StatefulWidget {
//   final Function(String) onSearch;
//
//   const SearchBarWidget({
//     super.key,
//     required this.onSearch,
//   });
//
//   @override
//   State<SearchBarWidget> createState() => _SearchBarWidgetState();
// }
//
// class _SearchBarWidgetState extends State<SearchBarWidget> {
//   final TextEditingController _searchController = TextEditingController();
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void _clearSearch() {
//     _searchController.clear();
//     widget.onSearch('');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: _searchController,
//         onChanged: widget.onSearch,
//         decoration: InputDecoration(
//           hintText: 'البحث عن اسم...',
//           hintStyle: TextStyle(color: Colors.grey[600]),
//           prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
//           suffixIcon: _searchController.text.isNotEmpty
//               ? IconButton(
//             icon: const Icon(Icons.clear),
//             onPressed: _clearSearch,
//           )
//               : IconButton(
//             icon: const Icon(Icons.mic),
//             onPressed: () {
//               // Implement voice search
//             },
//           ),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//               horizontal: 20,
//               vertical: 16
//           ),
//         ),
//       ),
//     );
//   }
// }

// lib/features/AudioName/presentation/widgets/search_bar_widget.dart
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    _focusNode.unfocus();
    widget.onSearch('');
    if (widget.onClear != null) {
      widget.onClear!();
    }
    setState(() {});
  }

  void _onSearchChanged(String value) {
    widget.onSearch(value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: _onSearchChanged,
        onSubmitted: widget.onSearch,
        decoration: InputDecoration(
          hintText: 'البحث عن اسم...',
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          // suffixIcon: _buildSuffixIcon(),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        textInputAction: TextInputAction.search,
      ),
    );
  }

  // Widget? _buildSuffixIcon() {
  //   if (_searchController.text.isNotEmpty) {
  //     return IconButton(
  //       icon: Icon(Icons.clear, color: Colors.grey[600]),
  //       onPressed: _clearSearch,
  //       tooltip: 'مسح البحث',
  //     );
  //   }
  //
  //   return IconButton(
  //     icon: Icon(Icons.mic, color: Colors.grey[600]),
  //     onPressed: () {
  //       // يمكن إضافة ميزة البحث الصوتي هنا
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('ميزة البحث الصوتي قيد التطوير'),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //     },
  //     tooltip: 'البحث الصوتي',
  //   );
  // }
}