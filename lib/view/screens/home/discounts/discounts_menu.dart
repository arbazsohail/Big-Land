import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/discount_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/filter_button_widget.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:provider/provider.dart';

class DiscountsMenuScreen extends StatefulWidget {
  const DiscountsMenuScreen({Key? key}) : super(key: key);

  @override
  State<DiscountsMenuScreen> createState() => _DiscountsMenuScreenState();
}

class _DiscountsMenuScreenState extends State<DiscountsMenuScreen> {
  final ScrollController _scrollController = ScrollController();
  String _type = 'all';

  @override
  void initState() {
    Provider.of<DiscountProvider>(context, listen: false)
        .getDiscountMenu(true, '1');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final discountProvider =
        Provider.of<DiscountProvider>(context, listen: false);
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          (discountProvider.discountMenuList != null) &&
          !discountProvider.isLoading) {
        int pageSize;
        pageSize = (discountProvider.popularPageSize! / 10).ceil();
        if (discountProvider.discountOffset < pageSize) {
          discountProvider.discountOffset++;
          discountProvider.showBottomLoader();
          await discountProvider.getDiscountMenu(
              false, discountProvider.discountOffset.toString());
        }
      }
    });
    return Scaffold(
      appBar: CustomAppBar(
          context: context, title: getTranslated('discount', context)),
      body: Consumer<DiscountProvider>(builder: (context, discount, child) {
        return Column(
          children: [
            Expanded(
              child: discount.discountMenuList != null
                  ? discount.discountMenuList!.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: () async {
                            await Provider.of<DiscountProvider>(context,
                                    listen: false)
                                .getDiscountMenu(true, '1');
                          },
                          backgroundColor: Theme.of(context).primaryColor,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Center(
                              child: SizedBox(
                                width: 1170,
                                child: GridView.builder(
                                  gridDelegate: ResponsiveHelper.isDesktop(
                                          context)
                                      ? const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 195,
                                          mainAxisExtent: 250)
                                      : SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5,
                                          childAspectRatio: 3.5,
                                          crossAxisCount:
                                              ResponsiveHelper.isTab(context)
                                                  ? 2
                                                  : 1,
                                        ),
                                  itemCount: discount.discountMenuList!.length,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.paddingSizeExtraSmall),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ResponsiveHelper.isDesktop(context)
                                        ? Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: ProductWidgetWeb(
                                                product: discount
                                                    .discountMenuList![index]),
                                          )
                                        : ProductWidget(
                                            product: discount
                                                .discountMenuList![index]);
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      : const NoDataScreen()
                  : GridView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio:
                            ResponsiveHelper.isDesktop(context) ? 0.7 : 4,
                        crossAxisCount: ResponsiveHelper.isDesktop(context)
                            ? 6
                            : ResponsiveHelper.isTab(context)
                                ? 2
                                : 1,
                      ),
                      itemBuilder: (context, index) {
                        return ResponsiveHelper.isDesktop(context)
                            ? const ProductWidgetWebShimmer()
                            : ProductShimmer(
                                isEnabled: discount.discountMenuList == null,
                              );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
