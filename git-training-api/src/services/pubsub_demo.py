import redis


redisConn = redis.Redis()

def handlerFunc(payload):
    print(payload["data"])

sbsPubSub = redisConn.pubsub()

#sbsPubSub.subscribe(**{'sbs_data_change': handlerFunc})
sbsPubSub.subscribe(**{"name": handlerFunc, "mychannel": handlerFunc, "marripudi": handlerFunc})
# sbsPubSub.subscribe(mychannel = handlerFunc)
sbsPubSub.subscribe(Gio = handlerFunc)

sbsPubSub = sbsPubSub.run_in_thread(sleep_time= 0.001, daemon= False)