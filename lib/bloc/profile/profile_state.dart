abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class UserProfileLoaded extends ProfileState {
  final Map<String, dynamic> userProfile;

  UserProfileLoaded(this.userProfile);
}

class UserProfileUpdated extends ProfileState {
  UserProfileUpdated();
}

class UserProfileUpdating extends ProfileState {
  UserProfileUpdating();
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
