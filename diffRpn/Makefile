
cpath=$(HOME)/opt/GNAT/2018/bin

CC=$(cpath)/gnatmake

drpn_osx:  mathtypes.ads
	mkdir -p obj
	$(CC) drpn -D $(CURDIR)/obj -I$(CURDIR) 
	mv drpn drpn_osx

drpn_gnu:  mathtypes.ads
	mkdir -p obj
	$(CC) drpn -D obj -I$(CURDIR)
	mv drpn drpn_gnu

.PHONY : clean

clean: 
	-rm -Rf drpn_osx drpn_gnu obj 
