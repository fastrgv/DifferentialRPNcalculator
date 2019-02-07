
if [ -d ./obj/ ]; then
	rm ./obj/*
else
	mkdir obj
fi


export PATH=$HOME/opt/GNAT/2018/bin:$PATH

gnatmake drpn -o drpn_gnu -D obj

