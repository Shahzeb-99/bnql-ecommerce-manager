import 'dart:io';

import 'package:ecommerce_bnql/pdf_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../investor_panel/customer/customer_page/customer_screen.dart';
import '../../investor_panel/customer/add_new_customer/add_customer_screen.dart';
import '../../investor_panel/view_model/viewmodel_customers.dart';

enum CustomerFilterOptions { all, oneMonth, sixMonths }

class AllCustomersScreen extends StatefulWidget {
  const AllCustomersScreen({Key? key}) : super(key: key);

  @override
  State<AllCustomersScreen> createState() => _AllCustomersScreenState();
}

class _AllCustomersScreenState extends State<AllCustomersScreen> {
  @override
  void initState() {
    if (Provider.of<CustomerViewInvestor>(context, listen: false).option ==
        CustomerFilterOptions.all) {
      Provider.of<CustomerViewInvestor>(context, listen: false).getCustomers();
    } else {
      //Provider.of<CustomerView>(context, listen: false).getThisMonthCustomers();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Customers',
              style: TextStyle(fontSize: 25),
            ),
            Expanded(
              child: Container(),
            ),
            IconButton(
                onPressed: () async {
                  final pdf = pw.Document();

                  final image = (await rootBundle.load('assets/dart.png'))
                      .buffer
                      .asUint8List();
                  final list =
                      Provider.of<CustomerViewInvestor>(context, listen: false)
                          .allCustomers;
                  pdf.addPage(
                    pw.Page(
                        build: (pw.Context context) => pw.Column(
                              children: [
                                pw.SizedBox(
                                    width: 250,
                                    child: pw.Center(
                                      child: pw.Image(pw.MemoryImage(image)),
                                    )),
                                pw.SizedBox(height: 25),
                                pw.Center(
                                  child: pw.Text('Customers List'),
                                ),
                                pw.SizedBox(height: 100),
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.stretch,
                                    children: [
                                      pw.Row(children: [
                                        pw.Expanded(child: pw.Text('Name')),
                                        pw.Expanded(
                                            child:
                                                pw.Text('Outstanding Balance')),
                                        pw.Expanded(
                                            child: pw.Text('Amount Paid')),
                                      ]),
                                      pw.Divider(
                                          thickness: 1, color: PdfColors.black)
                                    ]),
                                pw.ListView.builder(
                                    itemBuilder:
                                        (pw.Context context, int index) {
                                      return pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.stretch,
                                          children: [
                                            pw.Row(children: [
                                              pw.Expanded(
                                                  child: pw.Text(
                                                      '${list[index].name}')),
                                              pw.Expanded(
                                                  child: pw.Text(
                                                      '${list[index].outstandingBalance}')),
                                              pw.Expanded(
                                                  child: pw.Text(
                                                      '${list[index].paidAmount}')),
                                            ]),
                                            pw.Divider(color: PdfColors.black)
                                          ]);
                                    },
                                    itemCount: list.length),

                              ],
                            )),
                  );
                  final path = (await getApplicationDocumentsDirectory()).path;
                  final file = File('${path}customerList.pdf');
                  await file
                      .writeAsBytes(await pdf.save())
                      .whenComplete(() async => await OpenFilex.open(file.path));

                  print(file.path);
                },
                icon: const Icon(Icons.picture_as_pdf_rounded)),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCustomerScreen()));
              },
              icon: const Icon(Icons.add_rounded),
              splashRadius: 25,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ListView.builder(
            physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: Provider.of<CustomerViewInvestor>(context, listen: false)
                        .option ==
                    CustomerFilterOptions.all
                ? Provider.of<CustomerViewInvestor>(context).allCustomers.length
                : Provider.of<CustomerViewInvestor>(context)
                    .thisMonthCustomers
                    .length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 5,
                color: const Color(0xFF2D2C3F),
                child: InkWell(
                  onLongPress: () {},
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CustomerProfile(index: index)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              Provider.of<CustomerViewInvestor>(context,
                                              listen: false)
                                          .option ==
                                      CustomerFilterOptions.all
                                  ? Provider.of<CustomerViewInvestor>(context)
                                      .allCustomers[index]
                                      .image
                                  : Provider.of<CustomerViewInvestor>(context)
                                      .thisMonthCustomers[index]
                                      .image),
                          radius: 30,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Provider.of<CustomerViewInvestor>(context,
                                              listen: false)
                                          .option ==
                                      CustomerFilterOptions.all
                                  ? Provider.of<CustomerViewInvestor>(context)
                                      .allCustomers[index]
                                      .name
                                  : Provider.of<CustomerViewInvestor>(context)
                                      .thisMonthCustomers[index]
                                      .name,
                              style: kBoldText,
                            ),
                            Text(
                              'Outstanding Balance : ${Provider.of<CustomerViewInvestor>(context, listen: false).option == CustomerFilterOptions.all ? Provider.of<CustomerViewInvestor>(context).allCustomers[index].outstandingBalance : Provider.of<CustomerViewInvestor>(context).thisMonthCustomers[index].outstandingBalance} PKR',
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

const TextStyle kBoldText = TextStyle(fontWeight: FontWeight.bold);
