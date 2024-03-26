part of 'menu_bloc.dart';

sealed class MenuState extends Equatable {
  final List<Category>? categories;
  final List<Product>? items;
  final List<Product>? cartItems;

  const MenuState({this.categories, this.items, this.cartItems});
}

final class MenuInitialState extends MenuState {
  const MenuInitialState();
  
  @override
  List<Object?> get props => [];
}

final class MenuLoadingState extends MenuState {
  const MenuLoadingState();
  
  @override
  List<Object?> get props => [];
}

final class MenuSuccessState extends MenuState {
  const MenuSuccessState({super.categories, super.items, super.cartItems});
  
  @override
  List<Object?> get props => [super.categories, super.items, super.cartItems];
}

final class MenuFailureState extends MenuState {
  final Object? exception;

  const MenuFailureState({this.exception});
  
  @override
  List<Object?> get props => [exception];
}
