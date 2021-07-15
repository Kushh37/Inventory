import 'dart:io';
import 'package:inventory/AllScreens.dart';

class EditProductScreen extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productQty;
  final String productImageUrl;
  final String docId;
  const EditProductScreen(
      {Key? key,
      required this.docId,
      required this.productName,
      required this.productPrice,
      required this.productQty,
      required this.productImageUrl})
      : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool isLoading = false;
  bool _isDeleting = false;
  File? selectedFile;

  List<Product> products = [];

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _productName = TextEditingController();
  TextEditingController _productPrice = TextEditingController();
  TextEditingController _productQty = TextEditingController();

  @override
  void initState() {
    _productName = TextEditingController(text: widget.productName);
    _productPrice = TextEditingController(text: widget.productPrice);
    _productQty = TextEditingController(text: widget.productQty);
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              "Edit Product",
              style: GoogleFonts.aBeeZee(),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false);
                },
                icon: Icon(Icons.arrow_back)),
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
                            child: widget.productImageUrl != null
                                ? Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.25),
                                    height: width * 0.3,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade300,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                widget.productImageUrl))),
                                    child: null,
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    //width: width * 0.1,
                                    height: width * 0.3,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade300),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Picture Not Found",
                                          style: GoogleFonts.raleway(
                                              fontSize: width * 0.04,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Icon(
                                          Icons.camera_alt,
                                          size: width * 0.05,
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                          SizedBox(height: width * 0.1),
                          TFormfield(
                            width: width,
                            label: "Product Name",
                            controller: _productName,
                            textInputType: TextInputType.name,
                            suffixText: '',
                          ),
                          SizedBox(height: width * 0.03),
                          TFormfield(
                            width: width,
                            label: "Product Price",
                            controller: _productPrice,
                            textInputType: TextInputType.number,
                            suffixText: '',
                          ),
                          SizedBox(height: width * 0.03),
                          TFormfield(
                            width: width,
                            label: "Product Qty",
                            controller: _productQty,
                            textInputType: TextInputType.number,
                            suffixText: 'KG',
                          ),
                          SizedBox(height: width * 0.2),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  width: width * 0.3,
                                  height: width * 0.1,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.05),
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.deepOrangeAccent)),
                                      onPressed: () async {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        if (_formKey.currentState!.validate()) {
                                          updateProduct(docId: widget.docId);
                                          Future.delayed(Duration(seconds: 2),
                                              () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomeScreen()),
                                                    (route) => false);
                                          });
                                        }
                                      },
                                      child: isLoading == false
                                          ? Text(
                                              'Update',
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
                              ),
                              Expanded(
                                child: Container(
                                  width: width * 0.3,
                                  height: width * 0.1,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.05),
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.deepOrangeAccent)),
                                      onPressed: () async {
                                        setState(() {
                                          _isDeleting = true;
                                        });
                                        deleteProduct(docId: widget.docId);

                                        Future.delayed(Duration(seconds: 2),
                                            () {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomeScreen()),
                                                  (route) => false);
                                        });
                                      },
                                      child: _isDeleting == false
                                          ? Text(
                                              'Delete',
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
                              ),
                            ],
                          ),
                        ],
                      ))
                ],
              ),
            ),
          )),
    );
  }

  Future<void> deleteProduct({
    required String docId,
  }) async {
    final CollectionReference _mainCollection =
        FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userdoc = user!.uid;
    DocumentReference documentReferencer =
        _mainCollection.doc(userdoc).collection('products').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product Deleted Successfully.'))))
        .catchError((e) => print(e));
  }

  Future<void> updateProduct({
    required String docId,
  }) async {
    final CollectionReference _mainCollection =
        FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userdoc = user!.uid;
    DocumentReference documentReferencer =
        _mainCollection.doc(userdoc).collection('products').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "productName": _productName.text,
      "productPrice": _productPrice.text,
      "productQty": _productQty.text,
      // "productImageUrl": w
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product Updated Successfully.'))))
        .catchError((e) => print(e));
  }

  // void _selectImage(BuildContext context) async {
  //   final pickedFile = await ImageHelper.pickImageFromGallery(
  //       context: context,
  //       cropStyle: CropStyle.rectangle,
  //       title: 'Product Image');
  //   if (pickedFile != null) {
  //     setState(() {
  //       selectedFile = pickedFile;
  //       // productImageUrl = productImageUrl;
  //     });
  //   }
  // }
}

class TFormfield extends StatelessWidget {
  const TFormfield(
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
              fontSize: width * 0.04, fontWeight: FontWeight.bold)),
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
