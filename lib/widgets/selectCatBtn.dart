import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/provider/selectedCategory/selectedCategory_provider.dart';

class SelectCatBtn extends ConsumerWidget {
  final VoidCallback onPressed;
  final String? text;
  final List<String>? selected;

  const SelectCatBtn(
      {Key? key, required this.onPressed, this.text, this.selected})
      : super(key: key); // Use super() without arguments

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);
    return Container(
      height: 45,
      width: 250,
      decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFF00A2FF),
          ),
          borderRadius: BorderRadius.circular(8)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(8),
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey.shade700,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (selected.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Allow horizontal scrolling
                  child: Row(
                    children: selected!.map((cat) {
                      return Text(
                        '$cat, ',
                        overflow: TextOverflow.ellipsis,
                      );
                    }).toList(),
                  ),
                ),
              )
            else
              Expanded(
                child: Text(
                  text ?? 'Select Category',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const Icon(
              // <-- Icon
              Icons.menu_open,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
