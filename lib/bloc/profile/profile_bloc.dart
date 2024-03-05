import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/api/fireBaseApi.dart';
import 'package:serrato_water_app/bloc/profile/profile_event.dart';
import 'package:serrato_water_app/bloc/profile/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseAPI profileRepository;

  ProfileBloc(this.profileRepository) : super(ProfileInitial()) {
    on<LoadUserProfile>((event, emit) async {
      try {
        emit(ProfileLoading());
        final userProfile = await profileRepository.getUserByEmail(event.email);
        if (userProfile != null) {
          emit(UserProfileLoaded(userProfile));
        } else {
          emit(ProfileError('User not found'));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    // Agrega aquí el manejador para el evento de actualización del perfil del usuario
    on<UpdateUserProfile>((event, emit) async {
      try {
        emit(UserProfileUpdating());

        await profileRepository.putUserExtendInfo(
          event.id,
          event.email,
          event.name,
          event.surname,
          event.address,
          event.phone,
          event.companyName,
          event.companyAddress,
          event.companyPhone,
          event.status,
          event.ein,
          event.userType,
          event.nodeId,
        );
        emit(UserProfileUpdated());
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
