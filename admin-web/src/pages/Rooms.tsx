import { useMemo, useState } from 'react'
import { App, Button, Card, Progress, Space, Table, Tag } from 'antd'
import type { TableProps } from 'antd'
import { ReloadOutlined, StopOutlined } from '@ant-design/icons'
import { rooms } from '../data/mock'
import type { RoomRow } from '../data/mock'

const statusMeta: Record<RoomRow['status'], { color: string; label: string }> = {
  waiting: { color: 'gold', label: '等待开局' },
  'in-progress': { color: 'green', label: '进行中' },
  finished: { color: 'default', label: '已结束' },
}

export default function Rooms() {
  const { modal } = App.useApp()
  const [data, setData] = useState(rooms)

  const stats = useMemo(() => {
    const active = data.filter((r) => r.status === 'in-progress').length
    const waiting = data.filter((r) => r.status === 'waiting').length
    const total = data.length
    return { active, waiting, total }
  }, [data])

  const dismiss = (r: RoomRow) => {
    modal.confirm({
      title: `确认解散房间 ${r.id}？`,
      content: `剧本《${r.script}》当前 ${r.players} 名玩家将全部退出，此操作不可撤销。`,
      onOk: () => {
        setData((d) => d.filter((x) => x.id !== r.id))
        modal.success({ title: '已解散', content: `房间 ${r.id} 已强制解散（模拟操作）` })
      },
    })
  }

  const columns: TableProps<RoomRow>['columns'] = [
    { title: '房间号', dataIndex: 'id', render: (v: string) => <b>{v}</b> },
    { title: '剧本', dataIndex: 'script' },
    { title: '房主', dataIndex: 'host' },
    {
      title: '人数',
      key: 'players',
      render: (_, r) => (
        <div style={{ width: 120 }}>
          <Progress
            percent={Math.round((r.players / r.capacity) * 100)}
            strokeColor={r.players === r.capacity ? '#37c99a' : '#7c5cff'}
          />
          <span style={{ fontSize: 12, color: 'rgba(255,255,255,.5)' }}>
            {r.players}/{r.capacity}
          </span>
        </div>
      ),
      sorter: (a, b) => a.players - b.players,
    },
    { title: '阶段', dataIndex: 'stage' },
    {
      title: '状态',
      dataIndex: 'status',
      render: (v: RoomRow['status']) => (
        <Tag color={statusMeta[v].color}>{statusMeta[v].label}</Tag>
      ),
    },
    { title: '开局时间', dataIndex: 'createdAt' },
    {
      title: '操作',
      render: (_, r) =>
        r.status === 'in-progress' ? (
          <Button danger size="small" icon={<StopOutlined />} onClick={() => dismiss(r)}>
            强制解散
          </Button>
        ) : (
          <Button size="small" disabled icon={<StopOutlined />}>
            强制解散
          </Button>
        ),
    },
  ]

  return (
    <Card
      title="房间 / 组局管理"
      extra={<Button icon={<ReloadOutlined />}>刷新</Button>}
    >
      <Space size={16} style={{ marginBottom: 16 }}>
        <Tag color="green">进行中 {stats.active}</Tag>
        <Tag color="gold">等待开局 {stats.waiting}</Tag>
        <Tag>共 {stats.total} 局</Tag>
      </Space>
      <Table rowKey="id" columns={columns} dataSource={data} pagination={{ pageSize: 6 }} />
    </Card>
  )
}