// import 'package:club_app/paypal1/Payment.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
//
//
// class Transaction extends StatefulWidget {
//   @override
//   _TransactionState createState() => _TransactionState();
// }
//
// class _TransactionState extends State<Transaction> {
//   //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //         debugShowCheckedModeBanner: false,
// //         home: new Scaffold(
// //           backgroundColor: Colors.white,
// //           key: _scaffoldKey,
// //           appBar: new AppBar(
// //             centerTitle: true,
// //             backgroundColor: Colors.white,
// //             title: Text(
// //               'Paypal Payment',
// //               style: TextStyle(
// //                 fontSize: 18.0,
// //                 color: Colors.black,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //           body: Container(
// //               width: MediaQuery.of(context).size.width,
// //               child: Container(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: <Widget>[
// //                     Column(
// //                       children: [
// //                         Text(
// //                           "Items in your Cart",
// //                           style: TextStyle(
// //                               fontSize: 16, fontWeight: FontWeight.w600),
// //                         ),
// //                         ListTile(
// //                           title: Text(
// //                             "Product: iPhone 7",
// //                             style: TextStyle(
// //                                 fontSize: 14, fontWeight: FontWeight.w600),
// //                           ),
// //                           subtitle: Text(
// //                             "Quantity: 1",
// //                             style: TextStyle(
// //                                 fontSize: 14, fontWeight: FontWeight.w600),
// //                           ),
// //                           trailing: Text(
// //                             "\$200",
// //                             style: TextStyle(
// //                                 fontSize: 16, fontWeight: FontWeight.w600),
// //                           ),
// //                         )
// //                       ],
// //                     ),
// //                     TextButton(
// //                     //  color: Colors.red,
// //                       onPressed: () {
// //                         // make PayPal payment
// //
// //                         Navigator.of(context).push(
// //                           MaterialPageRoute(
// //                             builder: (BuildContext context) => Payment(
// //                               onFinish: (number) async {
// //                                 // payment done
// //                                 final snackBar = SnackBar(
// //                                   content: Text("Payment done Successfully"),
// //                                   duration: Duration(seconds: 5),
// //                                   action: SnackBarAction(
// //                                     label: 'Close',
// //                                     onPressed: () {
// //                                       // Some code to undo the change.
// //                                     },
// //                                   ),
// //                                 );
// //                                 // _scaffoldKey.currentState
// //                                 //     .showSnackBar(snackBar);
// //                                 print('order id: ' + number);
// //                                 print('ddasdas');
// //                               },
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                       child: Text(
// //                         'Pay with Paypal',
// //                         textAlign: TextAlign.center,
// //                         style: TextStyle(color: Colors.black),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               )),
// //         ));
// //   }
// // }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       key: _scaffoldKey,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         title: const Text(
//           'Paypal Payment',
//           style: TextStyle(
//             fontSize: 18.0,
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SizedBox(
//           width: MediaQuery
//               .of(context)
//               .size
//               .width,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Column(
//                 children: const [
//                   Text(
//                     "Items in your Cart",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                   ),
//                   ListTile(
//                     title: Text(
//                       "Product: One plus 10",
//                       style:
//                       TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//                     ),
//                     subtitle: Text(
//                       "Quantity: 1",
//                       style:
//                       TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//                     ),
//                     trailing: Text(
//                       "\$100",
//                       style:
//                       TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                     ),
//                   )
//                 ],
//               ),
//               ElevatedButton(
//
//                 //color: Colors.red,
//                 onPressed: () {
//                   // make PayPal payment
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (BuildContext context) =>
//                           Payment(
//                             onFinish: (number) async {
//                               // payment done
//                               final snackBar = SnackBar(
//                                 content: const Text(
//                                     "Payment done Successfully",style: TextStyle(color: Colors.cyan),),
//                                 duration: const Duration(seconds: 5),
//                                 action: SnackBarAction(
//                                   label: 'Close',textColor: Colors.cyan,
//                                   onPressed: () {
//                                     // Some code to undo the change.
//                                   },
//                                 ),
//                               );
//
//                                // _scaffoldKey.currentState.showSnackBar(snackBar);
//                             },
//                           ),
//                     ),
//                   );
//                 },
//                 child: const Text(
//                   'Pay with Paypal',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ],
//           )),
//     );
//   }
// }