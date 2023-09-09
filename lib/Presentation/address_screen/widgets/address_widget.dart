import 'package:catch_it_project/Presentation/address_add_screen/address_add_screen.dart';
import 'package:catch_it_project/Presentation/address_screen/address_screen.dart';
import 'package:catch_it_project/core/models/address_model.dart';
import 'package:flutter/material.dart';
import '../../../constants/size_color_constants.dart';

InkWell addressWidget(
    {bool? selectedIndicator,
    String? addressId,
    bool? changeButton,
    bool? editButton,
    Function? makeAsDefault,
    required BuildContext context,
    required Address address}) {
  return InkWell(
    onTap: makeAsDefault != null
        ? () {
            makeAsDefault();
          }
        : null,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(4, 4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: addressModelRow(
                        fieldName: "Name", text: address.name.toString()),
                  ),
                  const Spacer(),
                  selectedIndicator == true
                      ? const Icon(
                          Icons.check_box,
                          color: Colors.green,
                        )
                      : const SizedBox(),
                  changeButton == true
                      ? TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddresScreen(),
                                ));
                          },
                          style: TextButton.styleFrom(
                              side: const BorderSide(color: tBlue)),
                          child: const Text(
                            "Change",
                            style: TextStyle(fontSize: 17),
                          ),
                        )
                      : const SizedBox(),
                  editButton == true
                      ? IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddAdressScreen(
                                          address: address,
                                          addressId: addressId,
                                        )));
                          },
                        )
                      : const SizedBox()
                ],
              ),
              tSizedBoxHeight10,
              addressModelRow(fieldName: "Address", text: address.address),
              tSizedBoxHeight10,
              addressModelRow(fieldName: "City", text: address.city),
              tSizedBoxHeight10,
              addressModelRow(fieldName: "State", text: address.state),
              tSizedBoxHeight10,
              addressModelRow(fieldName: "Postal Code", text: address.pin),
              tSizedBoxHeight10,
              addressModelRow(fieldName: "Phone number", text: address.phone),
              tSizedBoxHeight10,
            ],
          )),
    ),
  );
}

addressModelRow({required String fieldName, required String text}) {
  return Row(
    children: [
      Text(
        "$fieldName: ",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
      ),
    ],
  );
}
