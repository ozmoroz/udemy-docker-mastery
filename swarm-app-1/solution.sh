# Create networks
vdocker network create --driver overlay frontend
docker network create --driver overlay backend

# Create web front end for users to vote dog/cat

docker service create \
    --name vote \
    --network frontend \
    --replicas 2 \
    --publish 80:80 \
    dockersamples/examplevotingapp_vote:before

# Create redis service - key/value storage for incoming votes

docker service create \
    --name redis \
    --network frontend \
    --replicas 1 \
    redis:3.2

# Create worker service - backend processor of redis and storing results in postgres

docker service create \
    --name worker \
    --network frontend \
    --network backend \
    --replicas 1 \
    dockersamples/examplevotingapp_worker

# Create db service - PostgreSQL

docker service create \
    --name db \
    --network backend \
    --mount type=volume,source=db-data,target=/var/lib/postgresql/data \
    postgres:9.4

# Create result service - web app that shows results

docker service create \
    --name result \
    --publish 5001:80 \
    --network backend \
    dockersamples/examplevotingapp_result:before


