import { useMemo, useState } from 'react'
import { App, Button, Card, Select, Space, Table, Tag } from 'antd'
import type { TableProps } from 'antd'
import { useLogs } from '../data/logStore'
import type { LogEntry, LogType } from '../data/logStore'
import { AuditOutlined, DownloadOutlined } from '@ant-design/icons'
import { useAuth } from '../auth/AuthContext'
import { exportCsv } from '../utils/exportCsv'

const typeMeta: Record<LogType, { color: string; label: string }> = {
  auth: { color: 'purple', label: '登录' },
  user: { color: 'cyan', label: '用户' },
  script: { color: 'gold', label: '剧本' },
  room: { color: 'green', label: '房间' },
  announcement: { color: 'blue', label: '公告' },
  review: { color: 'orange', label: '评论' },
}

export default function Logs() {
  const { message } = App.useApp()
  const logs = useLogs()
  const { user } = useAuth()
  const [type, setType] = useState<string>('all')

  const rows = useMemo(
    () => logs.filter((l) => type === 'all' || l.type === type),
    [logs, type],
  )

  const doExport = () => {
    exportCsv(
      `操作日志_${new Date().toISOString().slice(0, 10)}.csv`,
      ['时间', '类型', '操作人', '操作', '详情'],
      rows.map((l) => [l.time, typeMeta[l.type].label, l.actor, l.action, l.detail]),
    )
    message.success(`已导出 ${rows.length} 条日志（模拟操作）`)
  }

  const columns: TableProps<LogEntry>['columns'] = [
    { title: '时间', dataIndex: 'time', width: 160 },
    {
      title: '类型',
      dataIndex: 'type',
      width: 90,
      render: (v: LogType) => <Tag color={typeMeta[v].color}>{typeMeta[v].label}</Tag>,
    },
    { title: '操作人', dataIndex: 'actor', width: 140 },
    { title: '操作', dataIndex: 'action', width: 140 },
    { title: '详情', dataIndex: 'detail' },
  ]

  return (
    <Card
      title="操作日志"
      extra={
        <Space>
          <Button icon={<DownloadOutlined />} onClick={doExport}>
            导出 CSV
          </Button>
          <AuditOutlined style={{ color: 'rgba(255,255,255,.35)' }} />
          <span style={{ color: 'rgba(255,255,255,.45)', fontSize: 13 }}>
            当前账号：{user ?? '管理员'}
          </span>
        </Space>
      }
    >
      <Space style={{ marginBottom: 16 }}>
        <Select
          style={{ width: 140 }}
          value={type}
          onChange={setType}
          options={[
            { value: 'all', label: '全部类型' },
            { value: 'auth', label: '登录' },
            { value: 'user', label: '用户' },
            { value: 'script', label: '剧本' },
            { value: 'room', label: '房间' },
            { value: 'announcement', label: '公告' },
            { value: 'review', label: '评论' },
          ]}
        />
      </Space>
      <Table
        rowKey="id"
        columns={columns}
        dataSource={rows}
        pagination={{ pageSize: 10 }}
        locale={{ emptyText: '暂无操作记录' }}
      />
    </Card>
  )
}