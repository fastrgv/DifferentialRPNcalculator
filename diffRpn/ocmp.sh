
# use this to ensure a complete recompilation:
if [ -d ./obj/ ]; then
	rm ./obj/*
else
	mkdir obj
fi

# Now, we use AdaCore2018:
export PATH=$HOME/opt/GNAT/2018/bin:$PATH

gnatmake drpn -o drpn_osx -D $PWD/obj

