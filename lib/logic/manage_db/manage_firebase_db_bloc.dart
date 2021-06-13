import 'package:andes/data/firebase/firebase_database.dart';
import 'package:andes/logic/manage_db/manage_db_event.dart';
import 'package:andes/logic/manage_db/manage_db_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageFirebaseBloc extends Bloc<ManageEvent, ManageState> {
  ManageFirebaseBloc() : super(InsertState());

  @override
  Stream<ManageState> mapEventToState(ManageEvent event) async* {
    if(event is SubmitEventUser) {
      if (state is InsertState) {
        FirebaseRemoteServer.helper.insertUser(event.user);
      } else if(state is UpdateStateUser) {
        FirebaseRemoteServer.helper.getUserList();
        yield UpdateStateUser();
      }
    }
  }
}