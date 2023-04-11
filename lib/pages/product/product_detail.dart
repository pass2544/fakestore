import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/pages/camera/camera.dart';
import 'package:project/pages/model/all_product_model.dart';
import 'package:project/pages/service/fakestore_service.dart';
import 'package:readmore/readmore.dart';

class ProductDetailPage extends StatefulWidget {
  final int id;
  const ProductDetailPage({super.key, required this.id});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  FakeStoreService fakeStoreService = FakeStoreService();
  Product product = Product();

  File? pic;
  bool check = false;
  final Future<FirebaseApp> fireBase = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
    fetchData();
    allData();
  }

  fetchData() async {
    await fakeStoreService.oneProductService(widget.id).then((value) {
      setState(() {
        product = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: product.title == null
              ? Center(
                  child: Container(
                    height: 100.h,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(255, 237, 235, 235),
                      color: Colors.grey,
                      strokeWidth: 3,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      //รูป
                      Row(
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back))
                        ],
                      ),
                      Center(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(39, 0, 0, 0),
                                blurRadius: 5.0,
                                spreadRadius: 5.0,
                                offset: Offset(2.0, 2.0),
                              )
                            ],
                          ),
                          child: Image.network(
                            product.image!,
                            width: 250.w,
                            height: 250.h,
                          ),
                        ),
                      ),
                      //ชื่อ
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          "${product.title}",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      //ประเภท
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              "Category : ",
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            product.category!,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ],
                      ),
                      //รายละเอียด
                      SizedBox(
                        height: 10.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            "Description : ",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: ReadMoreText(product.description!,
                            style: TextStyle(fontSize: 16.sp),
                            trimLines: 2,
                            trimLength: 200,
                            colorClickableText: Colors.pink,
                            trimMode: TrimMode.Length,
                            trimCollapsedText: ' อ่านเพิ่มเติม',
                            trimExpandedText: ' อ่านน้อยลง',
                            moreStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                            lessStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.start),
                      ),
                      //ราคา
                      SizedBox(
                        height: 30.h,
                      ),
                      Row(children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            "Price : ",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "${product.price} USD",
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(
                          height: 50.h,
                        )
                      ]),
                      //ถ่ายรูป
                      // SizedBox(
                      //   height: 15.h,
                      // ),
                      // ElevatedButton.icon(
                      //   onPressed: () {
                      //     setState(() {
                      //       check = false;
                      //     });
                      //     Camera().getImage(ImageSource.camera).then((value) {
                      //       setState(() {
                      //         check = true;
                      //         pic = value;
                      //       });
                      //     });
                      //   },
                      //   icon: const Icon(Icons.camera_alt),
                      //   label: const Text("Camera"),
                      // ),
                      // check
                      //     ? Row(
                      //         children: [
                      //           pic != null && pic != ''
                      //               ? Text("มีไฟล์")
                      //               : Container(),
                      //           ElevatedButton.icon(
                      //             onPressed: () {
                      //               uploadPicInStorage();
                      //             },
                      //             icon: const Icon(Icons.send),
                      //             label: const Text("Camera"),
                      //             style: ElevatedButton.styleFrom(
                      //                 backgroundColor: Colors.green),
                      //           ),
                      //         ],
                      //       )
                      //     : Container()
                    ],
                  ),
                )),
    );
  }

  Future<void> allData() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference collectionReference =
        firebaseFirestore.collection('picture');
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots = response.docs;
      for (var snapshot in snapshots) {}
    });
  }

  Future<void> uploadPicInStorage() async {
    Random random = Random();
    int num = random.nextInt(100000);
    UploadTask? uploadTask;

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference reference = firebaseStorage.ref().child('picture/pic$num.jpg');
    setState(() {
      uploadTask = reference.putFile(pic!);
    });

    final urlPicture = await uploadTask!.whenComplete(() {});
    final urlDownload = await urlPicture.ref.getDownloadURL();
    print('url pic = $urlPicture');

    setState(() {
      uploadTask = null;
    });
  }
}
