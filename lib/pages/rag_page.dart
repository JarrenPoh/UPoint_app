import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_svg/svg.dart';
import 'package:upoint/globals/bold_text.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/user_model.dart';
import '../api/openai_service.dart';
import '../bloc/rag_page_bloc.dart';
import '../secret.dart';

class RagPage extends StatefulWidget {
  final String hero;
  final UserModel user;
  const RagPage({
    super.key,
    required this.hero,
    required this.user,
  });

  @override
  State<RagPage> createState() => _RagPageState();
}

class _RagPageState extends State<RagPage> with SingleTickerProviderStateMixin {
  late final RagPageBloc _bloc;
  late final TextEditingController _textController;
  late final CColor cColor = CColor.of(context);
  late final AnimationController _animationController;
  late final ScrollController _scrollController; // 添加 ScrollController

  @override
  void initState() {
    super.initState();
    _bloc = RagPageBloc(
      user: types.User(
        id: widget.user.uuid,
      ),
      openAIService: OpenAIService(OPENAI_API_KEY, ASSISTANT_ID),
    );
    _textController = TextEditingController();
    _scrollController = ScrollController(); // 初始化 ScrollController

    // 初始化 AnimationController
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(); // 設置動畫重複執行

    // 載入 Firebase 初始消息
    _bloc.loadInitialMessages(widget.user).then((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose(); // 銷毀 ScrollController
    _bloc.dispose();
    _animationController.dispose(); // 銷毀 AnimationController
    super.dispose();
  }

  void _onSendPressed() async {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      final partialText = types.PartialText(text: text);
      _bloc.handleSendPressed(message: partialText, u: widget.user);
      _textController.clear();
      FocusScope.of(context).unfocus(); // 傳送後收起鍵盤
      _scrollToBottom();
      await _bloc.fetchData(u: widget.user, message: partialText);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      backgroundColor: Colors.transparent,
      onDismissed: () {
        Navigator.of(context).pop();
      },
      direction: DismissiblePageDismissDirection.horizontal,
      isFullScreen: true,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: const Color(0xFF1B202D),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1B202D),
            title: Hero(
              tag: widget.hero,
              child: BoldText(color: Colors.white, size: 18, text: "U碰智能小助手"),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Colors.white,
              size: 20,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width2 * 7),
            child: SafeArea(
              child: Stack(
                children: [
                  // 聊天室內容
                  Positioned.fill(
                    bottom: 60, // 給輸入框留出空間
                    child: SingleChildScrollView(
                      controller: _scrollController, // 綁定 ScrollController
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Dimensions.height5 * 4),
                          // Center(
                          //   child: MediumText(
                          //     color: Colors.white,
                          //     size: 12,
                          //     text: "1 FEB 12:00",
                          //   ),
                          // ),
                          SizedBox(height: Dimensions.height2 * 4),
                          ValueListenableBuilder<List<types.Message>>(
                            valueListenable: _bloc.messagesNotifier,
                            builder: (context, messages, _) {
                              return chatBuild(messages);
                            },
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: _bloc.isLoadingNotifier,
                            builder: (context, isLoading, _) {
                              return isLoading
                                  ? loadingIndicator()
                                  : SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 固定在底部的輸入框
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: Dimensions.height5 * 9,
                      margin: EdgeInsets.all(Dimensions.height2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xFF3D4354),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              cursorColor: Colors.grey.shade500,
                              controller: _textController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "NotoSansMedium",
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                hintStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  left: Dimensions.width2 * 8,
                                  right: Dimensions.width2 * 8,
                                  bottom: Dimensions.height2 * 2,
                                ),
                              ),
                              onSubmitted: (_) => _onSendPressed(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send, color: Colors.white),
                            onPressed: _onSendPressed,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget chatBuild(List<types.Message> messages) {
    return Column(
      children: List.generate(messages.length, (index) {
        bool isUser = messages[index].author.id == _bloc.user.id;
        return Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (isUser)
              myChat(text: (messages[index] as types.TextMessage).text),
            if (!isUser)
              otherChat(text: (messages[index] as types.TextMessage).text),
            SizedBox(height: Dimensions.height2 * 6),
          ],
        );
      }),
    );
  }

  Widget myChat({required String text}) {
    return Align(
      alignment: Alignment.centerRight, // 對齊右側
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Color(0xFF7A8194)),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 20),
        child: MediumText(
          color: Colors.white,
          maxLines: 100,
          size: 14,
          text: text, // 使用傳遞進來的文本
        ),
      ),
    );
  }

  Widget otherChat({required String text}) {
    return Align(
      alignment: Alignment.centerLeft, // 對齊左側
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: cColor.primary,
            ),
            child: SvgPicture.asset(
              width: 22,
              height: 22,
              "assets/robot.svg",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: Dimensions.width5 * 1.5),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xFF373E4E)),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: Dimensions.width2 * 10),
              child: MediumText(
                color: Colors.white,
                maxLines: 100,
                size: 14,
                text: text, // 使用傳遞進來的文本
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadingIndicator() {
    return Align(
      alignment: Alignment.centerLeft, // 顯示在左側
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(right: Dimensions.width2 * 10),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            int dots = 2 + (_animationController.value * 1).round(); // 計算點數
            String dotsText = '.' * dots; // 動態生成點點
            return Text(
              "正在搜尋資料$dotsText",
              style: TextStyle(color: Colors.white, fontSize: 14),
            );
          },
        ),
      ),
    );
  }
}
