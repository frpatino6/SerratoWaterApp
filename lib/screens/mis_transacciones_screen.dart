import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_bloc.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_event.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_state.dart';
import 'package:serrato_water_app/models/sales_data.dart';
import 'package:serrato_water_app/providers/user_provider.dart';
import 'package:serrato_water_app/screens/update_application_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MisTransaccionesScreen extends StatefulWidget {
  final String userType;

  const MisTransaccionesScreen({super.key, required this.userType});

  @override
  State<MisTransaccionesScreen> createState() => _MisTransaccionesScreenState();
}

class _MisTransaccionesScreenState extends State<MisTransaccionesScreen> {
  @override
  Widget build(BuildContext context) {
    Future<String> userFuture = getUserName();

    // define variable user
    var user = Provider.of<UserProvider>(context, listen: false).username;

    Future<void> fetchData() async {
      userFuture.then((String userLocal) {
        user = userLocal;
        context.read<SalesBloc>().add(LoadSalesEvent(userLocal));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales List',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return BlocConsumer<SalesBloc, SalesState>(
              listener: (context, state) {
                if (state is SalesError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is SalesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SalesLoaded) {
                  return ListView.separated(
                    itemCount: state.salesData.length,
                    itemBuilder: (context, index) {
                      SaleData data = state.salesData[index];
                      return CustomListItem(
                          saleData: data, userType: widget.userType);
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  );
                }

                return const Center(
                    child: Text('Please tap button to load data',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0)));
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<SalesBloc>().add(LoadSalesEvent(user)),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }
}

class CustomListItem extends StatelessWidget {
  final SaleData saleData;
  final String userType;

  const CustomListItem(
      {super.key, required this.saleData, required this.userType});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child:
            Text('${saleData.applicantFirstName}${saleData.applicantLastName}'),
      ),
      title: Text(
        '${saleData.applicantFirstName} ${saleData.applicantLastName}',
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
      ),
      subtitle: RichText(
        text: TextSpan(
          children: [
            const TextSpan(
                text: 'Customer name: ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '${saleData.applicantName}\n'),
            const TextSpan(
                text: 'Address: ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '${saleData.address}\n'),
            const TextSpan(
                text: 'Status: ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '${saleData.applicationState}\n'),
          ],
          style: const TextStyle(color: Colors.black54),
        ),
      ),
      trailing: userType == 'SuperAdministrator'
          ? const Icon(Icons.arrow_forward_ios, size: 14.0)
          : null,
      onTap: () {
        // Navegar a la pantalla de detalles
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UpdateApplicationStatus(saleData: saleData),
          ),
        );
      },
    );
  }
}
