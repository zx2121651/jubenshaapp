import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/script_model.dart';

final scriptListProvider = Provider<List<ScriptModel>>((ref) {
  return [
    ScriptModel(
      id: '1',
      title: '血色婚礼',
      coverUrl:
          'https://images.unsplash.com/photo-1544257121-6d2c4310e303?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
      tags: ['6人', '硬核', '恐怖'],
      authorName: 'DM老猫',
      authorAvatar:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&auto=format&fit=crop&q=60',
      likes: 1250,
      players: 6,
      category: '恐怖',
      durationMins: 270,
    ),
    ScriptModel(
      id: '2',
      title: '长安夜行',
      coverUrl:
          'https://images.unsplash.com/photo-1582200424578-8316c024d353?w=500&auto=format&fit=crop&q=60',
      tags: ['8人', '阵营', '古风'],
      authorName: '沉浸探案',
      authorAvatar:
          'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=100&auto=format&fit=crop&q=60',
      likes: 980,
      players: 8,
      category: '阵营',
      durationMins: 300,
    ),
    ScriptModel(
      id: '3',
      title: '再见，昨天',
      coverUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60',
      tags: ['5人', '情感', '治愈'],
      authorName: '星光剧场',
      authorAvatar:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&auto=format&fit=crop&q=60',
      likes: 2100,
      players: 5,
      category: '情感',
      durationMins: 180,
    ),
    ScriptModel(
      id: '4',
      title: '第四面墙',
      coverUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=500&auto=format&fit=crop&q=60',
      tags: ['4人', '变格', '推理'],
      authorName: '脑洞大开',
      authorAvatar:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&auto=format&fit=crop&q=60',
      likes: 856,
      players: 4,
      category: '硬核',
      durationMins: 210,
    ),
    ScriptModel(
      id: '5',
      title: '诡影寻踪',
      coverUrl:
          'https://images.unsplash.com/photo-1509248961158-e54f6934749c?w=500&auto=format&fit=crop&q=60',
      tags: ['7人', '惊悚', '还原'],
      authorName: '夜幕之下',
      authorAvatar:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&auto=format&fit=crop&q=60',
      likes: 1540,
      players: 7,
      category: '惊悚',
      durationMins: 240,
    ),
    ScriptModel(
      id: '6',
      title: '盛夏的果实',
      coverUrl:
          'https://images.unsplash.com/photo-1505968409348-bd000797c92e?w=500&auto=format&fit=crop&q=60',
      tags: ['6人', '校园', '欢乐'],
      authorName: '青春记忆',
      authorAvatar:
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=100&auto=format&fit=crop&q=60',
      likes: 3200,
      players: 6,
      category: '欢乐',
      durationMins: 120,
    ),
  ];
});