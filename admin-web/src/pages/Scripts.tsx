import { useMemo, useState } from 'react'
import {
  App,
  Button,
  Card,
  Descriptions,
  Divider,
  Drawer,
  Form,
  Input,
  InputNumber,
  Modal,
  Rate,
  Select,
  Space,
  Table,
  Tag,
  Tooltip,
  Typography,
} from 'antd'
import type { TableProps } from 'antd'
import { CheckOutlined, EyeOutlined, PlusOutlined, SearchOutlined, DownloadOutlined } from '@ant-design/icons'
import { scripts } from '../data/mock'
import type { ScriptRow } from '../data/mock'
import { usePersistentState } from '../hooks/usePersistentState'
import { pushLog } from '../data/logStore'
import { useAuth } from '../auth/AuthContext'
import { exportCsv } from '../utils/exportCsv'

const categoryList = [...new Set(scripts.map((s) => s.category))]

const statusMeta: Record<ScriptRow['status'], { color: string; label: string }> = {
  online: { color: 'green', label: '已上架' },
  offline: { color: 'default', label: '已下架' },
  pending: { color: 'gold', label: '待审核' },
}

export default function Scripts() {
  const { modal, message } = App.useApp()
  const { user } = useAuth()
  const [keyword, setKeyword] = useState('')
  const [category, setCategory] = useState<string>('all')
  const [status, setStatus] = useState<string>('all')
  const [data, setData] = usePersistentState<ScriptRow[]>('admin_scripts', scripts)
  const [open, setOpen] = useState(false)
  const [selected, setSelected] = useState<string[]>([])
  const [form] = Form.useForm()
  const [detail, setDetail] = useState<ScriptRow | null>(null)
  const [detailForm] = Form.useForm()

  const tagList = useMemo(() => [...new Set(data.flatMap((s) => s.tags))], [data])

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
    const label = action === 'online' ? '通过并上架' : action === 'offline' ? '下架' : '设为待审核'
    pushLog({ type: 'script', actor: user ?? '管理员', action: action === 'online' ? '审核通过' : action === 'offline' ? '下架' : '状态调整', detail: `剧本 ${id} ${label}` })
    modal.success({ title: `${label}成功`, content: `剧本 ${id} 已${label}（模拟操作）` })
  }

  const batchApprove = () => {
    setData((d) => d.map((s) => (selected.includes(s.id) ? { ...s, status: 'online' } : s)))
    pushLog({ type: 'script', actor: user ?? '管理员', action: '批量上架', detail: `对 ${selected.length} 部待审核剧本审核通过` })
    modal.success({ title: '批量上架', content: `已对 ${selected.length} 部待审核剧本执行通过（模拟操作）` })
    setSelected([])
  }

  const create = () => {
    form.validateFields().then((values) => {
      const row: ScriptRow = {
        id: `S${Math.floor(100 + Math.random() * 900)}`,
        plays: 0,
        status: 'pending',
        desc: '',
        price: 68,
        tags: [],
        ...values,
      }
      setData((d) => [row, ...d])
      setOpen(false)
      form.resetFields()
      pushLog({ type: 'script', actor: user ?? '管理员', action: '提交剧本', detail: `新增剧本「${values.title}」${row.id}（待审核）` })
      message.success(`已新增剧本「${values.title}」（待审核）`)
    })
  }

  const openDetail = (r: ScriptRow) => {
    setDetail(r)
    detailForm.setFieldsValue(r)
  }

  const doExport = () => {
    exportCsv(
      `剧本列表_${new Date().toISOString().slice(0, 10)}.csv`,
      ['ID', '剧本名称', '作者', '分类', '难度', '时长(秒)', '价格(元)', '游玩数', '评分', '状态'],
      rows.map((s) => [s.id, s.title, s.author, s.category, s.difficulty, s.duration, s.price, s.plays, s.rating, statusMeta[s.status].label]),
    )
    message.success(`已导出 ${rows.length} 个剧本（模拟操作）`)
  }

  const saveDetail = () => {
    if (!detail) return
    detailForm.validateFields().then((values) => {
      setData((d) => d.map((s) => (s.id === detail.id ? { ...s, ...values } : s)))
      pushLog({ type: 'script', actor: user ?? '管理员', action: '编辑剧本', detail: `修改剧本 ${detail.id}「${values.title}」资料` })
      message.success(`已更新剧本 ${detail.id}（模拟操作）`)
      setDetail(null)
    })
  }

  const columns: TableProps<ScriptRow>['columns'] = [
    { title: 'ID', dataIndex: 'id' },
    { title: '剧本名称', dataIndex: 'title', render: (v: string) => <b>{v}</b> },
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
      render: (v: ScriptRow['status']) => <Tag color={statusMeta[v].color}>{statusMeta[v].label}</Tag>,
    },
    {
      title: '操作',
      render: (_, r) => (
        <Space>
          <Button size="small" icon={<EyeOutlined />} onClick={() => openDetail(r)}>
            详情
          </Button>
          {r.status === 'pending' ? (
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
              <Button size="small" onClick={() => toggleStatus(r.id, r.status === 'online' ? 'offline' : 'online')}>
                {r.status === 'online' ? '下架' : '上架'}
              </Button>
            </Tooltip>
          )}
        </Space>
      ),
    },
  ]

  return (
    <>
      <Card
        title="剧本管理"
        extra={
          <Space>
            <Button icon={<DownloadOutlined />} onClick={doExport}>
              导出 CSV
            </Button>
            <Button icon={<SearchOutlined />}>导入剧本</Button>
            <Button type="primary" icon={<PlusOutlined />} onClick={() => { setOpen(true); form.resetFields() }}>
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
          {selected.length > 0 && (
            <Button type="primary" icon={<CheckOutlined />} onClick={batchApprove}>
              批量通过（{selected.length}）
            </Button>
          )}
        </Space>
        <Table
          rowKey="id"
          columns={columns}
          dataSource={rows}
          pagination={{ pageSize: 6 }}
          rowSelection={{
            selectedRowKeys: selected,
            onChange: (keys) => setSelected(keys as string[]),
            getCheckboxProps: (r) => ({ disabled: r.status !== 'pending' }),
          }}
        />
      </Card>

      <Modal
        title="新建剧本"
        open={open}
        onCancel={() => setOpen(false)}
        onOk={create}
        okText="提交审核"
        cancelText="取消"
      >
        <Form form={form} layout="vertical">
          <Form.Item name="title" label="剧本名称" rules={[{ required: true, message: '请输入名称' }]}>
            <Input placeholder="如：雪夜列车" />
          </Form.Item>
          <Form.Item name="author" label="作者" rules={[{ required: true }]}>
            <Input placeholder="作者昵称" />
          </Form.Item>
          <Form.Item name="category" label="分类" rules={[{ required: true, message: '请选择分类' }]}>
            <Select
              placeholder="请选择分类"
              options={categoryList.map((c) => ({ value: c, label: c }))}
            />
          </Form.Item>
          <Form.Item name="difficulty" label="难度" rules={[{ required: true, message: '请选择难度' }]}>
            <Select
              placeholder="请选择难度"
              options={['新手', '进阶', '困难'].map((v) => ({ value: v, label: v }))}
            />
          </Form.Item>
          <Form.Item name="duration" label="时长（秒）">
            <InputNumber min={60} max={720} step={30} style={{ width: '100%' }} />
          </Form.Item>
        </Form>
      </Modal>

      <Drawer
        title={detail ? `剧本详情 ${detail.id}` : '剧本详情'}
        size={520}
        open={!!detail}
        onClose={() => setDetail(null)}
        extra={
          detail && (
            <Tag color={statusMeta[detail.status].color}>
              {statusMeta[detail.status].label}
            </Tag>
          )
        }
      >
        {detail && (
          <>
            <Descriptions column={2} size="small">
              <Descriptions.Item label="剧本 ID">{detail.id}</Descriptions.Item>
              <Descriptions.Item label="游玩数">{detail.plays}</Descriptions.Item>
            </Descriptions>
            <Divider style={{ margin: '12px 0 16px' }} />
            <Form form={detailForm} layout="vertical">
              <Form.Item name="title" label="剧本名称" rules={[{ required: true, message: '请输入名称' }]}>
                <Input />
              </Form.Item>
              <Form.Item name="author" label="作者" rules={[{ required: true }]}>
                <Input />
              </Form.Item>
              <Form.Item name="category" label="分类" rules={[{ required: true, message: '请选择分类' }]}>
                <Select options={categoryList.map((c) => ({ value: c, label: c }))} />
              </Form.Item>
              <Form.Item name="difficulty" label="难度" rules={[{ required: true, message: '请选择难度' }]}>
                <Select options={['新手', '进阶', '困难'].map((v) => ({ value: v, label: v }))} />
              </Form.Item>
              <Space size={12} style={{ display: 'flex' }}>
                <Form.Item name="duration" label="时长（秒）" style={{ flex: 1 }}>
                  <InputNumber min={60} max={720} step={30} style={{ width: '100%' }} />
                </Form.Item>
                <Form.Item name="price" label="价格（元）" style={{ flex: 1 }}>
                  <InputNumber min={0} max={999} step={10} style={{ width: '100%' }} addonBefore="￥" />
                </Form.Item>
              </Space>
              <Form.Item name="rating" label="评分">
                <InputNumber min={0} max={5} step={0.1} style={{ width: '100%' }} />
              </Form.Item>
              <Form.Item name="tags" label="标签">
                <Select mode="multiple" placeholder="选择标签" options={tagList.map((t) => ({ value: t, label: t }))} />
              </Form.Item>
              <Form.Item name="desc" label="简介">
                <Input.TextArea rows={4} maxLength={200} showCount />
              </Form.Item>
            </Form>
            <Typography.Paragraph type="secondary" style={{ fontSize: 12 }}>
              修改保存后即时生效并计入操作日志（模拟操作）。
            </Typography.Paragraph>
            <Button type="primary" block onClick={saveDetail}>
              保存修改
            </Button>
          </>
        )}
      </Drawer>
    </>
  )
}