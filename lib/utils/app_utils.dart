import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppButton extends StatelessWidget
{
  final String _title;
  final _onTap;
  final Color color;
  final Color _textColor;

  AppButton(this._title, this.color, this._textColor, this._onTap);

  @override
  Widget build(BuildContext context)
  {
    return Material(
      color: color,
      elevation: 2.0,
      borderRadius: BorderRadius.circular(25.0),
      child: InkWell(
        child: Center(
          child: Padding(
            child: Text(
              _title,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: _textColor),
            ),
            padding: EdgeInsets.symmetric(vertical: 12.0),
          ),
        ),
        onTap: _onTap,
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;

  AppCard({required this.child, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      shadowColor: Colors.blue.shade100,
      borderRadius: borderRadius,
      child: child,
    );
  }
}

class AppTextView extends StatelessWidget {
  final String title;
  final String value;

  AppTextView(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),
        ),
        Padding(
          padding: EdgeInsets.all(1.0),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.black26),
        )
      ],
    );
  }
}

class AppTextField extends StatelessWidget {
  final String? floatingHint, hint;
  final TextEditingController? controller;
  final onSaved;
  final validator;
  final Color? underlineColor;
  final Color? hintColor;
  final Color? textColor;
  final TextInputType? keyboardType;
  final bool? showPasswordType;
  final bool? enabled;
  final double? fontSize;
  final int? maxLength;
  final bool? autoFocus;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final Color? cursorColor;
  final Color? disabledColor;
  final int? maxLines;

  final autovalidate;

  AppTextField(
      {this.floatingHint,
      this.controller,
      this.onSaved,
      this.maxLines = 1,
      this.validator,
      this.hintColor = Colors.white,
      this.textColor = Colors.white,
      this.underlineColor = Colors.white,
      this.keyboardType = TextInputType.text,
      this.showPasswordType = false,
      this.enabled = true,
      this.autoFocus = false,
      this.fontSize = 16.0,
      this.maxLength,
      this.textAlign = TextAlign.start,
      this.focusNode,
      this.cursorColor,
      this.hint,
      this.autovalidate = false,
      this.disabledColor});

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: TextFormField(
        maxLines: maxLines,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: floatingHint,
          hintText: hint,
          contentPadding: EdgeInsets.all(7.0),
          isDense: true,
          errorMaxLines: 2,
          enabled: enabled as bool,
          labelStyle: TextStyle(
            color: hintColor,
            fontSize: fontSize,
          ),
        ),
        style: TextStyle(fontSize: fontSize, color: textColor),
        onSaved: onSaved,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: showPasswordType as bool,
        controller: controller,
        autovalidate: autovalidate,
        autofocus: autoFocus as bool,
        textAlign: textAlign as TextAlign,
        focusNode: focusNode,
        inputFormatters: maxLength != null
            ? [LengthLimitingTextInputFormatter(maxLength)]
            : null,
      ),
      data: ThemeData(
          primaryColor: underlineColor,
          hintColor: hintColor,
          cursorColor: cursorColor,
          disabledColor: disabledColor),
    );
  }
}

class AppCircleImage extends StatelessWidget {
  final dynamic image;
  final double size;
  final double borderWidth;

  AppCircleImage(this.size, this.image, this.borderWidth);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: image != null ? CachedNetworkImageProvider(image) : Image.asset('assets/images/ic_profile_blank.png') as ImageProvider, fit: BoxFit.cover,
        ),
        borderRadius: new BorderRadius.all(new Radius.circular(60.0)),
        border: new Border.all(
          color: Theme.of(context).primaryColor,
          width: borderWidth,
        ),
      ),
    );
  }
}

class ContentWithEditRemoveIconView extends StatelessWidget {
  final addEditExperience;
  final Color textColor;
  final String title;
  final showEdit;
  final showRemove;
  final maxWidth;
  final onEditTap;
  final onRemoveTap;
  final fontSize;
  final fontWeight;
  final maxLines;
  final textAlign;

