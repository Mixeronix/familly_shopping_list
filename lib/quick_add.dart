import 'package:flutter/material.dart';

class QuickAdd extends StatefulWidget {
  const QuickAdd({super.key, required this.supabase, required this.onSubmitted});

  final supabase;
  final Function onSubmitted;

  @override
  State<QuickAdd> createState() => _QuickAddState();
}

class _QuickAddState extends State<QuickAdd> {
  final fieldText = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 17.5, right: 17.5, left: 17.5),
      child: ListTile(
        title: TextFormField(
          focusNode: focusNode,
          keyboardAppearance: Brightness.dark,
          keyboardType: TextInputType.text,
          onFieldSubmitted: (value) async {
            if (value != "") {
              await widget.supabase.from('products').insert({"text": value, "created_at": DateTime.now().millisecondsSinceEpoch});
              widget.onSubmitted(
                {'done': false, "text": value, "created_at": DateTime.now().millisecondsSinceEpoch, 'done_at': null},
              );

              focusNode.requestFocus();

              fieldText.clear();
            }
          },
          cursorColor: Colors.white,
          controller: fieldText,
          decoration: const InputDecoration(
            hintText: "Dodaj...",
            border: InputBorder.none,
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0), borderRadius: BorderRadius.all(Radius.circular(10))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0), borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Icon(Icons.add),
        ),
        tileColor: const Color.fromARGB(255, 40, 40, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
