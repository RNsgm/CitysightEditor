
all:
	~

building:
	flutter build web --web-renderer canvaskit --dart-define=BROWSER_IMAGE_DECODING_ENABLED=false --dart-define ACCESS_TOKEN=pk.eyJ1Ijoibm9qZWQiLCJhIjoiY2swc2VseDIzMDFzMTNnbHRzeXI4OHM1dSJ9.a5zQLX6VgSABJEdj6U_IXg

run:
	flutter run -d chrome --web-port=9090 --web-renderer canvaskit --debug --dart-define=BROWSER_IMAGE_DECODING_ENABLED=false --dart-define ACCESS_TOKEN=pk.eyJ1Ijoibm9qZWQiLCJhIjoiY2swc2VseDIzMDFzMTNnbHRzeXI4OHM1dSJ9.a5zQLX6VgSABJEdj6U_IXg
