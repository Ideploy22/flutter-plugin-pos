const String nameSpace = 'br.ideploy.pos.integration.flutter_plugin_pos_integration';
const String methods = 'methods';
const String eventChannelId = 'events';

enum POSEvent {
  login('login'),
  scan('scan'),
  pair('pair'),
  payment('payment'),
  terminalMessage('terminalMessage'),
  unknown('unknown');

  final String event;
  const POSEvent(this.event);
}
