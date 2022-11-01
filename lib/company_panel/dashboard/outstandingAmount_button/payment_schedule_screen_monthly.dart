// ignore_for_file: camel_case_types

import 'package:ecommerce_bnql/company_panel/dashboard/outstandingAmount_button/payment_schedule_widget_monthly.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../customer/payment_schedule_class.dart';
import '../../view_model/viewmodel_customers.dart';
import '../../view_model/viewmodel_dashboard.dart';
import '../dashboard_screen.dart';

class PaymentScheduleScreenMonthlyOutstanding extends StatefulWidget {
  const PaymentScheduleScreenMonthlyOutstanding(
      {Key? key,
      required this.paymentList,
      required this.productIndex,
      required this.index})
      : super(key: key);

  final List<PaymentSchedule> paymentList;
  final int productIndex;
  final int index;

  @override
  State<PaymentScheduleScreenMonthlyOutstanding> createState() =>
      _PaymentScheduleScreenMonthlyOutstandingState();
}

class _PaymentScheduleScreenMonthlyOutstandingState
    extends State<PaymentScheduleScreenMonthlyOutstanding> {
  @override
  void initState() {
    if (Provider.of<DashboardView>(context, listen: false).option !=
        DashboardFilterOptions.all) {
      Provider.of<CustomerView>(context, listen: false)
          .getPaymentScheduleMonthlyOutstanding(
              index: widget.index, productIndex: widget.productIndex);
    } else {
      Provider.of<CustomerView>(context, listen: false)
          .getAllPaymentScheduleDashboardView(
              index: widget.index, productIndex: widget.productIndex);
    }
    super.initState();
  }

  late DateTime dateTime;
  late TimeOfDay time;
  final formKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payment Schedule',
              style: TextStyle(fontSize: 25),
            ),
            IconButton(
                onPressed: () {
                  dateTime = DateTime.now();
                  time = TimeOfDay.now();
                  final TextEditingController moneyController =
                      TextEditingController();
                  showModalBottomSheet<void>(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          decoration: const BoxDecoration(
                              color: Color(0xFF2D2C3F),
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Add Money',
                                  style: TextStyle(fontSize: 25),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      vertical: 4.0),
                                  child: InkWell(
                                    onTap: () async {
                                      DateTime? newDate =
                                      await showDatePicker(
                                        context: context,
                                        initialDate: dateTime,
                                        initialDatePickerMode:
                                        DatePickerMode.day,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      setState(() {
                                        dateTime = newDate!;
                                      });
                                    },
                                    child: Container(
                                      padding:
                                      const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              4),
                                          border: Border.all(
                                              color: const Color(
                                                  0xFF0E1223),
                                              width: 1)),
                                      child: Text(
                                        DateFormat.yMMMMEEEEd()
                                            .format(dateTime),
                                        style: const TextStyle(
                                            color:
                                            Color(0x59FFFFFF),
                                            fontSize: 20,
                                            fontWeight:
                                            FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      vertical: 4.0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      TimeOfDay? newTime =
                                      await showTimePicker(
                                          context: context,
                                          initialTime:
                                          TimeOfDay.now());
                                      setState(() {
                                        time = newTime!;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              4),
                                          border: Border.all(
                                              color: const Color(
                                                  0xFF0E1223),
                                              width: 1)),
                                      child: Text(
                                        DateFormat.jms().format(
                                            DateTime(
                                                dateTime.year,
                                                dateTime.month,
                                                dateTime.day,
                                                time.hour,
                                                time.minute)),
                                        style: const TextStyle(
                                            color:
                                            Color(0x59FFFFFF),
                                            fontSize: 20,
                                            fontWeight:
                                            FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        key: formKey,
                                        autofocus: true,
                                        controller: moneyController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: kDecoration.inputBox(
                                            'Amount', 'PKR'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'This field is required';
                                          } else if (int.parse(value) >
                                              Provider.of<CustomerView>(context,
                                                      listen: false)
                                                  .thisMonthCustomers[
                                                      widget.index]
                                                  .purchases[
                                                      widget.productIndex]
                                                  .outstandingBalance) {
                                            return 'Value greater than outstanding amount';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            if (Provider.of<CustomerView>(
                                                            context,
                                                            listen: false)
                                                        .thisMonthCustomers[
                                                            widget.index]
                                                        .purchases[
                                                            widget.productIndex]
                                                        .outstandingBalance -
                                                    int.parse(
                                                        moneyController.text) >
                                                500) {
                                              Provider.of<CustomerView>(context,
                                                      listen: false)
                                                  .thisMonthCustomers[
                                                      widget.index]
                                                  .purchases[
                                                      widget.productIndex]
                                                  .addTransaction(
                                                      amount: int.parse(
                                                          moneyController.text),
                                                      dateTime: DateTime(
                                                          dateTime.year,
                                                          dateTime.month,
                                                          dateTime.day,
                                                          time.hour,
                                                          time.minute));

                                              int index = 0;
                                              int length =
                                                  Provider.of<CustomerView>(
                                                          context,
                                                          listen: false)
                                                      .thisMonthCustomers[
                                                          widget.index]
                                                      .purchases[
                                                          widget.productIndex]
                                                      .paymentSchedule
                                                      .length;
                                              int newPayment = int.parse(
                                                  moneyController.text);

                                              updateLocalState(
                                                  context, newPayment);
                                              Provider.of<CustomerView>(context,
                                                      listen: false)
                                                  .thisMonthCustomers[
                                                      widget.index]
                                                  .purchases[
                                                      widget.productIndex]
                                                  .updateCustomTransaction(
                                                      amount: newPayment);

                                              moneyController.clear();

                                              for (PaymentSchedule payment
                                                  in Provider.of<CustomerView>(
                                                          context,
                                                          listen: false)
                                                      .thisMonthCustomers[
                                                          widget.index]
                                                      .purchases[
                                                          widget.productIndex]
                                                      .paymentSchedule) {
                                                if (!payment.isPaid) {
                                                  if (newPayment <=
                                                      payment.remainingAmount) {
                                                    payment.remainingAmount -=
                                                        newPayment;
                                                    payment.addTransaction(
                                                        amount: newPayment,
                                                        dateTime: DateTime(
                                                            dateTime.year,
                                                            dateTime.month,
                                                            dateTime.day,
                                                            time.hour,
                                                            time.minute));
                                                    if (payment
                                                            .remainingAmount ==
                                                        0) {
                                                      payment.isPaid = true;
                                                    }
                                                    payment.updateFirestore();
                                                    newPayment = 0;
                                                    break;
                                                  } else {
                                                    newPayment = newPayment -
                                                        payment.remainingAmount;
                                                    payment.addTransaction(
                                                        amount: payment
                                                            .remainingAmount,
                                                        dateTime: DateTime(
                                                            dateTime.year,
                                                            dateTime.month,
                                                            dateTime.day,
                                                            time.hour,
                                                            time.minute));
                                                    payment.remainingAmount = 0;
                                                    payment.isPaid = true;
                                                    payment.updateFirestore();

                                                    index++;
                                                    length--;

                                                    int roundedPayment =
                                                        newPayment ~/ length;

                                                    for (index;
                                                        index <
                                                            Provider.of<CustomerView>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .thisMonthCustomers[
                                                                    widget
                                                                        .index]
                                                                .purchases[widget
                                                                    .productIndex]
                                                                .paymentSchedule
                                                                .length;
                                                        index++) {
                                                      if (index !=
                                                          Provider.of<CustomerView>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .thisMonthCustomers[
                                                                      widget
                                                                          .index]
                                                                  .purchases[widget
                                                                      .productIndex]
                                                                  .paymentSchedule
                                                                  .length -
                                                              1) {
                                                        Provider.of<CustomerView>(
                                                                    context,
                                                                    listen: false)
                                                                .thisMonthCustomers[
                                                                    widget.index]
                                                                .purchases[widget
                                                                    .productIndex]
                                                                .paymentSchedule[
                                                                    index]
                                                                .remainingAmount -=
                                                            roundedPayment;
                                                        Provider.of<CustomerView>(
                                                                context,
                                                                listen: false)
                                                            .thisMonthCustomers[
                                                                widget.index]
                                                            .purchases[widget
                                                                .productIndex]
                                                            .paymentSchedule[
                                                                index]
                                                            .addTransaction(
                                                                amount:
                                                                    roundedPayment,
                                                                dateTime: DateTime(
                                                                    dateTime
                                                                        .year,
                                                                    dateTime
                                                                        .month,
                                                                    dateTime
                                                                        .day,
                                                                    time.hour,
                                                                    time.minute));
                                                        newPayment -=
                                                            roundedPayment;
                                                        Provider.of<CustomerView>(
                                                                context,
                                                                listen: false)
                                                            .thisMonthCustomers[
                                                                widget.index]
                                                            .purchases[widget
                                                                .productIndex]
                                                            .paymentSchedule[
                                                                index]
                                                            .updateFirestore();
                                                      } else {
                                                        Provider.of<CustomerView>(
                                                                context,
                                                                listen: false)
                                                            .thisMonthCustomers[
                                                                widget.index]
                                                            .purchases[widget
                                                                .productIndex]
                                                            .paymentSchedule[
                                                                index]
                                                            .remainingAmount -= newPayment;
                                                        Provider.of<CustomerView>(
                                                                context,
                                                                listen: false)
                                                            .thisMonthCustomers[
                                                                widget.index]
                                                            .purchases[widget
                                                                .productIndex]
                                                            .paymentSchedule[
                                                                index]
                                                            .addTransaction(
                                                                amount:
                                                                    newPayment,
                                                                dateTime: DateTime(
                                                                    dateTime
                                                                        .year,
                                                                    dateTime
                                                                        .month,
                                                                    dateTime
                                                                        .day,
                                                                    time.hour,
                                                                    time.minute));
                                                        newPayment = 0;
                                                        Provider.of<CustomerView>(
                                                                context,
                                                                listen: false)
                                                            .thisMonthCustomers[
                                                                widget.index]
                                                            .purchases[widget
                                                                .productIndex]
                                                            .paymentSchedule[
                                                                index]
                                                            .updateFirestore();
                                                      }
                                                    }
                                                  }
                                                } else {
                                                  index++;
                                                  length--;
                                                }
                                              }
                                              Navigator.pop(context);
                                              setState(() {});
                                            } else {
                                              if (moneyController
                                                  .text.isNotEmpty) {
                                                Provider.of<CustomerView>(
                                                        context,
                                                        listen: false)
                                                    .thisMonthCustomers[
                                                        widget.index]
                                                    .purchases[
                                                        widget.productIndex]
                                                    .addTransaction(
                                                        amount: int.parse(
                                                            moneyController
                                                                .text),
                                                        dateTime: DateTime(
                                                            dateTime.year,
                                                            dateTime.month,
                                                            dateTime.day,
                                                            time.hour,
                                                            time.minute));
                                                int newPayment = int.parse(
                                                    moneyController.text);
                                                moneyController.clear();
                                                updateLocalState(
                                                    context, newPayment);
                                                Provider.of<CustomerView>(
                                                        context,
                                                        listen: false)
                                                    .thisMonthCustomers[
                                                        widget.index]
                                                    .purchases[
                                                        widget.productIndex]
                                                    .updateCustomTransaction(
                                                        amount: newPayment);
                                                for (var payment in Provider.of<
                                                            CustomerView>(
                                                        context,
                                                        listen: false)
                                                    .thisMonthCustomers[
                                                        widget.index]
                                                    .purchases[
                                                        widget.productIndex]
                                                    .paymentSchedule) {
                                                  setState(() {
                                                    if (!payment.isPaid) {
                                                      if (newPayment >=
                                                          payment
                                                              .remainingAmount) {
                                                        payment.isPaid = true;
                                                        newPayment = newPayment -
                                                            payment
                                                                .remainingAmount;
                                                        payment.addTransaction(
                                                            amount: payment
                                                                .remainingAmount,
                                                            dateTime: DateTime(
                                                                dateTime.year,
                                                                dateTime.month,
                                                                dateTime.day,
                                                                time.hour,
                                                                time.minute));
                                                        payment.remainingAmount =
                                                            0;
                                                      } else {
                                                        payment.remainingAmount =
                                                            payment.remainingAmount -
                                                                newPayment;
                                                        payment.addTransaction(
                                                            amount: newPayment,
                                                            dateTime: DateTime(
                                                                dateTime.year,
                                                                dateTime.month,
                                                                dateTime.day,
                                                                time.hour,
                                                                time.minute));
                                                        newPayment = 0;
                                                      }
                                                    }
                                                  });

                                                  payment.updateFirestore();
                                                }
                                              }

                                              Navigator.pop(context);
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.navigate_next))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Product Name : ${Provider.of<CustomerView>(context).thisMonthCustomers[widget.index].purchases[widget.productIndex].productName}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
                'Vendor Name : ${Provider.of<CustomerView>(context).thisMonthCustomers[widget.index].purchases[widget.productIndex].vendorName}',
                style: const TextStyle(fontSize: 20)),
            Text(
                'Selling Amount : ${Provider.of<CustomerView>(context).thisMonthCustomers[widget.index].purchases[widget.productIndex].sellingAmount.toString()}',
                style: const TextStyle(fontSize: 20)),
            Text(
                'Purchase Amount : ${Provider.of<CustomerView>(context).thisMonthCustomers[widget.index].purchases[widget.productIndex].purchaseAmount.toString()}',
                style: const TextStyle(fontSize: 20)),
            Text(
                'Profit : ${Provider.of<CustomerView>(context).thisMonthCustomers[widget.index].purchases[widget.productIndex].sellingAmount - Provider.of<CustomerView>(context).thisMonthCustomers[widget.index].purchases[widget.productIndex].purchaseAmount}',
                style: const TextStyle(fontSize: 20)),
            // TextButton(
            //     style: ButtonStyle(
            //         backgroundColor: MaterialStateProperty.all(
            //       const Color(0xFF2D2C3F),
            //     )),
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => TransactionHistoryScreen(
            //                   productIndex: widget.productIndex,
            //                   index: widget.index)));
            //     },
            //     child: const Text('Transaction History')),
            Expanded(
              child: ListView.builder(
                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                itemCount: Provider.of<CustomerView>(context)
                    .thisMonthCustomers[widget.index]
                    .purchases[widget.productIndex]
                    .paymentSchedule
                    .length,
                itemBuilder: (BuildContext context, int paymentIndex) {
                  return PaymentScheduleWidgetMonthly(
                      index: widget.index,
                      productIndex: widget.productIndex,
                      paymentIndex: paymentIndex);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateLocalState(BuildContext context, int amount) {
    Provider.of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .purchases[widget.productIndex]
        .outstandingBalance -= amount;
    Provider.of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .purchases[widget.productIndex]
        .amountPaid += amount;
    Provider.of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .outstandingBalance -= amount;
    Provider.of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .paidAmount += amount;
  }
}

class kDecoration {
  static InputDecoration inputBox(String hintText, String suffix) {
    return InputDecoration(
      suffix: suffix.isNotEmpty ? Text(suffix) : null,
      filled: true,
      fillColor: const Color(0xFF2D2C3F),
      border: const OutlineInputBorder(),
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
    );
  }
}
