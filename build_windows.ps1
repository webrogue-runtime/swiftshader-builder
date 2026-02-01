if (-Not (Test-Path -Path depot_tools)) {
    git clone --single-branch --depth=1 https://github.com/google/swiftshader.git
}
cmake -S . -B build '-DCMAKE_POLICY_VERSION_MINIMUM=3.5' -G 'Visual Studio 17 2022'
cmake --build build --parallel --config Release --target vk_swiftshader

mkdir artifacts
mkdir artifacts\x64
Copy-Item build\Release\vk_swiftshader.dll -Destination artifacts\x64\vk_swiftshader.dll
Compress-Archive -Path .\artifacts\x64\ -DestinationPath .\artifacts\x64.zip
