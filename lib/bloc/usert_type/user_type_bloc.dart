import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/api/user_type_api.dart';
import 'user_type_event.dart';
import 'user_type_state.dart';

class UserTypeBloc extends Bloc<UserTypeEvent, UserTypeState> {
  final UsertTypeApi api;
  UserTypeBloc({required this.api}) : super(UserTypeInitial()) {
    on<LoadUserType>((event, emit) async {
      emit(UserTypeLoading());
      try {
        final userType = await api.getUserType();

        if (userType.isNotEmpty) {
          emit(UserTypeLoaded(userType));
        } else {
          emit(UserTypeError('No user type found'));
        }
      } catch (e) {
        emit(UserTypeError(e.toString()));
      }
    });
  }
}
