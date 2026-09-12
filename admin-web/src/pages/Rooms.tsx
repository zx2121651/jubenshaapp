import { useMemo, useState } from 'react'
import { App, Button, Card, Col, Input, Progress, Row, Select, Space, Statistic, Table, Tag } from 'antd'
import type { TableProps } from 'antd'
import {
  ReloadOutlined,
  StopOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  TeamOutlined,
  RiseOutlined,
} from '@ant-design/icons'
import { rooms } from '../data/mock'
import type { RoomRow } from '../data/mock'
import { usePersistentState } from '../hooks/usePersistentState'
import { pushLog } from '../data/logStore'
import { useAuth } from '../auth/AuthContext'

const statusMeta: Record<RoomRow['status'], { color: string; label: string }> = {
  waiting: { color: 'gold', label: '等待开局' },
  'in-progress': { color: 'green', label: '进行中' },
  finished: { color: 'default', label: '已结束' },
}

export default function Rooms() {
  const { modal } = App.useApp()
  const { user } = useAuth()
  const [keyword, setKeyword] = useState('')
  const [status, setStatus] = useState<string>('all')
  const [data, setData] = usePersistentState<RoomRow[]>('admin_rooms', rooms)

  const stats = useMemo(() => {
    const active = data.filter((r) => r.status === 'in-progress').length
    const waiting = data.filter((r) => r.status === 'waiting').length
    const finished = data.filter((r) => r.status === 'finished').length
    const total = data.length
    const filled = data.reduce((s, r) => s + r.players, 0)
    const cap = data.reduce((s, r) => s + r.capacity, 0)
    return { active, waiting, finished, total, occupancy: cap ? Math.round((filled / cap) * 100) : 0 }
  }, [data])

  const rows = useMemo(() => {
    const kw = keyword.trim().toLowerCase()
    return data.filter((r) => {
      const matchKw =
        !kw ||
        r.id.toLowerCase().includes(kw) ||
        r.script.toLowerCase().includes(kw) ||
        r.host.toLowerCase().includes(kw)
      const matchS = status === 'all' || r.status === status
      return matchKw && matchS
    })
  }, [data, keyword, status])

  const dismiss = (r: RoomRow) => {
    modal.confirm({
      title: `确认解散房间 ${r.id}？`,
      content: `剧本《${r.script}》当前 ${r.players} 名玩家将全部退出，此操作不可撤销。`,
      onOk: () => {
        setData((d) => d.filter((x) => x.id !== r.id))
        pushLog({ type: 'room', actor: user ?? '管理员', action: '强制解散', detail: `房间 ${r.id}《${r.script}》${r.players} 名玩家已退出` })
        modal.success({ title: '已解散', content: `房间 ${r.id} 已强制解散（模拟操作）` })
      },
    })
  }

  const refresh = () => {
    setKeyword('')
    setStatus('all')
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
      extra={<Button icon={<ReloadOutlined />} onClick={refresh}>刷新</Button>}
    >
      <Row gutter={[16, 16]}>
        <Col xs={12} sm={6}>
          <Card size="small">
            <Statistic title="进行中" value={stats.active} valueStyle={{ color: '#37c99a' }} prefix={<RiseOutlined />} />
          </Card>
        </Col>
        <Col xs={12} sm={6}>
          <Card size="small">
            <Statistic title="等待开局" value={stats.waiting} valueStyle={{ color: '#e0a63c' }} prefix={<ClockCircleOutlined />} />
          </Card>
        </Col>
        <Col xs={12} sm={6}>
          <Card size="small">
            <Statistic title="已结束" value={stats.finished} valueStyle={{ color: 'rgba(255,255,255,.7)' }} prefix={<CheckCircleOutlined />} />
          </Card>
        </Col>
        <Col xs={12} sm={6}>
          <Card size="small">
            <Statistic title="整体上座率" value={stats.occupancy} suffix="%" valueStyle={{ color: '#7c5cff' }} prefix={<TeamOutlined />} />
          </Card>
        </Col>
      </Row>

      <Space style={{ margin: '16px 0' }}>
        <Input
          allowClear
          prefix={<TeamOutlined />}
          placeholder="搜索房间号 / 剧本 / 房主"
          style={{ width: 240 }}
          value={keyword}
          onChange={(e) => setKeyword(e.target.value)}
        />
        <Select
          style={{ width: 130 }}
          value={status}
          onChange={setStatus}
          options={[
            { value: 'all', label: '全部状态' },
            { value: 'waiting', label: '等待开局' },
            { value: 'in-progress', label: '进行中' },
            { value: 'finished', label: '已结束' },
          ]}
        />
        <Tag color="green">进行中 {stats.active}</Tag>
        <Tag color="gold">等待开局 {stats.waiting}</Tag>
        <Tag>共 {stats.total} 局</Tag>
      </Space>
      <Table rowKey="id" columns={columns} dataSource={rows} pagination={{ pageSize: 6 }} />
    </Card>
  )
}