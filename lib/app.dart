import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final fieldText = TextEditingController();
  final focusNode = FocusNode();

  final supabase = Supabase.instance.client;

  List items = [];
  List itemsUndone = [];
  List itemsDone = [];

  void fetch() async {
    var data = await supabase.from('products').select();

    setState(() {
      items = data;
    });
  }

  @override
  void initState() {
    supabase.from('products').stream(primaryKey: ['id']).listen((List<Map<String, dynamic>> data) {
      setState(() {
        items = data;
      });
    });
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (items.isNotEmpty) {
      setState(() {
        itemsUndone = items.where((element) {
          if (element['done']) {
            return DateTime.now().millisecondsSinceEpoch - element['done_at'] < 60000;
          } else {
            return true;
          }
        }).toList();

        itemsDone = items.where((element) {
          if (element['done']) {
            return DateTime.now().millisecondsSinceEpoch - element['done_at'] > 60000 && DateTime.now().millisecondsSinceEpoch - element['done_at'] < 100000000;
          } else {
            return false;
          }
        }).toList();

        itemsUndone.sort(
          (a, b) {
            if (b['done'] != a["done"]) {
              return b["done"] ? 0 : 1;
            } else {
              return a['created_at'].compareTo(b['created_at']);
            }
          },
        );
      });
    }

    return RefreshIndicator(
      displacement: 2,
      color: Colors.greenAccent,
      onRefresh: () async {
        var data = await supabase.from('products').select();

        setState(() {
          items = data;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(17.5),
        child: Column(
          children: [
            ListTile(
              title: TextFormField(
                focusNode: focusNode,
                keyboardAppearance: Brightness.dark,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (value) async {
                  if (value != "") {
                    await supabase.from('products').insert({'done': false, "text": value, "created_at": DateTime.now().millisecondsSinceEpoch});

                    focusNode.requestFocus();
                    setState(() {
                      items.add(
                        {'done': false, "text": value, "created_at": DateTime.now().millisecondsSinceEpoch, 'done_at': null},
                      );
                    });

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
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: itemsUndone.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          key: ValueKey(index),
                          padding: const EdgeInsets.only(top: 15),
                          child: ListTile(
                            title: Text(
                              itemsUndone[index]["text"],
                              style: TextStyle(
                                decoration: itemsUndone[index]["done"] ? TextDecoration.lineThrough : TextDecoration.none,
                              ),
                            ),
                            leading: Checkbox(
                                value: itemsUndone[index]["done"],
                                onChanged: (value) async {
                                  if (value!) {
                                    Future.delayed(const Duration(seconds: 61), () {
                                      print(items);
                                      setState(() {});
                                    });
                                  }
                                  setState(() {
                                    itemsUndone[index]["done"] = value;
                                    itemsUndone[index]['done_at'] = value ? DateTime.now().millisecondsSinceEpoch : null;
                                  });

                                  await supabase.from('products').update(itemsUndone[index]).match({'id': itemsUndone[index]["id"]});
                                }),
                            tileColor: const Color.fromARGB(255, 70, 70, 70),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                    ),
                    if (itemsDone.isNotEmpty)
                      ExpansionTile(
                        title: const Text("Kupione", style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w600)),
                        iconColor: Colors.greenAccent,
                        collapsedIconColor: Colors.grey,
                        shape: ShapeBorder.lerp(InputBorder.none, InputBorder.none, 0),
                        children: [
                          ListTile(
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
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: itemsDone.length,
                            itemBuilder: (context, index) {
                              DateTime time = DateTime.fromMillisecondsSinceEpoch(itemsDone[index]['done_at']);
                              return Padding(
                                key: ValueKey(index),
                                padding: const EdgeInsets.only(top: 15),
                                child: ListTile(
                                  title: Text(
                                    itemsDone[index]["text"],
                                    style: TextStyle(
                                      decoration: itemsDone[index]["done"] ? TextDecoration.lineThrough : TextDecoration.none,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Kupione: ${time.hour}:${time.minute < 10 ? "0${time.minute}" : time.minute} | ${time.day < 10 ? "0${time.day}" : time.day}.${time.month < 10 ? "0${time.month}" : time.month}",
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  leading: Checkbox(
                                      value: itemsDone[index]["done"],
                                      onChanged: (value) async {
                                        setState(() {
                                          itemsDone[index]["done"] = value;
                                          itemsDone[index]['done_at'] = value! ? DateTime.now().millisecondsSinceEpoch : null;
                                        });

                                        await supabase.from('products').update(itemsDone[index]).match({'id': itemsDone[index]["id"]});
                                      }),
                                  tileColor: const Color.fromARGB(255, 40, 40, 40),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
