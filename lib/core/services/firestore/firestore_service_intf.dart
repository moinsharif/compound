
import 'package:compound/shared_models/user_model.dart';

abstract class FirestoreServiceIntf {  
  Future createUser(User user);
  Future getUser(String uid);
}

