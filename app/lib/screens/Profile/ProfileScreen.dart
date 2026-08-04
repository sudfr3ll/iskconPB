// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/constants/provider.dart';
import 'package:iskcon/models/stateModel.dart';
import 'package:iskcon/widgets/customShape.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  String? stateValue;
  String? cityValue;
  String? countryValue;
  String gender = '';
  String name = '';
  String emailAddress = '';
  String? selectedState;
  String? selectCities;
  DateTime dob = DateTime.now();
  List<States>? loadstate;
  void handleDateSelect() {
    print('object');
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
  }

  Future<void> getData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      textEditingController.text = _prefs.getString('phoneNumber').toString();
      print(textEditingController.text);
    });
  }

  Future datePicker() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      print(
          formattedDate); //formatted date output using intl package =>  2021-03-16
      setState(() {
        dateInput.text = formattedDate; //set output date to TextField value.
      });
    } else {}
  }

  @override
  void initState() {
    dateInput.text = "";
    getData();
    Provider.of<AppState>(context, listen: false).loadState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();
    final provider = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 46,
        automaticallyImplyLeading: false,
        title: Text(
          'My Account'.toUpperCase(),
          style: TextStyle(fontSize: 15),
        ),
        actions: [Image.asset('assets/images/logo2.png')],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: _size.height,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ClipPath(
                        clipper: Customshape(),
                        child: Container(
                          height: _size.height * 0.25,
                          decoration: BoxDecoration(color: Colors.amber
                              // image: DecorationImage(
                              //     image: NetworkImage(
                              //         "https://w0.peakpx.com/wallpaper/687/933/HD-wallpaper-iskcon-bengaluru-iskon-karnataka-temple-thumbnail.jpg"),
                              //     fit: BoxFit.cover),
                              ),
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                    ClipPath(
                      clipper: Customshape(),
                      child: Container(
                          height: _size.height * 0.25,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://w0.peakpx.com/wallpaper/687/933/HD-wallpaper-iskcon-bengaluru-iskon-karnataka-temple-thumbnail.jpg"),
                                fit: BoxFit.cover),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.amber, width: 2)),
                              color: Color.fromRGBO(112, 5, 195, .6),
                            ),
                          )),
                    ),
                    Positioned(
                      // left: _size.width * 0.319,
                      top: _size.height * 0.13,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://www.holidify.com/images/cmsuploads/compressed/RadhaGopal_20200510223342.jpg'),
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.height * 0.15,
                        // child: Image.network(
                        //   '',
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Form(
                    key: _formKey,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          FormField(
                            hintText: 'Enter your name',
                            label: 'Name',
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(height: 20),
                          FormField(
                            hintText: 'Enter your email',
                            label: 'Email Address',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 20),
                          FormField(
                            textEditingController: textEditingController,
                            hintText: 'Enter your phone number',
                            label: 'Phone Number',
                            keyboardType: TextInputType.number,
                          ),
                          // DropdownButton(items: items, onChanged:(value){})
                          // Container(
                          //   margin: EdgeInsets.only(top: 20),
                          //   child: CSCPicker(
                          //     countrySearchPlaceholder: "Country",
                          //     stateSearchPlaceholder: "State",
                          //     citySearchPlaceholder: "City",
                          //     showStates: true,
                          //     showCities: true,
                          //     dropdownDialogRadius: 10.0,
                          //     onCountryChanged: (value) {
                          //       setState(() {
                          //         countryValue = value.toString();
                          //         print('Hello');
                          //       });
                          //     },
                          //     onStateChanged: (value) {
                          //       setState(() {
                          //         stateValue = value!;
                          //       });
                          //     },
                          //     onCityChanged: (value) {
                          //       setState(() {
                          //         cityValue = value!;
                          //       });
                          //     },
                          //   ),
                          // ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('States',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 8),
                              provider.waiting == false
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.purple,
                                      ),
                                    )
                                  : Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black12)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: Center(
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                                isExpanded: true,
                                                // decoration: InputDecoration(
                                                //   filled: true,
                                                //   fillColor: Colors.white,
                                                //   border: OutlineInputBorder(),
                                                //   enabledBorder: OutlineInputBorder(
                                                //       borderSide: BorderSide(
                                                //     color: Colors.black12,
                                                //     width: 1.0,
                                                //   )),
                                                // ),
                                                value: selectedState,
                                                hint: Text('Select State'),
                                                items: provider.stateList!.map<
                                                    DropdownMenuItem<
                                                        String>>((value) {
                                                  return DropdownMenuItem(
                                                    value: value.iso2,
                                                    child:
                                                        Text('${value.name}'),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedState =
                                                        value.toString();
                                                    provider.loadCities(
                                                        selectedState!);
                                                    print(selectedState);
                                                    // provider.loadCities(selectCities!);
                                                  });
                                                  print(selectedState);
                                                }),
                                          ),
                                        ),
                                      ),
                                    ),
                              selectedState == null
                                  ? SizedBox(
                                      height: 0,
                                    )
                                  : SizedBox(height: 20),
                              selectedState == null
                                  ? SizedBox(
                                      height: 0,
                                    )
                                  : Text('City',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                              SizedBox(height: 8),
                              selectedState == null
                                  ? SizedBox(
                                      height: 0,
                                    )
                                  : provider.waiting1 == false
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.purple,
                                          ),
                                        )
                                      : Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black12)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Center(
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  // decoration: InputDecoration(
                                                  //   filled: true,
                                                  //   fillColor: Colors.white,
                                                  //   border: OutlineInputBorder(),
                                                  //   enabledBorder: OutlineInputBorder(
                                                  //       borderSide: BorderSide(
                                                  //     color: Colors.black12,
                                                  //     width: 1.0,
                                                  //   )),
                                                  // ),
                                                  value: selectCities,
                                                  hint: Text('Select city'),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectCities =
                                                          value.toString();
                                                    });
                                                  },
                                                  items: provider.citiesList!
                                                      .map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                        (value) =>
                                                            DropdownMenuItem(
                                                          value: value.name,
                                                          child: Text(
                                                              '${value.name}'),
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                              SizedBox(height: 20),
                              Text('Date of Birth',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 8),
                              SizedBox(
                                height: 40,
                                child: Center(
                                  child: TextField(
                                    readOnly: true,
                                    onTap: datePicker,
                                    controller: dateInput,
                                    cursorColor: Colors.purple,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8.0),
                                      hintText: 'Choose...',
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      suffixIcon: Icon(Icons.calendar_month),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.purple),
                                      ),
                                      focusColor: Colors.green,
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black12,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.black12,
                                        width: 1.0,
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          // FormField(
                          //   textEditingController: dateInput,
                          //   hintText: 'Enter your dob',
                          //   label: 'Date of Birth',
                          //   keyboardType: TextInputType.datetime,
                          //   handleDateSelect: datePicker(),
                          // ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: double.infinity,
                            child: Text(
                              "Gender",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                child: Row(children: [
                                  Radio(
                                    activeColor: Colors.purple,
                                    value: 'male',
                                    groupValue: gender,
                                    onChanged: (val) {
                                      setState(() {
                                        gender = val!;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Male',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ]),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Row(children: [
                                  Radio(
                                    activeColor: Colors.purple,
                                    overlayColor:
                                        WidgetStatePropertyAll(Colors.grey),
                                    value: 'female',
                                    groupValue: gender,
                                    onChanged: (val) {
                                      setState(() {
                                        gender = val!;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Female',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ]),
                              ),
                            ],
                          ),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: ElevatedButton.icon(
                                  style: TextButton.styleFrom(
                                      elevation: 2,
                                      // backgroundColor: Colors.amber,
                                      textStyle:
                                          TextStyle(color: Colors.black)),
                                  onPressed: () {
                                      // Navigator.push(
                                      //         context,
                                      //         CupertinoPageRoute(
                                      //             builder: (context) =>
                                      //               WebViews()));
                                    // showModalBottomSheet(
                                    //     backgroundColor: Colors.transparent,
                                    //     context: context,
                                    //     builder: (context) =>
                                    //         LogoutBottomSheet());
                                  },
                                  icon: Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    'LOGOUT',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: _size.height * 0.2,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final dynamic handleDateSelect;
  final TextEditingController? textEditingController;
  // final String controller;

  const FormField({
    super.key,
    //  this.controller,
    required this.label,
    required this.keyboardType,
    this.handleDateSelect,
    required this.hintText,
    this.textEditingController,
  });

  @override
  State<FormField> createState() => _FormFieldState();
}

class _FormFieldState extends State<FormField> {
  @override
  Widget build(BuildContext context) {
    dynamic validator(dynamic val) {
      if (val?.isEmpty == true) {
        return val;
      }
      return null;
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: widget.handleDateSelect,
            child: SizedBox(
              height: 40,
              child: Center(
                child: TextFormField(
                  controller: widget.textEditingController,
                  validator: (value) {
                    validator(value);
                    return null;
                  },
                  keyboardType: widget.keyboardType,
                  cursorColor: Colors.purple,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: widget.hintText,
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    suffixIcon: widget.keyboardType == TextInputType.datetime
                        ? Icon(Icons.calendar_month)
                        : null,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                    focusColor: Colors.green,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black12,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black12,
                      width: 1.0,
                    )),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
