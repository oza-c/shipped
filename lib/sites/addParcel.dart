import 'package:flutter/material.dart';
import 'package:shipped/assets/getTrackingInformation.dart';
import 'package:shipped/assets/parcel.dart';

class AddParcel extends StatefulWidget {
  const AddParcel({Key? key}) : super(key: key);

  @override
  State<AddParcel> createState() => _AddParcelState();
}

final _formKey = GlobalKey<FormState>();

class _AddParcelState extends State<AddParcel> {
  String dropdownValue = 'DHL';
  final TextEditingController _parcelIdController = TextEditingController();
  final TextEditingController _parcelValueController = TextEditingController();
  void validateAndSave() {
  final form = _formKey.currentState;
  if (form!.validate()) {
    getTrackingData(_parcelIdController.text).then((TrackingInfo result){
    Shipment parcel = Shipment(
              parcel_id: _parcelIdController.text	,
              parcelname: _parcelValueController.text,
              shippingprovider: dropdownValue, tracking: result); 
    Navigator.pop(
          context, parcel);
    });
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(196, 226, 133, 19),
        title: const Text("Add your Parcel"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(8, 20, 8, 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                autocorrect: false,
                controller: _parcelIdController,
                decoration: const InputDecoration(
                  labelText: 'Tracking id',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Fill the Field please";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 500,
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Carrier',
                    border: OutlineInputBorder(),
                  ),
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['DHL', 'DPD', 'UPS', 'Hermes']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: <Widget>[
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              child: Icon(Icons.mail, size: 40),
                            ),
                            Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20, 5, 0, 0),
                                child: Text(value,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)))
                          ],
                        ));
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.text,
                autocorrect: false,
                controller: _parcelValueController,
                decoration: const InputDecoration(
                  labelText: 'Package name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: const Color.fromARGB(196, 226, 133, 19)),
                  onPressed: () {
                    validateAndSave();
                  },
                  child: const Text("Add Parcel"))
            ],
          ),
        ),
      ),
    );
  }
}