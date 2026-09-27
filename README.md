# Lumiere Cinema

Lumiere Cinema là ứng dụng đặt vé và quản lý rạp chiếu phim được xây dựng bằng Flutter. Ứng dụng có các luồng riêng cho khách hàng và quản trị viên, sử dụng REST API để tải dữ liệu và thực hiện các thao tác nghiệp vụ.

> Dự án hiện đang trong quá trình phát triển. Một số chức năng quản trị vẫn là màn hình giữ chỗ; hãy xem mục [Trạng thái và lưu ý](#trạng-thái-và-lưu-ý) trước khi triển khai thực tế.

## Nội dung

- [Tính năng](#tính-năng)
- [Công nghệ](#công-nghệ)
- [Cấu trúc dự án](#cấu-trúc-dự-án)
- [Yêu cầu](#yêu-cầu)
- [Cài đặt và chạy](#cài-đặt-và-chạy)
- [Cấu hình backend](#cấu-hình-backend)
- [Luồng ứng dụng](#luồng-ứng-dụng)
- [Kiểm thử](#kiểm-thử)
- [Trạng thái và lưu ý](#trạng-thái-và-lưu-ý)

## Tính năng

### Khách hàng

- Giới thiệu ứng dụng lần đầu, đăng ký, đăng nhập và đăng xuất.
- Lưu token, vai trò và một số trạng thái phiên bằng `shared_preferences`; điều hướng theo vai trò sau khi khởi động.
- Duyệt phim đang chiếu và phim sắp chiếu, xem thông tin chi tiết và lịch chiếu.
- Chọn rạp, suất chiếu và ghế trong luồng đặt vé.
- Xem tin tức, thông tin tài khoản và lịch sử đơn hàng/vé.
- Hiển thị vé dưới dạng mã QR.
- Quản lý giỏ hàng bằng Provider; xem tổng tiền và tiến hành thanh toán PayPal ở chế độ sandbox.

### Quản trị viên

- Màn hình quản trị hiện cung cấp các mục quản lý chi nhánh, rạp, thể loại phim, phim và suất chiếu.
- Các mục ghế ngồi, vé và người dùng đang được hiển thị trong giao diện nhưng chưa có màn hình quản lý hoàn chỉnh.

## Công nghệ

- **Flutter / Dart**: giao diện và ứng dụng đa nền tảng.
- **Provider**: trạng thái giỏ hàng.
- **REST API** với `http`: xác thực và dữ liệu phim, rạp, lịch chiếu, đơn hàng, vé, tin tức, dịch vụ và tài khoản.
- **Shared Preferences**: lưu thông tin phiên đăng nhập cục bộ.
- **PayPal Checkout**: luồng thanh toán sandbox.
- Các thư viện giao diện và tiện ích: `intl`, `cached_network_image`, `carousel_slider`, `youtube_player_flutter`, `flutter_html`, `qr_flutter`, `barcode_widget`, `url_launcher`, `lucide_icons` và `font_awesome_flutter`.

## Cấu trúc dự án

```text
lib/
	main.dart                  Điểm vào ứng dụng, khởi tạo locale và Provider
	data/                      Dữ liệu tĩnh của ứng dụng
	models/                    Model ánh xạ dữ liệu API
	providers/                 Trạng thái dùng chung, hiện có giỏ hàng
	screens/
		Admin/                   Màn hình và luồng quản trị
		User/                    Màn hình khách hàng, đặt vé và tài khoản
		login_screen.dart        Đăng nhập
		register_screen.dart     Đăng ký
		splash_screen.dart       Kiểm tra giới thiệu và phiên đăng nhập
	services/                  Gọi API và xử lý nghiệp vụ
	utils/                     Hằng số và tiện ích dùng chung
	widgets/                   Widget giao diện tái sử dụng
assets/images/               Hình ảnh sử dụng trong ứng dụng
android/                     Cấu hình nền tảng Android
ios/                         Cấu hình nền tảng iOS
web/, windows/, macos/, linux/ Cấu hình nền tảng Flutter tương ứng
test/                        Kiểm thử
```

## Yêu cầu

- Flutter SDK tương thích với Dart SDK `^3.7.2` (xem `environment` trong `pubspec.yaml`).
- Android Studio hoặc Xcode tùy nền tảng cần chạy; cài đặt và khởi động một emulator/simulator hoặc kết nối thiết bị thật.
- Backend của dự án có thể truy cập từ thiết bị chạy ứng dụng.

Kiểm tra môi trường Flutter:

```bash
flutter doctor
```

## Cài đặt và chạy

Tại thư mục gốc dự án:

```bash
flutter pub get
flutter run
```

Chọn thiết bị cụ thể nếu cần:

```bash
flutter devices
flutter run -d <device-id>
```

Tạo bản build Android dạng APK:

```bash
flutter build apk
```

## Cấu hình backend

URL API được khai báo trong `lib/utils/api_constants.dart`. Mặc định ứng dụng đang dùng backend production:

```text
https://backend-cinema-u7ai.onrender.com
```

`ApiConstants.loginUrl` được ghép từ `baseUrl`; các service gọi những endpoint tương ứng theo từng nghiệp vụ. Để chạy với backend khác, cập nhật `baseUrl` và đảm bảo server cung cấp các API mà ứng dụng sử dụng.

Khi phát triển local, không dùng `0.0.0.0` làm địa chỉ đích từ thiết bị. Hãy cấu hình địa chỉ có thể truy cập được từ môi trường đang chạy app: ví dụ địa chỉ host dành cho Android Emulator hoặc địa chỉ IP LAN của máy phát triển khi dùng thiết bị thật. Đảm bảo backend và thiết bị nằm trong mạng có thể kết nối.

## Luồng ứng dụng

1. `main.dart` khởi tạo Flutter, định dạng ngày tháng tiếng Việt và đăng ký `CartProvider`.
2. `SplashScreen` đọc trạng thái đã xem giới thiệu, token, vai trò và mã người dùng từ `SharedPreferences`.
3. Ứng dụng mở màn hình giới thiệu, đăng nhập hoặc trang chính phù hợp với vai trò.
4. Các màn hình gọi service tương ứng để lấy/cập nhật dữ liệu backend. Những API yêu cầu xác thực sử dụng token Bearer.
5. Khách hàng thêm dịch vụ vào giỏ, kiểm tra tổng tiền và thực hiện luồng thanh toán; đơn hàng được tạo sau callback thanh toán thành công.

## Kiểm thử

Chạy toàn bộ kiểm thử Flutter:

```bash
flutter test
```

Hiện `test/sample_test.dart` chỉ có một kiểm thử mẫu đơn giản; chưa có bộ kiểm thử bao phủ các luồng đặt vé, xác thực hoặc tích hợp API.

## Trạng thái và lưu ý

- Ứng dụng phụ thuộc backend để tải dữ liệu và thực hiện nghiệp vụ; cần xác nhận backend khả dụng và đúng cấu trúc dữ liệu trước khi chạy các luồng này.
- Quản lý ghế, vé và người dùng phía admin chưa hoàn chỉnh.
- PayPal hiện được tích hợp ở chế độ sandbox. Không đưa client secret hoặc thông tin xác thực thanh toán vào mã nguồn phát hành; hãy thu hồi/thay thế thông tin đã lộ, chuyển xử lý bí mật về backend và cung cấp cấu hình an toàn cho môi trường triển khai.
- Đây là trạng thái theo mã nguồn hiện tại, không phải xác nhận rằng mọi luồng đã được kiểm thử trên thiết bị hoặc sẵn sàng phát hành.
