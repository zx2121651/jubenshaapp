import { useMemo, useState } from 'react'
import { App, Button, Card, Input, Rate, Select, Space, Table, Tag, Tooltip } from 'antd'
import type { TableProps } from 'antd'
import { PlusOutlined, SearchOutlined } from '@ant-design/icons'
import { scripts } from '../data/mock'
import type { ScriptRow } from '../data/mock'

const categoryList = [...new Set(scripts.map((s) => s.category))]

const statusMeta: Record<
  ScriptRow['status'],
  { color: string; label: string }
> = {
  online: { color: 'green', label: '已上架' },
  offline: { color: 'default', label: '已下架' },
  pending: { color: 'gold', label: '待审核' },
}

export default function Scripts() {
  const { modal } = App.useApp()
  const [keyword, setKeyword] = useState('')
  const [category, setCategory] = useState<string>('all')
  const [status, setStatus] = useState<string>('all')
  const [data, setData] = useState(scripts)

  const rows = useMemo(() => {
    return data.filter((s) => {
      const kw = keyword.trim().toLowerCase()
      const matchKw = !kw || s.title.toLowerCase().includes(kw)
      const matchC = category === 'all' || s.category === category
      const matchS = status === 'all' || s.status === status
      return matchKw && matchC && matchS
    })
  }, [data, keyword, category, status])

  const toggleStatus = (id: string, action: ScriptRow['status']) => {
    setData((d) => d.map((s) => (s.id === id ? { ...s, status: action } : s)))
    const label = action === 'online' ? '通过并上架' : '下架'
    modal.success({ title: `${label}成功`, content: `剧本 ${id} 已${label}（模拟操作）` })
  }

  const columns: TableProps<ScriptRow>['columns'] = [
    { title: 'ID', dataIndex: 'id' },
    {
      title: '剧本名称',
      dataIndex: 'title',
      render: (v: string) => <b>{v}</b>,
    },
    { title: '作者', dataIndex: 'author' },
    { title: '分类', dataIndex: 'category' },
    { title: '难度', dataIndex: 'difficulty' },
    { title: '时长(s)', dataIndex: 'duration', sorter: (a, b) => a.duration - b.duration },
    { title: '游玩数', dataIndex: 'plays', sorter: (a, b) => a.plays - b.plays },
    {
      title: '评分',
      dataIndex: 'rating',
      render: (v: number) => <Rate disabled allowHalf value={v} />,
      sorter: (a, b) => a.rating - b.rating,
    },
    {
      title: '状态',
      dataIndex: 'status',
      render: (v: ScriptRow['status']) => (
        <Tag color={statusMeta[v].color}>{statusMeta[v].label}</Tag>
      ),
    },
    {
      title: '操作',
      render: (_, r) =>
        r.status === 'pending' ? (
          <Space>
            <Button type="primary" size="small" onClick={() => toggleStatus(r.id, 'online')}>
              审核通过
            </Button>
            <Button danger size="small" onClick={() => toggleStatus(r.id, 'offline')}>
              驳回
            </Button>
          </Space>
        ) : (
          <Tooltip title="切换上架状态">
            <Button
              size="small"
              onClick={() => toggleStatus(r.id, r.status === 'online' ? 'offline' : 'online')}
            >
              {r.status === 'online' ? '下架' : '上架'}
            </Button>
          </Tooltip>
        ),
    },
  ]

  return (
    <Card
      title="剧本管理"
      extra={
        <Space>
          <Button>导入剧本</Button>
          <Button type="primary" icon={<PlusOutlined />}>
            新建剧本
          </Button>
        </Space>
      }
    >
      <Space style={{ marginBottom: 16 }}>
        <Input
          allowClear
          prefix={<SearchOutlined />}
          placeholder="搜索剧本"
          style={{ width: 220 }}
          value={keyword}
          onChange={(e) => setKeyword(e.target.value)}
        />
        <Select
          style={{ width: 140 }}
          value={category}
          onChange={setCategory}
          options={[{ value: 'all', label: '全部分类' }, ...categoryList.map((c) => ({ value: c, label: c }))]}
        />
        <Select
          style={{ width: 140 }}
          value={status}
          onChange={setStatus}
          options={[
            { value: 'all', label: '全部状态' },
            { value: 'online', label: '已上架' },
            { value: 'offline', label: '已下架' },
            { value: 'pending', label: '待审核' },
          ]}
        />
      </Space>
      <Table rowKey="id" columns={columns} dataSource={rows} pagination={{ pageSize: 6 }} />
    </Card>
  )
}