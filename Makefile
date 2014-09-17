


default:
	-cd build; make
	./build/pomodoro

clean:
	rm -fr build
	mkdir build
	cd build; cmake ..
