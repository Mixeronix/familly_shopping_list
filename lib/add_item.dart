import 'package:flutter/material.dart';

class AddItem extends StatefulWidget {
  const AddItem({
    super.key,
    required this.supabase,
    required this.filters,
  });
  final dynamic supabase;
  final List filters;

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final fieldText = TextEditingController();
  String text = "";
  List filters = [];

  @override
  void initState() {
    super.initState();
    for (var filter in widget.filters) {
      filter[1] = false;
      filters.add(filter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(17.5),
      alignment: Alignment.topCenter,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 500,
          ),
          ListTile(
            title: TextFormField(
              onChanged: (value) => text = value,
              keyboardAppearance: Brightness.dark,
              keyboardType: TextInputType.text,
              cursorColor: Colors.white,
              controller: fieldText,
              decoration: const InputDecoration(
                hintText: "Dodaj...",
                border: InputBorder.none,
              ),
            ),
            leading: const Icon(Icons.add),
            tileColor: const Color.fromARGB(255, 55, 55, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length + 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: index == 0
                      ? RawChip(
                          label: const Text("Kategorie"),
                          avatar: const Icon(Icons.add, color: Colors.greenAccent),
                          onPressed: () {},
                        )
                      : filters[index - 1][1]
                          ? Chip(
                              deleteIconColor: Colors.greenAccent,
                              backgroundColor: const Color.fromARGB(255, 55, 55, 55),
                              label: Text(
                                '${filters[index - 1][2]}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              onDeleted: () => setState(() => filters[index - 1][1] = false),
                            )
                          : null,
                );
              },
            ),
          )
        ],
      ),
      title: const Text("Dodaj produkt"),
      actions: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text("Dodaj produkt"),
        )
      ],
    );
  }
}
