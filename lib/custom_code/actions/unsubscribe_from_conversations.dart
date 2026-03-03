// Custom Action: unsubscribeFromConversations
// Return Type: void

import '/custom_code/realtime_service.dart';

Future unsubscribeFromConversations() async {
  await RealtimeService.instance.unsubscribeFromConversations();
}
