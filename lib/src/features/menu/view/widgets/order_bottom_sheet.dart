import 'package:flutter/material.dart';
import 'package:flutter_course/src/features/menu/bloc/menu_bloc.dart';
import 'package:flutter_course/src/features/menu/model/product.dart';

class OrderBottomSheet extends StatefulWidget {
  final List<Product> cart;
  final MenuBloc bloc;

  const OrderBottomSheet({super.key, required this.cart, required this.bloc});

  @override
  _OrderBottomSheetState createState() => _OrderBottomSheetState();
}

class _OrderBottomSheetState extends State<OrderBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Ваш заказ",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    IconButton(
                        onPressed: () {
                          widget.bloc.add(const ClearCartEvent());
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.delete))
                  ]),
            ),
            const Divider(),
            const SizedBox(height: 10),
            ListView.separated(
                controller: ScrollController(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                      contentPadding: const EdgeInsets.all(10.0),
                      leading: Image.network(
                          widget.bloc.state.cartItems![index].imageUrl,
                          width: 55.0,
                          height: 55.0,
                          fit: BoxFit.contain),
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(widget.bloc.state.cartItems![index].name,
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                            widget.bloc.state.cartItems![index].description,
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                      trailing: Text(
                          widget.bloc.state.cartItems![index].prices[0]
                              .toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)));
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: widget.bloc.state.cartItems!.length),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)))),
                  onPressed: () {
                    final orderJson = createOrder(widget.bloc.state.cartItems!);
                    debugPrint('$orderJson');
                    widget.bloc.add(CreateNewOrderEvent(orderJson));
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Заказ создан"),
                        duration: Duration(seconds: 2)));
                    widget.bloc.add(const ClearCartEvent());
                  },
                  child: const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                            child: Text("Оформить заказ",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal))),
                      ))),
            )
          ],
        ),
      ),
    );
  }

  Map<String, int> createOrder(List<Product> cart) {
    Map<String, int> orderJson = {};

    for (var element in cart) {
      final product = element.id.toString();
      if (!orderJson.containsKey(product)) {
        orderJson[product] = 1;
      } else {
        orderJson.update(product, (value) => value + 1);
      }
    }

    return orderJson;
  }
}
