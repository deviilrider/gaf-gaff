import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Views/Profile/profileview.dart';

class CostumAppBar extends StatelessWidget {
  final String pagetitle;
  final List<Widget> actions;

  const CostumAppBar({Key key, this.pagetitle, this.actions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 5, bottom: 3),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfileView()));
                  },
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(50)),
                      child: Image.asset(
                        "assets/images/gaf-gaff.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                pagetitle,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.black,
                    fontFamily: "Roboto"),
              ),
            ],
          ),
          Row(children: actions),
        ],
      ),
    );
  }
}
