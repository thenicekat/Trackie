clean:
	@echo "Cleaning..."
	cd android && ./gradlew clean
	@echo "Cleaned successfully!"
.PHONY: clean

aab-release:
	@echo "Cleaning old AAB..."
	@rm -rf android/app/build/outputs/bundle/release
	@echo "Building AAB..."
	cd android && ./gradlew bundleRelease --stacktrace
	@echo "AAB built successfully!"
.PHONY: aab-release
