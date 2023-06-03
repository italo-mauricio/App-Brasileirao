import 'package:flutter/material.dart';

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  final List columnNames;
  final List propertyNames;

  const DataTableWidget({
    super.key,
    this.jsonObjects = const [],
    this.columnNames = const [],
    this.propertyNames = const []
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: columnNames
            .map((name) => DataColumn(
                label: Expanded(
                    child: Text(name,
                        style: const TextStyle(fontStyle: FontStyle.italic)))))
            .toList(),
        rows: jsonObjects
            .map((obj) => DataRow(
                cells: propertyNames
                    .map((propName) => DataCell(Text(obj[propName])))
                    .toList()))
            .toList());
  }
}