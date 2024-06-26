import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madarkharj/Pages/create_group.dart';
import 'package:madarkharj/services/get_greoup_info_byid.dart';
import 'package:madarkharj/services/get_tokens.dart';
import 'package:madarkharj/models/groups_data.dart';

class GroupMembersPage extends StatefulWidget {
  const GroupMembersPage({super.key});

  @override
  State<GroupMembersPage> createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage>
    with SingleTickerProviderStateMixin {
  late Group _groups;
  bool _isLoading = true;
  var _bottomNavIndex = 0;

  final groupId = Get.arguments['id'];
  final iconList = <IconData>[Icons.home_rounded, Icons.person_rounded];


  @override
  void initState() {
    super.initState();
    _isLoading = true;
    GetGroupInfoById.getGroupsInfo(groupId).then((groups) => {
          setState(() {
            _groups = groups;
            _isLoading = false;
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
          print(_groups.user);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 30,
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            "اعضا",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 6, 157, 36),
        child: const Icon(Icons.add_rounded, size: 45, color: Colors.white),
        onPressed: () {
          Get.to(() => const CreateGroupPage());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeColor: const Color.fromARGB(255, 6, 157, 36),
        height: Get.height / 13,
        backgroundColor: Colors.white,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        gapLocation: GapLocation.center,
        icons: iconList,
        activeIndex: 0,
        iconSize: 32,
        onTap: (int) {
          print(int);
        },
      ),
      body: ListView.builder(
        itemCount: _groups.user.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child:  ListTile(
                  
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 24.0,
                    child:
                        Icon(Icons.person_pin, color: Colors.white, size: 32.0),
                  ),
                  title: Text(
                     _groups.user[index]['username'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Peyda',
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
