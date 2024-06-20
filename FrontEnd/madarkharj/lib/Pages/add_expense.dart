import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:madarkharj/Controllers/user_controller.dart';
import 'package:madarkharj/models/create_expense.dart';
import 'package:madarkharj/models/groups_data.dart';
import 'package:madarkharj/services/add_expense_service.dart';
import 'package:madarkharj/services/get_greoup_info_byid.dart';
import 'package:madarkharj/widgets/appbar_widget.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddExpense();
  }
}

class _AddExpense extends State<AddExpense> {
  final priceController = TextEditingController();
  final nameController = TextEditingController();
  final membersController = TextEditingController();

  late Group _groups;
  late List<dynamic> users;

  final UserController userController = Get.find();

  final groupId = Get.arguments['id'];

  @override
  void dispose() {
    priceController.dispose();
    nameController.dispose();
    membersController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    GetGroupInfoById.getGroupsInfo(groupId).then((groups) => {
          setState(() {
            _groups = groups;
            users = _groups.user;
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'افزودن خرج', backButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildTextField(
              context,
              'مبلغ',
              Icons.attach_money_rounded,
              priceController,
            ),
            const SizedBox(height: 32),
            _buildTextField(
              context,
              'بابت',
              Icons.comment_rounded,
              nameController,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            _buildTextField(context, 'افزودن اعضا', Icons.group_add_rounded,
                membersController),
            Expanded(
                child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index]['username'];
                      final id = users[index]['id'];
                      print(user);
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _buildMemberChip(user, id),
                      );
                    })),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
                width: double.infinity,
                child: Obx(() {
                  final user = userController.user.value;
                  return ElevatedButton(
                    onPressed: () {
                      List<int> userIds =
                          users.map((user) => user['id'] as int).toList();
                      AddExpenseModel data = AddExpenseModel(
                        name: nameController.text,
                        price: int.parse(priceController.text),
                        owner: user.id,
                        users: userIds,
                      );
                      print({data.name});
                      AddExpenseService.createGroup(data , context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 6, 157, 36),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        textStyle: const TextStyle(
                          fontSize: 25,
                        )),
                    child: const Text(
                      "افزودن",
                      style: TextStyle(fontSize: 25, fontFamily: 'Peyda'),
                    ),
                  );
                })),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String labelText, IconData icon,
      TextEditingController controller,
      {int maxLines = 1}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 19,
        ),
        decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(icon, color: Colors.green),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16),
            ),
            floatingLabelStyle: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            filled: true,
            fillColor: Colors.white,
            labelStyle: const TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildMemberChip(String name, int Id) {
    return Chip(
      label: Text(name),
      deleteIcon: _buildDeleteIcon(),
      onDeleted: () {
        setState(() {
          users = users.where((user) => user['id'] != Id).toList();
        });
      },
      backgroundColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }

  Widget _buildDeleteIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.green),
      ),
      child: const Center(
        child: Icon(Icons.close, size: 16, color: Colors.green),
      ),
    );
  }
}
