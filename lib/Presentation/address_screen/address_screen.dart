import 'package:catch_it_project/Presentation/address_add_screen/address_add_screen.dart';
import 'package:catch_it_project/Presentation/address_add_screen/provider/address_provider.dart';
import 'package:catch_it_project/Presentation/address_screen/widgets/address_widget.dart';
import 'package:catch_it_project/constants/size_color_constants.dart';
import 'package:catch_it_project/core/models/address_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddresScreen extends StatelessWidget {
  const AddresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tSize = MediaQuery.of(context).size;
    final tpro = Provider.of<AddressPro>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back)),
                    SizedBox(width: tSize.width * 0.25),
                    const Text(
                      "Address",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    tSizedBoxWidth40,
                    TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddAdressScreen(),
                              ));
                        },
                        icon: const Icon(Icons.add),
                        label: const Text(
                          "Add new",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14),
                        ))
                  ],
                ),
                tSizedBoxHeight10,
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .collection("address")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          DocumentSnapshot addressdoc =
                              snapshot.data!.docs[index];
                          final selectedAddressId = addressdoc.id;
                          Address addressData =
                              Address.fromFirestore(addressdoc);

                          return addressWidget(
                              editButton: true,
                              address: addressData,
                              context: context,
                              selectedIndicator:
                                  addressData.isDefault == true ? true : false,
                              addressId: selectedAddressId,
                              makeAsDefault: () async {
                                await tpro.selectAsDefault(
                                    selectedAddressId: selectedAddressId);
                              });
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            thickness: 2,
                          );
                        },
                        itemCount: snapshot.data!.docs.length);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
