import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitcarib/ui/messages/messages.dart';
import 'package:fitcarib/ui/notifications/notifications.dart';
import 'package:fitcarib/ui/settings/settings.dart';
import 'package:fitcarib/ui/friends/friends.dart';


class CommonBottomNavigationBar extends StatefulWidget {
  final selectedIndex;
  CommonBottomNavigationBar({Key? key, this.selectedIndex}) : super(key: key,);
  @override
  CommonBottomNavigationBarState createState() => new CommonBottomNavigationBarState(selectedIndex);
}

class CommonBottomNavigationBarState extends State<CommonBottomNavigationBar> {

  var selectedIndex;

  CommonBottomNavigationBarState(this.selectedIndex);

  SharedPreferences? sharedPreferences;
  String? downloadUrl;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      sharedPreferences = sp;
    });
  }

  @override
  Widget build(BuildContext context) {
     return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: '',),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: ''),
        BottomNavigationBarItem(icon: Text(''), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
      ],
      currentIndex: selectedIndex,
      fixedColor: Colors.tealAccent[700],
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(context,MaterialPageRoute(builder: (context) => NotificationsScreen()),);
    } else if (index == 1) {
      Navigator.push(context,MaterialPageRoute(builder: (context) => MessageScreen()),);
    } else if (index == 3) {
      Navigator.push(context,MaterialPageRoute(builder: (context) => FriendsScreen()),);
    } else if (index == 4) {
      Navigator.push(context,MaterialPageRoute(builder: (context) => SettingsScreen()),);
    }
  }


}
