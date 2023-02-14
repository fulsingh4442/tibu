import 'package:club_app/constants/constants.dart';
import 'package:club_app/logic/models/cart_table_event_model.dart';
import 'package:club_app/logic/models/tables_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddOnDialog extends StatefulWidget {
  AddOnDialog({
    this.tables,
    this.events,
    this.selectedTables,
    this.selectedEvents,
    this.onSelectedTablesChanged,
    this.onSelectedEventChanged,
  });

  final List<TableCartModel> tables;
  final List<EventCartModel> events;
  final List<TableCartModel> selectedTables;
  final List<EventCartModel> selectedEvents;
  final ValueChanged<List<TableCartModel>> onSelectedTablesChanged;
  final ValueChanged<List<EventCartModel>> onSelectedEventChanged;

  @override
  _AddOnDialogState createState() => _AddOnDialogState();
}

class _AddOnDialogState extends State<AddOnDialog> {
  List<TableCartModel> _tempSelectedTables = [];
  List<EventCartModel> _tempSelectedEvents = [];

  @override
  void initState() {
    // _tempSelectedTables = widget.selectedTables;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Text(
                  'Select Table',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            height: widget.tables.length > 0
                ? MediaQuery.of(context).size.height * 0.20
                : MediaQuery.of(context).size.height * 0.02,
            child: widget.tables.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.tables.length,
                    itemBuilder: (BuildContext context, int index) {
                      final TableCartModel table = widget.tables[index];
                      return Container(
                        child: CheckboxListTile(
                            activeColor: Colors.black,
                            dense: true,
                            title: Text(
                              '${table.categoryName} - ${table.tableName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .apply(color: colorPrimaryDark),
                            ),
                            value: _tempSelectedTables.contains(table),
                            controlAffinity: ListTileControlAffinity.leading,
                            subtitle: Text(
                              'Max: ${table.capacity} GUESTS',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .apply(color: colorPrimaryDark),
                            ),
                            onChanged: (bool value) {
                              if (_tempSelectedEvents.length > 0) {
                                setState(() {
                                  _tempSelectedEvents = [];
                                });
                              }
                              print(value);
                              if (value) {
                                if (!_tempSelectedTables.contains(table)) {
                                  setState(() {
                                    _tempSelectedTables.add(table);
                                  });
                                }
                              } else {
                                if (_tempSelectedTables.contains(table)) {
                                  setState(() {
                                    _tempSelectedTables.removeWhere(
                                        (TableCartModel tableModel) =>
                                            tableModel == table);
                                  });
                                }
                              }
                              widget
                                  .onSelectedTablesChanged(_tempSelectedTables);
                            }),
                      );
                    })
                : Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Text("No Table Added !"),
                      ],
                    ),
                  ),
          ),
          // const SizedBox(
          //   height: 4.0,
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: const <Widget>[
          //       Text(
          //         'Select Events',
          //         style: TextStyle(
          //             fontSize: 18.0,
          //             color: Colors.black,
          //             fontWeight: FontWeight.w500),
          //         textAlign: TextAlign.center,
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   height: widget.events.length > 0
          //       ? MediaQuery.of(context).size.height * 0.20
          //       : MediaQuery.of(context).size.height * 0.10,
          //   child: widget.events.length > 0
          //       ? ListView.builder(
          //           shrinkWrap: true,
          //           itemCount: widget.events.length,
          //           itemBuilder: (BuildContext context, int index) {
          //             final EventCartModel event = widget.events[index];
          //             return Container(
          //               child: CheckboxListTile(
          //                   activeColor: Colors.black,
          //                   dense: true,
          //                   title: Text(
          //                     event.name,
          //                     style: Theme.of(context)
          //                         .textTheme
          //                         .bodyText1
          //                         .apply(color: colorPrimaryDark),
          //                   ),
          //                   value: _tempSelectedEvents.contains(event),
          //                   controlAffinity: ListTileControlAffinity.leading,
          //                   subtitle: Text(
          //                     'Date: ${event.date}',
          //                     style: Theme.of(context)
          //                         .textTheme
          //                         .bodyText2
          //                         .apply(color: colorPrimaryDark),
          //                   ),
          //                   onChanged: (bool value) {
          //                     if (_tempSelectedTables.length > 0) {
          //                       setState(() {
          //                         _tempSelectedTables = [];
          //                       });
          //                     }
          //                     if (value) {
          //                       if (!_tempSelectedEvents.contains(event)) {
          //                         setState(() {
          //                           _tempSelectedEvents.add(event);
          //                         });
          //                       }
          //                     } else {
          //                       if (_tempSelectedEvents.contains(event)) {
          //                         setState(() {
          //                           _tempSelectedEvents.removeWhere(
          //                               (EventCartModel eventModel) =>
          //                                   eventModel == event);
          //                         });
          //                       }
          //                     }
          //                     //   widget
          //                     //     .onSelectedEventChanged(_tempSelectedEvents);
          //                   }),
          //             );
          //           })
          //       : Container(
          //           margin: EdgeInsets.only(left: 15),
          //           child: Row(
          //             children: [
          //               Text("No Event Added !"),
          //             ],
          //           ),
          //         ),
          // ),
          // const SizedBox(
          //   height: 4.0,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: Text(
                  'Cancel',
                  textAlign: TextAlign.end,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .apply(color: Colors.black),
                ),
              ),
              const SizedBox(
                width: 4.0,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop({
                      "table": _tempSelectedTables,
                      "events": _tempSelectedEvents
                    });
                  });
                },
                child: Text(
                  'Ok',
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .apply(color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4.0,
          ),
        ],
      ),
    );
  }
}
