import { Card, Col, Row, Space, Statistic, Tag, Empty, List } from 'antd'
import {
  ArrowDownOutlined,
  ArrowUpOutlined,
  UserOutlined,
  TeamOutlined,
  AppstoreOutlined,
  WalletOutlined,
} from '@ant-design/icons'
import { useLogs } from '../data/logStore'
import type { LogType } from '../data/logStore'
import {
  ResponsiveContainer,
  AreaChart,
  Area,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  PieChart,
  Pie,
  Cell,
  Legend,
  BarChart,
  Bar,
} from 'recharts'
import { dashMetrics, trendData, categoryDist, scripts } from '../data/mock'
import type { AnnouncementType } from '../data/mock'
import { useAnnouncements } from '../data/announcementStore'

const icons: Record<string, React.ReactNode> = {
  users: <UserOutlined />,
  todayUsers: <TeamOutlined />,
  activeRooms: <AppstoreOutlined />,
  revenue: <WalletOutlined />,
}

const PIEColors = ['#7c5cff', '#eb5aa7', '#37c99a', '#4dc8ff', '#ffb020']

const annTypeMeta: Record<AnnouncementType, { color: string; label: string }> = {
  system: { color: 'blue', label: '系统' },
  activity: { color: 'magenta', label: '活动' },
  update: { color: 'cyan', label: '更新' },
}

const logTypeMeta: Record<LogType, { color: string; label: string }> = {
  auth: { color: 'blue', label: '认证' },
  user: { color: 'purple', label: '用户' },
  script: { color: 'cyan', label: '剧本' },
  room: { color: 'gold', label: '房间' },
  announcement: { color: 'magenta', label: '公告' },
  review: { color: 'green', label: '评论' },
}

export default function Dashboard() {
  const announcements = useAnnouncements()
  const published = announcements
    .filter((a) => a.status === 'published')
    .slice(0, 4)
  const hotScripts = [...scripts].sort((a, b) => b.plays - a.plays).slice(0, 5)
  const recentLogs = useLogs().slice(0, 6)

  return (
    <div>
      <Row gutter={[16, 16]}>
        {dashMetrics.map((m) => (
          <Col xs={24} sm={12} xl={6} key={m.key}>
            <Card>
              <Statistic
                title={m.label}
                value={m.value}
                suffix={m.unit}
                prefix={icons[m.key]}
                styles={{ content: { color: m.color } }}
              />
              <div style={{ marginTop: 8 as number }}>
                <Tag
                  color={m.trend ? 'green' : 'red'}
                  icon={
                    m.trend ? <ArrowUpOutlined /> : <ArrowDownOutlined />
                  }
                >
                  {m.delta}%
                </Tag>
                <span style={{ color: 'rgba(255,255,255,.4)', fontSize: 12 }}>
                  较上周期
                </span>
              </div>
            </Card>
          </Col>
        ))}
      </Row>

      <Row gutter={[16, 16]} style={{ marginTop: 16 }}>
        <Col xs={24} xl={16}>
          <Card title="近 7 日平台趋势">
            <ResponsiveContainer width="100%" height={300}>
              <AreaChart data={trendData}>
                <defs>
                  <linearGradient id="gUsers" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#7c5cff" stopOpacity={0.5} />
                    <stop offset="95%" stopColor="#7c5cff" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,.08)" />
                <XAxis dataKey="day" stroke="rgba(255,255,255,.4)" />
                <YAxis stroke="rgba(255,255,255,.4)" />
                <YAxis orientation="right" yAxisId="right" stroke="#ffb020" />
                <Tooltip />
                <Legend />
                <Area
                  type="monotone"
                  dataKey="users"
                  name="新增用户"
                  stroke="#7c5cff"
                  fill="url(#gUsers)"
                />
                <Area
                  type="monotone"
                  dataKey="rooms"
                  name="房间数"
                  stroke="#4dc8ff"
                  fill="transparent"
                  strokeDasharray="4 4"
                />
                <Area
                  yAxisId="right"
                  type="monotone"
                  dataKey="revenue"
                  name="营收(元)"
                  stroke="#ffb020"
                  fill="transparent"
                />
              </AreaChart>
            </ResponsiveContainer>
          </Card>
        </Col>
        <Col xs={24} xl={8}>
          <Card title="剧本分类分布">
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={categoryDist}
                  dataKey="value"
                  nameKey="name"
                  innerRadius={60}
                  outerRadius={95}
                  label
                >
                  {categoryDist.map((_, i) => (
                    <Cell
                      key={i}
                      fill={PIEColors[i % PIEColors.length]}
                    />
                  ))}
                </Pie>
                <Tooltip />
                <Legend />
              </PieChart>
            </ResponsiveContainer>
          </Card>
        </Col>
      </Row>

      <Row gutter={[16, 16]} style={{ marginTop: 16 }}>
        <Col span={24}>
          <Card title="热门剧本 Top5（按游玩数）">
            <ResponsiveContainer width="100%" height={280}>
              <BarChart data={hotScripts} margin={{ top: 8, left: -16, right: 8 }}>
                <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,.08)" />
                <XAxis dataKey="title" stroke="rgba(255,255,255,.4)" />
                <YAxis stroke="rgba(255,255,255,.4)" />
                <Tooltip />
                <Bar dataKey="plays" name="游玩数" fill="#7c5cff" radius={[6, 6, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </Card>
        </Col>
      </Row>

      <Row gutter={[16, 16]} style={{ marginTop: 16 }}>
        <Col xs={24} xl={14}>
          <Card title="平台公告">
            {published.length ? (
              <List
                dataSource={published}
                renderItem={(a) => (
                  <List.Item key={a.id}>
                    <List.Item.Meta
                      title={
                        <Space>
                          <Tag color={annTypeMeta[a.type].color}>{annTypeMeta[a.type].label}</Tag>
                          <span>{a.title}</span>
                        </Space>
                      }
                      description={a.content}
                    />
                    <span style={{ color: 'rgba(255,255,255,.35)', fontSize: 12 }}>
                      {a.publishTime}
                    </span>
                  </List.Item>
                )}
              />
            ) : (
              <Empty description="暂无已发布公告" />
            )}
          </Card>
        </Col>
        <Col xs={24} xl={10}>
          <Card title="最新操作动态">
            {recentLogs.length ? (
              <List
                dataSource={recentLogs}
                renderItem={(l) => (
                  <List.Item key={l.id}>
                    <List.Item.Meta
                      title={
                        <Space>
                          <Tag color={logTypeMeta[l.type].color}>{logTypeMeta[l.type].label}</Tag>
                          <span>{l.action}</span>
                        </Space>
                      }
                      description={<span style={{ fontSize: 12, color: 'rgba(255,255,255,.55)' }}>{l.detail}</span>}
                    />
                    <span style={{ color: 'rgba(255,255,255,.35)', fontSize: 12 }}>
                      {l.actor}
                      <br />
                      {l.time}
                    </span>
                  </List.Item>
                )}
              />
            ) : (
              <Empty description="暂无操作记录" />
            )}
          </Card>
        </Col>
      </Row>
    </div>
  )
}