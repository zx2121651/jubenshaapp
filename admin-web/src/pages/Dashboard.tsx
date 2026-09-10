import { Card, Col, Row, Space, Statistic, Tag, Empty, List } from 'antd'
import {
  ArrowDownOutlined,
  ArrowUpOutlined,
  UserOutlined,
  TeamOutlined,
  AppstoreOutlined,
  WalletOutlined,
} from '@ant-design/icons'
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
} from 'recharts'
import { dashMetrics, trendData, categoryDist } from '../data/mock'
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

export default function Dashboard() {
  const announcements = useAnnouncements()
  const published = announcements
    .filter((a) => a.status === 'published')
    .slice(0, 4)

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
      </Row>
    </div>
  )
}