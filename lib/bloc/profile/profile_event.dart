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
  final String companyName;
  final String companyAddress;
  final String companyPhone;
  final String ein;
  final int status;
  final String userType;
  final String nodeId;

  UpdateUserProfile(
      this.id,
      this.name,
      this.surname,
      this.phone,
      this.address,
      this.email,
      this.companyName,
      this.companyAddress,
      this.companyPhone,
      this.ein,
      this.status,
      this.userType,
      this.nodeId);
}
