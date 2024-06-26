import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_course/src/features/menu/data/category_repository.dart';
import 'package:flutter_course/src/features/menu/data/location_repository.dart';
import 'package:flutter_course/src/features/menu/data/order_repository.dart';
import 'package:flutter_course/src/features/menu/data/product_repository.dart';
import 'package:flutter_course/src/features/menu/model/category.dart';
import 'package:flutter_course/src/features/menu/model/location.dart';
import 'package:flutter_course/src/features/menu/model/product.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final ILocationRepository _locationRepository;
  final IProductRepository _productRepository;
  final ICategoryRepository _categoryRepository;
  final IOrderRepository _orderRepository;

  MenuBloc({
    required ILocationRepository locationRepository,
    required IProductRepository productRepository,
    required ICategoryRepository categoryRepository,
    required IOrderRepository orderRepository,
  })  : _locationRepository = locationRepository,
        _productRepository = productRepository,
        _categoryRepository = categoryRepository,
        _orderRepository = orderRepository,
        super(const MenuLoadingLocationsState()) {
    on<LoadLocationsEvent>(_onLoadLocations);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadItemsEvent>(_onLoadItems);
    on<AddItemToCartEvent>(_onAddItemToCart);
    on<RemoveItemFromCartEvent>(_onRemoveItemFromCart);
    on<ClearCartEvent>(_onClearCart);
    on<CreateNewOrderEvent>(_onCreateNewOrder);
  }

  Future<void> _onLoadLocations(
      LoadLocationsEvent event, Emitter<MenuState> emit) async {
    log("fetching locations");
    try {
      final locations = await _locationRepository.loadLocations();
      emit(MenuLoadingCategoriesState(
          locations: locations,
          categories: state.categories,
          items: state.items,
          cartItems: const []));
    } catch (e) {
      emit(MenuFailureState(exception: e));
    }
  }

  Future<void> _onLoadCategories(
      LoadCategoriesEvent event, Emitter<MenuState> emit) async {
    log("fetching categories");
    try {
      final categories = await _categoryRepository.loadCategories();
      emit(MenuLoadingProductsState(
          locations: state.locations,
          categories: categories,
          items: state.items,
          cartItems: const []));
    } catch (e) {
      emit(MenuFailureState(exception: e));
    }
  }

  Future<void> _onLoadItems(
      LoadItemsEvent event, Emitter<MenuState> emit) async {
    try {
      List<Product> items = [];
      for (var category in state.categories!) {
        log("fetching product with category id = ${category.id}");
        final result = await _productRepository.loadProducts(
            category: category, limit: 10);
        items.addAll(result);
        emit(MenuSuccessState(
            locations: state.locations,
            categories: state.categories,
            items: items,
            cartItems: state.cartItems));
      }
      emit(MenuSuccessState(
          locations: state.locations,
          categories: state.categories,
          items: state.items,
          cartItems: state.cartItems));
    } catch (e) {
      emit(MenuFailureState(exception: e));
    }
  }

  Future<void> _onAddItemToCart(
      AddItemToCartEvent event, Emitter<MenuState> emit) async {
    List<Product> cart = List<Product>.from(state.cartItems!);
    cart.add(event.item);
    emit(MenuSuccessState(
        locations: state.locations,
        categories: state.categories,
        items: state.items,
        cartItems: cart));
    log("Added item to cart");
  }

  Future<void> _onRemoveItemFromCart(
      RemoveItemFromCartEvent event, Emitter<MenuState> emit) async {
    List<Product> cart = List<Product>.from(state.cartItems!);
    cart.remove(event.item);
    emit(MenuSuccessState(
        locations: state.locations,
        categories: state.categories,
        items: state.items,
        cartItems: cart));
    log("Remove item from cart");
  }

  Future<void> _onClearCart(
      ClearCartEvent event, Emitter<MenuState> emit) async {
    emit(MenuSuccessState(
        locations: state.locations,
        categories: state.categories,
        items: state.items,
        cartItems: const []));
    log("Cart cleared");
  }

  Future<void> _onCreateNewOrder(
      CreateNewOrderEvent event, Emitter<MenuState> emit) async {
    try {
      final result =
          await _orderRepository.loadOrder(orderJson: event.orderJson);
      log(result.toString());
      if (result.isEmpty) throw const SocketException("No data");
      emit(MenuSuccessState(
          locations: state.locations,
          categories: state.categories,
          items: state.items,
          cartItems: state.cartItems,
          status: OrderStatus.success));
    } on Exception catch (e) {
      emit(MenuSuccessState(
          locations: state.locations,
          categories: state.categories,
          items: state.items,
          cartItems: state.cartItems,
          status: OrderStatus.failure));
      log(e.toString());
    }
    log("Create new order");
  }
}
