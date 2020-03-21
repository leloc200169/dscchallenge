import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:app_usage/app_usage.dart';
import 'dart:async';
import 'task.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppUsage appUsage = new AppUsage();
  double apps;

  List<Task> appTime= [];

  Widget appTemplate(app){
    if (app != null) {
      return Card(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Text(
                app.taskName
            ),
            Divider(height: 1.0, thickness: 2.0,),
            Text(
                app.taskTime
            )
          ],
        ),
      );
    }
    else return Text('Press the button again');
  }

  Color c1 = ColorUtil.color('#086BEB');
  Color c2 = ColorUtil.color('#081CFF');
  Color c3 = ColorUtil.color('#C1E3FF');
  Color c4 = ColorUtil.color('#8CB1EB');
  Color c5 = ColorUtil.color('#4889FF');

  double initTime=3600.0*24.0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
  }

  void getUsageStats() async {
    try {
      DateTime endDate = new DateTime.now();
      DateTime startDate = endDate.subtract(new Duration(hours: 24));
      Map<String, double> usage = await appUsage.fetchUsage(startDate, endDate);
      usage.removeWhere((key, val) => val == 0);
      setState(() => apps = calculate(usage));
      setState(()=> appTime = process(usage));
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  List<Task> process (Map<String, double> usage){
    List<Task> temp=[];

    usage.forEach((k,v) => temp.add(Task(taskName: k,taskTime: v)));

    return temp;
  }

  double calculate(Map<String, double> usage) {
    double sum=0;
    usage.forEach((k,v){
      sum=sum+v;
    });
    return sum;
  }

  @override
  Widget build(BuildContext context) {



    DateTime day= new DateTime.now();
    int today= day.weekday;
    double dayPer;
    String nameDay;
    print(day);
    switch (today){
      case 1:
        {

            nameDay='Monday';

        }
        break;
      case 2:
        {

            nameDay='Tuesday';

        }
        break;
      case 3:
        {

            nameDay='Wednesday';

        }
        break;
      case 4:
        {

            nameDay='Thursday';

        }
        break;
      case 5:
        {

            nameDay='Friday';

        }
        break;
      case 6:
        {

            nameDay='Saturday';

        }
        break;
      case 7:
        {

            nameDay='Sunday';

        }
        break;

    }
    var list=[];
    double scrwidth = MediaQuery. of(context). size. width;
    double scrheight = MediaQuery. of(context). size. height;

    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('FREEtiME',
                style: TextStyle(fontSize: 30 ),
              )
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () {
          getUsageStats();
          print(apps);

        },

      ),

      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[

                  Container(
                    margin: new EdgeInsets.all(10.0),
                    height: scrheight/10*2.5,
                    width: scrwidth,
                    decoration: new BoxDecoration(
                      color: Colors.purple,
                      gradient: new LinearGradient(
                        colors: [c2,c1],
                      ),
                      borderRadius: new BorderRadius.all(new Radius.circular(30.0)),

                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            flex: 5,
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Free time chart',
                                    style: TextStyle(fontSize: 20)),
                              ],
                            )
                        ),
                        Expanded(
                            flex:5,
                            child: SleekCircularSlider(
                              appearance: CircularSliderAppearance(
                                  customWidths: CustomSliderWidths(progressBarWidth: 10.0 ,trackWidth: 5.0),
                                  customColors: CustomSliderColors(
                                      progressBarColors: [
                                        c3,c4,c5
                                      ]),
                                  infoProperties: InfoProperties(
                                      mainLabelStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      bottomLabelStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700
                                      ),

                                      bottomLabelText: 'Your free time'
                                  )
                              ),
                              min: 10,
                              max: 28,
                              initialValue: 14,
                            )
                        )
                      ],
                    ),


                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(

                    decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: new BorderRadius.all(new Radius.circular(30.0)),

                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(nameDay + ' Tasks:',
                          style: TextStyle(fontSize: 20), )
                      ],

                    ),
                  )
              ),

            ],
          )
      ),
    );
  }

}

