// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../constant/color_const.dart';
import '../widgets/text_normal.dart';
import '../widgets/text_title.dart';
import '../widgets/utils.dart';

class TableEventsExample extends StatefulWidget {
  const TableEventsExample({super.key});

  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    var kHolidays = [
      DateTime.utc(2022, 6, 12),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        elevation: 0,
        backgroundColor: AppColor.sliderColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            holidayPredicate: (DateTime date) => kHolidays.contains(date),
            weekendDays: const [DateTime.saturday],
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            headerStyle: const HeaderStyle(formatButtonVisible: false),
            calendarStyle: const CalendarStyle(
              holidayDecoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.red, width: 1.4)), shape: BoxShape.circle),
              weekendTextStyle: TextStyle(color: Colors.red),
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const TextTitle(
                    text: "Today",
                    size: 18,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  TextNormal(text: DateFormat("MMMM").format(DateTime.now()), size: 18),
                  Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      TextTitle(text: DateFormat("dd,").format(DateTime.now()), size: 18),
                      TextNormal(text: DateFormat("EEEE").format(DateTime.now()), size: 18),
                    ],
                  )
                ],
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.03),
              Container(
                width: MediaQuery.of(context).size.width * 0.001,
                height: MediaQuery.of(context).size.height * 0.11,
                color: Colors.black,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.1,
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Container(padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01), child: Text('${value[index]}'));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.17),
        ],
      ),
    );
  }
}
