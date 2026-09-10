import { useState } from 'react'
import { App, Button, Card, Space, Switch, Table, Tag, Input } from 'antd'
import type { TableProps } from 'antd'
import { PlusOutlined, UserAddOutlined } from '@ant-design/icons'
import { permissionSchema, roleMatrix } from '../data/mock'

interface RoleRow {
  role: string
  color: string
  perms: boolean[]
  members: number
}

const initial: RoleRow[] = roleMatrix.map((r, i) => ({
  role: r.role,
  color: r.color,
  perms: [...r.perms],
  members: 3 + i * 2,
}))

export default function Permissions() {
  const { message } = App.useApp()
  const [rows, setRows] = useState<RoleRow[]>(initial)
  const [newRole, setNewRole] = useState('')

  const togglePerm = (ri: number, pi: number, v: boolean) => {
    setRows((rs) =>
      rs.map((r, i) =>
        i === ri ? { ...r, perms: r.perms.map((p, j) => (j === pi ? v : p)) } : r,
      ),
    )
  }

  const addRole = () => {
    const name = newRole.trim()
    if (!name) return
    setRows((rs) => [...rs, { role: name, color: '#4dc8ff', perms: permissionSchema.map(() => false), members: 0 }])
    setNewRole('')
    message.success(`已新增角色「${name}」（模拟操作）`)
  }

  const deleteRole = (name: string) => {
    if (name === '超级管理员') {
      message.warning('超级管理员不可删除')
      return
    }
    setRows((rs) => rs.filter((r) => r.role !== name))
    message.success(`已删除角色「${name}」（模拟操作）`)
  }

  const columns: TableProps<RoleRow>['columns'] = [
    {
      title: '角色',
      dataIndex: 'role',
      render: (v: string, r) => <Tag color={r.color}>{v}</Tag>,
    },
    { title: '成员数', dataIndex: 'members' },
    ...permissionSchema.map((p, pi) => ({
      title: p,
      key: p,
      render: (_: unknown, r: RoleRow, ri: number) => (
        <Switch
          size="small"
          checked={r.perms[pi]}
          disabled={r.role === '超级管理员'}
          onChange={(v) => togglePerm(ri, pi, v)}
        />
      ),
    })),
    {
      title: '操作',
      key: 'op',
      render: (_, r) => (
        <Button size="small" danger disabled={r.role === '超级管理员'} onClick={() => deleteRole(r.role)}>
          删除
        </Button>
      ),
    },
  ]

  return (
    <Card
      title="权限管理 · RBAC 角色矩阵"
      extra={<Button type="primary" icon={<PlusOutlined />} onClick={addRole}>新增角色</Button>}
    >
      <Space style={{ marginBottom: 16 }}>
        <Input
          placeholder="输入新角色名"
          style={{ width: 200 }}
          value={newRole}
          onChange={(e) => setNewRole(e.target.value)}
          onPressEnter={addRole}
        />
        <Button icon={<UserAddOutlined />} onClick={() => message.info('跳转成员分配页（模拟）')}>
          成员分配
        </Button>
      </Space>
      <Table
        rowKey="role"
        columns={columns}
        dataSource={rows}
        pagination={false}
        scroll={{ x: 'max-content' }}
      />
    </Card>
  )
}