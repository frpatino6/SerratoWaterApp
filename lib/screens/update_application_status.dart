import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_bloc.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_event.dart';
import 'package:serrato_water_app/bloc/users/user_bloc.dart';
import 'package:serrato_water_app/bloc/users/user_event.dart';
import 'package:serrato_water_app/bloc/users/user_state.dart';
import 'package:serrato_water_app/models/sales_data.dart';
import 'package:serrato_water_app/models/user_data.dart';
import 'package:serrato_water_app/screens/CreditApplicationProcessingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateApplicationStatus extends StatefulWidget {
  final SaleData saleData;
  final String currentUserType;
  const UpdateApplicationStatus(
      {super.key, required this.saleData, required this.currentUserType});

  @override
  State<UpdateApplicationStatus> createState() =>
      _UpdateApplicationStatusState();
}

class _UpdateApplicationStatusState extends State<UpdateApplicationStatus> {
  String? selectedInstaller;
  DateTime? selectedInstallationDate;
  late String dropdownValue;
  late String currentUserType;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.saleData.applicationState; // Inicialízalo aquí
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    List<String> products = widget.saleData.productsSold.split(',');
    // add widget.saleData.installationDate is null or emtpy
    if (widget.saleData.installationDate.isNotEmpty) {
      DateTime installationDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS")
          .parse(widget.saleData.installationDate);
      formattedDate = DateFormat("dd/MM/yyyy").format(installationDate);
    } else {
      formattedDate = 'Unassigned installation date';
    }
    TextStyle headingStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );

    TextStyle contentStyle = const TextStyle(
      fontSize: 16,
      color: Colors.black54,
    );

    List<String> statusOptions = [
      "Submitted",
      "Under Review",
      "Declined",
      "Approved",
      "Pending Installation",
      "Installed",
      "Pending Verification",
      "Funding Process",
      "Completed",
    ];

    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        bool isDropdownEnabled = true;

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final prefs = snapshot.data!;
          final userType = prefs.getString('userType');
          if (userType == "SuperAdministrator" &&
              widget.saleData.applicationState == "Submitted") {
            isDropdownEnabled = false;
            dropdownValue = "Under Review";
          } else {
            isDropdownEnabled = false;
          }
          if (userType == "SuperAdministrator") {
            isDropdownEnabled = true;
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Installation Details'),
            actions: [
              if (widget.currentUserType == 'SuperAdministrator' ||
                  widget.currentUserType == 'Administrator')
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    final salesBloc = BlocProvider.of<SalesBloc>(context);
                    final newState = dropdownValue;
                    final salesId = widget.saleData.id;

                    // Verifica si el estado es 'Pending Installation' y si no se ha seleccionado un instalador o fecha de instalación
                    if (dropdownValue == 'Pending Installation' &&
                        (selectedInstaller == null ||
                            selectedInstallationDate == null)) {
                      // Usa AlertDialog en lugar de SnackBar
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Incomplete Information'),
                            content: const Text(
                                'Please select an installer and installation date'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Cierra el AlertDialog
                                  _showInstallationDialog(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }

                    if (selectedInstaller != null &&
                        selectedInstallationDate != null) {
                      salesBloc.add(UpdateSalesStatusEmialInstalleEvent(
                          salesId, newState, selectedInstaller!));
                    } else {
                      salesBloc.add(UpdateSalesStatusEvent(salesId, newState));
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Updating sales status...')),
                    );
                  },
                ),
              if (widget.currentUserType == 'Installer')
                IconButton(
                  icon: const Icon(Icons.credit_score),
                  onPressed: _processCreditApplication,
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text('Applicant Name:', style: headingStyle),
                Text(widget.saleData.applicantName, style: contentStyle),
                const SizedBox(height: 16),
                Text('Address:', style: headingStyle),
                Text(widget.saleData.address, style: contentStyle),
                const SizedBox(height: 16),
                Text('Installation date:', style: headingStyle),
                Text(formattedDate, style: contentStyle),
                const SizedBox(height: 16),
                Text('Installation Address:', style: headingStyle),
                Text(widget.saleData.address, style: contentStyle),
                const SizedBox(height: 16),
                Text('Status:', style: headingStyle),
                DropdownButtonFormField<String>(
                  value: dropdownValue,
                  items: statusOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: isDropdownEnabled
                      ? (newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                          if (newValue == 'Pending Installation') {
                            _showInstallationDialog(context);
                          }
                        }
                      : null, // Controla si el dropdown es modificable
                ),
                const SizedBox(height: 16),
                Text('Product List', style: headingStyle),
                const SizedBox(height: 8),
                ...products.map((product) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: const Icon(Icons.check_circle_outline,
                          color: Colors.blue),
                      title: Text(product, style: contentStyle),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _processCreditApplication() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreditApplicationProcessingScreen(
          saleData: widget.saleData,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        // Actualiza el estado de la aplicación con el resultado.
        widget.saleData.applicationState = result as String;
        // Actualiza el valor del dropdown para reflejar el nuevo estado.
        dropdownValue = widget.saleData.applicationState;
      });
    }
  }

  void _showInstallationDialog(BuildContext context) {
    // Trigger the event to load installers
    context.read<UserBloc>().add(LoadUsers());

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select Installation Details'),
          content: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return const CircularProgressIndicator();
              } else if (state is UserLoaded) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      value: selectedInstaller,
                      hint: const Text('Select Installer'),
                      items: state.users.map((UserData userData) {
                        return DropdownMenuItem<String>(
                          value: userData.email,
                          child: Text(
                              "${userData.firstName} ${userData.lastName}"),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedInstaller = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate:
                              selectedInstallationDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedInstallationDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        selectedInstallationDate == null
                            ? 'Select Installation Date'
                            : 'Installation Date: ${selectedInstallationDate!.toLocal().toString().split(' ')[0]}',
                      ),
                    ),
                  ],
                );
              } else if (state is UserError) {
                return Text('Error: ${state.message}');
              }
              return const Text('Please wait...');
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Accept'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
