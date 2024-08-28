import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import '../../bloc/calendar_bloc.dart';
import '../../globals/dimension.dart';

class CalendarTable extends StatefulWidget {
  final CalendarBloc bloc;
  final UserModel? user;
  const CalendarTable({
    super.key,
    required this.bloc,
    required this.user,
  });

  @override
  State<CalendarTable> createState() => _CalendarTableState();
}

class _CalendarTableState extends State<CalendarTable> {
  late final CColor cColor = CColor.of(context);
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      eventLoader: (day) => widget.bloc.events[day] ?? [],
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: Icon(
          Icons.chevron_left_rounded,
          color: cColor.grey500,
        ),
        titleTextStyle: TextStyle(color: cColor.grey500),
        rightChevronIcon: Icon(
          Icons.chevron_right_rounded,
          color: cColor.grey500,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        decoration: const BoxDecoration(),
        weekdayStyle: TextStyle(color: cColor.grey400),
        weekendStyle: const TextStyle(color: Color(0xFFE1887F)),
      ),
      rowHeight: Dimensions.height5 * 10,
      daysOfWeekHeight: Dimensions.height5 * 5,
      calendarStyle: CalendarStyle(
          cellAlignment: Alignment.center,
          cellMargin: EdgeInsets.all(Dimensions.height2 * 4),
          // outsideTextStyle: TextStyle(color: onSecondaryColor),
          todayDecoration: BoxDecoration(
            color: cColor.sub,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(),
          selectedDecoration: const BoxDecoration(
            color: Color.fromRGBO(251, 147, 72, 0.72),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(color: Colors.white),
          // weekendDecoration: BoxDecoration(
          //   color: thirdColor,
          //   border: Border.all(color: firstColor, width: 0.5),
          // ),
          weekendTextStyle: TextStyle(color: cColor.grey500),
          // defaultDecoration: BoxDecoration(
          //   border: Border.all(color: firstColor, width: 0.5),
          // ),
          defaultTextStyle: TextStyle(color: cColor.grey500)),
      availableGestures: AvailableGestures.all,
      selectedDayPredicate: (day) => isSameDay(day, widget.bloc.focusedDay),
      focusedDay: widget.bloc.focusedDay,
      firstDay: DateTime.utc(2002, 09, 15),
      lastDay: DateTime.utc(2030, 09, 15),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          widget.bloc.focusedDay = selectedDay;
          widget.bloc.onDaySelected(widget.bloc.events[selectedDay]);
        });
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          return Wrap(
            spacing: 2,
            children: List.generate(
              events.length,
              (index) {
                Color color = const Color(0xFF4EB7FF);
                events as List<PostModel>;
                PostModel post = events[index];
                if (widget.user != null) {
                  if (widget.user?.signList?.contains(post.postId) ?? false) {
                    // 已報名
                    color = const Color(0xFF80CE88);
                  } else if (widget.user?.followings
                          ?.contains(post.organizerUid) ??
                      false) {
                    color = const Color(0xFFFF7D7D);
                  }
                }
                return Container(
                  width: Dimensions.height2 * 4,
                  height: Dimensions.height2 * 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: color,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
