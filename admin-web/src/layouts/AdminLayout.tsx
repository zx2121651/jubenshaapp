import { useState } from 'react'
import { useNavigate, useLocation, Outlet } from 'react-router-dom'
import { Layout, Menu, Avatar, Badge, Space, Dropdown, Typography, theme } from 'antd'
import type { MenuProps } from 'antd'
import {
  DashboardOutlined,
  TeamOutlined,
  BookOutlined,
  AppstoreOutlined,
  SafetyOutlined,
  NotificationOutlined,
  CommentOutlined,
  FileSearchOutlined,
  BellOutlined,
  UserOutlined,
  MoonOutlined,
  LogoutOutlined,
} from '@ant-design/icons'
import { useAuth } from '../auth/AuthContext'
import { pushLog } from '../data/logStore'

const { Sider, Header, Content } = Layout

const items = [
  { key: '/dashboard', icon: <DashboardOutlined />, label: '数据看板' },
  { key: '/users', icon: <TeamOutlined />, label: '用户管理' },
  { key: '/scripts', icon: <BookOutlined />, label: '剧本管理' },
  { key: '/rooms', icon: <AppstoreOutlined />, label: '房间 / 组局' },
  { key: '/permissions', icon: <SafetyOutlined />, label: '权限管理' },
  { key: '/announcements', icon: <NotificationOutlined />, label: '公告管理' },
  { key: '/reviews', icon: <CommentOutlined />, label: '评论管理' },
  { key: '/logs', icon: <FileSearchOutlined />, label: '操作日志' },
]

const userMenu: MenuProps['items'] = [
  { key: 'profile', icon: <UserOutlined />, label: '个人中心' },
  { type: 'divider' },
  { key: 'logout', icon: <LogoutOutlined />, label: '退出登录', danger: true },
]

export default function AdminLayout() {
  const navigate = useNavigate()
  const location = useLocation()
  const { token } = theme.useToken()
  const { user, logout } = useAuth()
  const [collapsed, setCollapsed] = useState(false)

  const selectedKey =
    '/' + (location.pathname.split('/')[1] || 'dashboard')

  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Sider
        collapsible
        collapsed={collapsed}
        onCollapse={setCollapsed}
        width={232}
        style={{
          background: token.colorBgContainer,
          borderRight: `1px solid ${token.colorSplit}`,
        }}
      >
        <div className="brand">
          <div className="brand-logo">侦</div>
          {!collapsed && (
            <div className="brand-text">
              <b>剧本杀运营后台</b>
              <span>Jubensha Admin</span>
            </div>
          )}
        </div>
        <Menu
          mode="inline"
          selectedKeys={[selectedKey]}
          items={items}
          onClick={({ key }) => navigate(key)}
          style={{ background: 'transparent', borderInlineEnd: 'none' }}
        />
      </Sider>

      <Layout>
        <Header
          style={{
            background: token.colorBgContainer,
            borderBottom: `1px solid ${token.colorSplit}`,
            padding: '0 24px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            height: 60,
          }}
        >
          <Typography.Text style={{ color: token.colorTextSecondary }}>
            管理控制台 · 随时掌握平台动态
          </Typography.Text>
          <Space size={20}>
            <Badge count={5} size="small">
              <BellOutlined style={{ fontSize: 18, color: token.colorTextSecondary }} />
            </Badge>
            <Space size={10}>
              <span style={{ color: token.colorTextSecondary }}>
                <MoonOutlined />
              </span>
            </Space>
            <Dropdown
              menu={{
                items: userMenu,
                onClick: ({ key }) => {
                  if (key === 'logout') {
                    pushLog({ type: 'auth', actor: user ?? '管理员', action: '退出登录', detail: '登出后台系统' })
                    logout()
                    navigate('/login', { replace: true })
                  } else if (key === 'profile') {
                    navigate('/profile')
                  }
                },
              }}
            >
              <Space style={{ cursor: 'pointer' }}>
                <Avatar style={{ background: '#7c5cff' }}>
                  {user?.charAt(0) ?? '管'}
                </Avatar>
                <span style={{ color: token.colorText }}>{user ?? '管理员'}</span>
              </Space>
            </Dropdown>
          </Space>
        </Header>
        <Content style={{ padding: 24 }}>
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  )
}