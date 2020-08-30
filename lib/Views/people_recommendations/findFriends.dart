import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'people_recommed.dart';
import '../../ViewModel/home_viewmodel.dart';
import '../Widget/user_search.dart';

class FindFriendPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
        create: (_) => HomeViewModel(),
        child: Consumer<HomeViewModel>(builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Find Friends'),
              actions: [
                IconButton(
                  icon: Icon(Icons.search, size: 19),
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: UserSearch(userList: model.usersList));
                  },
                ),
              ],
            ),
            body: PeopleRecommend(),
          );
        }));
  }
}
