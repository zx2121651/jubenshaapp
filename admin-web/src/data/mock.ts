// 后台管理系统 Mock 数据 —— 与 App 端剧本杀业务对齐。

export interface UserRow {
  id: string
  name: string
  phone: string
  role: string
  level: string
  score: number
  status: 'normal' | 'banned'
  regDate: string
}

export const users: UserRow[] = [
  { id: 'U1001', name: '草莓甜心派', phone: '138****2091', role: '玩家', level: '名侦探', score: 1280, status: 'normal', regDate: '2024-03-11' },
  { id: 'U1002', name: '露水之情', phone: '139****7723', role: '玩家', level: '高级侦探', score: 864, status: 'normal', regDate: '2024-05-02' },
  { id: 'U1003', name: '掌灯人', phone: '150****3318', role: '作者', level: '见习侦探', score: 320, status: 'banned', regDate: '2024-06-17' },
  { id: 'U1004', name: '夜枭', phone: '186****9044', role: '主持人', level: '名侦探', score: 1520, status: 'normal', regDate: '2024-01-25' },
  { id: 'U1005', name: '墨笔', phone: '133****5561', role: '作者', level: '高级侦探', score: 976, status: 'normal', regDate: '2024-04-09' },
  { id: 'U1006', name: '赫赫什么', phone: '137****8820', role: '玩家', level: '中级侦探', score: 512, status: 'normal', regDate: '2024-08-13' },
  { id: 'U1007', name: '灰暗先生', phone: '188****4177', role: '玩家', level: '见习侦探', score: 210, status: 'banned', regDate: '2025-01-06' },
  { id: 'U1008', name: '南巷', phone: '135****2298', role: '主持人', level: '名侦探', score: 1788, status: 'normal', regDate: '2023-11-30' },
  { id: 'U1009', name: '白夜川', phone: '151****6632', role: '玩家', level: '高级侦探', score: 740, status: 'normal', regDate: '2024-09-21' },
  { id: 'U1010', name: '十一', phone: '189****3085', role: '作者', level: '名侦探', score: 2014, status: 'normal', regDate: '2023-10-15' },
]

export type ScriptStatus = 'online' | 'offline' | 'pending'

export interface ScriptRow {
  id: string
  title: string
  author: string
  category: string
  difficulty: string
  duration: number
  plays: number
  rating: number
  status: ScriptStatus
  desc: string
  price: number
  tags: string[]
}

export const scripts: ScriptRow[] = [
  { id: 'S101', title: '暗杀网络小说家', author: '墨笔', category: '推理', difficulty: '进阶', duration: 300, plays: 12840, rating: 4.8, status: 'online', desc: '一场发生在作家公寓的离奇凶案，七名嫌疑人各怀秘密，真相藏在被撕碎的手稿之中。', price: 88, tags: ['本格', '密室', '还原'] },
  { id: 'S102', title: '血色婚礼', author: '十一', category: '恐怖', difficulty: '困难', duration: 360, plays: 9321, rating: 4.6, status: 'online', desc: '婚礼现场的突然死亡，让宾客席变成审讯室。爱与恨交织，人人都有动机。', price: 98, tags: ['变格', '恐怖', '情感'] },
  { id: 'S103', title: '孤岛疑云', author: '白夜川', category: '推理', difficulty: '新手', duration: 240, plays: 15204, rating: 4.5, status: 'online', desc: '风暴将至的孤岛旅馆，十二名旅客被困于此，凶手就藏在其中。', price: 78, tags: ['本格', '暴风雪山庄'] },
  { id: 'S104', title: '钟楼怪谈', author: '掌灯人', category: '惊悚', difficulty: '进阶', duration: 300, plays: 6110, rating: 4.2, status: 'offline', desc: '钟楼敲响第十二下时，迷雾中出现的身影带走了最后一个证人。', price: 88, tags: ['变格', '惊悚', '沉浸'] },
  { id: 'S105', title: '豪门恩怨', author: '南巷', category: '情感', difficulty: '新手', duration: 240, plays: 18977, rating: 4.9, status: 'online', desc: '豪门家族遗产争夺夜，老爷子留下一句遗言，恩怨在此终结。', price: 68, tags: ['情感', '豪门', '欢乐'] },
  { id: 'S106', title: '轮回棋局', author: '夜枭', category: '科幻', difficulty: '困难', duration: 360, plays: 4488, rating: 4.0, status: 'pending', desc: '一局无法结束的棋局，执棋者陷入循环，唯有找出破局之人。', price: 108, tags: ['科幻', '烧脑', '进阶'] },
  { id: 'S107', title: '雪夜列车', author: '赫赫什么', category: '推理', difficulty: '进阶', duration: 270, plays: 7355, rating: 4.4, status: 'online', desc: '暴雪夜的高原列车，乘客与乘务员之间暗流涌动，一场精心策划的谋杀正在上演。', price: 92, tags: ['本格', '密室', '硬核'] },
  { id: 'S108', title: '迷雾剧场', author: '灰暗先生', category: '惊悚', difficulty: '新手', duration: 210, plays: 12110, rating: 4.7, status: 'pending', desc: '剧场落幕之后，主演倒在舞台中央，幕后黑手藏在观众席之间。', price: 72, tags: ['变格', '剧场', '新手'] },
]

export type RoomStatus = 'waiting' | 'in-progress' | 'finished'

export interface RoomRow {
  id: string
  script: string
  host: string
  players: number
  capacity: number
  stage: string
  status: RoomStatus
  createdAt: string
}

