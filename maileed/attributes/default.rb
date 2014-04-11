default['maileed']['ssh']['public_key'] = '12345'
default['maileed']['ssh']['private_key'] = '12345'
default['maileed']['total_senders'] = 60
default['maileed']['uid'] = `ls /home/`.split("\n")[0]
default['maileed']['gid'] = `ls /home/`.split("\n")[0]
default['maileed']['deploy_dir'] = '/opt/maileed'
default['maileed']['deploy_user'] = 'ubuntu'
default['maileed']['pid_dir'] = default['maileed']['deploy_dir'] + '/pids'
default['dnsmasq'] = {"dns" => {}}
default['maileed']['repo'] = 'https://git@bitbucket.org/panop/maileed.git'


default['maileed']['database'] = {
  'host' => 'localhost',
  'database' => 'mailee_development',
  'port' => 5432,
  'user' => 'mailer',
  'password' => '1234'
}

default['maileed']['options'] = {
    # the amount of seconds that the message will sleep waiting to ask redis the quantity of messages in the queue
    'wait_for_the_end_timeout' => 1,

    # the amount of seconds that the sender will sleep waiting for new deliveries in the queue
    'sender_loop_timeout' => 10,

    # number of messages that sender will loop before reloading the relays and the active_messages
    'sender_block_size' => 100,

    # the amount of seconds that sender will block for redis list pop (redis.blpop)
    'sender_list_pop_block_timeout' => 0,

    # if the size of the message queue exceed this value it will sleep before put more messages into the queue
    'queue_max_size' => 1000,

    # this is the amount of time that the message will sleep before put more messages into the queue, if it exceed the max_queue_size
    'queue_sleep_time' => 20,

    # this is the amount of deliveries that the message will get each time it fetches the cursor
    'message_cursor_rows_to_fetch' => 4000,

}

default['maileed']['redis'] = {
  'host' => 'localhost',
  'password' => '',
  'port' => 6379,
  'namespace' => 'maileed'
}

default['maileed']['dkim_private_key'] = "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAsKIycBtFUnx1mcjId0Kxi3kLWVGASKuBNT+vcJnII2xyQM1x\nuDaijxQGcD7u1fjHxFarL2no/G/O4lXt1FeEa4sD55kK/pboov9r5vKbabYG4QI8\nG9FtZYNd1PLq7apSk5dczyUxEGeiTgbI625y3k8pZJDzFH6jBPuflgq8vC/4FBfo\nQNzflYmICQqdzmyj3zVWszaAgDBudjJ72nl4x9Q2wjjtVb5QMZRwcGpAZ9Dm/Yxr\nwgSsZrX4YzaONxZODlR7xTYb3ynmX89ODx47auti5jAGUdLCxU3YP4Sy2oN8sxN5\nZ95LyzfZP0GwMowzzBtRu9fJG7wNPoOpYhc5IwIDAQABAoIBADfPyGgr9ceOlAo3\nq0Ajzr3nTXK3kfVkW7tbmC/YJ6kpxyA6ykgO22aiSTaGbCkoJtcfG5ArwvagzZou\n1KtXy/u/PUiczyCKxo9abdnXpsvMPHg0oJGZpxuAWtHCwADA5L7GAQljExG/7UUC\nV9IsYBdmpAmm02gSa6hTaaWbVu+PIihAjLPsqEP1nTkS8EDbk2cx95OcCqUs3TKG\n5wC2veZOGdRgiwRPw+hhs9OCes7UfoddaXVanRCbZqYSypk52g/FxQ5pFPnVkoiK\nx0b+/pbFTdFR4qX16OJMgX0euNWbKAS5vyeBbkXjKSOqx+Sv6kcBO1uxamKBU0SS\nd/pWpGECgYEA3tf1pq3/8U/INFGvOin90YzhZ+g8a0asg+GKgF6PMdEyKBWjNZP8\nR0k/1u0lDA6VvPtarCyKrzwaXo/9BDoYTgjVFNZMShFcvwo/C0HFnK3aCb6D9em+\n0BP4Z/dHE0D7PsGOChHmBwW8JO1yw2kvnIfpOGNV69JdJXpT2x3gPucCgYEAyuoc\n9AfxTTU3P9qQIqsPrXKNTzMr8xboHwEyUre6OryHpk4bYyNi5CotYjaYWZFdanFo\nLpz98JEDDvPkoD2EqOu8j5QZAH9kduv4/0gZ5gXb1i4nV5D3O24qBkq16O3kpJof\nRhRX1R92rCzFiPRilkpuseLO1OGUb+1B/xApWGUCgYAYc4vRwS/fM4jdLMVUVX0z\nPAkTlKjkgHm3csz2rul5ZuHhAhbJbzZ0P/ZQR+8Ttpn5hX76e1ywQ6EFFTmG+DTo\ngxGWWrk+O0946s/mFU5wlabiANSL7Bzyye4swjY7R5sJ1MUYF8SsqpVtW9yG0ojV\n3RfbBxNLb+amkRiYZ1vOqwKBgQCoZSmqC31hyawUPdooKzZThyFmfN0YXAY+1Mti\ngj72x8b7aQ6pc5B6MdaADzbX/h88WulO5dKIdo/HNPijUuppFVni/dDR7Ob/Gk4F\n7Vww3OPYF21m6lOC6qXNmurkZ6i8QXt6uR87K2Vc9brpMYcvmo3K6qMjYCHD0W5X\nsp3dUQKBgQCjL+cJEVomUa2zqpn4vZX8QfkC59WZy2yeVKPeHSs5/DrnX7pwRQN2\n3PxBMzyV37Xe9ko9MdsCxyeUmgkiylx+1ls7arFn46lHzw/LBSOdHivRKOKeAB6T\ntlFFML+kSNR3JUXzxqkQRb+jA6ikTOnVGPx98KjcbcbaKz5M+bsp0w==\n-----END RSA PRIVATE KEY-----\n"
