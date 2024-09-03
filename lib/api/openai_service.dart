import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String _apiKey;
  final String _assistantId; // 使用者定義的 assistant ID

  OpenAIService(this._apiKey, this._assistantId);

  Future<String> createThreadAndFetchResponse(String userQuestion) async {
    // Step 1: Create a new thread
    final threadResponse = await http.post(
      Uri.parse('https://api.openai.com/v1/threads'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
        'OpenAI-Beta': 'assistants=v2',
      },
      body: jsonEncode({
        'messages': [
          {
            "role": "user",
            "content": userQuestion + " 請列點回答",
          }
        ]
      }),
    );

    if (threadResponse.statusCode != 200) {
      throw Exception('Failed to create thread: ${threadResponse.body}');
    }

    final threadData = jsonDecode(threadResponse.body);
    final threadId = threadData['id'];

    // Step 2: Run the thread with the assistant
    final runResponse = await http.post(
      Uri.parse('https://api.openai.com/v1/threads/$threadId/runs'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
        'OpenAI-Beta': 'assistants=v2',
      },
      body: jsonEncode({'assistant_id': _assistantId}),
    );

    if (runResponse.statusCode != 200) {
      throw Exception('Failed to run thread: ${runResponse.body}');
    }

    final runData = jsonDecode(runResponse.body);
    final runId = runData['id'];

    // Step 3: Polling for the response
    String responseText = "";
    bool isCompleted = false;

    while (!isCompleted) {
      final statusResponse = await http.get(
        Uri.parse('https://api.openai.com/v1/threads/$threadId/runs/$runId'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'OpenAI-Beta': 'assistants=v2',
        },
      );

      if (statusResponse.statusCode != 200) {
        throw Exception(
            'Failed to retrieve run status: ${statusResponse.body}');
      }

      final statusData = jsonDecode(statusResponse.body);
      isCompleted = statusData['status'] == 'completed';

      if (isCompleted) {
        final messagesResponse = await http.get(
          Uri.parse('https://api.openai.com/v1/threads/$threadId/messages'),
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'OpenAI-Beta': 'assistants=v2',
          },
        );

        if (messagesResponse.statusCode != 200) {
          throw Exception(
              'Failed to retrieve messages: ${messagesResponse.body}');
        }
        final decodedBody = utf8.decode(messagesResponse.bodyBytes);
        final messagesData = jsonDecode(decodedBody);
        final latestMessage = messagesData['data'];
        responseText = latestMessage[0]["content"][0]["text"]["value"];
      } else {
        await Future.delayed(Duration(seconds: 5)); // 延遲幾秒再重試
      }
    }

    return responseText;
  }
}
