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

  void _showMultiSelect(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true, // required for min/max child size
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setStateInside) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Wybierz kategorie",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: filters
                        .map(
                          (filter) => FilterChip(
                            selectedColor: Colors.greenAccent,
                            selected: filter[1],
                            backgroundColor: const Color.fromARGB(255, 55, 55, 55),
                            checkmarkColor: const Color.fromARGB(255, 40, 40, 40),
                            label: Text(
                              '${filter[2]} ${filter[0]}',
                              style: TextStyle(
                                fontSize: 16,
                                color: filter[1] ? const Color.fromARGB(255, 40, 40, 40) : Colors.white,
                              ),
                            ),
                            onSelected: (bool value) {
                              setStateInside(() => filter[1] = value);
                              setState(() => filter[1] = value);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
                          onPressed: () {
                            _showMultiSelect(context);
                          },
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
          onPressed: () async {
            if (text != '') {
              await widget.supabase.from('products').insert({
                "text": text,
                "created_at": DateTime.now().millisecondsSinceEpoch,
                'fruit': filters[0][1],
                'vegetable': filters[1][1],
                'dairy': filters[2][1],
                'meat': filters[3][1],
                'asian': filters[4][1],
                'drink': filters[5][1],
              });
              for (var filter in filters) {
                filter[1] = false;
              }
              Navigator.pop(context);
            }
          },
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
