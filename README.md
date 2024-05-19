# Dự án Phần mềm Kỹ thuật Web App

![Screenshot 2024-05-19 134312](https://github.com/quyencanh203/Web-App-Software-Engineering-/assets/125014823/84ea2cf5-e7d1-404f-ac34-ce8fc9a5cfc4)

## Giới thiệu

Đây là dự án Phần mềm Kỹ thuật Web App được phát triển bởi [Quyền Cảnh](https://github.com/quyencanh203) và [Phạm Quân](https://github.com/hquan3404). Dự án này tập trung vào việc xây dựng một ứng dụng web hiện đại và linh hoạt giúp kết nối học sinh và gia sư một cách hiệu quả.

Thông tin chi tiết về sản phẩm và cách cài đặt chạy demo được trình bày trong video và bài báo cáo. Bạn có thể xem thêm tại [VIDEO VÀ BÁO CÁO BTL](https://drive.google.com/drive/folders/16rZRvvGM9Y5cE_o_7BkkvhTaqto2yB-O?usp=sharing).

## Mục lục

1. [Thông tin dự án](#thông-tin-dự-án)
2. [Tính năng](#tính-năng)
3. [Cài đặt](#cài-đặt)
4. [Sử dụng](#sử-dụng)
5. [Cấu trúc dự án](#cấu-trúc-dự-án)
6. [Đóng góp](#đóng-góp)
7. [Giấy phép](#giấy-phép)

## Thông tin dự án

Dự án lập trình web gia sư nhằm tạo ra một nền tảng kết nối học sinh và gia sư. Mục tiêu chính của web là tạo ra một nơi để học sinh có thể đưa ra yêu cầu tìm kiếm gia sư và gia sư có thể đăng ký nhận lớp. 

## Tính năng

- Học sinh có thể tạo yêu cầu tìm kiếm gia sư với các tiêu chí cụ thể.
- Gia sư có thể duyệt qua các yêu cầu và đăng ký nhận lớp.
- Hệ thống quản lý tài khoản cho cả học sinh và gia sư.
- Giao diện thân thiện và dễ sử dụng.
- Hỗ trợ tìm kiếm và lọc yêu cầu dựa trên các tiêu chí như môn học, địa điểm, và mức phí.

## Cài đặt

Hướng dẫn cài đặt dự án và thiết lập môi trường phát triển:

1. Tạo cơ sở dữ liệu trên máy tính local với tên `dataq`.
2. Tạo môi trường ảo:
    ```bash
    pip install virtualenv
    virtualenv venv
    ```
3. Kích hoạt môi trường ảo:
    - Trên Windows:
        ```bash
        venv\Scripts\activate
        ```
    - Trên macOS/Linux:
        ```bash
        source venv/bin/activate
        ```
4. Cài đặt các gói cần thiết:
    ```bash
    pip install -r requirements.txt
    ```
5. Chuyển đến thư mục ứng dụng:
    ```bash
    cd Tutor_app/app
    ```
6. Khởi chạy ứng dụng:
    ```bash
    python app.py
    ```

## Sử dụng

Hướng dẫn chi tiết cách sử dụng ứng dụng có sẵn trong [README.md](https://github.com/quyencanh203/Web-App-Software-Engineering-/blob/main/README.md#L32-L33).

## Cấu trúc dự án

Dưới đây là cấu trúc thư mục của dự án:

![Screenshot 2024-05-19 160617](https://github.com/quyencanh203/Web-App-Software-Engineering-/assets/125014823/9c7b7fff-7c51-4f6e-b0f7-e32db8f5123c)


## Đóng góp

Chúng tôi hoan nghênh mọi đóng góp từ cộng đồng. Vui lòng tạo một nhánh mới, thực hiện các thay đổi và gửi yêu cầu kéo (pull request) để chúng tôi xem xét.

## Giấy phép

Dự án này được cấp phép theo [MIT License](LICENSE).