  ContentWithEditRemoveIconView(this.title,
      {this.addEditExperience,
      this.textColor = Colors.black,
      this.showEdit = false,
      this.maxLines = 1,
      this.showRemove = false,
      this.maxWidth = double.infinity,
      this.onEditTap,
      this.textAlign = TextAlign.start,
      this.fontSize = 12.6,
      this.fontWeight = FontWeight.w300,
      this.onRemoveTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        title,
                        maxLines: maxLines,
                        overflow: TextOverflow.ellipsis,
                        textAlign: textAlign,
                        style: TextStyle(
                            color: textColor,
                            fontSize: fontSize ?? 12.6,
                            fontWeight: fontWeight),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                ),
                // showEdit
                //     ? InkWell(
                //         child: Icon(
                //           Icons.edit,
                //           color: Colors.grey,
                //           size: 16.0,
                //         ),
                //         onTap: onEditTap,
                //       )
                //     : Container()
              ],
            ),
          ),
          // showRemove
          //     ? Padding(
          //         padding: EdgeInsets.only(right: 8.0),
          //         child: InkWell(
          //           child: Icon(
          //             Icons.remove_circle_outline,
          //             size: 18.0,
          //           ),
          //           onTap: onRemoveTap,
          //         ),
          //       )
          //     : Container()
          showEdit
              ? Material(
                  color: Colors.white,
                  child: InkWell(
                    child: Icon(
                      Icons.edit,
                      color: Colors.grey,
                      size: 20.0,
                    ),
                    onTap: onEditTap,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

class TitleContentView extends StatelessWidget {
  final addEditExperience;
  final Color textColor;
  final String title;
  final showEdit;
  final showRemove;
  final maxWidth;
  final onEditTap;
  final onRemoveTap;

  TitleContentView(this.title,
      {this.addEditExperience,
      this.textColor = Colors.black,
      this.showEdit = false,
      this.showRemove = false,
      this.maxWidth = double.infinity,
      this.onEditTap,
      this.onRemoveTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Text(
                  title,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TitleWithAddIconView extends StatelessWidget {
  final onTap;
  final Color textColor;
  final String title;

  TitleWithAddIconView(this.title, {this.onTap, this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  color: textColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Material(
            child: InkWell(
                child: Icon(
                  Icons.add,
                  color: textColor,
                  size: 25.0,
                ),
                onTap: onTap),
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height - size.height / 7);

    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, size.height / 7);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DiagonalClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width, size.height / 2 - 100.0);

    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DiagonalClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(size.width, size.height);

    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ProfileText extends StatelessWidget {
  final String _title;

  ProfileText(this._title);

  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 17.5),
    );
  }
}

String? validateName(String value) {
  String patttern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Name is Required";
  } else if (!regExp.hasMatch(value)) {
    return "Name must be a-z and A-Z";
  }
  return null;
}

String? validateEmptyField(String value) {
  if (value.isEmpty) {
    return "Field is required";
  }
  return null;
}

String? validateOnlyNumber(String value) {
  if (value.isEmpty) {
    return "Field is required";
  } else if (!isNumeric(value)) {
    return "Only Number is Allowed";
  }
  return null;
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return int.parse(s) != null;
}

String? validateMobile(String value) {
  String patttern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Phone is Required";
  } else if (value.length != 10) {
    return "Phone number must 10 digits";
  } else if (!regExp.hasMatch(value)) {
    return "Phone Number must be digits";
  }
  return null;
}

String? validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Email is Required";
  } else if (!regExp.hasMatch(value)) {
    return "Invalid Email";
  } else {
    return null;
  }
}

final RegExp regExpSpecialCharacter =
    new RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-]');
final RegExp regExpForNumeric = new RegExp(r'[0-9]');
final RegExp regExpForAlpha = new RegExp(r'[A-Z]');

String? validatePassword(String value) {
  if (value.length == 0) {
    return "Password is Required";
  } /*else if (!regExpSpecialCharacter.hasMatch(value)) {
    return "Atleast one special character is required";
  } else if (!regExpForNumeric.hasMatch(value)) {
    return "Atleast one numeric is required";
  } else if (!regExpForAlpha.hasMatch(value)) {
    return "Atleast one aphabetic capital character is required";
  } else if (value.length < 6) {
    return "Min 6 character password is required";
  }*/
  else {
    return null;
  }
}

