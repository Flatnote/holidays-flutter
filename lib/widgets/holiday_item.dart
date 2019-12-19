import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HolidayItem extends StatefulWidget {
  final String dp;
  final String name;
  final String time;
  final String img;
  final String date;

  HolidayItem(
      {Key key,
      @required this.dp,
      @required this.name,
      @required this.time,
      @required this.img,
      @required this.date})
      : super(key: key);

  @override
  _HolidayItemState createState() => _HolidayItemState();
}

class _HolidayItemState extends State<HolidayItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: InkWell(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    "${widget.dp}",
                  ),
                ),
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  "${widget.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  DateFormat.yMMMMd()
                      .format(DateTime.parse("${widget.date}")),
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 11,
                  ),
                ),
              ),
              Image.asset(
                "${widget.img}",
                height: 170,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ],
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
