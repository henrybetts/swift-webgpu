# exit when any command fails
set -e

# path to the macos artifact from google's CI run
# https://github.com/google/dawn/actions/workflows/ci.yml
# expect RELEASE_ROOT/lib and /include dirs inside
# todo: automate this? or make it a param?
#RELEASE_ROOT="Dawn-ecf224df05e711fe7009fbd76840301fb82bde1a-macos-latest-Release"
RELEASE_ROOT="./"

OUTPUT_FILENAME="Dawn.xcframework"
OUTPUT_PATH="./${OUTPUT_FILENAME}"

MACOS_LIBRARY_PATH="${RELEASE_ROOT}/lib/libwebgpu_dawn.dylib"
MACOS_HEADER_PATH="${RELEASE_ROOT}/include"
DAWN_JSON_PATH="${RELEASE_ROOT}/dawn.json"

# we cannot include arbritary files into an xcframework via normal means, but we can sneak them into the headers
#cp ${DAWN_JSON_PATH} ${MACOS_HEADER_PATH}

rm -r ${OUTPUT_PATH}

xcodebuild -create-xcframework \
	-library ${MACOS_LIBRARY_PATH} \
	-headers ${MACOS_HEADER_PATH}	\
	-output ${OUTPUT_PATH}

# we cannot include arbritary files into an xcframework via normal means, but we can sneak them into the headers
cp ${DAWN_JSON_PATH} ${OUTPUT_PATH}
