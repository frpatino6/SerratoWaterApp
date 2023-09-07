abstract class CreditApplicationEvent {}

class SaveCreditApplicationEvent extends CreditApplicationEvent {
  final Map<String, dynamic> applicationData;

  SaveCreditApplicationEvent(this.applicationData);
}
