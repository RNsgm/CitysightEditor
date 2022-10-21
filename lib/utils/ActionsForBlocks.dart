class ActionParam{
  ActionParam({required this.id, required this.action});
  String id;
  BlockAction action;
}

enum BlockAction{
  UP,
  DOWN,
  DELETE,
  NONE
}