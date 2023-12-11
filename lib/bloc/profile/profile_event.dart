abstract class ProfileEvent {}

class LoadUserProfile extends ProfileEvent {
  final String email;

  LoadUserProfile(this.email);
}

class UpdateUserProfile extends ProfileEvent {
  final String id;
  final String name;
  final String surname;
  final String phone;
  final String address;
  final String email;

  UpdateUserProfile(
      this.id, this.name, this.surname, this.phone, this.address, this.email);
}
