import 'package:andes/data/local/local_database.dart';
import 'package:andes/logic/manage_db/manage_db_event.dart';
import 'package:andes/logic/manage_db/manage_db_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageLocalBloc extends Bloc<ManageEvent, ManageState> {
  ManageLocalBloc() : super(InsertState());

  @override
  Stream<ManageState> mapEventToState(ManageEvent event) async* {
    if(event is DeleteEvent) {
      DatabaseLocalServer.helper.deleteItem(event.id);
    } else if(event is UpdateRequest) {
      yield UpdateState(productId: event.productId, previousProduct: event.previousProduct);
    } else if(event is SubmitEvent) {
      if(state is InsertState) {
        DatabaseLocalServer.helper.insertItem(event.product);
      } else {
        DatabaseLocalServer.helper.getItemList();
      }
    }
  }
}