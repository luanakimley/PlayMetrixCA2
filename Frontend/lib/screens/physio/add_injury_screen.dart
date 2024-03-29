import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/edit_player_profile_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> addInjury({
  required int playerId,
  required String injuryType,
  required String injuryLocation,
  required String expectedRecoveryTime,
  required String recoveryMethod,
  required DateTime dateOfInjury,
  required DateTime dateOfRecovery,
}) async {
  const apiUrl =
      '$apiBaseUrl/injuries/'; // Replace with your actual backend URL

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'injury_type': injuryType,
        'injury_location': injuryLocation,
        'expected_recovery_time': expectedRecoveryTime,
        'recovery_method': recoveryMethod,
      }),
    );

    print('Response: ${response.body}');
    if (response.statusCode == 200) {
      const playerInjuriesApiUrl = "$apiBaseUrl/player_injuries/";

      final playerInjuriesResponse = await http.post(
        Uri.parse(playerInjuriesApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'player_id': playerId,
          'injury_id': jsonDecode(response.body)['id'],
          'date_of_injury': dateOfInjury.toIso8601String(),
          'date_of_recovery': dateOfRecovery.toIso8601String(),
        }),
      );

      print('Response: ${playerInjuriesResponse.body}');
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

class AddInjuryScreen extends StatefulWidget {
  final int playerId;
  final UserRole userRole;
  final int teamId;
  const AddInjuryScreen(
      {super.key,
      required this.playerId,
      required this.userRole,
      required this.teamId});

  @override
  AddInjuryScreenState createState() => AddInjuryScreenState();
}

class AddInjuryScreenState extends State<AddInjuryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController injuryTypeController = TextEditingController();
  final TextEditingController injuryLocationController =
      TextEditingController();
  final TextEditingController expectedRecoveryTimeController =
      TextEditingController();
  final TextEditingController recoveryMethodController =
      TextEditingController();

  String playerName = "";
  Uint8List playerImage = Uint8List(0);

  DateTime selectedDateOfInjury = DateTime.now();
  DateTime selectedDateOfRecovery = DateTime.now();

  @override
  void initState() {
    super.initState();

    getPlayerById(widget.playerId).then((player) {
      setState(() {
        playerName = "${player.player_firstname} ${player.player_surname}";
        playerImage = player.player_image;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Player Profile"),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(35),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Add Injury',
                          style: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: AppFonts.gabarito,
                            fontSize: 36.0,
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 10),
                      divider(),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Column(children: [
                                playerImage.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(75),
                                        child: Image.memory(
                                          playerImage,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.asset(
                                        "lib/assets/icons/profile_placeholder.png",
                                        width: 120,
                                      ),
                                const SizedBox(height: 15),
                                Text(playerName,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: AppFonts.gabarito,
                                        fontWeight: FontWeight.bold)),
                              ])),
                              const SizedBox(height: 5),
                              formFieldBottomBorderController(
                                  "Injury type", injuryTypeController, (value) {
                                return (value != null && value.isEmpty)
                                    ? 'This field is required.'
                                    : null;
                              }),
                              const SizedBox(height: 5),
                              formFieldBottomBorderController(
                                  "Injury location", injuryLocationController,
                                  (value) {
                                return (value != null && value.isEmpty)
                                    ? 'This field is required.'
                                    : null;
                              }),
                              const SizedBox(height: 5),
                              formFieldBottomBorderController(
                                  "Expected recovery time",
                                  expectedRecoveryTimeController, (value) {
                                return (value != null && value.isEmpty)
                                    ? 'This field is required.'
                                    : null;
                              }),
                              const SizedBox(height: 5),
                              formFieldBottomBorderController(
                                  "Recovery method", recoveryMethodController,
                                  (value) {
                                return (value != null && value.isEmpty)
                                    ? 'This field is required.'
                                    : null;
                              }),
                              const SizedBox(height: 7),
                              datePickerNoDivider(context, "Date of injury",
                                  selectedDateOfInjury, (date) {
                                setState(() {
                                  selectedDateOfInjury = date;
                                });
                              }),
                              const SizedBox(height: 5),
                              datePickerNoDivider(context, "Date of recovery",
                                  selectedDateOfRecovery, (date) {
                                setState(() {
                                  selectedDateOfRecovery = date;
                                });
                              }),
                              const SizedBox(height: 25),
                              bigButton("Add Injury", () {
                                if (_formKey.currentState!.validate()) {
                                  addInjury(
                                      playerId: widget.playerId,
                                      injuryType: injuryTypeController.text,
                                      injuryLocation:
                                          injuryLocationController.text,
                                      expectedRecoveryTime:
                                          expectedRecoveryTimeController.text,
                                      recoveryMethod:
                                          recoveryMethodController.text,
                                      dateOfInjury: selectedDateOfInjury,
                                      dateOfRecovery: selectedDateOfRecovery);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditPlayerProfileScreen(
                                                  playerId: widget.playerId,
                                                  userRole: widget.userRole,
                                                  teamId: widget.teamId)));
                                }
                              })
                            ]),
                      )
                    ]))),
        bottomNavigationBar: physioBottomNavBar(context, 1));
  }
}
