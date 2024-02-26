import 'package:flutter_restaurant/data/model/response/product_model.dart';

class DiscountModel {
  int? _totalSize;
  String? _limit;
  String? _offset;
  List<Product>? _products;

  DiscountModel(
      {int? totalSize,
      String? limit,
      String? offset,
      List<Product>? products}) {
    _totalSize = totalSize;
    _limit = limit;
    _offset = offset;
    _products = products;
  }

  int? get totalSize => _totalSize;
  String? get limit => _limit;
  String? get offset => _offset;
  List<Product>? get products => _products;

  DiscountModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'].toString();
    _offset = json['offset'].toString();
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach(
        (v) {
          if (!v.containsKey('products')) {
            _products!.add(Product.fromJson(v));
          }
        },
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = _totalSize;
    data['limit'] = _limit;
    data['offset'] = _offset;
    if (_products != null) {
      data['products'] = _products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
