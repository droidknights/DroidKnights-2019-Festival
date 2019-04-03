import 'dart:io' show Platform;
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:droidknights/models/track_schedule.dart';
import 'package:droidknights/res/strings.dart';
import 'package:flutter/material.dart';

class SessionDetailDialog extends ModalRoute<void> {
  final ScheduleModel sessionData;

  SessionDetailDialog(this.sessionData);

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.82);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return GestureDetector(
      child: Material(
        type: MaterialType.transparency,
        // make sure that the overlay content is not cut off
        child: SafeArea(
          child: new Stack(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(27.0),
                    child: new IconButton(
                      icon:
                          new Image.asset(Strings.SESSION_DIALOG_IMAGES_CLOSE),
                      iconSize: 24,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              _buildOverlayContent(context),
            ],
          ),
        ),
      ),
      onTap: () => Navigator.pop(context),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Center(
          child: new Stack(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(
                    left: 27.0, right: 27.0, top: avatarHalfSize, bottom: 27.0),
                child: GestureDetector(
                    child: new Container(
                      width: double.infinity,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.all(
                          const Radius.circular(4.0),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: avatarHalfSize,
                          bottom: avatarHalfSize),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                              padding: const EdgeInsets.only(
                                  left: 32.0,
                                  right: 32.0,
                                  top: 16.0,
                                  bottom: 3.0),
                              child: new Text(
                                sessionData.title,
                                textAlign: TextAlign.center,
                                style: new TextStyle(fontSize: 16.0),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                sessionData.names.join(", "),
                                style: new TextStyle(
                                    color: new Color(0xffa5b495), fontSize: 16.0),
                              ),
                              sessionData.tag ? _setTag() : Container(),
                            ],
                          ),
                          new Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 13.0),
                              child: new Text(
                                sessionData.contents.toString(),
                                style: new TextStyle(
                                    color: new Color(0xff4a4a4a),
                                    fontSize: 12.0),
                              )),
                          //rating
                        ],
                      ),
                    ),
                    onTap: () => {}),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[profileImage],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _setTag() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        Strings.SCHEDULE_ITEM_BEGINNER_TAG,
        style:
        TextStyle(color: Color(0xff40d225), fontSize: 12.0),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  static const double avatarSize = 160.0;
  static const double avatarHalfSize = avatarSize / 2;

  Widget get profileImage {
    return new Hero(
        tag: sessionData,
        child: Row(
          children: sessionData.speakers
              .sublist(0, min(sessionData.speakers.length, 2))
              .map(avatarContainer)
              .expand((w) => [w, Padding(padding: EdgeInsets.only(left: 8.0))])
              .toList()
                ..removeLast(),
        ));
  }

  Widget avatarContainer(SpeakerModel speaker) {
    return GestureDetector(
      child: ClipOval(
        child: FadeInImage(
          width: avatarSize,
          height: avatarSize,
          fadeInDuration: const Duration(seconds: 0),
          fadeOutDuration: const Duration(seconds: 0),
          image: CachedNetworkImageProvider(speaker.avatarUrl),
          placeholder: AssetImage(Platform.isAndroid
              ? Strings.IMAGES_DK_PROFILE
              : Strings.IMAGES_DK_IOS_PROFILE),
          fit: BoxFit.fitHeight,
        )
      ),

      onTap: () => {}
    );
  }
}
