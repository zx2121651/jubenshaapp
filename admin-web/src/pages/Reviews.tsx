import { useMemo, useState } from 'react'
import { App, Button, Card, Input, Rate, Select, Space, Table, Tag, Tooltip } from 'antd'
import type { TableProps } from 'antd'
import { CheckOutlined, DownloadOutlined, SearchOutlined } from '@ant-design/icons'
import { reviews } from '../data/mock'
import type { ReviewRow, ReviewStatus } from '../data/mock'
import { usePersistentState } from '../hooks/usePersistentState'
import { pushLog } from '../data/logStore'
import { useAuth } from '../auth/AuthContext'
import { exportCsv } from '../utils/exportCsv'

const statusMeta: Record<ReviewStatus, { color: string; label: string }> = {
  pending: { color: 'gold', label: '待审核' },
  approved: { color: 'green', label: '已通过' },
  rejected: { color: 'red', label: '已驳回' },
}

export default function Reviews() {
  const { modal, message } = App.useApp()
  const { user } = useAuth()
  const [keyword, setKeyword] = useState('')
  const [script, setScript] = useState<string>('all')
  const [status, setStatus] = useState<string>('all')
  const [data, setData] = usePersistentState<ReviewRow[]>('admin_reviews', reviews)
  const [selected, setSelected] = useState<string[]>([])

  const scriptList = useMemo(() => [...new Set(data.map((r) => r.scriptTitle))], [data])

  const rows = useMemo(() => {
    return data.filter((r) => {
      const kw = keyword.trim().toLowerCase()
      const matchKw =
        !kw || r.content.toLowerCase().includes(kw) || r.userName.toLowerCase().includes(kw)
      const matchS = script === 'all' || r.scriptTitle === script
      const matchT = status === 'all' || r.status === status
      return matchKw && matchS && matchT
    })
  }, [data, keyword, script, status])

  const counts = useMemo(
    () => ({
      pending: data.filter((r) => r.status === 'pending').length,
      approved: data.filter((r) => r.status === 'approved').length,
      rejected: data.filter((r) => r.status === 'rejected').length,
    }),
    [data],
  )

  const setReviewStatus = (r: ReviewRow, next: ReviewStatus) => {
    setData((d) => d.map((x) => (x.id === r.id ? { ...x, status: next } : x)))
    const label = next === 'approved' ? '审核通过' : next === 'rejected' ? '驳回' : '恢复待审'
    pushLog({ type: 'review', actor: user ?? '管理员', action: label, detail: `评论 ${r.id}「${r.content.slice(0, 12)}…」已${label}` })
    modal.success({ title: `${label}成功`, content: `评论 ${r.id} 已${label}（模拟操作）` })
  }

  const batchApprove = () => {
    setData((d) => d.map((x) => (selected.includes(x.id) ? { ...x, status: 'approved' } : x)))
    pushLog({ type: 'review', actor: user ?? '管理员', action: '批量通过', detail: `对 ${selected.length} 条待审核评论审核通过` })
    modal.success({ title: '批量通过', content: `已对 ${selected.length} 条待审核评论执行通过（模拟操作）` })
    setSelected([])
  }

  const remove = (r: ReviewRow) => {
    modal.confirm({
      title: `确认删除评论 ${r.id}？`,
      content: `删除后不可恢复，此操作不可撤销。`,
      onOk: () => {
        setData((d) => d.filter((x) => x.id !== r.id))
        pushLog({ type: 'review', actor: user ?? '管理员', action: '删除评论', detail: `删除评论 ${r.id}「${r.content.slice(0, 12)}…」` })
        modal.success({ title: '已删除', content: `评论 ${r.id} 已删除（模拟操作）` })
      },
    })
  }

  const doExport = () => {
    exportCsv(
      `剧本评论_${new Date().toISOString().slice(0, 10)}.csv`,
      ['ID', '剧本', '用户', '评分', '评论内容', '状态', '举报数', '时间'],
      rows.map((r) => [r.id, r.scriptTitle, r.userName, r.rating, r.content, statusMeta[r.status].label, r.reportCount, r.time]),
    )
    message.success(`已导出 ${rows.length} 条评论（模拟操作）`)
  }

  const columns: TableProps<ReviewRow>['columns'] = [
    { title: 'ID', dataIndex: 'id', width: 76 },
    {
      title: '剧本 / 用户',
      key: 'who',
      width: 200,
      render: (_, r) => (
        <div>
          <div style={{ fontWeight: 600 }}>{r.scriptTitle}</div>
          <div style={{ color: 'rgba(255,255,255,.4)', fontSize: 12 }}>{r.userName}</div>
        </div>
      ),
    },
    {
      title: '评分',
      dataIndex: 'rating',
      width: 140,
      render: (v: number) => <Rate disabled allowHalf value={v} />,
    },
    {
      title: '评论内容',
      dataIndex: 'content',
      ellipsis: true,
      render: (v: string) => (
        <Tooltip title={v}>
          <span>{v}</span>
        </Tooltip>
      ),
    },
    {
      title: '举报',
      dataIndex: 'reportCount',
      width: 80,
      render: (v: number) =>
        v > 0 ? <Tag color="red">举报 {v}</Tag> : <span style={{ color: 'rgba(255,255,255,.3)' }}>—</span>,
      sorter: (a, b) => a.reportCount - b.reportCount,
    },
    {
      title: '状态',
      dataIndex: 'status',
      width: 90,
      render: (v: ReviewStatus) => <Tag color={statusMeta[v].color}>{statusMeta[v].label}</Tag>,
    },
    { title: '时间', dataIndex: 'time', width: 150 },
    {
      title: '操作',
      width: 180,
      render: (_, r) =>
        r.status === 'pending' ? (
          <Space>
            <Button type="primary" size="small" onClick={() => setReviewStatus(r, 'approved')}>
              通过
            </Button>
            <Button danger size="small" onClick={() => setReviewStatus(r, 'rejected')}>
              驳回
            </Button>
            <Button size="small" danger type="text" onClick={() => remove(r)}>
              删除
            </Button>
          </Space>
        ) : (
          <Button size="small" danger onClick={() => remove(r)}>
            删除
          </Button>
        ),
    },
  ]

  return (
    <Card
      title="评论管理"
      extra={
        <Button icon={<DownloadOutlined />} onClick={doExport}>
          导出 CSV
        </Button>
      }
    >
      <Space size={16} style={{ marginBottom: 16 }}>
        <Tag color="gold">待审核 {counts.pending}</Tag>
        <Tag color="green">已通过 {counts.approved}</Tag>
        <Tag color="red">已驳回 {counts.rejected}</Tag>
      </Space>
      <Space style={{ marginBottom: 16 }}>
        <Input
          allowClear
          prefix={<SearchOutlined />}
          placeholder="搜索内容 / 用户"
          style={{ width: 220 }}
          value={keyword}
          onChange={(e) => setKeyword(e.target.value)}
        />
        <Select
          style={{ width: 160 }}
          value={script}
          onChange={setScript}
          options={[{ value: 'all', label: '全部剧本' }, ...scriptList.map((s) => ({ value: s, label: s }))]}
        />
        <Select
          style={{ width: 130 }}
          value={status}
          onChange={setStatus}
          options={[
            { value: 'all', label: '全部状态' },
            { value: 'pending', label: '待审核' },
            { value: 'approved', label: '已通过' },
            { value: 'rejected', label: '已驳回' },
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
        pagination={{ pageSize: 8 }}
        rowSelection={{
          selectedRowKeys: selected,
          onChange: (keys) => setSelected(keys as string[]),
          getCheckboxProps: (r) => ({ disabled: r.status !== 'pending' }),
        }}
      />
    </Card>
  )
}