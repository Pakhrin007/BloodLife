import 'package:flutter/material.dart';

class Bloodrequest extends StatefulWidget {
  const Bloodrequest({super.key});

  @override
  State<Bloodrequest> createState() => _BloodrequestState();
}

class _BloodrequestState extends State<Bloodrequest> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          children: [
            Icon(Icons.close),
            Padding(
              padding: EdgeInsets.only(left: 89),
              child: Text("Blood Request"),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 10),
              child: SizedBox(
                height: 60,
                width: 368,
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior
                        .always, // Forces label to always float at top

                    label: const Text("Patient's Name"),
                    hintText: "Enter Patient's Name",
                    hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: SizedBox(
                height: 60,
                width: 368,
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    label: const Text("Location"),
                    hintText: 'Blood Banks/Hospital Location',
                    hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: SizedBox(
                height: 60,
                width: 368,
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    label: const Text("Contact Number"),
                    hintText: 'Enter Your Contact Number',
                    hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: SizedBox(
                height: 60,
                width: 368,
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    label: const Text("Blood Type"),
                    // hintText: 'Enter Patient Name',
                    hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: SizedBox(
                height: 60,
                width: 368,
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    label: const Text("Needed date"),
                    // hintText: 'Enter Patient Name',
                    suffixIcon: const Icon(Icons.calendar_month),
                    hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: SizedBox(
                height: 150,
                width: 368,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    alignLabelWithHint: true,
                    label: const Text("Additional Info (Optional)"),
                    hintText: 'Enter Additional Info',
                    hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: SizedBox(
                height: 60,
                width: 368,
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    label: const Text("Upload mediacal documnets"),
                    // hintText: 'Enter Patient Name',
                    suffixIcon: const Icon(Icons.file_copy),
                    hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 5),
              child: Container(
                // padding: EdgeInsets.all(10),
                height: 50,
                width: 400,
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // This will push checkbox to the right
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 25, top: 5),
                      child: Text(
                        "Urgent Need",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 5),
                      child: Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        activeColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 30, top: 20),
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(30)),
              child: const Center(
                child: Text(
                  "Submit Request",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
