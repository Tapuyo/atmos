import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:doctor_appointment_booking/myvars.dart';

class SelectTo extends StatefulWidget {
  @override
  _SelectFrom createState() => _SelectFrom();
}

class _SelectFrom extends State<SelectTo> {

  CalendarController calendarController = CalendarController();
  DateTime dtselect;



  @override
  void initState() {
    super.initState();
    calendarController = CalendarController();
  }


  @override
  void dispose() {
    calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Date"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: TableCalendar(

                initialSelectedDay: DateTime.now(),
                calendarStyle: CalendarStyle(
                    canEventMarkersOverflow: true,
                    todayColor: Colors.orange,
                    selectedColor: Theme.of(context).primaryColor,
                    todayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white)),
                initialCalendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                calendarController: calendarController,
                onDaySelected: (date, events) {
                  setState(() {
                    DateTime dtme = DateFormat("yyyy-MM-dd").parse(date.toString());
                    dtselect = dtme;
                    print(dtselect.toString());
                  });
                },
              ),
            ),

            Container(
              height: 50,
              child: Card
                (
                  color: Colors.blueAccent,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        AppVar.dtto = dtselect.year.toString() + "-" + dtselect.month.toString() + "-" +dtselect.day.toString();
                      });
                      Navigator.pop(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Center(
                            child: Text("Select Date", style: TextStyle(color: Colors.white, fontSize: 16),)
                        ),

                      ],
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

}