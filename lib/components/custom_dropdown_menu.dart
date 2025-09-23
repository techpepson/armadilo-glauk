import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:glauk/core/constants/constants.dart';

class CustomDropdownMenu extends StatefulWidget {
  const CustomDropdownMenu({
    super.key,
    this.title,
    required this.items,
    this.hintText,
    this.onChanged,
    this.initialValue,
  });

  final String? title;
  final String? hintText;
  final List<String> items;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  @override
  State<CustomDropdownMenu> createState() => CustomDropdownMenuState();
}

class CustomDropdownMenuState extends State<CustomDropdownMenu> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null && widget.title!.isNotEmpty) ...[
          Text(
            widget.title!,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        DropdownSearch<String>(
          items: (filter, loadProps) => widget.items,
          selectedItem: _selected,
          onChanged: (val) {
            setState(() => _selected = val);
            widget.onChanged?.call(val);
          },
          compareFn: (a, b) => a.toLowerCase() == b.toLowerCase(),
          itemAsString: (item) => item,
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              hintText: widget.hintText ?? 'Select an option',
              prefixIcon: const Icon(Icons.school_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          suffixProps: DropdownSuffixProps(
            dropdownButtonProps: DropdownButtonProps(
              iconOpened: Icon(Constants.dropDownUpIcon),
              iconClosed: Icon(Constants.dropDownIcon),
            ),
          ),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                isDense: true,
              ),
            ),
            itemBuilder: (
              BuildContext context,
              String item,
              bool isDisabled,
              bool isSelected,
            ) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? theme.colorScheme.primary.withOpacity(0.08)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 18,
                      color:
                          isSelected
                              ? theme.colorScheme.primary
                              : theme.hintColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyLarge?.color,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                  ],
                ),
              );
            },
          ),
          dropdownBuilder: (context, selectedItem) {
            return Text(selectedItem ?? '', style: theme.textTheme.bodyMedium);
          },
        ),
      ],
    );
  }
}
