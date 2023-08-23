// import 'package:erick/features/tasks/model/usermember.dart';
// import 'package:flutter/material.dart';

// class SelectedMembersProvider with ChangeNotifier {
//   List<userListData> _selectedMembers = [];

//   List<userListData> get selectedMembers => _selectedMembers;
//   // Add a method to get the selected members
//   List<userListData> getSelectedMembers() {
//     return _selectedMembers;
//   }

//   // Add a method to toggle selection and update _selectedMembers
//   void toggleSelected(userListData user) {
//     if (_selectedMembers.contains(user)) {
//       _selectedMembers.remove(user);
//     } else {
//       _selectedMembers.add(user);
//     }
//     notifyListeners();
//   }

//   // Method to check if a member is selected
//   bool isSelected(userListData member) {
//     return _selectedMembers.contains(member);
//   }
// }
