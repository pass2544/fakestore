import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/pages/model/all_product_model.dart';
import 'package:project/pages/product/product_detail.dart';

import 'service/fakestore_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  FakeStoreService fakeStoreService = FakeStoreService();
  List<Product> product = [];
  List<Product> categoryList1 = [];
  List<Product> categoryList2 = [];
  List<Product> categoryList3 = [];
  List<Product> categoryList4 = [];

  late TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(vsync: this, length: 4, initialIndex: 0);
    super.initState();
    fetchData();
    category("electronics");
    category("jewelery");
    category("men's clothing");
    category("women's clothing");
  }

  fetchData() async {
    await fakeStoreService.allProductService().then((value) {
      setState(() {
        product = value;
      });
      log("length = ${product.length}");
    });
  }

  category(String text) async {
    await fakeStoreService.getCategoryList(text).then((value) {
      setState(() {
        if (text == "electronics") {
          categoryList1 = value;
        } else if (text == "jewelery") {
          categoryList2 = value;
        } else if (text == "men's clothing") {
          categoryList3 = value;
        } else if (text == "women's clothing") {
          categoryList4 = value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 70.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.sp),
                    bottomRight: Radius.circular(30.sp)),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 43, 125, 248),
                    Color.fromARGB(255, 85, 153, 255),
                  ],
                ),
              ),
              child: Text(
                "Fake Store",
                style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            TabBar(
              controller: tabController,
              labelColor: Colors.black,
              labelStyle:
                  TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              tabs: const [
                Tab(
                  text: "electronics",
                ),
                Tab(
                  text: "jewelery",
                ),
                Tab(
                  text: "men's clothing",
                ),
                Tab(
                  text: "women's clothing",
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: TabBarView(controller: tabController, children: [
                categoryListView(categoryList1),
                categoryListView(categoryList2),
                categoryListView(categoryList3),
                categoryListView(categoryList4),
              ]),
            ),
            BottomAppBar(
              child: Container(
                height: 45.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 43, 125, 248),
                    Color.fromARGB(255, 85, 153, 255),
                  ],
                )),
                child: IconTheme(
                  data: IconThemeData(
                      color: Theme.of(context).colorScheme.onPrimary),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        tooltip: 'Menu',
                        icon: const Icon(Icons.menu),
                        onPressed: () {},
                      ),
                      IconButton(
                        tooltip: 'Search',
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                      IconButton(
                        tooltip: 'Cart',
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {},
                      ),
                      IconButton(
                        tooltip: 'Profile',
                        icon: const Icon(Icons.person),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget categoryListView(List<Product> dataList) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                  id: dataList[index].id!,
                ),
              )),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.sp),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(39, 0, 0, 0),
                      blurRadius: 5.0,
                      spreadRadius: 5.0,
                      offset: Offset(2.0, 2.0),
                    )
                  ]),
              width: double.infinity,
              height: 310.h,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        dataList[index].image!,
                        width: 200.w,
                        height: 200.h,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${dataList[index].title}",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Price ${dataList[index].price} USD.",
                      maxLines: 2,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
