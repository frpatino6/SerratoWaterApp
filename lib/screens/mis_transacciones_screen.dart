import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_bloc.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_event.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_state.dart';
import 'package:serrato_water_app/models/sales_data.dart';
import 'package:serrato_water_app/providers/user_provider.dart';
import 'package:serrato_water_app/screens/update_application_status.dart';

class MisTransaccionesScreen extends StatefulWidget {
  final String userType;

  const MisTransaccionesScreen({super.key, required this.userType});

  @override
  State<MisTransaccionesScreen> createState() => _MisTransaccionesScreenState();
}

class _MisTransaccionesScreenState extends State<MisTransaccionesScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    if (widget.userType == 'SuperAdministrator') {
      context.read<SalesBloc>().add(LoadAllSalesEvent());
    } else {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      context.read<SalesBloc>().add(LoadSalesEvent(userProvider.username));
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocConsumer<SalesBloc, SalesState>(
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadData,
        child: const Icon(Icons.refresh),
      ),
    );
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UpdateApplicationStatus(saleData: saleData),
          ),
        );
      },
    );
  }
}
