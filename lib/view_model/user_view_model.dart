import 'package:get/get.dart';
import 'package:healty_ways/model/user_model.dart';

class UserViewModel extends GetxController {
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  UserModel? get currentUser => _currentUser.value;
  set currentUser(UserModel? value) => _currentUser.value = value;

  final RxList<UserModel> _allUsers = <UserModel>[].obs;
  List<UserModel> get allUsers => _allUsers;

  @override
  void onInit() {
    super.onInit();
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _allUsers.addAll([
      UserModel(
        uid: 'user1',
        fullName: 'John Doe',
        email: 'john@example.com',
        profileImage: 'https://example.com/john.jpg',
      ),
      UserModel(
        uid: 'user2',
        fullName: 'Jane Smith',
        email: 'jane@example.com',
        profileImage: 'https://example.com/jane.jpg',
      ),
    ]);
  }

  void setCurrentUser(UserModel user) {
    currentUser = user;
  }

  void addUser(UserModel user) {
    _allUsers.add(user);
  }

  void removeUser(String uid) {
    _allUsers.removeWhere((user) => user.uid == uid);
  }
}
