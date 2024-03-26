part of 'menu_bloc.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();
}

final class LoadCategoriesEvent extends MenuEvent {
  const LoadCategoriesEvent();
  
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class LoadItemsEvent extends MenuEvent {
  const LoadItemsEvent();
  
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class AddItemToCartEvent extends MenuEvent {
  final Product item;

  const AddItemToCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}

final class RemoveItemFromCartEvent extends MenuEvent {
  final Product item;

  const RemoveItemFromCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}

final class ClearCartEvent extends MenuEvent {
  const ClearCartEvent();

  @override
  List<Object?> get props => [];
}

final class CreateNewOrderEvent extends MenuEvent {
  final Map<String, int> orderJson;

  const CreateNewOrderEvent(this.orderJson);

  @override
  List<Object?> get props => [orderJson];
}
