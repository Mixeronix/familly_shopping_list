import 'package:flutter/material.dart';
import 'package:shopping_list/done_item_list.dart';
import 'package:shopping_list/item_list.dart';
import 'package:shopping_list/quick_add.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'filter_bar.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final supabase = Supabase.instance.client;

  List items = [];
  List itemsUndone = [];
  List itemsDone = [];
  bool showSettings = false;
  List settings = [false, false, false, false];
  List filters = [
    ["Owoce", false, '🍎'],
    ["Warzywa", false, '🥕'],
    ["Nabiał", false, '🥛'],
    ["Mięsa", false, '🥩'],
  ];

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

        itemsUndone = itemsUndone.where((element) {
          if (filters[0][1] || filters[1][1] || filters[2][1] || filters[3][1]) {
            return (element['fruit'] == filters[0][1] && filters[0][1]) || (element['vegetable'] == filters[1][1] && filters[1][1]) || (element['fruit'] == filters[2][1] && filters[2][1]) || (element['meat'] == filters[3][1] && filters[3][1]);
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
      displacement: 5,
      color: Colors.greenAccent,
      onRefresh: () async {
        var data = await supabase.from('products').select();

        setState(() {
          items = data;
        });
      },
      child: Column(
        children: [
          Material(
            color: Colors.grey[850],
            child: Column(
              children: [
                QuickAdd(
                  supabase: supabase,
                  onSubmitted: (item) {
                    setState(() {
                      items.add(item);
                    });
                    print(item);
                  },
                ),
                Filter(
                  filters: filters,
                  onSelected: (value, index) {
                    setState(() {
                      if (value) {
                        for (var filter in filters) {
                          filter[1] = false;
                        }
                        filters[index][1] = true;
                      } else {
                        filters[index][1] = false;
                      }
                    });
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ItemList(
                    items: itemsUndone,
                    supabase: supabase,
                    onChangedState: (index, value) {
                      if (value!) {
                        Future.delayed(const Duration(seconds: 61), () {
                          setState(() {});
                        });
                      }
                      setState(() {
                        itemsUndone[index]["done"] = value;
                        itemsUndone[index]['done_at'] = value ? DateTime.now().millisecondsSinceEpoch : null;
                      });
                    },
                  ),
                  DoneItemList(
                    supabase: supabase,
                    items: itemsDone,
                    onChangedState: (index, value) {
                      setState(() {
                        itemsDone[index]["done"] = value;
                        itemsDone[index]['done_at'] = value! ? DateTime.now().millisecondsSinceEpoch : null;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
