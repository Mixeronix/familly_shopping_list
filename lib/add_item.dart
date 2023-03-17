import 'package:flutter/material.dart';

class AddItem extends StatelessWidget {
  const AddItem({
    super.key,
    required this.supabase,
  });
  final dynamic supabase;

  @override
  Widget build(BuildContext context) {
    final fieldText = TextEditingController();
    String text = "";

    return AlertDialog(
      insetPadding: EdgeInsets.all(17.5),
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
            tileColor: const Color.fromARGB(255, 50, 50, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
