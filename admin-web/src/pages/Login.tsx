import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { App, Button, Checkbox, Input, Form, Typography } from 'antd'
import { LockOutlined, UserOutlined, EyeInvisibleOutlined, EyeTwoTone } from '@ant-design/icons'
import { useAuth } from '../auth/AuthContext'

export default function Login() {
  const { login } = useAuth()
  const { message } = App.useApp()
  const navigate = useNavigate()
  const [loading, setLoading] = useState(false)

  const onFinish = (values: { username: string }) => {
    setLoading(true)
    // 模拟登录：任意非空账号即可，默认填充管理员。
    setTimeout(() => {
      login(values.username.trim() || '超级管理员')
      setLoading(false)
      message.success(`欢迎回来，${values.username.trim() || '超级管理员'}`)
      navigate('/dashboard', { replace: true })
    }, 500)
  }

  return (
    <div className="login-wrap">
      <div className="login-card">
        <div className="login-brand">
          <div className="brand-logo">侦</div>
        </div>
        <Typography.Title level={3} style={{ textAlign: 'center', marginTop: 16, marginBottom: 4 }}>
          剧本杀运营后台
        </Typography.Title>
        <Typography.Text type="secondary" style={{ display: 'block', textAlign: 'center', marginBottom: 28 }}>
          Jubensha Admin Console
        </Typography.Text>

        <Form
          initialValues={{ username: '超级管理员', remember: true }}
          onFinish={onFinish}
          size="large"
        >
          <Form.Item name="username" rules={[{ required: true, message: '请输入账号' }]}>
            <Input prefix={<UserOutlined style={{ color: 'rgba(255,255,255,.35)' }} />} placeholder="账号" />
          </Form.Item>
          <Form.Item name="password" initialValue="admin123" rules={[{ required: true, message: '请输入密码' }]}>
            <Input.Password
              prefix={<LockOutlined style={{ color: 'rgba(255,255,255,.35)' }} />}
              placeholder="密码"
              iconRender={(visible) => (visible ? <EyeTwoTone /> : <EyeInvisibleOutlined />)}
            />
          </Form.Item>
          <Form.Item name="remember" valuePropName="checked" style={{ marginBottom: 12 }}>
            <Checkbox>记住我</Checkbox>
          </Form.Item>
          <Button type="primary" htmlType="submit" block loading={loading} style={{ height: 46, fontWeight: 700 }}>
            登 录
          </Button>
        </Form>
      </div>
    </div>
  )
}