import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunar_calendar/models/birthday_model.dart';
import 'package:lunar_calendar/models/date_model.dart';
import 'package:lunar_calendar/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<DateModel> lunData;
  late Future<B_DateModel> lunBirth;
  String lunDay = '01', lunMonth = '01';
  String solyear = '1900', solmonth = '01', solday = '31';

  DateTime date = DateTime.now();
  DateTime now = DateTime.now();
  String selectedDay = '날짜를 선택해 주세요(클릭)';

  @override
  void initState() {
    super.initState();
    lunData = ApiService.getLunarDay('1900', '01', '31');
    lunBirth = ApiService.getLunarBirth(
        now.year.toString(),
        (int.parse(DateFormat('yyy').format(DateTime.now()).toString()) + 2)
            .toString(),
        '01',
        '01');
  }

  Future<void> _fetchData() async {
    lunData = ApiService.getLunarDay(solyear, solmonth, solday);
    final DateModel dateModel = await lunData;

    lunBirth = ApiService.getLunarBirth(
      now.year.toString(),
      (int.parse(DateFormat('yyy').format(DateTime.now()).toString()) + 2)
          .toString(),
      dateModel.lunDay,
      dateModel.lunMonth,
    );
    await lunBirth;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              '양력 날짜를 선택해 주세요',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  setState(() {
                    date = selectedDate;
                    selectedDay = date.toString();
                    selectedDay = selectedDay.substring(0, 10);
                    solyear = selectedDay.substring(0, 4);
                    solmonth = selectedDay.substring(5, 7);
                    solday = selectedDay.substring(8, 10);
                    _fetchData();
                  });
                }
              },
              child: Text(
                selectedDay,
                style: TextStyle(
                  color: Colors.amber[400],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Icon(Icons.keyboard_arrow_down, color: Colors.amber[800]),
            const SizedBox(height: 20),
            const Text(
              "음력 날짜",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: lunData,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  lunDay = snapshot.data!.lunDay;
                  lunMonth = snapshot.data!.lunMonth;
                  return Column(
                    children: [
                      Text(
                        "${snapshot.data!.lunYear}-${snapshot.data!.lunMonth}-${snapshot.data!.lunDay}",
                        style: TextStyle(
                          color: Colors.amber[400],
                        ),
                      )
                    ],
                  );
                } else {
                  return Text(
                    "0000-00-00",
                    style: TextStyle(color: Colors.amber[400]),
                  );
                }
              }),
            ),
            const SizedBox(height: 20),
            Icon(Icons.keyboard_arrow_down, color: Colors.amber[800]),
            const SizedBox(height: 20),
            Column(
              children: [
                const Text(
                  '다음 음력 생일',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                  future: lunBirth,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return Column(
                        children: [
                          Text(
                            '${snapshot.data!.solYear}-${snapshot.data!.solMonth}-${snapshot.data!.solDay}',
                            style: TextStyle(
                              color: Colors.amber[400],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedIconTheme: const IconThemeData(color: Colors.amber),
        unselectedIconTheme: const IconThemeData(color: Colors.amber),
        selectedFontSize: 18,
        unselectedFontSize: 14,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: (int index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, '/lunar');
              break;
            default:
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sunny),
            label: '양력',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nightlight),
            label: '음력',
          ),
        ],
      ),
    );
  }
}
