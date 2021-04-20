import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'main.dart';



class OnlineJsonData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalendarExample();
}

Future<String>getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String idUserCo = prefs.getString('userData');
  //String user = jsonEncode(User.fromJson(json));
  //String idUserCo = jsonDecode(idUserCo);
  Map<String, dynamic> userObject = json.decode(idUserCo);
  String id = userObject["_id"];
  return id;
}

List<String> colors = <String>[
  'Rose',
  'Bleu',
  'Marron',
  'Jaune',
  'Defaut'
];

List<String> views = <String>[
  'Jour',
  'Semaine',
  'Mois'
];

class CalendarExample extends State<OnlineJsonData> {
  List<Color> _colorCollection;
  String _networkStatusMsg;

  //************//
  CalendarController _controller;
  DateTime _jumpToTime = DateTime.now();
  String _text = '';
  Color headerColor, viewHeaderColor, calendarColor, defaultColor;
  //************************//

  @override
  void initState() {
    _initializeEventColor();
    super.initState();

    _controller = CalendarController();
    _controller.view = CalendarView.week;
    _text = DateFormat('MMMM yyyy').format(_jumpToTime).toString();
  }


  createAlertDialog(BuildContext context){

    String dateChoisie="Choisir une date";
    changeText(String text){
      setState(() {
        dateChoisie = text ;
      });
    }
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("Entrez un évènement", style: TextStyle(fontSize: 20),),
        content:  Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder() , labelText: "Titre de l'évènement"
              ),
              // ignore: missing_return
              validator: (value){
                if (value.isEmpty)
                  return "Le champs Mot de Passe vide";
              },
              onSaved: (newValue){
              },
            ),
      FlatButton(
      onPressed: () {
      DatePicker.showDateTimePicker(context,
      showTitleActions: true,
      minTime: DateTime(2018, 3, 5),
      maxTime: DateTime(2019, 6, 7),
          onChanged: (date) {
      print('change $date');
      },
          onConfirm: (date) {
        dateChoisie = '${date.year} - ${date.month} - ${date.day} - ${date.hour}:${date.minute} ' ;
        setState(() {

        });
           /* String newDate = DateFormat('yyyy-MM-dd – kk:mm').format(date);
            changeText(newDate);
            print("test"+dateChoisie);*/
      },
          currentTime: DateTime.now(), locale: LocaleType.fr);
      },
      child: Column(
        children: [
          Text(dateChoisie,
            style: TextStyle(color: Colors.blue),
          ),
          RaisedButton(

          )

        ],
      ),),
          ],

        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.color_lens),
            itemBuilder: (BuildContext context) {
              return colors.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            onSelected: (String value) {
              setState(() {
                if (value == 'Rose') {
                  headerColor = const Color(0xFF09e8189);
                  viewHeaderColor = const Color(0xFF0f3acb6);
                  calendarColor = const Color(0xFF0ffe5d8);
                } else if (value == 'Bleu') {
                  headerColor = const Color(0xFF0007eff);
                  viewHeaderColor = const Color(0xFF03aa4f6);
                  calendarColor = const Color(0xFF0bae5ff);
                } else if (value == 'Marron') {
                  headerColor = const Color(0xFF0937c5d);
                  viewHeaderColor = const Color(0xFF0e6d9b1);
                  calendarColor = const Color(0xFF0d1d2d6);
                } else if (value == 'Jaune') {
                  headerColor = const Color(0xFF0f7ed53);
                  viewHeaderColor = const Color(0xFF0fff77f);
                  calendarColor = const Color(0xFF0f7f2cc);
                } else if (value == 'Defaut') {
                  headerColor = null;
                  viewHeaderColor = null;
                  calendarColor = null;
                }
              });
            },
          ),
        ],
        backgroundColor: headerColor,
        centerTitle: true,
        titleSpacing: 60,
        title: Text(_text),
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.calendar_today),
          itemBuilder: (BuildContext context) => views.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList(),
          onSelected: (String value) {
            setState(() {
              if (value == 'Jour') {
                _controller.view = CalendarView.day;
              } else if (value == 'Semaine') {
                _controller.view = CalendarView.week;
              }  else if (value == 'Mois') {
                _controller.view = CalendarView.month;
              }
            });
          },
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: getDataFromWeb(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 390,
                        child: SfCalendar(
                          headerHeight: 0,
                              viewHeaderStyle: ViewHeaderStyle(
                                backgroundColor: viewHeaderColor
                              ),
                              backgroundColor: calendarColor,
                              controller: _controller,
                              initialDisplayDate: _jumpToTime,
                              onTap: calendarTapped,

                              dataSource: MeetingDataSource(snapshot.data),
                          monthViewSettings: MonthViewSettings(
                            navigationDirection: MonthNavigationDirection.vertical
                          ),
                          onViewChanged:(ViewChangedDetails viewChangedDetails){
                            String headerText;
                            if (_controller.view == CalendarView.month) {
                            headerText = DateFormat('MMMM yyyy')
                           .format(viewChangedDetails.visibleDates[
                            viewChangedDetails.visibleDates.length ~/ 2])
                            .toString();
                             }
                            else {
                            headerText = DateFormat('MMMM yyyy')
                           .format(viewChangedDetails.visibleDates[0])
                           .toString();
                           }
                           if (headerText != null && headerText != null){
                             SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
                               _text = headerText;
                               setState(() {

                               });
                             });
                           }
                          } ,



                            ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(padding: EdgeInsets.only(left: 330),
                      child: FloatingActionButton(
                        backgroundColor: Colors.red[400],
                        onPressed: (){
                          createAlertDialog(context);
                        },
                        child: Icon(Icons.add),
                      ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: Text('$_networkStatusMsg'),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Meeting>> getDataFromWeb() async {
    String token = await (getStringValuesSF() as FutureOr<String>);
    var data = await http.get(
        BaseUrl+"api/event/getAllEvents/"+token);
    var jsonData = json.decode(data.body);

    final List<Meeting> appointmentData = [];
    final Random random = new Random();
    for (var data in jsonData) {
      /*DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm");
      DateTime startTT = dateFormat.parse(data["start"]);
      DateTime endTT = startTT.add(const Duration(hours: 2));*/
//print( _convertDateFromString(data['start'][16]));
      Meeting meetingData = Meeting(
          eventName: data['title'],
          from: _convertDateFromString(data['start']),
          to: _convertDateFromString(data['end']),
          background: _colorCollection[random.nextInt(9)],
          allDay: data['allDay']);
      appointmentData.add(meetingData);
    }
    return appointmentData;
  }

  DateTime _convertDateFromString(String date) {
    return DateTime.parse(date);
  }
  //

  void _initializeEventColor() {
    this._colorCollection = new List<Color>();
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }
  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
      _updateState(calendarTapDetails.date);
    } else if ((_controller.view == CalendarView.week ||
        _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
      _updateState(calendarTapDetails.date);
    }
  }

  void _updateState(DateTime date) {
    setState(() {
      _jumpToTime = date;
      _text = DateFormat('MMMM yyyy').format(_jumpToTime).toString();
    });
  }

}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;

  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].allDay;
  }
}

class Meeting {
  Meeting(
      {this.eventName,
        this.from,
        this.to,
        this.background,
        this.allDay = false});

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool allDay;
}