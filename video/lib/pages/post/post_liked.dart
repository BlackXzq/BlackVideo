import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:async';

import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../components/components.dart';


class PostLikedPage extends StatelessWidget {

  final int userId;

  PostLikedPage({Key key, @required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        userId: userId,
        postLiked: (store.state.post.postsLiked[userId] ?? [])
            .map<PostEntity>((v) => store.state.post.posts[v.toString()])
            .toList()
      ),
      builder: (context, vm) => Scaffold(
        appBar: AppBar(
          title: Text('喜欢'),
        ),
        body: _Body(
          store: StoreProvider.of<AppState>(context),
          vm: vm,
        ),
      ),
    );
  }
}

class _ViewModel {
  final int userId;
  final List<PostEntity> postLiked;

  _ViewModel({
    @required this.userId,
    @required this.postLiked,
  });
}


class _Body extends StatefulWidget {

  final Store<AppState> store;
  final _ViewModel vm;

  _Body({
    Key key,
    @required this.store,
    @required this.vm
  }) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {

  final _scrollController = ScrollController();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);

    _loadPostsLiked(recent: true, more: false);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadPostsLiked();
    }
  }

  void _loadPostsLiked({
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

    int beforeId;
    if (more && widget.vm.postLiked.isNotEmpty) {
      beforeId = widget.vm.postLiked.last.id;
    }
    int afterId;
    if (recent && widget.vm.postLiked.isNotEmpty) {
      afterId = widget.vm.postLiked.first.id;
    }

    widget.store.dispatch(postsLikedAction(
      userId: widget.vm.userId,
      beforeId: beforeId,
      afterId: afterId,
      refresh: refresh,
      onSucceed: (posts) {
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
    _loadPostsLiked(
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
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: widget.vm.postLiked.length,
            itemBuilder: (context, index) => Post(
              key: Key(widget.vm.postLiked[index].id.toString()),
              post: widget.vm.postLiked[index],
            ),
          ),
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
