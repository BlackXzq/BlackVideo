import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../components/components.dart';
import '../config.dart';
import '../models/models.dart';
import '../theme.dart';
import '../actions/actions.dart';
import 'pages.dart';

class MePage extends StatelessWidget {
  
  static final _bodyKey = GlobalKey<__BodyState>();

  MePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel> (
      converter: (store) => _ViewModel(
        user: store.state.account.user,
      ),
      builder: (context, vm) => Scaffold(
        appBar: AppBar(
          title: Text('我'),
        ),
        body: _Body(
          key: _bodyKey,
          store: StoreProvider.of<AppState>(context),
          vm: vm,
        ),
        bottomNavigationBar: BLTabBar(tabIndex: 2),
      ),
    );
  }
}

class _ViewModel {
  final UserEntity user;

  _ViewModel({
    @required this.user
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
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadAccountInfo();
  }

  void _loadAccountInfo() {
    setState(() {
      _isLoading = true;
    });

    widget.store.dispatch(accountInfoAction(
      onSucceed: (user) {
        setState(() {
          _isLoading = false;
        });
      },
      onFailed: (notice) {
        setState(() {
          _isLoading = false;
        });
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      }
    ));
  }


  void _logout() {
    setState(() {
      _isLoading = true;
    });

    widget.store.dispatch(accountLogoutAction(
      onFailed: (notice) {
        setState(() {
          _isLoading = false;
        });
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      },
      onSucceed: (){
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context, rootNavigator: true).pushReplacementNamed('/login');
      }
    ));
  }

  Widget _visibility() {
    return Visibility(
        visible: _isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
    );
  }
  //个人信息头部样式
  Widget _headCard() {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            leading: GestureDetector(
              onTap: Feedback.wrapForTap((){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Userpage(userId: widget.vm.user.id,)));
              }, context),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: widget.vm.user.avatar == '' ? null : CachedNetworkImageProvider(widget.vm.user.avatar),
                child: widget.vm.user.avatar == '' ? Icon(Icons.account_circle) : null,
              ),
            ),
            title: Text(
              widget.vm.user.username,
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              '${widget.vm.user.mobile.isEmpty ? '尚未填写手机号' : widget.vm.user.mobile}'
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
          )
        ],
      )
    );
  }
//================================list列表内容================================================
  Widget _listContentTile(String title, Function ontap) {
    return ListTile(
      onTap: ontap,
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      title: Text(title, style: TextStyle(fontSize: BLTheme.fontSizeLarge),),
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }

  Widget _listCard() {
    return Card(
      child: Column(
        children: <Widget>[
          _listContentTile('喜欢', (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostLikedPage()));
          }),
          Divider(height: 1,),
          _listContentTile('关注', (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => UsersFollowingPage()));
          }),
          Divider(height: 1,),
          _listContentTile('粉丝', (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => FollowersPage()));
          }),
        ],
      ),
    );
  }
//======================退出登录 widget==========================================================
  Widget _logoutWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: BLTheme.marginSizeNormal),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              padding: EdgeInsets.all(BLTheme.paddingSizeNormal),
              onPressed: _logout,
              color: Theme.of(context).primaryColorDark,
              child: Text(
                '退出',
                style: TextStyle(
                    color: BLTheme.whiteLight,
                    fontSize: BLTheme.fontSizeLarge,
                    letterSpacing: 30
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  //======================底部提示信息栏目==========================
  Widget _tipInfoWidget() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        '${BLConfig.packageInfo.appName} v${BLConfig.packageInfo.version}@${BLConfig.domain}',
        style: TextStyle(
          color: Theme.of(context).hintColor
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            _headCard(),
            _listCard(),
            _logoutWidget(),
            _tipInfoWidget()
          ],
        ),
        _visibility()
      ],
    );
  }
}

