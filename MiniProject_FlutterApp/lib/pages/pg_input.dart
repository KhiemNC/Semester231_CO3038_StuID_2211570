import 'package:db_iot_flutter/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();

  String _selectedCondition = 'temperature';
  String _selectedComparison = '>';
  String _selectedAction = 'turn on';
  String _selectedDevice = 'fan';
  String _inputValue = '';

  List<String> rules = [];

  Future<void> _saveRules() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('rules', rules);
  }

  Future<void> _loadRules() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rules = prefs.getStringList('rules') ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRules();
  }

  void _addRule() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          rules.add('When $_selectedCondition $_selectedComparison $_inputValue => $_selectedAction $_selectedDevice');
          _saveRules();
        });
      } else {
        print("Invalid input");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setting Control Rule',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Lato',
            color: AppColors.textBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: AppColors.backgroundColor,
        child: Column(
          children: [
            Expanded(
              flex: 25,
              child: Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                          flex: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              const Text(
                                'When',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Lato',
                                  color: AppColors.textBlack,
                                ),
                              ),
                              DropdownButton<String>(
                                value: _selectedCondition,
                                items: <String>['temperature', 'humidity', 'heatindex'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Lato',
                                      color: AppColors.textBlack,
                                    ),),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCondition = newValue!;
                                  });
                                },
                              ),
                              DropdownButton<String>(
                                value: _selectedComparison,
                                items: <String>['>', '<', '>=', '<=', '='].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Lato',
                                      color: AppColors.textBlack,
                                    ),),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedComparison = newValue!;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 80,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'value',
                                    hintStyle: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Lato',
                                      color: Colors.grey,
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Invalid';
                                    }
                                    final bool isNumeric = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$').hasMatch(value);
                                    if (isNumeric == false) {
                                      return 'Invalid';
                                    }
                                    return null;
                                  },
                                  onSaved: (String? value) {
                                    _inputValue = value!;
                                  },
                                ),
                              ),
                            ],
                          )
                      ),
                      Expanded(
                          flex: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              const Text(
                                'then',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Lato',
                                  color: AppColors.textBlack,
                                ),
                              ),
                              DropdownButton<String>(
                                value: _selectedAction,
                                items: <String>['turn on', 'turn off'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Lato',
                                      color: AppColors.textBlack,
                                    ),),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedAction = newValue!;
                                  });
                                },
                              ),
                              DropdownButton<String>(
                                value: _selectedDevice,
                                items: <String>['fan', 'curtains'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Lato',
                                      color: AppColors.textBlack,
                                    ),),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedDevice = newValue!;
                                  });
                                },
                              ),
                              ElevatedButton(
                                onPressed: _addRule,
                                child: const Text('Add Rule'),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(
              color: AppColors.textBlack,
              thickness: 0.8,
            ),
            Expanded(
              flex: 70,
              child: Container(
                  child: Column(
                      children: [
                        const Expanded(
                          flex: 10,
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  'RULES LIST',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                                Text(
                                  '(tap to remove rule)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    color: AppColors.textRed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 90,
                          child: ListView.builder(
                            itemCount: rules.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                    key: Key('rule_$index'),
                                    onTap: () {
                                      setState(() {
                                        rules.removeAt(index);
                                        _saveRules();
                                      });
                                    },
                                    title: Text(rules[index]),
                                  )
                              );
                            },
                          ),
                        ),
                      ]
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}