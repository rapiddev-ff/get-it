import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'password_component_model.dart';
export 'password_component_model.dart';

class PasswordComponentWidget extends StatefulWidget {
  const PasswordComponentWidget({
    super.key,
    bool? isActive,
    required this.text,
  }) : this.isActive = isActive ?? false;

  final bool isActive;
  final String? text;

  @override
  State<PasswordComponentWidget> createState() =>
      _PasswordComponentWidgetState();
}

class _PasswordComponentWidgetState extends State<PasswordComponentWidget>
    with TickerProviderStateMixin {
  late PasswordComponentModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PasswordComponentModel());

    animationsMap.addAll({
      'iconOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 22.0,
          height: 22.0,
          decoration: BoxDecoration(),
          child: Builder(
            builder: (context) {
              if (widget.isActive) {
                return Icon(
                  Icons.check_sharp,
                  color: Color(0xFF4ADE80),
                  size: 22.0,
                ).animateOnPageLoad(animationsMap['iconOnPageLoadAnimation']!);
              } else {
                return Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Container(
                      width: 6.0,
                      height: 6.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ).animateOnPageLoad(
                        animationsMap['containerOnPageLoadAnimation']!),
                  ),
                );
              }
            },
          ),
        ),
        AnimatedDefaultTextStyle(
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 14.0,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          duration: Duration(milliseconds: 600),
          curve: Curves.easeOut,
          child: Text(
            valueOrDefault<String>(
              widget.text,
              'N/A',
            ),
          ),
        ),
      ].divide(SizedBox(width: 12.0)),
    );
  }
}
