import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationDataForm extends StatefulWidget {
  @override
  _LocationDataFormState createState() => _LocationDataFormState();
}

class _LocationDataFormState extends State<LocationDataForm> {
  String _countryControll;
  String _city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Data'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      hintText: _countryControll != null
                          ? _countryControll
                          : 'Country'),
                  onTap: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (ctx) => CupertinoActionSheet(
                        title: Text('Countries'),
                        message: Text('Select One Counrty'),
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            setState(() {
                              _countryControll = null;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            onPressed: () {
                              setState(() {
                                _countryControll = 'Saudi Arabia';
                              });

                              Navigator.of(context).pop();
                            },
                            child: Text('Saudi Arabia'),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              setState(() {
                                _countryControll = 'Kewait';
                              });

                              Navigator.of(context).pop();
                            },
                            child: Text('Kewait'),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              setState(() {
                                _countryControll = 'United Arab Emiraties';
                              });

                              Navigator.of(context).pop();
                            },
                            child: Text('United Arab Emiraties'),
                          ),
                        ],
                      ),
                    );
                  },
                  readOnly: true,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  readOnly: true,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0))),
                        builder: (context) {
                          return Container(
                            height: 200.0,
                            child: Center(
                              child: ListView(
                                children: <Widget>[
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        _city = 'Riyadh';
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    title: Text('Riyadh'),
                                    leading: Icon(Icons.mail_outline),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        Navigator.of(context).pop();
                                        _city = 'Madinah';
                                      });
                                    },
                                    title: Text('Madinah'),
                                    leading: Icon(Icons.mail_outline),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        _city = 'Makkah';
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    title: Text('Makkah'),
                                    leading: Icon(Icons.mail_outline),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        _city = 'Jaddah';
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    title: Text('Jaddah'),
                                    leading: Icon(Icons.mail_outline),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  decoration: InputDecoration(
                      fillColor: Theme.of(context).primaryColor,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                      ),
                      hintText: _city != null ? _city : 'City'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
