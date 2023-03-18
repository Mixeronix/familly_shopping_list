import 'package:flutter/material.dart';

class ItemList extends StatefulWidget {
  final List items;
  final dynamic supabase;
  final Function onChangedState;

  const ItemList({super.key, required this.items, required this.supabase, required this.onChangedState});

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
          child: ListTile(
            title: Text(
              widget.items[index]["text"],
              style: TextStyle(
                decoration: widget.items[index]["done"] ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            trailing: RichText(
              text: TextSpan(children: [
                if (widget.items[index]["fruit"]) const TextSpan(text: "🍎"),
                if (widget.items[index]["vegetable"]) const TextSpan(text: "🥕"),
                if (widget.items[index]["dairy"]) const TextSpan(text: "🥛"),
                if (widget.items[index]["meat"]) const TextSpan(text: "🥩"),
                if (widget.items[index]["asian"]) const TextSpan(text: "🥡"),
                if (widget.items[index]["drink"]) const TextSpan(text: "🧃"),
              ]),
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
        );
      },
    );
  }
}
