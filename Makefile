extended-ubuntu: extended-ubuntu/Dockerfile
	docker build $@ -t andyreagan/$@

datasci-hammer-ubuntu: datasci-hammer-ubuntu/Dockerfile extended-ubuntu
	docker build $@ -t andyreagan/$@
	docker push andyreagan/$@

launch: datasci-hammer-ubuntu
	docker run -it -v $(pwd)/src:/home/jovyan/src\
	 -v $(pwd)/data:/home/jovyan/data \
	 -p 8888:8888 \
	 andyreagan/$< start.sh jupyter lab --NotebookApp.token=''
