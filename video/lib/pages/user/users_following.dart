import 'package:flutter/material.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../actions/actions.dart';
import '../../components/components.dart';
import '../../models/models.dart';


class UsersFollowingPage extends StatelessWidget {

  final int userId;

  UsersFollowingPage({
    Key key,
    @required this.userId
  }) : super(key : key);
  
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        userId: userId,
        usersFollowing: (store.state.user.usersFollowing[userId.toString()] ?? [])
          .map<UserEntity>((v) => store.state.user.users[v.toString()])
            .toList()
      ),
      builder: (context, vm) => Scaffold(
        appBar: AppBar(
          title: Text('关注'),
        ),
        body: _Body(
          vm: vm,
          store: StoreProvider.of<AppState>(context),
        ),
      ),
    );
  }
}

class _ViewModel {
  final int userId;
  final List<UserEntity> usersFollowing;
  _ViewModel({
    @required this.userId,
    @required this.usersFollowing
  });
}

class _Body extends StatefulWidget {

  final _ViewModel vm;
  final Store<AppState> store;

  _Body({
    Key key,
    @required this.vm,
    @required this.store
  }) : super(key : key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {

  var _isLoading = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);

    _loadData(recent:  true, more: false);
  }

  @override
  void dispose() {

    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadData();
    }
  }

  void _loadData({
    bool recent = false,
    bool more = true,
    bool refresh = false,
    Completer<Null> completer
  }) {
    if (_isLoading) {
      completer?.complete();
      return;
    }

    if (!recent) {
      setState(() {
        _isLoading = true;
      });
    }

    int offset;

    if (more) {
      offset = widget.vm.usersFollowing.length;
    }
    widget.store.dispatch(usersFollowingAction(
      userId: widget.vm.userId,
      offset: offset,
      refresh: refresh,
      onSucceed: (users) {
        setState(() {
          _isLoading = false;
        });
        completer?.complete();
      },
      onFailed: (notice) {
        setState(() {
          _isLoading = false;
        });
        completer?.complete();

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      }
    ));
  }

  Future<Null> _refresh() {
    final completer = Completer<Null>();
    _loadData(
      more: false,
      refresh: true,
      completer: completer
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(height: 1),
            itemCount: widget.vm.usersFollowing.length,
            itemBuilder: (context, index) => UserTile(
              key: Key(widget.vm.usersFollowing[index].id.toString()),
              user: widget.vm.usersFollowing[index],
            ),
          )
        ),
        Visibility(
          visible: _isLoading,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
  }
}
