import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/src/features/menu/bloc/menu_bloc.dart';
import 'package:flutter_course/src/features/menu/model/product.dart';
import 'package:flutter_course/src/features/menu/view/widgets/cart_button.dart';
import 'package:flutter_course/src/features/menu/view/widgets/category_button.dart';
import 'package:flutter_course/src/features/menu/view/widgets/order_bottom_sheet.dart';

import 'widgets/coffeecard.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _scrollController = ScrollController();
  final menuBloc = MenuBloc();
  List<Product> cart = [];
  int _selectedIndex = 1;

  @override
  void initState() {
    menuBloc.add(const LoadCategoriesEvent());
    menuBloc.add(const LoadItemsEvent());
    _scrollController.addListener(() {});
    super.initState();
  }

  void scrollTo(int id) {
    setState(() {
      final targetContext = GlobalObjectKey(id).currentContext;
      if (targetContext != null && id != _selectedIndex) {
        Scrollable.ensureVisible(targetContext,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      }
    });
  }

  void selectCategory(index) {
    setState(() {
      if (index != _selectedIndex) {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
        bloc: menuBloc,
        builder: (context, state) {
          if (state is MenuSuccessState) {
            return Scaffold(
                floatingActionButton: FloatingActionButton.extended(
                    extendedPadding: const EdgeInsets.all(16.0),
                    label: CartButton(bloc: menuBloc),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return OrderBottomSheet(bloc: menuBloc, cart: cart);
                          });
                    }),
                body: CustomScrollView(
                    controller: ScrollController(),
                    slivers: <Widget>[
                      SliverAppBar(
                        pinned: true,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        flexibleSpace: SizedBox(
                          child: ListView.separated(
                            controller: ScrollController(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.categories!.length,
                            itemBuilder: (context, index) {
                              final category = state.categories![index];
                              return CategoryButton(
                                  text: category.slug,
                                  isActive: category.id == _selectedIndex,
                                  onPressed: () {
                                    scrollTo(category.id);
                                    selectCategory(category.id);
                                  });
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 8.0),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: ListView.builder(
                          controller: ScrollController(),
                          shrinkWrap: true,
                          itemCount: state.categories!.length,
                          itemBuilder: (context, index) {
                            if (state.items != null) {
                              final category = state.categories![index];
                              final coffee = state.items!
                                  .where((element) =>
                                      element.category.id == category.id)
                                  .toList();
                              if (coffee.isEmpty) return Container();
                              return CustomScrollView(
                                controller: ScrollController(),
                                  shrinkWrap: true,
                                  slivers: [
                                    SliverPadding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      sliver: SliverToBoxAdapter(
                                        key: GlobalObjectKey(category.id),
                                        child: Text(category.slug,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge),
                                      ),
                                    ),
                                    SliverPadding(
                                      padding: const EdgeInsets.all(16.0),
                                      sliver: SliverGrid(
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 320,
                                            mainAxisExtent: 216,
                                            mainAxisSpacing: 16.0,
                                            crossAxisSpacing: 16.0,
                                          ),
                                          delegate: SliverChildBuilderDelegate(
                                              (context, index) {
                                            return Coffeecard(
                                                bloc: menuBloc,
                                                coffee: coffee[index]);
                                          }, childCount: coffee.length)),
                                    ),
                                  ]);
                            }
                            return Container();
                          },
                        ),
                      )
                    ]));
          } else if (state is MenuFailureState) {
            return Scaffold(body: Center(child: Text(state.exception.toString())));
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}
