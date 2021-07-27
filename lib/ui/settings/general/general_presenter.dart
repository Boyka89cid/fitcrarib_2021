import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitcarib/base/presenter/base_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class GeneralContract extends BaseContract {

  void toLoginScreen();
}

class GeneralPresenter extends BasePresenter {
  GeneralPresenter(BaseContract view) : super(view);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  dynamic email1() async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.get("email");
  }

  Future changePassword(dynamic email, dynamic currentPassword, dynamic changePassword, dynamic repeatPassword) async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    final user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: currentPassword);
    if(user.user!.uid != null){
      if(changePassword == repeatPassword){
        user.user!.updatePassword(changePassword).whenComplete((){
          _firebaseAuth.signOut().whenComplete((){
            prefs.clear().whenComplete((){
              (view as GeneralContract).toLoginScreen();
            });
          });
        });
      }
      else{
        (view as GeneralContract).showMessage("New password didn't matched! Try again");
      }
    }
    else{
      (view as GeneralContract).showMessage("Wrong Password! Try Again!");
    }
  }
}
