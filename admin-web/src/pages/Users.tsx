import { useMemo, useState } from 'react'
import {
  App,
  Avatar,
  Button,
  Card,
  Input,
  Select,
  Space,
  Switch,
  Table,
  Tag,
} from 'antd'
import type { TableProps } from 'antd'
import { SearchOutlined, PlusOutlined } from '@ant-design/icons'
import { users } from '../data/mock'
import type { UserRow } from '../data/mock'

const roleColor: Record<string, string> = {
  玩家: 'default',
  作者: 'purple',
  主持人: 'cyan',
  管理员: 'gold',
}

export default function Users() {
  const { message } = App.useApp()
  const [keyword, setKeyword] = useState('')
  const [role, setRole] = useState<string>('all')
  const [data, setData] = useState(users)

  const rows = useMemo(() => {
    return data.filter((u) => {
      const kw = keyword.trim().toLowerCase()
      const matchKw =
        !kw || u.name.toLowerCase().includes(kw) || u.phone.includes(kw)
      const matchRole = role === 'all' || u.role === role
      return matchKw && matchRole
    })
  }, [data, keyword, role])

  const toggle = (id: string, banned: boolean) => {
    setData((d) =>
      d.map((u) => (u.id === id ? { ...u, status: banned ? 'banned' : 'normal' } : u)),
    )
    message.success(
      `${id} ${banned ? '已封禁' : '已解封'}（模拟操作）`,
    )
  }

  const columns: TableProps<UserRow>['columns'] = [
    {
      title: '用户',
      dataIndex: 'name',
      render: (_, r) => (
        <Space>
          <Avatar style={{ background: '#7c5cff' }}>
            {r.name.charAt(0)}
          </Avatar>
          <div>
            <div style={{ fontWeight: 600 }}>{r.name}</div>
            <div style={{ color: 'rgba(255,255,255,.4)', fontSize: 12 }}>
              {r.phone}
            </div>
          </div>
        </Space>
      ),
    },
    { title: 'ID', dataIndex: 'id' },
    {
      title: '角色',
      dataIndex: 'role',
      render: (v: string) => <Tag color={roleColor[v]}>{v}</Tag>,
      filters: [{ text: '玩家', value: '玩家' }, { text: '作者', value: '作者' }, { text: '主持人', value: '主持人' }],
      onFilter: (value, r) => r.role === value,
    },
    { title: '侦探等级', dataIndex: 'level' },
    { title: '积分', dataIndex: 'score', sorter: (a, b) => a.score - b.score },
    {
      title: '状态',
      dataIndex: 'status',
      render: (v: UserRow['status']) =>
        v === 'normal' ? (
          <Tag color="green">正常</Tag>
        ) : (
          <Tag color="red">已封禁</Tag>
        ),
    },
    { title: '注册时间', dataIndex: 'regDate' },
    {
      title: '操作',
      render: (_, r) => (
        <Space>
          <Button size="small">详情</Button>
          <Button
            size="small"
            danger={r.status === 'normal'}
            onClick={() => toggle(r.id, r.status === 'normal')}
          >
            {r.status === 'normal' ? '封禁' : '解封'}
          </Button>
        </Space>
      ),
    },
  ]

  return (
    <Card
      title="用户管理"
      extra={
        <Button type="primary" icon={<PlusOutlined />}>
          新建账号
        </Button>
      }
    >
      <Space style={{ marginBottom: 16 }}>
        <Input
          allowClear
          prefix={<SearchOutlined />}
          placeholder="搜索昵称 / 手机号"
          style={{ width: 240 }}
          value={keyword}
          onChange={(e) => setKeyword(e.target.value)}
        />
        <Select
          style={{ width: 140 }}
          value={role}
          onChange={setRole}
          options={[
            { value: 'all', label: '全部角色' },
            { value: '玩家', label: '玩家' },
            { value: '作者', label: '作者' },
            { value: '主持人', label: '主持人' },
          ]}
        />
        <Switch
          checkedChildren="含封禁"
          unCheckedChildren="隐藏封禁"
          onChange={(checked) =>
            setData(checked ? users : users.filter((u) => u.status === 'normal'))
          }
        />
      </Space>
      <Table rowKey="id" columns={columns} dataSource={rows} pagination={{ pageSize: 6 }} />
    </Card>
  )
}