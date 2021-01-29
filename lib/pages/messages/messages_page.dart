import 'package:admob_flutter/admob_flutter.dart';

import '../../components/custom_button.dart';
import '../../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';
import 'widgets/edit_widget.dart';
import 'widgets/info_widget.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with AutomaticKeepAliveClientMixin<MessagesPage> {
  bool _editing = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('edit_profile'.tr()),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                _editing = !_editing;
              });
            },
            icon: Icon(
              _editing ? Icons.close : Icons.edit,
              color: kColorBlue,
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          AdmobBanner(adUnitId: 'ca-app-pub-1156390496952979/1733346008', adSize: AdmobBannerSize.FULL_BANNER),

          Expanded(
            child: SingleChildScrollView(
              child: _editing ? EditWidget() : InfoWidget(),
            ),
          ),
          if (_editing)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: CustomButton(
                onPressed: () {},
                text: 'update_info'.tr(),
              ),
            )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
