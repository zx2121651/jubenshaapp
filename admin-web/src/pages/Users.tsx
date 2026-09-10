import { useMemo, useState } from 'react'
import {
  App,
  Avatar,
  Button,
  Card,
  Drawer,
  Form,
  Input,
  InputNumber,
  Select,
  Space,
  Switch,
  Table,
  Tag,
} from 'antd'
import type { TableProps } from 'antd'
import { EditOutlined, PlusOutlined, SearchOutlined } from '@ant-design/icons'
import { users } from '../data/mock'
import type { UserRow } from '../data/mock'
import { usePersistentState } from '../hooks/usePersistentState'
import { pushLog } from '../data/logStore'
import { useAuth } from '../auth/AuthContext'

const roleColor: Record<string, string> = {
  玩家: 'default',
  作者: 'purple',
  主持人: 'cyan',
  管理员: 'gold',
}

export default function Users() {
  const { message } = App.useApp()
  const { user } = useAuth()
  const [keyword, setKeyword] = useState('')
  const [role, setRole] = useState<string>('all')
  const [showBanned, setShowBanned] = useState(false)
  const [data, setData] = usePersistentState<UserRow[]>('admin_users', users)
  const [open, setOpen] = useState(false)
  const [editing, setEditing] = useState<UserRow | null>(null)
  const [form] = Form.useForm()

  const rows = useMemo(() => {
    return data.filter((u) => {
      const kw = keyword.trim().toLowerCase()
      const matchKw = !kw || u.name.toLowerCase().includes(kw) || u.phone.includes(kw)
      const matchRole = role === 'all' || u.role === role
      const matchBan = showBanned || u.status === 'normal'
      return matchKw && matchRole && matchBan
    })
  }, [data, keyword, role, showBanned])

  const openCreate = () => {
    setEditing(null)
    form.resetFields()
    setOpen(true)
  }

  const openEdit = (r: UserRow) => {
    setEditing(r)
    form.setFieldsValue(r)
    setOpen(true)
  }

  const submit = () => {
    form.validateFields().then((values) => {
      if (editing) {
        setData((d) => d.map((u) => (u.id === editing.id ? { ...u, ...values } : u)))
        pushLog({ type: 'user', actor: user ?? '管理员', action: '编辑用户', detail: `修改用户 ${editing.id}「${values.name}」资料` })
        message.success(`已更新用户 ${editing.id}（模拟操作）`)
      } else {
        const newRow: UserRow = {
          id: `U${Math.floor(1000 + Math.random() * 9000)}`,
          phone: values.phone || '188****0000',
          score: values.score ?? 0,
          status: 'normal',
          regDate: new Date().toISOString().slice(0, 10),
          ...values,
        }
        setData((d) => [newRow, ...d])
        pushLog({ type: 'user', actor: user ?? '管理员', action: '新增用户', detail: `创建账号「${values.name}」${newRow.id}` })
        message.success(`已新增用户「${values.name}」（模拟操作）`)
      }
      setOpen(false)
    })
  }

  const toggle = (id: string, banned: boolean) => {
    const target = data.find((u) => u.id === id)
    setData((d) =>
      d.map((u) => (u.id === id ? { ...u, status: banned ? 'banned' : 'normal' } : u)),
    )
    pushLog({ type: 'user', actor: user ?? '管理员', action: banned ? '封禁用户' : '解封用户', detail: `${banned ? '封禁' : '解封'} ${id}「${target?.name ?? ''}」` })
    message.success(`${id} ${banned ? '已封禁' : '已解封'}（模拟操作）`)
  }

  const columns: TableProps<UserRow>['columns'] = [
    {
      title: '用户',
      dataIndex: 'name',
      render: (_, r) => (
        <Space>
          <Avatar style={{ background: '#7c5cff' }}>{r.name.charAt(0)}</Avatar>
          <div>
            <div style={{ fontWeight: 600 }}>{r.name}</div>
            <div style={{ color: 'rgba(255,255,255,.4)', fontSize: 12 }}>{r.phone}</div>
          </div>
        </Space>
      ),
    },
    { title: 'ID', dataIndex: 'id' },
    {
      title: '角色',
      dataIndex: 'role',
      render: (v: string) => <Tag color={roleColor[v]}>{v}</Tag>,
      filters: [
        { text: '玩家', value: '玩家' },
        { text: '作者', value: '作者' },
        { text: '主持人', value: '主持人' },
      ],
      onFilter: (value, r) => r.role === value,
    },
    { title: '侦探等级', dataIndex: 'level' },
    { title: '积分', dataIndex: 'score', sorter: (a, b) => a.score - b.score },
    {
      title: '状态',
      dataIndex: 'status',
      render: (v: UserRow['status']) =>
        v === 'normal' ? <Tag color="green">正常</Tag> : <Tag color="red">已封禁</Tag>,
    },
    { title: '注册时间', dataIndex: 'regDate' },
    {
      title: '操作',
      render: (_, r) => (
        <Space>
          <Button size="small" icon={<EditOutlined />} onClick={() => openEdit(r)}>
            编辑
          </Button>
          <Button size="small" danger={r.status === 'normal'} onClick={() => toggle(r.id, r.status === 'normal')}>
            {r.status === 'normal' ? '封禁' : '解封'}
          </Button>
        </Space>
      ),
    },
  ]

  return (
    <>
      <Card
        title="用户管理"
        extra={
          <Button type="primary" icon={<PlusOutlined />} onClick={openCreate}>
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
          checked={showBanned}
          onChange={setShowBanned}
        />
        </Space>
        <Table
          rowKey="id"
          columns={columns}
          dataSource={rows}
          pagination={{ pageSize: 6 }}
        />
      </Card>

      <Drawer
        title={editing ? `编辑用户 ${editing.id}` : '新建账号'}
        size={420}
        open={open}
        onClose={() => setOpen(false)}
        extra={
          <Space>
            <Button onClick={() => setOpen(false)}>取消</Button>
            <Button type="primary" onClick={submit}>
              保存
            </Button>
          </Space>
        }
      >
        <Form form={form} layout="vertical">
          <Form.Item name="name" label="昵称" rules={[{ required: true, message: '请输入昵称' }]}>
            <Input placeholder="用户昵称" />
          </Form.Item>
          <Form.Item name="phone" label="手机号">
            <Input placeholder="138****0000" />
          </Form.Item>
          <Form.Item name="role" label="角色" rules={[{ required: true, message: '请选择角色' }]}>
            <Select
              placeholder="请选择角色"
              options={[
                { value: '玩家', label: '玩家' },
                { value: '作者', label: '作者' },
                { value: '主持人', label: '主持人' },
                { value: '管理员', label: '管理员' },
              ]}
            />
          </Form.Item>
          <Form.Item name="level" label="侦探等级">
            <Select
              placeholder="请选择等级"
              options={['见习侦探', '中级侦探', '高级侦探', '名侦探'].map((v) => ({
                value: v,
                label: v,
              }))}
            />
          </Form.Item>
          <Form.Item name="score" label="积分">
            <InputNumber min={0} style={{ width: '100%' }} />
          </Form.Item>
        </Form>
      </Drawer>
    </>
  )
}