
import 'package:catch_it_project/Presentation/more/provider/account_provider.dart';
import 'package:catch_it_project/core/models/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AccountBody extends StatelessWidget {
  AccountBody({this.account, super.key});
 final String email = FirebaseAuth.instance.currentUser!.email.toString();
  Account? account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("account")
              .snapshots(),
          builder: (context, snapshot) {
            DocumentSnapshot? accountSnapshot;
            Account? account;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData && snapshot.data?.docs.length != 0) {
              accountSnapshot = snapshot.data!.docs.first;
              // account = account?.fromfirestore(snapshot.data!);
               account = Account.fromFirestore(accountSnapshot);
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: 60,
                      backgroundImage: account == null
                          ? const AssetImage('assets/WallpaperDog-17025259.jpg')
                          : NetworkImage(
                              account.imageUrl,
                            ) as ImageProvider),
                  const SizedBox(height: 20),
                  Text(
                    account?.name == null ? "Your name" : account!.name, 
                    
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the profile editing screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                                  account: account,
                                )),
                      );
                    },
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  Account? account;
  EditProfileScreen({this.account, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    nameController.text = widget.account?.name ?? "";
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final tpro = Provider.of<AccountPro>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 60,
                backgroundImage:
                    //  newProfilePictureUrl.isNotEmpty
                    //     ? NetworkImage(newProfilePictureUrl)
                    // :
                    tpro.img != null
                        ? FileImage(tpro.img)
                        // Image.file(pickedImage) as ImageProvider
                        : widget.account?.imageUrl != null
                            ? NetworkImage(widget.account!.imageUrl)
                            : const AssetImage(
                                    "assets/WallpaperDog-17025259.jpg")
                                as ImageProvider
                // Add a default image asset
                ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                tpro.pickImage();
              },
              child: const Text('Change Profile Picture'),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: nameController,
                // onChanged: (value) {
                // newName = value;
                // },
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 30),
            Consumer<AccountPro>(
              builder: (context, value, child) => ElevatedButton(
                onPressed: () async {
                  // Update the account information with the new values
                  // if (tpro.img != null) {}

                  final Account accountDetails = Account(
                      imageUrl: tpro.img != null
                          ? tpro.pickedImageUrl
                          : widget.account!.imageUrl,
                      name: nameController.text);
                  await value.addOrUpdateAccountDetails(accountDetails);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context); // Navigate back to the account screen
                },
                child: value.loading == false
                    ? const Text('Save Changes')
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
