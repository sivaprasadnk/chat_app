class ChatModel {
  String? name;
  String? icon;
  String? time;
  String? currentMessage;
  bool? isGroup;
  bool? select = false;
  String? lastSeen;
  int? id;
  ChatModel({
    this.currentMessage,
    this.icon,
    this.id,
    this.isGroup,
    this.name,
    this.time,
    this.select,
    this.lastSeen,
  });
}

List<ChatModel> chats = [
  ChatModel(
    id: 1,
    name: 'Hari',
    currentMessage: 'hello!',
    time: '6:00',
    icon: 'person.svg',
    isGroup: false,
    lastSeen: '11:05',
  ),
  ChatModel(
    id: 2,
    name: 'Swetha',
    currentMessage: 'Good Morning!',
    time: '13:00',
    icon: 'person.svg',
    isGroup: false,
    lastSeen: '11:05',
  ),
  ChatModel(
    id: 3,
    name: 'Dev Community',
    currentMessage: 'Hey!',
    time: '11:00',
    icon: 'person.svg',
    isGroup: true,
    lastSeen: '',
  ),
];

List<ChatModel> loginUsers = [
  ChatModel(
    id: 1,
    name: 'Hari',
    currentMessage: 'hello!',
    time: '6:00',
    icon: 'person.svg',
    isGroup: false,
  ),
  ChatModel(
    id: 2,
    name: 'Swetha',
    currentMessage: 'Good Morning!',
    time: '13:00',
    icon: 'person.svg',
    isGroup: false,
  ),
];