// class HtmlText extends StatelessWidget {
//   final String data;
//   final Widget style;
//   final Function onLaunchFail;

//   BuildContext ctx;

//   HtmlText({this.data, this.style, this.onLaunchFail});

//   void _launchURL(String url) async {
//     try {
//       await cTab.launch(
//         url,
//         option: new cTab.CustomTabsOption(
//           toolbarColor: Theme.of(ctx).primaryColor,
//           enableDefaultShare: true,
//           enableUrlBarHiding: true,
//           showPageTitle: true,
//         ),
//       );
//     } catch (e) {
//       // An exception is thrown if browser app is not installed on Android device.
//       debugPrint(e.toString());
//     }
//   }

//   void _launchOtherURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       print('Could not launch $url');

//       if (this.onLaunchFail != null) {
//         this.onLaunchFail(url);
//       }
//     }
//   }

//   TapGestureRecognizer recognizer(String url) {
//     return new TapGestureRecognizer()
//       ..onTap = () {
//         if (url.startsWith("http://") || url.startsWith("https://")) {
//           _launchURL(url);
//         } else {
//           _launchOtherURL(url);
//         }
//       };
//   }

//   @override
//   Widget build(BuildContext context) {
//     ctx = context;
//     HtmlParser parser = new HtmlParser(context);
//     List nodes = parser.parse(this.data);

//     TextSpan span = this._stackToTextSpan(nodes, context);
//     RichText contents = new RichText(
//       text: span,
//       softWrap: true,
//     );

//     return new Container(
//         padding:
//             const EdgeInsets.only(top: 2.0, left: 8.0, right: 8.0, bottom: 2.0),
//         child: contents);
//   }

//   TextSpan _stackToTextSpan(List nodes, BuildContext context) {
//     List<TextSpan> children = <TextSpan>[];

//     for (int i = 0; i < nodes.length; i++) {
//       children.add(_textSpan(nodes[i]));
//     }

//     return new TextSpan(
//         text: '',
//         style: DefaultTextStyle.of(context).style,
//         children: children);
//   }

//   TextSpan _textSpan(Map node) {
//     TextSpan span;
//     String s = node['text'];

//     s = s.replaceAll('\u00A0', ' ');
//     s = s.replaceAll('&nbsp;', ' ');
//     s = s.replaceAll('&amp;', '&');
//     s = s.replaceAll('&lt;', '<');
//     s = s.replaceAll('&gt;', '>');

//     if (node['tag'] == 'a') {
//       span = new TextSpan(
//           text: s, style: node['style'], recognizer: recognizer(node['href']));
//     } else {
//       span = new TextSpan(
//         text: s,
//         style: node['style'],
//       );
//     }

//     return span;
//   }
// }

class HtmlParser {
  // Regular Expressions for parsing tags and attributes
  RegExp? _startTag;
  RegExp? _endTag;
  RegExp? _attr;
  RegExp? _style;
  RegExp? _color;

  final BuildContext context;

  final List _emptyTags = const [
    'area',
    'base',
    'basefont',
    'br',
    'col',
    'frame',
    'hr',
    'img',
    'input',
    'isindex',
    'link',
    'meta',
    'param',
    'embed'
  ];
  final List _blockTags = const [
    'address',
    'applet',
    'blockquote',
    'button',
    'center',
    'dd',
    'del',
    'dir',
    'div',
    'dl',
    'dt',
    'fieldset',
    'form',
    'frameset',
    'hr',
    'iframe',
    'ins',
    'isindex',
    'li',
    'map',
    'menu',
    'noframes',
    'noscript',
    'object',
    'ol',
    'p',
    'pre',
    'script',
    'table',
    'tbody',
    'td',
    'tfoot',
    'th',
    'thead',
    'tr',
    'ul'
  ];
  final List _inlineTags = const [
    'a',
    'abbr',
    'acronym',
    'applet',
    'b',
    'basefont',
    'bdo',
    'big',
    'br',
    'button',
    'cite',
    'code',
    'del',
    'dfn',
    'em',
    'font',
    'i',
    'iframe',
    'img',
    'input',
    'ins',
    'kbd',
    'label',
    'map',
    'object',
    'q',
    's',
    'samp',
    'script',
    'select',
    'small',
    'span',
    'strike',
    'strong',
    'sub',
    'sup',
    'textarea',
    'tt',
    'u',
    'var'
  ];
  final List _closeSelfTags = const [
    'colgroup',
    'dd',
    'dt',
    'li',
    'options',
    'p',
    'td',
    'tfoot',
    'th',
    'thead',
    'tr'
  ];
  final List _fillAttrs = const [
    'checked',
    'compact',
    'declare',
    'defer',
    'disabled',
    'ismap',
    'multiple',
    'nohref',
    'noresize',
    'noshade',
    'nowrap',
    'readonly',
    'selected'
  ];
  final List _specialTags = const ['script', 'style'];

