import { useMemo, useState } from 'react'
import { App, Button, Card, Form, Input, Modal, Select, Space, Table, Tag } from 'antd'
import type { TableProps } from 'antd'
import { EditOutlined, PlusOutlined, SearchOutlined } from '@ant-design/icons'
import { useAnnouncements, addAnnouncement, updateAnnouncement, setAnnouncementStatus, removeAnnouncement } from '../data/announcementStore'
import type { AnnouncementRow, AnnouncementStatus, AnnouncementType } from '../data/mock'
import { pushLog } from '../data/logStore'
import { useAuth } from '../auth/AuthContext'

const typeMeta: Record<AnnouncementType, { color: string; label: string }> = {
  system: { color: 'blue', label: '系统' },
  activity: { color: 'magenta', label: '活动' },
  update: { color: 'cyan', label: '更新' },
}

const statusMeta: Record<AnnouncementStatus, { color: string; label: string }> = {
  draft: { color: 'default', label: '草稿' },
  published: { color: 'green', label: '已发布' },
  offline: { color: 'red', label: '已下线' },
}

export default function Announcements() {
  const { modal, message } = App.useApp()
  const { user } = useAuth()
  const list = useAnnouncements()
  const [keyword, setKeyword] = useState('')
  const [type, setType] = useState<string>('all')
  const [status, setStatus] = useState<string>('all')
  const [open, setOpen] = useState(false)
  const [editing, setEditing] = useState<AnnouncementRow | null>(null)
  const [form] = Form.useForm()

  const rows = useMemo(() => {
    return list.filter((a) => {
      const kw = keyword.trim().toLowerCase()
      const matchKw = !kw || a.title.toLowerCase().includes(kw)
      const matchT = type === 'all' || a.type === type
      const matchS = status === 'all' || a.status === status
      return matchKw && matchT && matchS
    })
  }, [list, keyword, type, status])

  const openCreate = () => {
    setEditing(null)
    form.resetFields()
    setOpen(true)
  }

  const openEdit = (a: AnnouncementRow) => {
    setEditing(a)
    form.setFieldsValue({ title: a.title, type: a.type, content: a.content })
    setOpen(true)
  }

  const submit = () => {
    form.validateFields().then((values) => {
      if (editing) {
        updateAnnouncement(editing.id, values)
        pushLog({ type: 'announcement', actor: user ?? '管理员', action: '编辑公告', detail: `修改公告 ${editing.id}「${values.title}」` })
        message.success(`已更新公告 ${editing.id}（模拟操作）`)
      } else {
        const row = addAnnouncement(values)
        pushLog({ type: 'announcement', actor: user ?? '管理员', action: '新增公告', detail: `创建公告「${values.title}」${row.id}（草稿）` })
        message.success(`已新增公告「${values.title}」（草稿）`)
      }
      setOpen(false)
      form.resetFields()
    })
  }

  const toggleStatus = (a: AnnouncementRow) => {
    const next: AnnouncementStatus = a.status === 'published' ? 'offline' : 'published'
    setAnnouncementStatus(a.id, next)
    const label = next === 'published' ? '发布' : '下线'
    pushLog({ type: 'announcement', actor: user ?? '管理员', action: label + '公告', detail: `公告 ${a.id}「${a.title}」${label === '发布' ? '已发布' : '已下线'}` })
    message.success(`公告 ${a.id} 已${label}（模拟操作）`)
  }

  const remove = (a: AnnouncementRow) => {
    modal.confirm({
      title: `确认删除公告「${a.title}」？`,
      content: '删除后不可恢复，此操作不可撤销。',
      onOk: () => {
        removeAnnouncement(a.id)
        pushLog({ type: 'announcement', actor: user ?? '管理员', action: '删除公告', detail: `删除公告 ${a.id}「${a.title}」` })
        modal.success({ title: '已删除', content: `公告 ${a.id} 已删除（模拟操作）` })
      },
    })
  }

  const columns: TableProps<AnnouncementRow>['columns'] = [
    { title: 'ID', dataIndex: 'id', width: 80 },
    { title: '标题', dataIndex: 'title', render: (v: string) => <b>{v}</b> },
    {
      title: '类型',
      dataIndex: 'type',
      width: 90,
      render: (v: AnnouncementType) => <Tag color={typeMeta[v].color}>{typeMeta[v].label}</Tag>,
    },
    {
      title: '状态',
      dataIndex: 'status',
      width: 90,
      render: (v: AnnouncementStatus) => <Tag color={statusMeta[v].color}>{statusMeta[v].label}</Tag>,
    },
    { title: '发布时间', dataIndex: 'publishTime', width: 150 },
    { title: '创建时间', dataIndex: 'createTime', width: 120 },
    {
      title: '操作',
      width: 220,
      render: (_, a) => (
        <Space>
          <Button size="small" onClick={() => toggleStatus(a)}>
            {a.status === 'published' ? '下线' : '发布'}
          </Button>
          <Button size="small" icon={<EditOutlined />} onClick={() => openEdit(a)}>
            编辑
          </Button>
          <Button size="small" danger onClick={() => remove(a)}>
            删除
          </Button>
        </Space>
      ),
    },
  ]

  return (
    <>
      <Card
        title="公告管理"
        extra={
          <Button type="primary" icon={<PlusOutlined />} onClick={openCreate}>
            新建公告
          </Button>
        }
      >
        <Space style={{ marginBottom: 16 }}>
          <Input
            allowClear
            prefix={<SearchOutlined />}
            placeholder="搜索公告标题"
            style={{ width: 220 }}
            value={keyword}
            onChange={(e) => setKeyword(e.target.value)}
          />
          <Select
            style={{ width: 130 }}
            value={type}
            onChange={setType}
            options={[
              { value: 'all', label: '全部类型' },
              { value: 'system', label: '系统' },
              { value: 'activity', label: '活动' },
              { value: 'update', label: '更新' },
            ]}
          />
          <Select
            style={{ width: 130 }}
            value={status}
            onChange={setStatus}
            options={[
              { value: 'all', label: '全部状态' },
              { value: 'draft', label: '草稿' },
              { value: 'published', label: '已发布' },
              { value: 'offline', label: '已下线' },
            ]}
          />
        </Space>
        <Table rowKey="id" columns={columns} dataSource={rows} pagination={{ pageSize: 8 }} />
      </Card>

      <Modal
        title={editing ? `编辑公告 ${editing.id}` : '新建公告'}
        open={open}
        onCancel={() => setOpen(false)}
        onOk={submit}
        okText={editing ? '保存修改' : '创建草稿'}
        cancelText="取消"
      >
        <Form form={form} layout="vertical">
          <Form.Item name="title" label="公告标题" rules={[{ required: true, message: '请输入标题' }]}>
            <Input placeholder="如：新剧本上线公告" maxLength={50} showCount />
          </Form.Item>
          <Form.Item name="type" label="类型" rules={[{ required: true, message: '请选择类型' }]}>
            <Select
              placeholder="请选择类型"
              options={[
                { value: 'system', label: '系统' },
                { value: 'activity', label: '活动' },
                { value: 'update', label: '更新' },
              ]}
            />
          </Form.Item>
          <Form.Item name="content" label="公告内容" rules={[{ required: true, message: '请输入内容' }]}>
            <Input.TextArea rows={5} placeholder="公告正文" maxLength={300} showCount />
          </Form.Item>
        </Form>
      </Modal>
    </>
  )
}