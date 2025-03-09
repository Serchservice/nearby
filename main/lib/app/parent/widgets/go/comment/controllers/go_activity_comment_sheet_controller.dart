import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart' show TextEditingController;
import 'package:get/get.dart';
import 'package:smart/smart.dart';

import 'go_activity_comment_sheet_state.dart';

class GoActivityCommentSheetController extends GetxController {
  final List<GoActivityComment> comments;
  final String activity;
  final GoActivityCommentListUpdated onUpdated;
  final bool canComment;
  GoActivityCommentSheetController({
    required this.comments,
    required this.activity,
    required this.onUpdated,
    required this.canComment
  });

  final GoActivityCommentSheetState state = GoActivityCommentSheetState();

  final ConnectService _connect = Connect();

  final int _pageSize = 20;
  late PagedController<int, GoActivityComment> commentController;

  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    int firstPage = 0;

    if(comments.isNotEmpty) {
      commentController = PagedController.fromValue(
        Paged<int, GoActivityComment>(itemList: comments, nextPageKey: (comments.length / _pageSize).toInt()),
        firstPageKey: firstPage
      );
    } else {
      commentController = PagedController(firstPageKey: firstPage);
    }
    commentController.addPageRequestListener(_fetch);
    _prepareInfo();

    super.onInit();
  }

  void _prepareInfo() {
    (commentController.itemList ?? []).any((GoActivityComment c) => c.isCurrentUser)
        ? state.info.value = "You have already commented your experience on this activity."
        : state.info.value = info;
  }

  void _fetch(int page) async {
    _connect.get(endpoint: "/go/comment/$activity?page=$page&size=$_pageSize").then((Outcome response) {
      if(response.isSuccessful) {
        List<dynamic> list = response.data;
        List<GoActivityComment> comments = list.map((dynamic item) => GoActivityComment.fromJson(item)).toList();
        final isLastPage = comments.length.isLessThan(_pageSize);

        if(isLastPage) {
          commentController.appendLastPage(comments);
        } else {
          commentController.appendPage(comments, page + 1);
        }

        _prepareInfo();
        onUpdated(commentController.itemList ?? []);
      } else {
        commentController.error = response.message;
      }
    });
  }

  String get info => Database.instance.auth.isLoggedIn
      ? "Comment is reserved for users that attended this activity or you might have commented."
      : "Log in to comment your experience on this activity.";

  bool get showCommentField => canComment;

  bool get canPost => textController.text.isNotEmpty;

  void comment() async {
    if(canPost) {
      state.isCommenting.value = true;
      JsonMap payload = {
        "id": activity,
        "comment": textController.text.trim()
      };

      _connect.post(endpoint: "/go/comment", body: payload).then((Outcome response) {
        if(response.isSuccessful) {
          textController.clear();
          GoActivityComment comment = GoActivityComment.fromJson(response.data);

          List<GoActivityComment> comments = List.from(commentController.value.itemList ?? []);
          int index = comments.indexWhere((GoActivityComment c) => c.id.equals(comment.id));
          if(index.notEquals(-1)) {
            comments[index] = comment;
          } else {
            comments.insert(0, comment);
          }

          state.isCommenting.value = false;

          commentController.itemList = comments;
          onUpdated(comments);
        } else {
          state.isCommenting.value = false;
          notify.tip(message: response.message, color: CommonColors.instance.error);
        }
      });
    } else {
      notify.tip(message: "Please enter a comment", color: CommonColors.instance.error);
    }
  }

  @override
  void onClose() {
    commentController.removePageRequestListener(_fetch);
    commentController.dispose();
    textController.dispose();

    super.onClose();
  }
}