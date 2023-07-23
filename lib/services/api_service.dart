import 'package:http/http.dart' as http;
import 'package:lunar_calendar/models/birthday_model.dart';
import 'package:lunar_calendar/models/date_model.dart';

class ApiService {
  static const String baseUrl =
      "http://apis.data.go.kr/B090041/openapi/service/LrsrCldInfoService/getLunCalInfo";
  static const String baseUrl2 =
      "http://apis.data.go.kr/B090041/openapi/service/LrsrCldInfoService/getSpcifyLunCalInfo";
  static const serviceKey =
      'IzSH9n3Ya2Yp5FkPKn2%2Bsb7wTdXH%2B1LaLwKXcgzAPnuWb1yek%2Bk4fMfKV1FGkFbRBjk1CG0osHZErX1hDwPNhg%3D%3D';
  static Future<DateModel> getLunarDay(String solyear, solmonth, solday) async {
    final url = Uri.parse(
        '$baseUrl?solYear=$solyear&solMonth=$solmonth&solDay=$solday&ServiceKey=$serviceKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      String str = response.body;
      String day =
          str[str.indexOf('<lunDay>') + 8] + str[str.indexOf('<lunDay>') + 9];
      String month = str[str.indexOf('<lunMonth>') + 10] +
          str[str.indexOf('<lunMonth>') + 11];
      String year = str[str.indexOf('<lunYear>') + 9] +
          str[str.indexOf('<lunYear>') + 10] +
          str[str.indexOf('<lunYear>') + 11] +
          str[str.indexOf('<lunYear>') + 12];
      DateModel date = DateModel(year, month, day);
      return date;
    }
    throw Error();
  }

  static Future<B_DateModel> getLunarBirth(
      String fromSolYear, toSolYear, lunDay, lunMonth) async {
    final url = Uri.parse(
        '$baseUrl2?fromSolYear=$fromSolYear&toSolYear=$toSolYear&lunMonth=$lunMonth&lunDay=$lunDay&leapMonth=%ED%8F%89&ServiceKey=$serviceKey');
    final response = await http.get(url);
    List<int> day = [], month = [], year = [];
    if (response.statusCode == 200) {
      int L = response.body.length;
      for (int i = 1; i < L - 10; i++) {
        if (response.body[i - 1] == '<' && response.body[i] == 's') {
          if (response.body[i + 3] == 'D') {
            day.add(int.parse(response.body[i + 7] + response.body[i + 8]));
          } else if (response.body[i + 3] == 'M') {
            month.add(int.parse(response.body[i + 9] + response.body[i + 10]));
          } else if (response.body[i + 3] == 'Y') {
            year.add(int.parse(response.body[i + 8] +
                response.body[i + 9] +
                response.body[i + 10] +
                response.body[i + 11]));
          }
        }
      }
      DateTime now = DateTime.now();
      int nowYear = now.year, nowMonth = now.month, nowDay = now.day;
      for (int i = 0; i < day.length; i++) {
        if (year[i] == nowYear) {
          if (month[i] > nowMonth) {
            nowDay = day[i];
            nowMonth = month[i];
            nowYear = year[i];
            break;
          } else if (month[i] == nowMonth) {
            if (day[i] >= nowDay) {
              nowDay = day[i];
              nowMonth = month[i];
              nowYear = year[i];
              break;
            }
          }
        } else if (year[i] < nowYear) {
          continue;
        } else {
          nowDay = day[i];
          nowMonth = month[i];
          nowYear = year[i];
          break;
        }
      }
      String nY = nowYear.toString(),
          nM = nowMonth.toString(),
          nD = nowDay.toString();
      if (nM.length == 1) {
        nM = "0$nM";
      }
      if (nD.length == 1) {
        nD = "0$nD";
      }
      //print("$nY $nM $nD");
      B_DateModel date = B_DateModel(nY, nM, nD);
      return date;
    }
    throw Error();
  }
}
