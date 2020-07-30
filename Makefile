TOOLS_DIR := $(shell pwd)/envtools
FLUTTER_DIR := $(TOOLS_DIR)/flutter
JDK_DIR := $(TOOLS_DIR)/jdk
SDK_DIR := $(TOOLS_DIR)/sdk

setup-env:
	mkdir -p $(TOOLS_DIR)
	cd $(TOOLS_DIR)
	
	if [ ! -d "$(FLUTTER_DIR)" ]; then \
		git clone https://github.com/flutter/flutter.git -b stable --depth 1 $(FLUTTER_DIR); \
		$(FLUTTER_DIR)/bin/flutter --suppress-analytics upgrade; \
	fi
	
	if [ ! -d "$(JDK_DIR)" ]; then \
		wget https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz; \
		tar -xf openjdk-11.0.2_linux-x64_bin.tar.gz; \
		mv jdk-11.0.2/ $(JDK_DIR); \
	fi

	if [ ! -d "$(SDK_DIR)" ]; then \
		mkdir $(SDK_DIR); \
		wget https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip; \
		unzip -q commandlinetools-linux-6609375_latest.zip; \
		mv tools/ sdktools/; \
		yes | JAVA_HOME=$(JDK_DIR) sdktools/bin/sdkmanager --sdk_root="$(SDK_DIR)" --install 'platforms;android-28' 'build-tools;28.0.3'; \
	fi

run:
	ANDROID_HOME="$(SDK_DIR)" JAVA_HOME="$(JDK_DIR)" $(FLUTTER_DIR)/bin/flutter --suppress-analytics run

clean:
	$(FLUTTER_DIR)/bin/flutter --suppress-analytics clean

doctor:
	$(FLUTTER_DIR)/bin/flutter --suppress-analytics doctor

pub-get:
	$(FLUTTER_DIR)/bin/flutter --suppress-analytics pub get

clean-env:
	rm -rf $(TOOLS_DIR)