  List _stack = [];
  List _result = [];

  Map<String, dynamic>? _tag;

  HtmlParser(this.context) {
    this._startTag = new RegExp(
        r'^<([-A-Za-z0-9_]+)((?:\s+[-\w]+(?:\s*=\s*(?:(?:"[^"]*")' +
            "|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>");
    this._endTag = new RegExp("^<\/([-A-Za-z0-9_]+)[^>]*>");
    this._attr = new RegExp(
        r'([-A-Za-z0-9_]+)(?:\s*=\s*(?:(?:"((?:\\.|[^"])*)")' +
            r"|(?:'((?:\\.|[^'])*)')|([^>\s]+)))?");
    this._style = new RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
    this._color = new RegExp(r'^#([a-fA-F0-9]{6})$');
  }

  List parse(String html) {
    String last = html;
    Match match;
    int index;
    bool chars;

    while (html.length > 0) {
      chars = true;

      // Make sure we're not in a script or style element
      if (this._getStackLastItem() == null ||
          !this._specialTags.contains(this._getStackLastItem())) {
        // Comment
        if (html.indexOf('<!--') == 0) {
          index = html.indexOf('-->');

          if (index >= 0) {
            html = html.substring(index + 3);
            chars = false;
          }
        }
        // End tag
        else if (html.indexOf('</') == 0) {
          match = this._endTag!.firstMatch(html)!;

          if (match != null) {
            String tag = match![0] as String;

            html = html.substring(tag.length);
            chars = false;

            this._parseEndTag(tag);
          }
        }
        // Start tag
        else if (html.indexOf('<') == 0) {
          match = this._startTag!.firstMatch(html)!;

          if (match != null) {
            String tag = match![0] as String;

            html = html.substring(tag.length);
            chars = false;

            this._parseStartTag(tag, match![1] as String, match![2]!, match.start);
          }
        }

        if (chars) {
          index = html.indexOf('<');

          String text = (index < 0) ? html : html.substring(0, index);

          html = (index < 0) ? '' : html.substring(index);

          this._appendNode(text);
        }
      } else {
        RegExp re =
            new RegExp(r'(.*)<\/' + (this._getStackLastItem() as String) + r'[^>]*>');

        html = html.replaceAllMapped(re, (Match match) {
          String text = match[0]!
            ..replaceAll(new RegExp('<!--(.*?)-->'), '\$1')
            ..replaceAll(new RegExp('<!\[CDATA\[(.*?)]]>'), '\$1');

          this._appendNode(text);

          return '';
        });

        this._parseEndTag(this._getStackLastItem() as String);
      }

      if (html == last) {
        throw 'Parse Error: ' + html;
      }

      last = html;
    }

    // Cleanup any remaining tags
    this._parseEndTag();

    List result = this._result;

    // Cleanup internal variables
    this._stack = [];
    this._result = [];

    return result;
  }

  void _parseStartTag(String tag, String tagName, String rest, int unary) {
    tagName = tagName.toLowerCase();

    if (this._blockTags.contains(tagName)) {
      while (this._getStackLastItem() != null &&
          this._inlineTags.contains(this._getStackLastItem())) {
        this._parseEndTag(this._getStackLastItem() as String);
      }
    }

    if (this._closeSelfTags.contains(tagName) &&
        this._getStackLastItem() == tagName) {
      this._parseEndTag(tagName);
    }

    if (this._emptyTags.contains(tagName)) {
      unary = 1;
    }

    if (unary == 0) {
      this._stack.add(tagName);
    }

    Map attrs = {};

    Iterable<Match> matches = this._attr!.allMatches(rest);

    if (matches != null) {
      for (Match match in matches)
      {
        String attribute =match![1] as String;
        String? value;

        if (match[2] != null)
          value = match![2];
        else if (match[3] != null)
          value = match![3];
        else if (match[4] != null)
          value = match![4];
        else if (this._fillAttrs.contains(attribute) != null)
          value = attribute;

        attrs[attribute] = value;
      }
    }

    this._appendTag(tagName, attrs);
  }

