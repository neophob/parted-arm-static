# parted-arm-static
Quick hack to build a static parted for arm. Not really a beauty but does the trick

# Build

```
docker build -t static-binaries-arm .
mkdir -p dist
rm -rf /dist/*
docker run -v $(pwd)/dist:/out static-binaries-arm bash -c "cp -r /dist/* /out"
```
