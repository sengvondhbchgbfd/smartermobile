import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/chat_message_entity.dart';

class VoiceMessageWidget extends StatefulWidget {
  final ChatMessageEntity message;
  final bool isMe;

  const VoiceMessageWidget(
      {super.key, required this.message, required this.isMe});

  @override
  State<VoiceMessageWidget> createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget>
    with SingleTickerProviderStateMixin {
  bool _playing = false;
  late AnimationController _ctrl;
  final _rand = Random(42);

  // Fake waveform bars seeded per message id
  late final List<double> _bars;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..repeat(reverse: true);
    final seed = Random(widget.message.messageId);
    _bars = List.generate(
        30, (_) => 4 + seed.nextDouble() * 22);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _fmt(int? secs) {
    if (secs == null) return '0:00';
    return '${secs ~/ 60}:${(secs % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => setState(() => _playing = !_playing),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isMe
                        ? const Color(0xFF3a7bd5)
                        : const Color(0xFF2b5278),
                  ),
                  child: Icon(
                    _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) => Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(_bars.length, (i) {
                    final active = _playing && i < (_bars.length * _ctrl.value);
                    final h = _playing
                        ? _bars[i] * (0.5 + 0.5 * sin(_ctrl.value * pi + i))
                        : _bars[i] * 0.6;
                    return Container(
                      width: 3,
                      height: h.clamp(3.0, 26.0),
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: active
                            ? const Color(0xFF5caeff)
                            : Colors.white.withOpacity(0.25),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _fmt(widget.message.durationSecs),
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF8a9bb0)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _fmtTime(widget.message.createdAt),
                style: TextStyle(
                    fontSize: 11.5,
                    color: widget.isMe
                        ? Colors.white.withOpacity(0.45)
                        : const Color(0xFF6b8097)),
              ),
              if (widget.isMe) ...[
                const SizedBox(width: 3),
                Icon(
                  widget.message.isRead
                      ? Icons.done_all_rounded
                      : Icons.done_rounded,
                  size: 14,
                  color: widget.message.isRead
                      ? const Color(0xFF5caeff)
                      : Colors.white.withOpacity(0.4),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _fmtTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}