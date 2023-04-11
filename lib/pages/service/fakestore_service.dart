import 'dart:developer';

import 'package:dio/dio.dart';

import '../model/all_product_model.dart';

class FakeStoreService {
  var _dio = Dio();
  Future<List<Product>> allProductService() async {
    var url = "https://fakestoreapi.com/products";

    final products = <Product>[];
    try {
      Response response = await _dio.get(
        url,
      );

      if (response.statusCode == 200) {
        log("ผ่าน");

        for (var product in response.data) {
          products.add(Product.fromJson(product));
        }
      }

      return products;
    } on DioError catch (e) {
      log("ไม่ผ่าน ${e.response?.data}");
      return products;
    }
  }

  Future<List<Product>> getCategoryList(String text) async {
    var url = "https://fakestoreapi.com/products/category/$text";

    final products = <Product>[];
    try {
      Response response = await _dio.get(
        url,
      );

      if (response.statusCode == 200) {
        log("ผ่าน");

        for (var product in response.data) {
          products.add(Product.fromJson(product));
        }
      }

      return products;
    } on DioError catch (e) {
      log("ไม่ผ่าน${e.response?.data}");
      return products;
    }
  }

  Future<Product> oneProductService(int id) async {
    var url = "https://fakestoreapi.com/products/$id";

    Product products = Product();
    try {
      Response response = await _dio.get(
        url,
      );

      if (response.statusCode == 200) {
        products = Product.fromJson(response.data);
        log("ผ่านสัส");
      }

      return products;
    } on DioError catch (e) {
      log("ไม่ผ่าน ${e.response?.data}");
      return products;
    }
  }
}
