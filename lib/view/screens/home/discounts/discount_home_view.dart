import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/product_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/discount_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:provider/provider.dart';

class DiscountHomeViewWidegt extends StatelessWidget {
  final ScrollController? scrollController;
  const DiscountHomeViewWidegt({Key? key, this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscountProvider>(
      builder: (context, discountProvider, child) {
        List<Product>? productList;
        if (discountProvider.discountMenuList == null) {
        } else {
          productList = discountProvider.discountMenuList;
        }

        if (productList == null) {
          return SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  width: 195,
                  child: const ProductWidgetWebShimmer(),
                );
              },
            ),
          );
        }
        if (productList.isEmpty) {
          return const SizedBox();
        }
        return SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                width: 195,
                child: ProductWidgetWeb(
                  product: productList![index],
                  fromPopularItem: true,
                  discountLabel: true,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
