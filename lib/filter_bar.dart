import 'package:flutter/material.dart';

class Filter extends StatelessWidget {
  const Filter({super.key, required this.filters, required this.onSelected});
  final List filters;
  final Function onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 17.5),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 7.5),
            child: FilterChip(
              selected: filters[index][1],
              selectedColor: Colors.greenAccent,
              checkmarkColor: const Color.fromARGB(255, 40, 40, 40),
              label: Text(
                '${filters[index][2]} ${filters[index][0]}',
                style: TextStyle(color: filters[index][1] ? const Color.fromARGB(255, 40, 40, 40) : Colors.white),
              ),
              onSelected: (value) => onSelected(value, index),
            ),
          );
        },
      ),
    );
  }
}
