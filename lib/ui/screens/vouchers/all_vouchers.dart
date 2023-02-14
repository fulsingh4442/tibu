import 'package:club_app/logic/bloc/vouchers_bloc.dart';
import 'package:club_app/logic/models/vouchers.dart';
import 'package:flutter/material.dart';

class AllVouchers extends StatefulWidget {
  @override
  _AllVouchersState createState() => _AllVouchersState();
}

class _AllVouchersState extends State<AllVouchers>
    with AutomaticKeepAliveClientMixin<AllVouchers> {
  VouchersBloc _vouchersBloc;
  List<Vouchers> allVoucherList;
  int pageCount = 1;
  bool allVouchersFetched = false;
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container();
  }

  @override
  bool get wantKeepAlive => true;
}
