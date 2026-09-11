import { useState } from 'react'
import { App, Avatar, Button, Card, Col, Divider, Form, Input, List, Row, Space, Tag, Typography } from 'antd'
import {
  IdcardOutlined,
  LockOutlined,
  LoginOutlined,
  SafetyCertificateOutlined,
} from '@ant-design/icons'
import { useAuth } from '../auth/AuthContext'
import { useLogs } from '../data/logStore'

const AVATAR_COLORS = ['#7c5cff', '#37c99a', '#eb5aa7', '#4dc8ff', '#ffb020', '#e0a63c']

export default function Profile() {
  const { message } = App.useApp()
  const { user } = useAuth()
  const [colorIdx, setColorIdx] = useState(0)
  const [pwdForm] = Form.useForm()

  const loginRecords = useLogs()
    .filter((l) => l.type === 'auth')
    .slice(0, 6)
    .map((l) => ({
      ...l,
      detail: l.action === '登录系统' ? '账号密码登录成功' : l.detail,
      typeLabel: '身份认证',
    }))
  const displayName = user ?? '超级管理员'

  const changePassword = () => {
    pwdForm.validateFields().then((values) => {
      if (values.oldPwd !== 'admin123') {
        message.error('原密码不正确（演示用原密码 admin123）')
        return
      }
      if (values.newPwd !== values.confirmPwd) {
        message.error('两次输入的新密码不一致')
        return
      }
      message.success('密码修改成功（模拟操作）')
      pwdForm.resetFields()
    })
  }

  return (
    <div>
      <Row gutter={[16, 16]}>
        <Col xs={24} lg={8}>
          <Card title="账号概览" style={{ textAlign: 'center' }}>
            <Avatar size={72} style={{ background: AVATAR_COLORS[colorIdx], fontSize: 30 }}>
              {displayName.charAt(0)}
            </Avatar>
            <div style={{ marginTop: 12, fontWeight: 600, fontSize: 18 }}>{displayName}</div>
            <div style={{ marginTop: 4 }}>
              <Tag color="purple">超级管理员</Tag>
              <Tag color="cyan">已激活</Tag>
            </div>
            <Divider style={{ margin: '16px 0 12px' }} />
            <List size="small" split={false}>
              <List.Item>
                <Space>
                  <IdcardOutlined style={{ color: 'rgba(255,255,255,.45)' }} />
                  <span style={{ color: 'rgba(255,255,255,.45)' }}>账号 ID</span>
                  <span style={{ fontWeight: 600 }}>ADMIN-0001</span>
                </Space>
              </List.Item>
              <List.Item>
                <Space>
                  <SafetyCertificateOutlined style={{ color: 'rgba(255,255,255,.45)' }} />
                  <span style={{ color: 'rgba(255,255,255,.45)' }}>创建时间</span>
                  <span style={{ fontWeight: 600 }}>2024-03-01</span>
                </Space>
              </List.Item>
            </List>
            <Divider style={{ margin: '12px 0' }}>主题色</Divider>
            <Space size={8}>
              {AVATAR_COLORS.map((c, i) => (
                <span
                  key={c}
                  onClick={() => setColorIdx(i)}
                  style={{
                    width: 22,
                    height: 22,
                    borderRadius: 6,
                    background: c,
                    cursor: 'pointer',
                    border: i === colorIdx ? '2px solid #fff' : 'none',
                    display: 'inline-block',
                  }}
                />
              ))}
            </Space>
          </Card>
        </Col>

        <Col xs={24} lg={16}>
          <Card title="账号安全" style={{ marginBottom: 16 }}>
            <Form form={pwdForm} layout="vertical" style={{ maxWidth: 420 }}>
              <Form.Item name="oldPwd" label="原密码" rules={[{ required: true, message: '请输入原密码' }]}>
                <Input.Password prefix={<LockOutlined />} placeholder="请输入原密码" />
              </Form.Item>
              <Form.Item name="newPwd" label="新密码" rules={[{ required: true, min: 6, message: '至少 6 位' }]}>
                <Input.Password prefix={<LockOutlined />} placeholder="请输入新密码" />
              </Form.Item>
              <Form.Item name="confirmPwd" label="确认新密码" dependencies={['newPwd']} rules={[{ required: true, message: '请再次输入新密码' }]}>
                <Input.Password prefix={<LockOutlined />} placeholder="再次输入新密码" />
              </Form.Item>
              <Button type="primary" onClick={changePassword}>
                修改密码
              </Button>
            </Form>
          </Card>

          <Card
            title="登录记录"
            extra={
              <Space>
                <LoginOutlined style={{ color: 'rgba(255,255,255,.35)' }} />
                <Typography.Text type="secondary">最近操作</Typography.Text>
              </Space>
            }
          >
            <List
              dataSource={loginRecords}
              renderItem={(l) => (
                <List.Item>
                  <List.Item.Meta
                    title={
                      <Space>
                        <Tag color="purple">{l.action}</Tag>
                        <span>{l.detail}</span>
                      </Space>
                    }
                    description={`${l.actor} · ${l.typeLabel}`}
                  />
                  <span style={{ color: 'rgba(255,255,255,.35)', fontSize: 12 }}>{l.time}</span>
                </List.Item>
              )}
            />
          </Card>
        </Col>
      </Row>
    </div>
  )
}