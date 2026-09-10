// 平台公告 store：模块级数组 + 订阅 + localStorage 持久化。
// 供公告管理页 CRUD、看板展示公告共用，保证数据一致。
import { useSyncExternalStore } from 'react'
import { announcements, type AnnouncementRow } from './mock'

const STORAGE_KEY = 'admin_announcements'

let list: AnnouncementRow[] = load()

function load(): AnnouncementRow[] {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (raw) return JSON.parse(raw) as AnnouncementRow[]
  } catch {
    /* ignore */
  }
  return announcements
}

function save() {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(list))
  } catch {
    /* ignore */
  }
}

let nid = announcements.reduce((m, a) => Math.max(m, Number(a.id.slice(1))), 0)
let listeners = new Set<() => void>()

function emit() {
  listeners.forEach((l) => l())
}

export function getAnnouncements(): AnnouncementRow[] {
  return list
}

/** 新增公告（草稿），返回生成的 id。 */
export function addAnnouncement(data: Omit<AnnouncementRow, 'id' | 'status' | 'publishTime' | 'createTime'>) {
  const now = new Date().toISOString().slice(0, 10)
  const row: AnnouncementRow = {
    id: `A${++nid}`,
    status: 'draft',
    publishTime: '-',
    createTime: now,
    ...data,
  }
  list = [row, ...list]
  save()
  emit()
  return row
}

/** 更新公告标题 / 类型 / 内容。 */
export function updateAnnouncement(id: string, data: Partial<Pick<AnnouncementRow, 'title' | 'type' | 'content'>>) {
  list = list.map((a) => (a.id === id ? { ...a, ...data } : a))
  save()
  emit()
}

/** 发布 / 下线。 */
export function setAnnouncementStatus(id: string, status: AnnouncementRow['status']) {
  const now = new Date()
  const pad = (v: number) => String(v).padStart(2, '0')
  const time = `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())} ${pad(now.getHours())}:${pad(now.getMinutes())}`
  list = list.map((a) =>
    a.id === id ? { ...a, status, publishTime: status === 'published' ? time : a.publishTime } : a,
  )
  save()
  emit()
}

export function removeAnnouncement(id: string) {
  list = list.filter((a) => a.id !== id)
  save()
  emit()
}

function subscribe(cb: () => void) {
  listeners.add(cb)
  return () => {
    listeners.delete(cb)
  }
}

/** React Hook：订阅公告列表，变更时自动重渲染。 */
export function useAnnouncements(): AnnouncementRow[] {
  return useSyncExternalStore(subscribe, getAnnouncements)
}