  void _parseEndTag([String? tagName])
  {
    int pos;
    // If no tag name is provided, clean shop
    if (tagName == null)
      pos = 0;

    // Find the closest opened tag of the same type
    else {
      for (pos = this._stack.length - 1; pos >= 0; pos--) {
        if (this._stack[pos] == tagName) {
          break;
        }
      }
    }

    if (pos >= 0) {
      // Remove the open elements from the stack
      this._stack.removeRange(pos, this._stack.length);
    }
  }

  TextStyle _parseStyle(String tag, Map attrs) {
    Iterable<Match> matches;
    String style = attrs['style'];
    String param;
    String value;

    TextStyle defaultTextStyle = DefaultTextStyle.of(context).style;

    double fontSize = defaultTextStyle.fontSize as double;
    Color color = defaultTextStyle.color as Color;
    FontWeight fontWeight = defaultTextStyle.fontWeight as FontWeight;
    FontStyle fontStyle = defaultTextStyle.fontStyle as FontStyle;
    TextDecoration textDecoration = defaultTextStyle.decoration as TextDecoration;

    switch (tag) {
      case 'h1':
        fontSize = 32.0;
        break;
      case 'h2':
        fontSize = 24.0;
        break;
      case 'h3':
        fontSize = 20.8;
        break;
      case 'h4':
        fontSize = 16.0;
        break;
      case 'h5':
        fontSize = 12.8;
        break;
      case 'h6':
        fontSize = 11.2;
        break;
      case 'a':
        textDecoration = TextDecoration.underline;
        color = new Color(int.parse('0xFF1965B5'));
        break;

      case 'b':
      case 'strong':
        fontWeight = FontWeight.bold;
        break;

      case 'i':
      case 'em':
        fontStyle = FontStyle.italic;
        break;

      case 'u':
        textDecoration = TextDecoration.underline;
        break;
    }

    if (style != null) {
      matches = this._style!.allMatches(style);

      for (Match match in matches) {
        param = match[1]!.trim();
        value = match[2]!.trim();

        switch (param) {
          case 'color':
            if (this._color!.hasMatch(value)) {
              value = value.replaceAll('#', '').trim();
              color = new Color(int.parse('0xFF' + value));
            }

            break;

          case 'font-weight':
            fontWeight =
                (value == 'bold') ? FontWeight.bold : FontWeight.normal;

            break;

          case 'font-style':
            fontStyle =
                (value == 'italic') ? FontStyle.italic : FontStyle.normal;

            break;

          case 'text-decoration':
            textDecoration = (value == 'underline')
                ? TextDecoration.underline
                : TextDecoration.none;

            break;
        }
      }
    }

    TextStyle textStyle;

    if (fontSize != 0.0) {
      textStyle = new TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          decoration: textDecoration,
          fontSize: fontSize);
    } else {
      textStyle = new TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: textDecoration,
      );
    }

    return textStyle;
  }

  void _appendTag(String tag, Map attrs) {
    this._tag = {'tag': tag, 'attrs': attrs};
  }

  void _appendNode(String text) {
    if (this._tag == null) {
      this._tag = {'tag': 'p', 'attrs': {}};
    }

    this._tag!['text'] = text;
    this._tag!['style'] = this._parseStyle(this._tag!['tag'], this._tag!['attrs']);
    this._tag!['href'] =
        (this._tag!['attrs']['href'] != null) ? this._tag!['attrs']['href'] : '';

    this._tag!.remove('attrs');

    this._result.add(this._tag);

    this._tag = null;
  }

  String? _getStackLastItem() {
    if (this._stack.length <= 0) {
      return null;
    }

    return this._stack[this._stack.length - 1];
  }
}
