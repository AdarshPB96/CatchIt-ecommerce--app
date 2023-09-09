import 'package:catch_it_project/Presentation/address_add_screen/provider/address_provider.dart';
import 'package:catch_it_project/constants/size_color_constants.dart';
import 'package:catch_it_project/core/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAdressScreen extends StatefulWidget {
 final Address? address;
 final String? addressId;
  const AddAdressScreen({this.address, this.addressId, super.key});

  @override
  State<AddAdressScreen> createState() => _AddAdressScreenState();
}

class _AddAdressScreenState extends State<AddAdressScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  TextEditingController pinController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    if (widget.address != null) {
      nameController.text = widget.address!.name.toString();
      addressController.text = widget.address!.address.toString();
      cityController.text = widget.address!.city.toString();
      stateController.text = widget.address!.state.toString();
      pinController.text = widget.address!.pin.toString();
      phoneController.text = widget.address!.phone.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tSize = MediaQuery.of(context).size;
    final tPro = Provider.of<AddressPro>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              tSizedBoxHeight30,
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  SizedBox(
                    width: tSize.width * 0.2,
                  ),
                  const Text(
                    "Add address",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              tSizedBoxHeight30,
              addressNameTextfieldRow(
                name: "Name",
                hintText: "Enter your name",
                controller: nameController,
                tSize: tSize,
              ),
              tSizedBoxHeight10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Address",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  tSizedBoxWidth10,
                  SizedBox(
                    width: tSize.width * 0.7,
                    child: TextField(
                      controller: addressController,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            style: BorderStyle.solid,
                          )),
                          hintText: "Enter address"),
                      maxLines: 3,
                    ),
                  )
                ],
              ),
              tSizedBoxHeight10,
              addressNameTextfieldRow(
                  name: "City",
                  hintText: "Enter Your city",
                  controller: cityController,
                  tSize: tSize),
              tSizedBoxHeight10,
              addressNameTextfieldRow(
                  name: "State",
                  hintText: "Your state",
                  controller: stateController,
                  tSize: tSize),
              tSizedBoxHeight10,
              addressNameTextfieldRow(
                  name: "Pin code",
                  hintText: "Your pincode",
                  controller: pinController,
                  tSize: tSize,
                  numkeybord: true),
              tSizedBoxHeight10,
              addressNameTextfieldRow(
                  tSize: tSize,
                  hintText: "Phone number",
                  controller: phoneController,
                  name: "Phone",
                  numkeybord: true),
              tSizedBoxHeight30,
              Consumer<AddressPro>(
                builder: (context, value, child) {
                  return value.loading == false
                      ? ElevatedButton(
                          onPressed: () {
                            final Address newAddress = Address(
                                // isDefault: widget.address?.isDefault,
                                id: widget.address?.id,
                                name: nameController.text,
                                address: addressController.text,
                                city: cityController.text,
                                state: stateController.text,
                                pin: pinController.text,
                                phone: phoneController.text);
                            widget.address != null
                                ? tPro.updateAddress(
                                    newAddress, widget.addressId.toString())
                                : tPro.addAddress(newAddress, context);
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 35)),
                          child:
                              Text(widget.address != null ? "Update" : "Add"))
                      : const CircularProgressIndicator();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Column addressNameTextfieldRow(
      {required Size tSize,
      required String hintText,
      required String name,
      TextEditingController? controller,
      bool? numkeybord}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        tSizedBoxWidth10,
        SizedBox(
          width: tSize.width * 0.7,
          // height: tSize.height*,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(style: BorderStyle.solid)),
                hintText: hintText),
            keyboardType: numkeybord == true ? TextInputType.number : null,
          ),
        )
      ],
    );
  }
}
