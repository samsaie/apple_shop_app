part of 'comment_bloc.dart';

@immutable
abstract class CommentEvent {}

class CommentInitializeEvent extends CommentEvent {
  final String productId;

  CommentInitializeEvent(this.productId);
}

class CommentPostEvent extends CommentEvent {
  final String productId;
  final String comment;
  CommentPostEvent(this.productId, this.comment);
}
