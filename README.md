# 🛍️ Mini E-Commerce App

**BÀI THỰC HÀNH 4 - NHÓM 8: Ứng dụng bán hàng cơ bản với Flutter**

Ứng dụng e-commerce mini hoàn chỉnh với danh sách sản phẩm, trang chi tiết, giỏ hàng, thanh toán và lịch sử đơn hàng. Dự án tổng hợp kiến thức từ BÀI THỰC HÀNH 1-3 (UI, API, Navigation) và giải quyết bài toán quản lý trạng thái liên màn hình.

---

## 📋 Mục Lục

- [Tính Năng Chính](#tính-năng-chính)
- [Yêu Cầu Hệ Thống](#yêu-cầu-hệ-thống)
- [Cài Đặt](#cài-đặt)
- [Kiến Trúc Dự Án](#kiến-trúc-dự-án)
- [Hướng Dẫn Sử Dụng](#hướng-dẫn-sử-dụng)
- [Công Nghệ Sử Dụng](#công-nghệ-sử-dụng)
- [Cấu Trúc Màn Hình](#cấu-trúc-màn-hình)

---

## ✨ Tính Năng Chính

### 🏠 Trang Chủ (Home Screen)
- **SliverAppBar** với tiêu đề "TH4 - Nhóm 8" và gradient động
- **Search Bar tường minh** - dính ở đầu khi cuộn, thay đổi màu nền
- **Banner Carousel** - quảng cáo tự động phát, chỉ báo dấu chấm
- **Danh mục nổi bật** - grid 2 hàng, cuộn ngang
- **Danh sách sản phẩm** - GridView 2 cột với thẻ sản phẩm chi tiết
- **Thẻ sản phẩm** hiển thị: ảnh (Hero animation), tên (2 dòng), giá, tag (Giảm 50%, Yêu thích, Mall), lượt bán, rating
- **Pull to Refresh** - vuốt từ trên xuống để làm mới
- **Infinite Scrolling** - tự động tải trang tiếp theo khi cuộn đến cuối
- **Loading states** - shimmer placeholder, skeleton grid, error state

### 📦 Chi Tiết Sản Phẩm (Product Detail Screen)
- **Hero Animation** - ảnh phóng to mượt mà từ trang chủ
- **Slider ảnh** - xem nhiều góc độ (PageView)
- **Hiển thị giá** - giá hiện tại (màu đỏ), giá gốc (gạch ngang)
- **Rating sao** - hiển thị đánh giá + số lượt review
- **Mô tả sản phẩm** - "Xem thêm/Thu gọn" nếu quá dài
- **Chọn phân loại** - Size (S, M, L, XL) & Màu sắc via BottomSheet
- **Bottom Sheet selection** - chọn size, màu, số lượng (+/-)
- **Bottom Navigation Bar** - Chat icon, Cart icon, "Thêm vào giỏ", "Mua ngay"
- **SnackBar thông báo** - "Đã thêm X sản phẩm" + badge giỏ hàng tự update

### 🛒 Giỏ Hàng (Cart Screen)
- **Danh sách sản phẩm** - ListView với Checkbox cho từng item
- **Checkbox "Chọn tất cả"** - smart logic tự động toggle
- **Chi tiết item** - ảnh, tên, phân loại, giá, số lượng +/-
- **Vuốt trái để xóa** - Dismissible với nền đỏ + icon thùng rác
- **Hoàn tác xóa** - SnackBar action "Hoàn tác" phục hồi item
- **Tính tiền động** - chỉ cộng những sản phẩm đã check
- **Xóa với xác nhận** - khi số lượng = 0, hỏi trước
- **Thanh toán** - nút chuyển đến checkout

### 💳 Thanh Toán (Checkout Screen)
- **Xác nhận sản phẩm đã chọn** - danh sách cuối cùng trước thanh toán
- **Nhập địa chỉ giao hàng** - TextFormField với validation
- **Chọn phương thức thanh toán** - COD hoặc Momo
- **Tổng tiền cuối** - hiển thị rõ ràng
- **Dialog thành công** - "Đặt hàng thành công" + 2 tùy chọn
- **Xóa/Điều hướng** - xóa selected items, quay về trang chủ hoặc xem đơn mua

### 📜 Lịch Sử Đơn Hàng (Order History Screen)
- **Tab bar** - 4 trạng thái: Chờ xác nhận | Đang giao | Đã giao | Đã hủy
- **Hiển thị đơn** - mã đơn, ngày, số sản phẩm, phương thức thanh toán, địa chỉ, tổng tiền, status chip

### 💬 Tư Vấn Sản Phẩm (Product Chat Screen)
- Chat Q&A mock cho tư vấn sản phẩm
- Trả lời tự động về giá, đánh giá, phân loại, vận chuyển

---

## 🎨 Tính Năng UX/UI

✅ **Animations**
- Hero animation cho ảnh sản phẩm  
- Gradient transition động trên AppBar khi cuộn
- Shimmer loading effect
- Animated dots indicator trên banner

✅ **Loading & Error States**
- Skeleton grid loading (6 items)
- Shimmer placeholder trên product card
- Error state với nút Retry
- Empty state cho danh mục không có sản phẩm
- Circular progress indicator khi load more

✅ **Polish**
- Tất cả giá hiển thị format USD ($XX.XX)
- Modal bottom sheet với border radius 20px
- Card styling: border-radius 12, elevation 1-1.5
- Theme color teal (0xFF00A59B)
- Responsive layout với SliverGrid, LayoutBuilder

---

## 📱 Yêu Cầu Hệ Thống

- **Flutter**: >= 3.10.7
- **Dart**: >= 3.10.7
- **Android**: API level 21+
- **iOS**: 11.0+

---

## 🚀 Cài Đặt

### 1. Clone repo
```bash
git clone <repo-url>
cd mini_ecommerce_app
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Run app
```bash
flutter run
```

### 4. Build (tuỳ chọn)
```bash
# Android
flutter build apk

# iOS
flutter build ios
```

---

## 🏗️ Kiến Trúc Dự Án

Dự án tuân theo **MVVM Pattern** với cấu trúc thư mục rõ ràng:

```
lib/
├── main.dart                    # Entry point, MultiProvider setup
├── models/                      # Data models
│   ├── cart_item_model.dart     # CartItem, serialization
│   ├── order_model.dart         # OrderModel, Order status enum
│   └── product_model.dart       # Product, Rating models
├── providers/                   # State management (Provider pattern)
│   ├── cart_provider.dart       # Cart state: add, remove, select, persist
│   ├── order_provider.dart      # Order state: create, filter, persist
│   └── product_provider.dart    # Product state: fetch, filter, infinite scroll
├── screens/                     # UI screens
│   ├── home_screen.dart         # Trang chủ
│   ├── product_detail_screen.dart   # Chi tiết sản phẩm
│   ├── cart_screen.dart         # Giỏ hàng
│   ├── checkout_screen.dart     # Thanh toán
│   ├── order_history_screen.dart    # Lịch sử đơn
│   └── product_chat_screen.dart     # Tư vấn chat
├── services/                    # API & external services
│   └── api_service.dart         # FakeStore API client
└── widgets/                     # Reusable components
    ├── banner_slider.dart       # Banner carousel
    ├── cart_item_widget.dart    # Cart item card
    ├── category_item.dart       # Category button
    ├── product_card.dart        # Product card
    └── product_selection_bottom_sheet.dart  # Size/Color selection
```

---

## 📖 Hướng Dẫn Sử Dụng

### Luồng Mua Sắm

1. **Trang chủ**: Duyệt sản phẩm, tìm kiếm, lọc danh mục, vuốt refresh
2. **Chi tiết**: Xem ảnh, giá, đánh giá, mô tả → Chọn size/màu/số lượng
3. **Thêm giỏ**: Popup bottom sheet → Xác nhận → SnackBar thành công
4. **Giỏ hàng**: Xem sản phẩm, check/uncheck, tăng/giảm số lượng
5. **Thanh toán**: Chọn sản phẩm → Nhập địa chỉ → Chọn thanh toán → Đặt hàng
6. **Lịch sử**: Xem đơn hàng theo trạng thái (chờ, đang giao, đã giao, hủy)

### State Management

- **ProductProvider**: Quản lý danh sách sản phẩm, filter, pagination
- **CartProvider**: Quản lý giỏ hàng (add, remove, select, quantiy), lưu offline
- **OrderProvider**: Quản lý đơn hàng, filter theo status, lưu offline

Tất cả trạng thái được **persist via SharedPreferences** → Tắt app bật lại vẫn giữ dữ liệu

---

## 🔧 Công Nghệ Sử Dụng

| Package | Phiên bản | Mục đích |
|---------|----------|---------|
| **provider** | ^6.1.5 | State management |
| **http** | ^1.5.0 | API calls |
| **carousel_slider** | ^5.1.1 | Banner carousel |
| **badges** | ^3.1.2 | Cart badge |
| **cached_network_image** | ^3.4.1 | Image caching + placeholder |
| **shared_preferences** | ^2.5.3 | Offline persistence |

### API Source
- **FakeStore API** (https://fakestoreapi.com/)
  - 20 sản phẩm mẫu
  - 4 danh mục: electronics, jewelery, men's clothing, women's clothing
  - Hỗ trợ pagination, filter by category

---

## 🎯 Cấu Trúc Màn Hình

### Home Screen Flow
```
AppBar (TH4 - Nhóm 8) + Cart Badge
    ↓
Search Bar (sticky on scroll)
    ↓
Banner Carousel (auto-play)
    ↓
Category Grid (2 rows horizontal scroll)
    ↓
Product GridView (2 columns, infinite scroll)
    ↓
Pull to Refresh
```

### Product Detail Flow
```
Hero Image + 3-angle slider
    ↓
Price (current + original strikethrough)
    ↓
Rating stars
    ↓
Description (expand/collapse)
    ↓
[BottomSheet] → Size + Color selection
    ↓
Bottom Nav: Chat | Cart | "Thêm vào giỏ" | "Mua ngay"
```

### Cart Flow
```
Checkbox "Chọn tất cả"
    ↓
ListView [Item 1, Item 2, ...]
    (Swipe left to delete)
    ↓
Bottom Bar: Total + "Thanh toán" button
```

### Checkout Flow
```
Order summary (Item 1, Item 2, ...)
    ↓
Address input (validation)
    ↓
Payment method (COD / Momo)
    ↓
[Đặt hàng] button
    ↓
Success dialog → Home / Order History
```

---

## 🧪 Testing

### Manual Testing Checklist
- [ ] Search sản phẩm hoạt động
- [ ] Filter danh mục thay đổi danh sách
- [ ] Pull to refresh làm mới dữ liệu
- [ ] Infinite scroll tải thêm trang
- [ ] Thêm vào giỏ → Badge +1
- [ ] Check/uncheck item → Tổng tiền thay đổi
- [ ] Chọn tất cả → Tất cả item check
- [ ] Thanh toán → Tạo đơn hàng
- [ ] Tắt app → Mở lại → Giỏ hàng/Đơn hàng vẫn có

---

## 📝 Ghi Chú Phát Triển

### Offline Support
- Giỏ hàng lưu local via `SharedPreferences`
- Đơn hàng lưu local via `SharedPreferences`
- Tự động load khi app khởi động

### Error Handling
- Try-catch trên tất cả API calls
- User-friendly error messages
- Retry button trên error state
- Network timeout handling

### Performance
- `CachedNetworkImage` - cache ảnh
- `Shimmer placeholder` - perceived performance
- `Pagination` - không load tất cả sản phẩm cùng lúc
- `ChangeNotifier` + `Consumer` - rebuild optimal

---

## 📄 License

This project is part of a Flutter training course (BÀI THỰC HÀNH 4).

---

## 👥 Nhóm 8

**Dự án tập thể** - Mini E-Commerce App

**Công nghệ**: Flutter + Provider + FakeStore API

**Ngày hoàn thành**: March 2026

---

## 📞 Hỗ Trợ

Nếu gặp vấn đề:
1. Chạy `flutter pub get` để cài dependencies
2. Clean build: `flutter clean` → `flutter pub get`
3. Kiểm tra Flutter version: `flutter --version`
4. Xem logs: `flutter logs`

---

**Happy coding! 🚀**
