import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/src/features/map/map_screen.dart';
import 'package:flutter_course/src/theme/image_sources.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_course/src/features/menu/bloc/menu_bloc.dart';
import 'package:flutter_course/src/features/menu/view/widgets/cart_button.dart';
import 'package:flutter_course/src/features/menu/view/widgets/category_button.dart';
import 'package:flutter_course/src/features/menu/view/widgets/order_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/coffeecard.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _scrollController = ScrollController();
  int _categoryIndex = 1;
  int _locationIndex = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {});
    _loadPreferences();
  }

  void _loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _locationIndex = prefs.getInt('location') ?? _locationIndex;
    });
  }

  void _scrollTo(int id) {
    setState(() {
      final targetContext = GlobalObjectKey(id).currentContext;
      if (targetContext != null && id != _categoryIndex) {
        Scrollable.ensureVisible(targetContext,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      }
    });
  }

  void _selectCategory(int index) {
    setState(() {
      if (index != _categoryIndex) {
        _categoryIndex = index;
      }
    });
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MenuBloc, MenuState>(listener: (context, state) {
      if (state.status == OrderStatus.success) {
        _showSnackBar(AppLocalizations.of(context)!.snackBarSuccessMsg);
      } else if (state.status == OrderStatus.failure) {
        _showSnackBar(AppLocalizations.of(context)!.snackBarFailureMsg);
      }
    }, builder: (context, state) {
      if (state is MenuLoadingLocationsState) {
        context.read<MenuBloc>().add(const LoadLocationsEvent());
      } else if (state is MenuLoadingCategoriesState) {
        context.read<MenuBloc>().add(const LoadCategoriesEvent());
      } else if (state is MenuLoadingProductsState) {
        context.read<MenuBloc>().add(const LoadItemsEvent());
      } else if (state is MenuSuccessState) {
        return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
                elevation: 0.0,
                extendedPadding: const EdgeInsets.all(16.0),
                label: const CartButton(),
                onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => const OrderBottomSheet())),
            body: CustomScrollView(
                controller: ScrollController(),
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    collapsedHeight: 112,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(children: [
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          leading: ImageSources.locationIcon,
                          title: Text(
                              state.locations![_locationIndex - 1].address,
                              style: Theme.of(context).textTheme.bodyMedium),
                          onTap: () async {
                            final int? idx = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const MapScreen()));
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setInt(
                                'location', idx ?? _locationIndex);
                            setState(() {
                              _locationIndex = prefs.getInt('location')!;
                            });
                          },
                        ),
                        SizedBox(
                          height: 52,
                          child: ListView.separated(
                            shrinkWrap: true,
                            controller: ScrollController(),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.categories?.length ?? 0,
                            itemBuilder: (context, index) {
                              final category = state.categories![index];
                              return CategoryButton(
                                  text: category.slug,
                                  isActive: category.id == _categoryIndex,
                                  onPressed: () {
                                    _scrollTo(category.id);
                                    _selectCategory(category.id);
                                  });
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 8.0),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ListView.builder(
                      controller: ScrollController(),
                      shrinkWrap: true,
                      itemCount: state.categories?.length ?? 0,
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
                                          (context, index) =>
                                              Coffeecard(coffee: coffee[index]),
                                          childCount: coffee.length)),
                                ),
                              ]);
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  )
                ]));
      } else if (state is MenuFailureState) {
        String exceptionMsg = !kReleaseMode
            ? state.exception.toString()
            : AppLocalizations.of(context)!.msgException;
        return Scaffold(body: Center(child: Text(exceptionMsg)));
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
}
