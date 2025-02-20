


build : 
	@echo " ---- BUILD ---- "
	@docker build -t spark-hadoop-cluster .

start :
	@echo " ---- START ---- "
	@chmod +x startHadoopCluster.sh
	@./startHadoopCluster.sh 3
stop :
	@echo " ---- STOP ---- "
	@chmod +x stop.sh
	@./stop.sh

remove :
	@echo " ---- REMOVE ---- "
	@chmod +x remove_containers.sh
	@./remove_containers.sh

# remove :
# 	@echo " ---- REMOVE ---- "
# 	@chmod +x remove_containers.sh
# 	@./remove_containers.sh

connect :
	@echo " ---- MASTER NODE ---- "
	@docker exec -it cluster-master bash

master-ip : 
	@echo " ---- MASTER NODE IP ---- "
	@echo "Master node ip : " $(shell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cluster-master)
