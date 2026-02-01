# I failed to build SwiftShader for iOS simulator, sorry
# But this file stays

set -ex
cd $(dirname $0)

[ -d "swiftshader" ] || git clone --single-branch --depth=1 https://github.com/google/swiftshader.git

sed -i '' 's/"${COCOA_FRAMEWORK}" //g' swiftshader/CMakeLists.txt
sed -i '' 's/"${QUARTZ_FRAMEWORK}" //g' swiftshader/CMakeLists.txt
sed -i '' 's/	        ${CORE_TABLES_BODY_INC_FILE}/spirv-tools-tables/g' swiftshader/third_party/SPIRV-Tools/source/CMakeLists.txt
sed -i '' '/^macro/! { /set_cpp_flag/d; }' swiftshader/CMakeLists.txt

cmake -B build -S . \
    -G Xcode -DCMAKE_SYSTEM_NAME=iOS \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DSKIP_GLSLANG_INSTALL=ON

XCODE_CONFIGURATION_FLAG="-configuration=Debug"

XCODE_DESTINATION="generic/platform=iOS Simulator"

XCODEBUILD_FLAGS="-project build/SwiftShader.xcodeproj -scheme vk_swiftshader  CODE_SIGN_IDENTITY=\"\" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO $XCODE_DESTINATION_FLAG_1"

xcodebuild $XCODEBUILD_FLAGS -parallelizeTargets -destination "$XCODE_DESTINATION"
XC_BUILD_DIR=$(xcodebuild $XCODEBUILD_FLAGS -destination "$XCODE_DESTINATION" -showBuildSettings | grep -m 1 "BUILT_PRODUCTS_DIR" | grep -oEi "\/.*" || exit 3)
# 
