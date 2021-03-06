import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';
import '../../theme.dart';

class InputPage extends StatelessWidget {
  static final _bodyKey = GlobalKey<__BodyState>();

  final String title;
  final String initialValue;
  final String hintText;
  final int maxLength;
  final int maxLines;
  final bool obscureText;
  final void Function({
    @required String input,
    @required void Function() onSucceed,
    @required void Function(NoticeEntity) onFailed,
  }) submit;
  final FormFieldValidator<String> validator;

  InputPage({
    Key key,
    this.title = '',
    this.initialValue = '',
    this.hintText = '',
    this.maxLength,
    this.maxLines = 1,
    this.obscureText = false,
    @required this.submit,
    this.validator
  }):super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          FlatButton(
            onPressed: ()=>_bodyKey.currentState.submit(),
            child: Text(
              '完成',
              style: TextStyle(
                color: BLTheme.whiteNormal,
                fontSize: BLTheme.fontSizeLarge
              ),
            ),
          )
        ],
      ),
      body: _Body(
        key: _bodyKey,
        initialValue: initialValue,
        hintText: hintText,
        maxLength: maxLength,
        maxLines: maxLines,
        obscureText: obscureText,
        submit: submit,
        validator: validator,
      ),
    );
  }
}


class _Body extends StatefulWidget {

  final String initialValue;
  final String hintText;
  final int maxLength;
  final int maxLines;
  final bool obscureText;
  final void Function({
    @required String input,
    @required void Function() onSucceed,
    @required void Function(NoticeEntity) onFailed,
  }) submit;
  final FormFieldValidator<String> validator;

  _Body({
    Key key,
    @required this.initialValue,
    @required this.hintText,
    @required this.maxLength,
    @required this.maxLines,
    @required this.obscureText,
    @required this.submit,
    @required this.validator,
  }) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _textcontroller;
  var input = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textcontroller = TextEditingController(text: widget.initialValue);
  }

  void submit() {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      widget.submit(
        input: input,
        onSucceed: () => Navigator.of(context).pop(),
        onFailed: (notice) => Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(BLTheme.paddingSizeNormal),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: (){
                        _textcontroller.clear();
                      },
                    )
                  ),
                  validator: widget.validator,
                  onSaved: (value) => input = value,
                  autofocus: true,
                  maxLength: widget.maxLength,
                  maxLines: widget.maxLines,
                  maxLengthEnforced: true,
                  obscureText: widget.obscureText,
                  controller: _textcontroller,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