export const rooms: RoomRow[] = [
  { id: 'R8821', script: '暗杀网络小说家', host: '草莓甜心派', players: 8, capacity: 10, stage: '搜证阶段', status: 'in-progress', createdAt: '2026-09-10 13:20' },
  { id: 'R8834', script: '豪门恩怨', host: '南巷', players: 4, capacity: 7, stage: '等待开局', status: 'waiting', createdAt: '2026-09-10 12:41' },
  { id: 'R8850', script: '雪夜列车', host: '夜枭', players: 10, capacity: 10, stage: '投票阶段', status: 'in-progress', createdAt: '2026-09-10 11:55' },
  { id: 'R8863', script: '孤岛疑云', host: '露水之情', players: 2, capacity: 6, stage: '等待开局', status: 'waiting', createdAt: '2026-09-10 11:02' },
  { id: 'R8871', script: '雾都孤儿', host: '白夜川', players: 6, capacity: 6, stage: '剧本阅读阶段', status: 'in-progress', createdAt: '2026-09-10 10:30' },
  { id: 'R8889', script: '血月金矿', host: '十一', players: 0, capacity: 8, stage: '等待开局', status: 'waiting', createdAt: '2026-09-09 22:15' },
  { id: 'R8890', script: '暗杀网络小说家', host: '墨笔', players: 8, capacity: 10, stage: '揭晓时刻', status: 'finished', createdAt: '2026-09-09 21:40' },
 { id: 'R8901', script: '钟楼怪谈', host: '掌灯人', players: 5, capacity: 8, stage: '讨论阶段', status: 'in-progress', createdAt: '2026-09-09 20:05' },
]

// 权限矩阵：行=角色，列=模块权限点。
export const permissionSchema = [
  '数据看板',
  '用户管理',
  '剧本管理',
  '房间管理',
  '权限管理',
]

export const roleMatrix = [
  { role: '超级管理员', color: '#7c5cff', perms: [true, true, true, true, true] },
  { role: '运营', color: '#37c99a', perms: [true, true, true, true, false] },
  { role: '客服', color: '#e0a63c', perms: [true, true, false, false, false] },
  { role: '内容审核', color: '#eb5aa7', perms: [false, false, true, true, false] },
]

// 看板指标与趋势。
export const dashMetrics = [
  { key: 'users', label: '累计用户', value: 48213, unit: '人', delta: 12.4, trend: true, color: '#7c5cff' },
  { key: 'todayUsers', label: '今日新增', value: 356, unit: '人', delta: 4.2, trend: true, color: '#37c99a' },
  { key: 'activeRooms', label: '进行中房间', value: 128, unit: '局', delta: -3.1, trend: false, color: '#4dc8ff' },
  { key: 'revenue', label: '本月营收', value: 68240, unit: '元', delta: 8.7, trend: true, color: '#ffb020' },
]

export const trendData = [
  { day: '09-04', users: 290, revenue: 6100, rooms: 118 },
  { day: '09-05', users: 312, revenue: 6400, rooms: 122 },
  { day: '09-06', users: 298, revenue: 5900, rooms: 116 },
  { day: '09-07', users: 356, revenue: 7200, rooms: 131 },
  { day: '09-08', users: 402, revenue: 7800, rooms: 143 },
  { day: '09-09', users: 371, revenue: 7000, rooms: 127 },
  { day: '09-10', users: 384, revenue: 7500, rooms: 135 },
]

export const categoryDist = [
  { name: '推理', value: 128 },
  { name: '恐怖', value: 72 },
  { name: '情感', value: 96 },
  { name: '惊悚', value: 45 },
  { name: '科幻', value: 58 },
]

export type AnnouncementType = 'system' | 'activity' | 'update'
export type AnnouncementStatus = 'draft' | 'published' | 'offline'

export interface AnnouncementRow {
  id: string
  title: string
  type: AnnouncementType
  status: AnnouncementStatus
  content: string
  publishTime: string
  createTime: string
}

export const announcements: AnnouncementRow[] = [
  { id: 'A101', title: '平台服务器例行维护公告', type: 'system', status: 'published', content: '为提升对局稳定性，平台将于今晚 02:00-04:00 进行例行维护，期间暂停组局与匹配，请合理安排游戏时间。', publishTime: '2026-09-08 09:00', createTime: '2026-09-07 15:30' },
  { id: 'A102', title: '中秋主题活动「月圆之夜」上线', type: 'activity', status: 'published', content: '中秋限定剧本《月圆之夜》限时上架，参与活动局可赢取限定头像框与积分翻倍奖励，活动持续至 9 月 20 日。', publishTime: '2026-09-05 12:00', createTime: '2026-09-04 18:20' },
  { id: 'A103', title: '新剧本《雪夜列车》上线', type: 'update', status: 'published', content: '硬核本格新作《雪夜列车》已上架，6-10 人本，时长约 4.5 小时，适合进阶及以上玩家挑战。', publishTime: '2026-09-03 10:00', createTime: '2026-09-02 11:00' },
  { id: 'A104', title: '作者投稿奖励规则调整（草稿）', type: 'update', status: 'draft', content: '拟调整作者投稿奖励：优质剧本首月上架额外获得曝光位，具体细则待评审会后公布。', publishTime: '-', createTime: '2026-09-09 20:10' },
  { id: 'A105', title: '国庆活动方案', type: 'activity', status: 'offline', content: '国庆七天乐活动方案草拟稿，含充值返利、组局任务等玩法，暂缓发布。', publishTime: '2026-09-01 08:00', createTime: '2026-08-30 09:40' },
]