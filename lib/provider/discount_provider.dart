import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/discount_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/discount_repo.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';

class DiscountProvider extends ChangeNotifier {
  final DiscountRepo? discountRepo;
  DiscountProvider({required this.discountRepo});
  int? _popularPageSize;
  bool _isLoading = false;
  List<Product>? _discountMenuList;

  List<Product>? get discountMenuList => _discountMenuList;
  int? get popularPageSize => _popularPageSize;
  bool get isLoading => _isLoading;

  int discountOffset = 1;
  List<String> _offsetList = [];
  Future<bool> getDiscountMenu(bool reload, String offset,
      {String type = 'all', bool isUpdate = false}) async {
    bool apiSuccess = false;
    if (reload || offset == '1') {
      discountOffset = 1;
      _offsetList = [];
    }
    if (isUpdate) {
      notifyListeners();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList = [];
      _offsetList.add(offset);
      ApiResponse apiResponse = await discountRepo!.getDiscountMenu(offset);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        apiSuccess = true;
        if (reload || offset == '1') {
          _discountMenuList = [];
        }
        print(apiResponse.response!.data);
        _discountMenuList!.addAll(
            DiscountModel.fromJson(apiResponse.response!.data).products!);
        _popularPageSize =
            ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        showCustomSnackBar(apiResponse.error.toString());
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
    return apiSuccess;
  }

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }
}
