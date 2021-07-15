import 'dart:io';
import 'package:inventory/AllScreens.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  File? selectedFile;

  List<Product> products = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _productName = TextEditingController();
  TextEditingController _productPrice = TextEditingController();
  TextEditingController _productQty = TextEditingController();

  @override
  void dispose() {
    _productName = TextEditingController();
    _productPrice = TextEditingController();
    _productQty = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              "Add Product",
              style: GoogleFonts.aBeeZee(),
            ),
            centerTitle: true,
            backgroundColor: Colors.deepOrangeAccent,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: width * 0.1),
                          GestureDetector(
                            onTap: () {
                              _showSingleScreenChoiceDialog(
                                  context, width, height);
                            },
                            child: selectedFile != null
                                ? Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.25),
                                    height: width * 0.3,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.orangeAccent[300],
                                        // borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(selectedFile!,
                                                scale: 5))),
                                    child: null,
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    //width: width * 0.1,
                                    height: width * 0.3,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        //borderRadius: BorderRadius.circular(10),
                                        color: Colors.deepOrangeAccent
                                            .withOpacity(0.5)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Upload Picture",
                                          style: GoogleFonts.poppins(
                                              fontSize: width * 0.03,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: width * 0.05,
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                          SizedBox(height: width * 0.1),
                          KFormfield(
                            width: width,
                            label: "Product Name",
                            controller: _productName,
                            textInputType: TextInputType.name,
                            suffixText: '',
                          ),
                          SizedBox(height: width * 0.03),
                          KFormfield(
                            width: width,
                            label: "Product Price",
                            controller: _productPrice,
                            textInputType: TextInputType.number,
                            suffixText: '',
                          ),
                          SizedBox(height: width * 0.03),
                          KFormfield(
                            width: width,
                            label: "Product Qty",
                            controller: _productQty,
                            textInputType: TextInputType.number,
                            suffixText: 'KG',
                          ),
                          SizedBox(height: width * 0.15),
                          Container(
                            height: width * 0.1,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.3),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.deepOrangeAccent)),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (selectedFile == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor:
                                                  Colors.deepOrangeAccent,
                                              content:
                                                  Text('Please Upload Image')));
                                    } else {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      addItem();
                                    }
                                  }
                                },
                                child: isLoading == false
                                    ? Text(
                                        'Add',
                                        style: GoogleFonts.poppins(
                                            fontSize: width * 0.04,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          )),
    );
  }

  Future<void> addItem() async {
    final CollectionReference _mainCollection =
        FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userdoc = user!.uid;
    DocumentReference documentReferencer =
        _mainCollection.doc(userdoc).collection('products').doc();

    StorageProvider _storageProvider =
        StorageProvider(firebaseStorage: FirebaseStorage.instance);
    String productImageUrl =
        await _storageProvider.uploadProductImage(image: selectedFile);

    Map<String, dynamic> data = <String, dynamic>{
      "productName": _productName.text,
      "productPrice": _productPrice.text,
      "productQty": _productQty.text,
      "productImageUrl": productImageUrl
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.deepOrangeAccent,
            content: Text('Product Added Successfully.'))))
        .catchError((e) => print(e));

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }

  void _selectImageFromGallery(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
        context: context,
        cropStyle: CropStyle.rectangle,
        title: 'Product Image');
    if (pickedFile != null) {
      setState(() {
        selectedFile = pickedFile;
      });
    } else {}
  }

  void _selectImageFromCamera(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromCamera(
        context: context,
        cropStyle: CropStyle.rectangle,
        title: 'Product Image');
    if (pickedFile != null) {
      setState(() {
        selectedFile = pickedFile;
      });
    } else {}
  }

  _showSingleScreenChoiceDialog(BuildContext context, width, height) =>
      showDialog(
          context: context,
          builder: (context) {
            return Container(
              child: AlertDialog(
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                backgroundColor: Colors.white,
                content: Container(
                    height: height * 0.15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _selectImageFromCamera(context);
                            },
                            child: Container(
                              height: height,
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: width * 0.2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _selectImageFromGallery(context);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: height,
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                Icons.image,
                                color: Colors.white,
                                size: width * 0.2,
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            );
          });
}

class KFormfield extends StatelessWidget {
  const KFormfield(
      {Key? key,
      required this.textInputType,
      required this.label,
      required this.controller,
      required this.suffixText,
      required this.width})
      : super(key: key);
  final double width;
  final TextInputType textInputType;
  final String label;
  final TextEditingController controller;
  final String suffixText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      controller: controller,
      style: GoogleFonts.poppins(
          textStyle: GoogleFonts.poppins(
              color: Colors.blueGrey,
              fontSize: width * 0.04,
              fontWeight: FontWeight.bold)),
      decoration: InputDecoration(
        suffixText: suffixText,
        labelStyle: GoogleFonts.nunito(color: Colors.deepOrange),
        labelText: label,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueAccent)),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent)),
      ),
    );
  }
}
