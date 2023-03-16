import 'package:flutter/material.dart';

import 'delete_button.dart';

class DoneItemList extends StatefulWidget {
  const DoneItemList({super.key, required this.items, required this.supabase, required this.onChangedState});
  final List items;
  final supabase;
  final Function onChangedState;

  @override
  State<DoneItemList> createState() => _DoneItemListState();
}

class _DoneItemListState extends State<DoneItemList> {
  @override
  Widget build(BuildContext context) {
    if (widget.items.isNotEmpty) {
      return ExpansionTile(
        title: const Text("Kupione", style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w600)),
        iconColor: Colors.greenAccent,
        collapsedIconColor: Colors.grey,
        shape: ShapeBorder.lerp(InputBorder.none, InputBorder.none, 0),
        children: [
          DeleteButton(supabase: widget.supabase),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              DateTime time = DateTime.fromMillisecondsSinceEpoch(widget.items[index]['done_at']);
              return Padding(
                key: ValueKey(index),
                padding: const EdgeInsets.only(top: 12.5, left: 17.5, right: 17.5),
                child: ListTile(
                  title: Text(
                    widget.items[index]["text"],
                    style: TextStyle(
                      decoration: widget.items[index]["done"] ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    "Kupione: ${time.hour}:${time.minute < 10 ? "0${time.minute}" : time.minute} | ${time.day < 10 ? "0${time.day}" : time.day}.${time.month < 10 ? "0${time.month}" : time.month}",
                    style: const TextStyle(fontSize: 10),
                  ),
                  leading: Checkbox(
                      value: widget.items[index]["done"],
                      onChanged: (value) async {
                        widget.onChangedState(index, value);

                        await widget.supabase.from('products').update(widget.items[index]).match({'id': widget.items[index]["id"]});
                      }),
                  tileColor: const Color.fromARGB(255, 40, 40, 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
