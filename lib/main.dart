// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'models/currency.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'), // Farsi
      ],
      theme: ThemeData(
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontFamily: 'graphic',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          headline2: TextStyle(
              fontFamily: 'graphic',
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: Colors.white),
          bodyText1: TextStyle(
            fontFamily: 'graphic',
            fontWeight: FontWeight.w300,
            fontSize: 13,
          ),
          subtitle1: TextStyle(
              fontFamily: 'graphic',
              fontWeight: FontWeight.w300,
              fontSize: 13,
              color: Colors.red),
          subtitle2: TextStyle(
              fontFamily: 'graphic',
              fontWeight: FontWeight.w300,
              fontSize: 13,
              color: Colors.green),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currencies = [];

  Future getResponse(BuildContext context) async {
    var url =
        "https://sasansafari.com/flutter/api.php?access_key=flutter123456";

    var response = await http.get(Uri.parse(url));

    if (currencies.isEmpty) {
      if (response.statusCode == 200) {
        List jsonList = json.decode(response.body);

        if (jsonList.isNotEmpty) {
          for (var currency in jsonList) {
            setState(() {
              currencies.add(Currency(
                id: currency['id'],
                title: currency['title'],
                price: currency['price'],
                changes: currency['changes'],
                status: currency['status'],
              ));
            });
          }

          _showSnackBar(context, 'بروزرسانی اطلاعات موفقیت‌آمیز بود');
        }

        developer.log(
          response.body,
          name: 'getResponse()',
        );
      }
    }

    return response;
  }

  @override
  void initState() {
    super.initState();
    getResponse(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        actions: [
          const SizedBox(width: 10),
          Image.asset("assets/images/icon.png"),
          const SizedBox(width: 10),
          Text(
            'قیمت به روز ارز',
            style: Theme.of(context).textTheme.headline1,
          ),
          Expanded(
              child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset("assets/images/menu.png"),
          )),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Q U E S T I O N S
              Row(
                children: [
                  Image.asset("assets/images/question.png"),
                  const SizedBox(width: 10),
                  Text(
                    'نرخ آزاد ارز چیست؟',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // T E X T
              Text(
                textDirection: ui.TextDirection.rtl,
                " نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.",
                style: Theme.of(context).textTheme.bodyText1,
              ),

              // H E A D E R  C O N T A I N E R
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 28, 0, 0),
                child: Container(
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xff828282),
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('نام آزاد ارز',
                          style: Theme.of(context).textTheme.headline2),
                      Text('قیمت',
                          style: Theme.of(context).textTheme.headline2),
                      Text('تغییر',
                          style: Theme.of(context).textTheme.headline2),
                    ],
                  ),
                ),
              ),

              // L I S T V I E W
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.9,
                child: listFutureBuilder(context),
              ),

              // U P D A T E
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 22),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 13,
                  decoration: BoxDecoration(
                    color: Color(0xffE8E8E8),
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Button Update
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.6,
                        height: MediaQuery.of(context).size.height / 13,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(2),
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xffCAC1FF)),
                          ),
                          onPressed: () {
                            currencies.clear();
                            listFutureBuilder(context);
                            setState(() {
                              _getTime();
                            });
                          },
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              CupertinoIcons.refresh,
                              color: Colors.black,
                            ),
                          ),
                          label: Padding(
                            padding: const EdgeInsets.only(right: 3.0),
                            child: Text(
                              'بروزرسانی',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ),
                      ),

                      // Text Time

                      Text('آخرین بروزرسانی     ${_getTime()}'),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<dynamic> listFutureBuilder(BuildContext context) {
    return FutureBuilder(
      future: getResponse(context),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Center(child: CircularProgressIndicator())
            : ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: currencies.length,
                itemBuilder: (context, index) =>
                    CurrencyCard(index, currencies),
                separatorBuilder: (context, index) {
                  if (index % 9 == 0) {
                    return AdsCard();
                  } else {
                    return SizedBox.shrink();
                  }
                },
              );
        ;
      },
    );
  }
}

void _showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: Theme.of(context).textTheme.headline2,
    ),
    backgroundColor: Colors.green,
  ));
}

String _getTime() {
  // * My Method
  // var hours = DateTime.now().hour.toString().padLeft(2, '0');
  // var minutes = DateTime.now().minute.toString().padLeft(2, '0');

  final now = DateTime.now();
  // final formattedTime = DateFormat(DateFormat.HOUR_MINUTE).toString();
  final formattedTime = DateFormat('kk:mm').format(now);

  return changeToFarsiNumber(formattedTime);
}

class CurrencyCard extends StatelessWidget {
  CurrencyCard(this.index, this.currencies);

  int index;
  List<Currency> currencies;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Currency Name
            Text(
              currencies[index].title!,
              style: Theme.of(context).textTheme.bodyText1,
            ),

            // Currency Price
            Text(
              changeToFarsiNumber(currencies[index].price!),
              style: Theme.of(context).textTheme.bodyText1,
            ),

            // Currency Change
            Text(
              changeToFarsiNumber(currencies[index].changes!),
              style: currencies[index].status! == 'p'
                  ? Theme.of(context).textTheme.subtitle2
                  : Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}

class AdsCard extends StatelessWidget {
  const AdsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: Colors.red,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Ads',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ),
    );
  }
}

String changeToFarsiNumber(String number) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '٢', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  en.forEach((enDigit) {
    final faIndex = en.indexOf(enDigit);
    number = number.replaceAll(enDigit, fa[faIndex]);
  });

  return number;
}
