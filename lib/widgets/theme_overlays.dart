import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Pulsing radial gradients for Cyber Neon.
class AnimatedPulseOverlay extends StatefulWidget {
  final Color color;
  final Color secondary;
  const AnimatedPulseOverlay({super.key, required this.color, required this.secondary});
  @override
  State<AnimatedPulseOverlay> createState() => _AnimatedPulseOverlayState();
}

class _AnimatedPulseOverlayState extends State<AnimatedPulseOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat(reverse: true);
  }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final p = _c.value;
        return CustomPaint(
          painter: _PulsePainter(p, widget.color, widget.secondary),
        );
      },
    );
  }
}

class _PulsePainter extends CustomPainter {
  final double t; final Color a; final Color b;
  _PulsePainter(this.t, this.a, this.b);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width/2, size.height*0.35);
    final maxR = size.width*0.9;
    final r1 = (0.35 + 0.25*math.sin(t*math.pi*2))*maxR;
    final r2 = (0.55 + 0.25*math.sin(t*math.pi*2 + math.pi/2))*maxR;
    final paint = Paint()..style=PaintingStyle.fill;
    paint.shader = RadialGradient(colors:[a,b,Colors.transparent],stops: const [0,0.5,1]).createShader(Rect.fromCircle(center: center, radius: r2));
    canvas.drawCircle(center, r2, paint..colorFilter=null);
    paint.shader = RadialGradient(colors:[b,a.withOpacity(0.4),Colors.transparent],stops: const [0,0.4,1]).createShader(Rect.fromCircle(center: center, radius: r1));
    canvas.drawCircle(center, r1, paint);
  }
  @override
  bool shouldRepaint(covariant _PulsePainter old)=> old.t!=t;
}

/// Horizontal scanlines overlay.
class ScanlineOverlay extends StatelessWidget {
  final double opacity;
  const ScanlineOverlay({super.key, this.opacity=0.05});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ScanPainter(opacity));
  }
}
class _ScanPainter extends CustomPainter {
  final double o; _ScanPainter(this.o);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(o)
      ..strokeWidth = 1;
    for (double y=0; y<size.height; y+=6) {
      canvas.drawLine(Offset(0,y), Offset(size.width,y), paint);
    }
  }
  @override
  bool shouldRepaint(_ScanPainter old)=> false;
}

/// Vertical drifting mist for Midnight Teal.
class MistOverlay extends StatefulWidget {
  final Color baseColor; final Color highlightColor;
  const MistOverlay({super.key, required this.baseColor, required this.highlightColor});
  @override State<MistOverlay> createState()=>_MistOverlayState();
}
class _MistOverlayState extends State<MistOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override void initState(){super.initState(); _c=AnimationController(vsync:this,duration: const Duration(seconds: 20))..repeat();}
  @override void dispose(){_c.dispose();super.dispose();}
  @override Widget build(BuildContext context){
    return AnimatedBuilder(animation:_c,builder:(context,_){
      return CustomPaint(painter:_MistPainter(_c.value, widget.baseColor, widget.highlightColor));
    });
  }
}
class _MistPainter extends CustomPainter {
  final double t; final Color a; final Color b;
  _MistPainter(this.t,this.a,this.b);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style=PaintingStyle.fill;
    for(int i=0;i<3;i++){
      final phase = (t + i/3)%1;
      final top = size.height*(phase-1); // drift downward
      final rect = Rect.fromLTWH(0, top, size.width, size.height*0.9);
      paint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors:[a,b.withOpacity(0),],
        stops: const [0,1],
      ).createShader(rect);
      canvas.drawRect(rect, paint);
    }
  }
  @override bool shouldRepaint(covariant _MistPainter old)=> old.t!=t;
}

/// Floating particles for Midnight Teal.
class ParticleDriftOverlay extends StatefulWidget {
  final Color color; const ParticleDriftOverlay({super.key, required this.color});
  @override State<ParticleDriftOverlay> createState()=>_ParticleDriftOverlayState();
}
class _ParticleDriftOverlayState extends State<ParticleDriftOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _c; final List<_Particle> _parts = List.generate(32, (i)=>_Particle.random());
  @override void initState(){super.initState(); _c=AnimationController(vsync:this,duration: const Duration(seconds: 18))..repeat();}
  @override void dispose(){_c.dispose();super.dispose();}
  @override Widget build(BuildContext context){
    return AnimatedBuilder(animation:_c,builder:(context,_){
      return CustomPaint(painter:_ParticlePainter(_parts,_c.value, widget.color));
    });
  }
}
class _Particle { double x=0,y=0,r=0,s=0; _Particle.random(){ final rnd=math.Random(); x=rnd.nextDouble(); y=rnd.nextDouble(); r=1+rnd.nextDouble()*2.5; s=0.2+ rnd.nextDouble()*0.8; }}
class _ParticlePainter extends CustomPainter {
  final List<_Particle> parts; final double t; final Color c; _ParticlePainter(this.parts,this.t,this.c);
  @override void paint(Canvas canvas, Size size){
    final paint = Paint()..color=c;
    for(final p in parts){
      final dy = (p.y + t*p.s)%1 * size.height;
      final dx = (p.x + math.sin((t+p.x)*math.pi*2)*0.01)*size.width;
      canvas.drawCircle(Offset(dx,dy), p.r, paint..color=c.withOpacity(0.15));
    }
  }
  @override bool shouldRepaint(_ParticlePainter old)=> true;
}
