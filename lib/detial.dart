import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
//  final Contact contact;
  final arguments;

  DetailPage({this.arguments});

  @override
  DetailPageState createState() => new DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title: Text(widget.arguments["contact"].displayName),
        actions: <Widget>[
          new IconButton(
              // action button
              icon: new Icon(Icons.delete_outline),
              onPressed: () {
                showAlertDialog(context);
              }),
          new IconButton(
            // action button
            icon: new Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.only(top: 10),
          children: <Widget>[
            _getCard(_getPhonesCard),
            widget.arguments["contact"].emails.isEmpty
                ? Container() //如果为空, 返回一个空Container,返回null会报错
                : _getCard(_getEmailsCard),
            widget.arguments["contact"].company == null
                ? Container()
                : _getCard(_getCompanyAndJobCard)
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("我再想想"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("确认"),
      onPressed: () {
        ContactsService.deleteContact(widget.arguments["contact"]);
        Navigator.pushNamedAndRemoveUntil(
            context, "/", (route) => route == null);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
//      title: Text("AlertDialog"),
      content: Text("要删除此联系人吗?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Card _getCard(Function func) {
    return Card(
      margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
      elevation: 8,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: func(),
      ),
    );
  }

  //生成电话卡片
  List<Widget> _getPhonesCard() {
    List<Widget> _list = new List<Widget>();
    for (int i = 0; i < widget.arguments["contact"].phones.length; i++) {
      _list.add(new ListTile(
        leading: Icon(Icons.call),
        title: Text(
          widget.arguments["contact"].phones.elementAt(i).value,
          style: TextStyle(fontSize: 17),
        ),
        subtitle: Text(widget.arguments["contact"].phones.elementAt(i).label),
        onTap: () {
          launch(
              "tel:${widget.arguments["contact"].phones.elementAt(i).value}");
        },
        dense: true,
        trailing: IconButton(
          icon: Icon(Icons.message),
          onPressed: () {
            launch(
                "sms:${widget.arguments["contact"].phones.elementAt(i).value}");
          },
        ),
      ));
      if (i < widget.arguments["contact"].phones.length - 1) {
        _list.add(Divider());
      }
      setState(() {});
    }
    return _list;
  }

  // 生成邮件卡片
  List<Widget> _getEmailsCard() {
    List<Widget> _list = new List<Widget>();
    if (widget.arguments["contact"].emails.isEmpty) {
      return [];
    }
    for (int i = 0; i < widget.arguments["contact"].emails.length; i++) {
      _list.add(new ListTile(
        leading: Icon(Icons.mail),
        title: Text(
          widget.arguments["contact"].emails.elementAt(i).value,
          style: TextStyle(fontSize: 17),
        ),
        subtitle: Text(widget.arguments["contact"].emails.elementAt(i).label),
        dense: true,
        onTap: () {
          launch(
              "mailto:${widget.arguments["contact"].emails.elementAt(i).value}");
        },
      ));
      if (i < widget.arguments["contact"].emails.length - 1) {
        _list.add(Divider());
      }
      setState(() {});
    }
    return _list;
  }

  //生成公司描述卡片
  List<Widget> _getCompanyAndJobCard() {
    List<Widget> _list = new List<Widget>();
    _list.add(ListTile(
      leading: Icon(Icons.business),
      title: Text(
        widget.arguments["contact"].company,
        style: TextStyle(fontSize: 17),
      ),
      subtitle: widget.arguments["contact"].jobTitle.isEmpty
          ? null
          : Text(widget.arguments["contact"].jobTitle),
    ));
    return _list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(DetailPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
