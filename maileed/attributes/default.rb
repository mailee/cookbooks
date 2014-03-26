default['maileed']['ssh']['public_key'] = '12345'
default['maileed']['ssh']['private_key'] = '12345'

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
