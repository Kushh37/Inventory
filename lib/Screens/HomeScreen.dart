import 'dart:async';
import 'package:inventory/AllScreens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //

  static Stream<QuerySnapshot> readItems() {
    final CollectionReference _mainCollection =
        FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userdoc = user!.uid;

    CollectionReference notesItemCollection =
        _mainCollection.doc(userdoc).collection('products');
    return notesItemCollection.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inventory Management",
          style: GoogleFonts.aBeeZee(),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          IconButton(
              onPressed: () {
                AuthClass().signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: width * 0.02),
        child: StreamBuilder(
          stream: readItems(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            } else if (snapshot.hasData || snapshot.data != null) {
              return Container(
                // color: Colors.red,
                height: height,
                width: width,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: height * 0.01,
                  ),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    String docId = snapshot.data!.docs[index].id;

                    String productName =
                        snapshot.data!.docs[index]['productName'];
                    String productPrice =
                        snapshot.data!.docs[index]['productPrice'];
                    String productQty =
                        snapshot.data!.docs[index]['productQty'];
                    String productImageUrl =
                        snapshot.data!.docs[index]['productImageUrl'];
                    //var data = snapshot.data;
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                      ),
                      // height: height,
                      width: width,
                      child: GestureDetector(
                        onTap: () async {
                          await Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => EditProductScreen(
                                      docId: docId,
                                      productName: productName,
                                      productPrice: productPrice,
                                      productQty: productQty,
                                      productImageUrl: productImageUrl)),
                              (route) => false);
                        },
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          tileColor: Colors.deepOrange.withOpacity(0.2),
                          leading: Container(
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.symmetric(vertical: width * 0.01),
                            width: width * 0.2,
                            height: height * 0.2,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: NetworkImage(productImageUrl))),
                            child: null,
                          ),
                          title: Text(
                            productName,
                            style: GoogleFonts.poppins(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "₹$productPrice",
                            style: GoogleFonts.poppins(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: Container(
                            alignment: Alignment.center,
                            height: height * 0.1,
                            width: width * 0.2,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.rectangle),
                            child: Text(
                              "QTY:$productQty",
                              style: GoogleFonts.lato(
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrangeAccent,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddProductScreen()));
        },
        backgroundColor: Colors.deepOrangeAccent,
        child: Icon(Icons.add, size: width * 0.1),
      ),
    );
  }
}
