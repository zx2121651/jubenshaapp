// 操作日志（审计）微型 store：模块级数组 + 订阅，供各页面记录后台操作。
import { useSyncExternalStore } from 'react'

export type LogType = 'auth' | 'user' | 'script' | 'room' | 'announcement' | 'review'

export interface LogEntry {
  id: number
  time: string
  type: LogType
  actor: string
  action: string
  detail: string
}

const STORAGE_KEY = 'admin_logs'

// 预置几条演示日志，保证日志页打开即有内容。
const seed: LogEntry[] = [
  {
    id: 1,
    time: '2026-09-10 09:12',
    type: 'auth',
    actor: '超级管理员',
    action: '登录系统',
    detail: '通过账号密码进入后台',
  },
  {
    id: 2,
    time: '2026-09-10 10:35',
    type: 'script',
    actor: '超级管理员',
    action: '审核通过',
    detail: '剧本 S106《轮回棋局》通过并上架',
  },
  {
    id: 3,
    time: '2026-09-10 11:47',
    type: 'room',
    actor: '超级管理员',
    action: '强制解散',
    detail: '房间 R8893《血月金矿》已解散',
  },
]

let logs: LogEntry[] = load()

function load(): LogEntry[] {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (raw) return JSON.parse(raw) as LogEntry[]
  } catch {
    /* ignore */
  }
  return seed
}

function save() {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(logs.slice(0, 100)))
  } catch {
    /* ignore */
  }
}

let nid = seed.reduce((m, l) => Math.max(m, l.id), 0)
let listeners = new Set<() => void>()

function emit() {
  listeners.forEach((l) => l())
}

/** 记录一条操作日志。 */
export function pushLog(entry: Omit<LogEntry, 'id' | 'time'>) {
  const now = new Date()
  const pad = (v: number) => String(v).padStart(2, '0')
  const time = `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())} ${pad(
    now.getHours(),
  )}:${pad(now.getMinutes())}`
  logs = [{ id: ++nid, time, ...entry }, ...logs].slice(0, 100)
  save()
  emit()
}

export function getLogs(): LogEntry[] {
  return logs
}

function subscribe(cb: () => void) {
  listeners.add(cb)
  return () => {
    listeners.delete(cb)
  }
}

/** React Hook：订阅日志列表，变更时自动重渲染。 */
export function useLogs(): LogEntry[] {
  return useSyncExternalStore(subscribe, getLogs)
}