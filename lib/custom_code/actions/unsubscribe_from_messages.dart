// Custom Action: unsubscribeFromMessages
// Return Type: void

import '/custom_code/realtime_service.dart';

Future unsubscribeFromMessages() async {
  await RealtimeService.instance.unsubscribeFromMessages();
}
