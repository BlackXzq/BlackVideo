import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/models.dart';
import '../../theme.dart';
import '../../actions/actions.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
      ),
      body: _RegisterBody(),
    );
  }
}

class _RegisterBody extends StatefulWidget {
  @override
  __RegisterBodyState createState() => __RegisterBodyState();
}

class __RegisterBodyState extends State<_RegisterBody> {

  final _formKey = GlobalKey<FormState>();
  final _form = RegisterForm();

  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();

  var _isLoading = false;

  void _register() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });

      StoreProvider.of<AppState>(context).dispatch(accountRegisterAction(
        form: _form,
        onSucceed: (UserEntity user) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        },
        onFailed: (NoticeEntity notice) {
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
  }


  //                    onSaved: (value) => _form.username = value,
//                    focusNode: _usernameFocus,
//                    textInputAction: TextInputAction.next,
//                    onEditingComplete: (){
//                      _usernameFocus.unfocus();
//                      FocusScope.of(context).requestFocus(_passwordFocus);
//                    },

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          padding: EdgeInsets.all(BLTheme.paddingSizeNormal),
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: '用户名',
                      hintText: '2-20个中英文字符'
                    ),
                    onSaved: (value) => _form.username = value,
                    focusNode: _usernameFocus,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: (){
                      _usernameFocus.unfocus();
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: '密码',
                      hintText: '长度 6 - 20'
                    ),
                    obscureText: true,
                    onSaved: (value) => _form.password = value,
                    focusNode: _passwordFocus,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: _register,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: BLTheme.marginSizeNormal),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.all(BLTheme.paddingSizeNormal),
                            onPressed: _register,
                            color: Theme.of(context).primaryColorDark,
                            child: Text(
                              '注册',
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
                  )
                ],
              ),
            ),
          ],
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


