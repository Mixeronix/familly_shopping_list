import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final dynamic supabase;
  const DeleteButton({super.key, required this.supabase});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.5),
      child: ListTile(
        title: const Text(
          "Usuń wszystkie",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () async => await supabase.from('products').delete().lt('done_at', DateTime.now().millisecondsSinceEpoch - 60000),
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Icon(
            Icons.delete,
            color: Colors.redAccent,
            size: 26,
          ),
        ),
        tileColor: const Color.fromARGB(255, 40, 40, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        trailing: const SizedBox(width: 45),
      ),
    );
  }
}
