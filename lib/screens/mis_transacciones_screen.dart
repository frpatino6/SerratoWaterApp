import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_bloc.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_event.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_state.dart';
import 'package:serrato_water_app/models/sales_data.dart';
import 'package:serrato_water_app/providers/user_provider.dart';

class MisTransaccionesScreen extends StatelessWidget {
  MisTransaccionesScreen();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).username;

    Future<void> fetchData() async {
      context.read<SalesBloc>().add(LoadSalesEvent(user));
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
                      return CustomListItem(saleData: data);
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
}

class CustomListItem extends StatelessWidget {
  final SaleData saleData;

  CustomListItem({required this.saleData});

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
                text: 'Applicant name: ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '${saleData.applicantName}\n'),
            const TextSpan(
                text: 'Address: ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '${saleData.address}\n'),
          ],
          style: const TextStyle(color: Colors.black54),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14.0),
    );
  }
}
