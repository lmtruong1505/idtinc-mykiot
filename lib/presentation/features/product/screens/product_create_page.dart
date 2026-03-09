import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product/cubit/product_create_cubit/product_create_cubit.dart';
import 'package:pharmago/presentation/features/product/cubit/product_create_cubit/product_create_state.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_detail_entity.dart';
import 'package:pharmago/presentation/features/product/widgets/product_create/ingredient_form_view.dart';

import '../../../constants/typography.dart';
import '../../../router/router.gr.dart';
import '../widgets/product_create/info_basic_view.dart';
import '../widgets/product_create/info_extra_form_view.dart';
import '../widgets/product_create/prod_picture_view.dart';
import '../widgets/product_create/ware_house_info.dart';

@RoutePage()
// ignore: must_be_immutable
class ProductCreatePage extends StatefulWidget {
   ProductCreatePage({super.key, this.prod, this.id});

   ProductDetailEntity? prod;
   int? id;

  @override
  State<ProductCreatePage> createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage>
    with SingleTickerProviderStateMixin {
  final myBloc = getIt.get<ProductCreateCubit>();
  final _formKeyBasicInfo = GlobalKey<FormState>();

  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductCreateCubit>(
      create: (context) => myBloc..init(widget.prod),
      child: BlocBuilder<ProductCreateCubit, ProductCreateState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: bg_5,
              appBar: AppBar(
                title: Text(
                  widget.prod == null ? 'Tạo mới sản phẩm' : 'Chỉnh sửa sản phẩm',
                  style: h4.copyWith(fontWeight: BOLD, color: blackColor),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: blackColor,),
                  onPressed: () {
                    AutoRouter.of(context).pop();
                  },
                ),
                backgroundColor: whiteColor,
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: blackColor,
                  indicatorColor: green_3,
                  labelStyle: p5.copyWith(
                    color: greyColor,
                  ),
                  tabAlignment: TabAlignment.center,
                  tabs: const [
                    Tab(text: 'Thông tin cơ bản'),
                    Tab(text: 'Ảnh sản phẩm'),
                    Tab(text: 'Thông tin kho'),
                    Tab(text: 'Thông tin thành phần'),
                    Tab(text: 'Thông tin bổ sung'),
                  ],
                ),
              ),
              body: Form(
                key: _formKeyBasicInfo,
                onChanged: () {
                  _formKeyBasicInfo.currentState?.validate();
                },
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    InfoBasicView(
                      myBloc: myBloc,
                      //formKey: _formKeyBasicInfo,
                    ),
                    ProdPictureView(
                      myBloc: myBloc,
                    ),
                    WarehouseInfo(
                      myBloc: myBloc,
                    ),
                    IngredientFormView(
                      myBloc: myBloc,
                    ),
                    InfoExtraFormView(
                      myBloc: myBloc,
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.1),
                      offset: const Offset(0, -1),
                      blurRadius: sp4,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(sp16),
                width: double.infinity,
                child: MainButton(
                  title: 'Xác nhận',
                  event: () {
                    print('===> id: ${widget.id}');
                    if (widget.id == null) {
                      _createProductHandle();
                    } else {
                      _update();
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _createProductHandle() {
    final validate = (_formKeyBasicInfo.currentState?.validate() ?? false);
    if (!validate) {
      return;
    }
    DialogUtils.showLoadingDialog(context, 'Đang tạo sản phẩm vui lòng đợi!');
    myBloc.createProduct().then((value) {
      Navigator.of(context).pop();
      if (value.code == 200) {
        DialogUtils.showSuccessDialog(
          context,
          content: 'Tạo sản phẩm thành công',
          titleClose: 'Danh sách sản phẩm',
          titleConfirm: 'Chi tiết',
          close: () {
            context.router.popUntil((route) =>
                route.settings.name == 'HomeRoute',);
            context.router.push(const ProductListRoute());
          },
          accept: () {
            context.router.popUntil((route) =>
            route.settings.name == 'ProductListRoute' ||
                route.settings.name == 'HomeRoute',);
            context.router.push(ProductDetailRoute(id: value.data));
          },

        );
        return;
      }
      DialogUtils.showErrorDialog(
        context,
        content: 'Tạo sản phẩm thất bại \n ${value.message}',
      );
    });
  }

  void _update() {
    final validate = (_formKeyBasicInfo.currentState?.validate() ?? false);
    if (!validate) {
      return;
    }
    DialogUtils.showLoadingDialog(context, 'Đang cập nhật sản phẩm vui lòng đợi!');
    myBloc.updateProduct(widget.id!).then((value) {
      Navigator.of(context).pop();
      if (value.code == 200) {
        DialogUtils.showSuccessDialog(
          context,
          content: 'Cập nhật sản phẩm thành công',
          titleClose: 'Danh sách sản phẩm',
          titleConfirm: 'Chi tiết',
          close: () {
            context.router.popUntil((route) =>
            route.settings.name == 'ProductListRoute' ||
                route.settings.name == 'HomeRoute',);
          },
          accept: () {
            context.router.popUntil((route) =>
            route.settings.name == 'ProductListRoute' ||
                route.settings.name == 'HomeRoute',);
            context.router.push(ProductDetailRoute(id: value.data));
          },

        );
        return;
      }
      DialogUtils.showErrorDialog(
        context,
        content: 'Cập nhật sản phẩm thất bại \n ${value.message}',
      );
    });
  }
}
