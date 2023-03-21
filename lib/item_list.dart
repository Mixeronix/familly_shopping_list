import 'package:flutter/material.dart';

import 'add_item.dart';

class ItemList extends StatefulWidget {
  final List items;
  final dynamic supabase;
  final Function onChangedState;
  final List filters;

  const ItemList({
    super.key,
    required this.items,
    required this.supabase,
    required this.onChangedState,
    required this.filters,
  });

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 12.5, left: 17.5, right: 17.5),
          child: GestureDetector(
            onTap: () => showDialog(
                useRootNavigator: false,
                context: context,
                builder: (context) {
                  return AddItem(
                    text: widget.items[index]["text"],
                    id: widget.items[index]["id"],
                    filtersOn: [
                      widget.items[index]["fruit"],
                      widget.items[index]["vegetable"],
                      widget.items[index]["dairy"],
                      widget.items[index]["meat"],
                      widget.items[index]["asian"],
                      widget.items[index]["drink"],
                    ],
                    supabase: widget.supabase,
                    filters: widget.filters,
                  );
                }),
            child: ListTile(
              title: Text(
                widget.items[index]["text"],
                style: TextStyle(
                  decoration: widget.items[index]["done"] ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              trailing: RichText(
                text: TextSpan(
                  children: [
                    if (widget.items[index]["fruit"]) const TextSpan(text: "🍎"),
                    if (widget.items[index]["vegetable"]) const TextSpan(text: "🥕"),
                    if (widget.items[index]["dairy"]) const TextSpan(text: "🥛"),
                    if (widget.items[index]["meat"]) const TextSpan(text: "🥩"),
                    if (widget.items[index]["asian"]) const TextSpan(text: "🥡"),
                    if (widget.items[index]["drink"]) const TextSpan(text: "🧃"),
                  ],
                ),
              ),
              leading: Checkbox(
                  value: widget.items[index]["done"],
                  onChanged: (value) async {
                    widget.onChangedState(index, value);

                    await widget.supabase.from('products').update(widget.items[index]).match({'id': widget.items[index]["id"]});
                  }),
              tileColor: const Color.fromARGB(255, 70, 70, 70),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        );
      },
    );
  }
}
