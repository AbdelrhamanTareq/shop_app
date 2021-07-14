import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import '../providers/Products.dart';
import '../screens/edit_product_screen.dart';

class UserPorductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: _refreshProduct(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? CircularProgressIndicator()
                  : RefreshIndicator(
                      onRefresh: () => _refreshProduct(context),
                      child: Consumer<Products>(
                        builder: (ctx, productData, _) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: productData.items.length,
                            itemBuilder: (ctx, i) => Column(
                              children: [
                                UserProductItem(
                                    productData.items[i].id,
                                    productData.items[i].title,
                                    productData.items[i].imageUrl),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
    );
  }
}
