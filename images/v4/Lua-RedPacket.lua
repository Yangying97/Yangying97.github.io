
--hset red_packet_5 stock 1000
--hset red_packet_5 unit_amount 10

--缓存抢红包信息列表的key
local listKey = 'red_packet_list_'..KEYS[1]

--当前被抢红包key
local redPacket = 'red_packet_'..KEYS[1]

--获取当前红包库存
local stock = tonumber(redis.call('hget',redPacket,'stock'))

--没有库存，返回0
if stock <= 0 then return 0 end

--库存减1
stock = stock - 1
--保存当前库存
redis.call('hset',redPacket,'stock',tostring(stock))
--往链表加入当前红包信息
redis.call('rpush',listKey,ARGV[1])

--最后一个红包，返回2 抢红包结束 将列表中的数据保存到数据库
if stock == 0 then return 2 end

--非最后一个红包 返回1 抢红包成功
return 1