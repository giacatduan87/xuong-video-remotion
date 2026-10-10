# Xưởng dựng video Remotion — bộ cài cho học viên

Bộ công cụ dựng video bằng AI trên Windows, gồm 4 phần, cài một lần.

**Cần mật khẩu khóa học để cài.** Ruột gói cài đã được khóa; trang này ai cũng xem được nhưng không mở được gói. Chưa có mật khẩu thì hỏi nơi bạn mua khóa học.

---

## Bộ này có gì

| Bộ | Làm được gì | Skill cho Claude Code |
|---|---|---|
| **1. Dựng video Remotion** | Dự án dựng video bằng mã (Remotion), thư viện ~170 âm hiệu ứng, tự tách phụ đề tiếng Việt bằng Whisper chạy trên máy | `remotion-cinematic-editor` + 12 skill chính chủ Remotion |
| **2. 40 keyword phong cách** | 40 kiểu chữ nổi PC01–PC40 cho Reels/TikTok (neon, vàng sang, thẻ giá, bảng xếp hạng…) kèm 11 âm hiệu ứng hiện đại | `remotion-keyword-phong-cach` |
| **3. Giọng đọc từ văn bản** | Đọc kịch bản thành giọng nói tiếng Việt (8 giọng), chạy trên máy, không gửi dữ liệu đi đâu | `remotion-giong-doc` |
| **4. Video trước & sau** | Ghép bản quay thô với bản đã edit thành một video dọc để khoe khác biệt | `remotion-truoc-sau` |

Bộ 1 là nền. Bộ 2–4 cắm thêm vào dự án mà bộ 1 tạo ra.

### Cần có trước

- Windows 10 hoặc 11, kết nối Internet.
- Trống khoảng **10 GB** trên ổ C.
- **Claude Code** đã cài trên máy (để dùng được 4 skill).

Trình cài tự tải Node.js, FFmpeg và Python 3.12 nếu máy chưa có.

---

## Cài đặt

### Cách 1 — tải về rồi bấm đúp (dễ nhất, khuyên dùng)

1. Ở đầu trang này, bấm nút xanh **`Code`** → **`Download ZIP`** (khoảng 15 MB).
2. Giải nén ra một thư mục **không dấu tiếng Việt**, ví dụ `C:\tam`.
   *(Chuột phải vào file nén → `Extract All…`)*
3. Bấm đúp **`CAI-DAT.bat`**.

Rồi trả lời 4 câu:

1. **Mật khẩu khóa học** — nhập mật khẩu bạn được cấp.
2. Thư mục cài đặt — bấm **Enter** để dùng `C:\REMOTION`.
3. Có tải Whisper tiếng Việt (~1,6 GB)? — bấm **Enter** (nên tải).
4. Có tải mô hình giọng đọc (~600 MB)? — bấm **Enter** (nên tải).

Rồi để đó. Lần đầu mất **20–40 phút** vì phải tải Node.js, FFmpeg, Remotion, Whisper và Python.

> ⚠️ Phải **giải nén trước** khi bấm đúp. Bấm đúp file `.bat` ngay trong file nén sẽ lỗi, vì Windows chỉ mở tạm một file lẻ mà thiếu `goi.enc` bên cạnh.

Trong lúc chạy, Windows có thể hiện cửa sổ **UAC** xin quyền để cài Node.js — bấm **Yes**.

### Cách 2 — một lệnh PowerShell

Mở **PowerShell** (bấm `⊞ Win`, gõ `powershell`, Enter) rồi dán nguyên dòng này:

```powershell
$p = Join-Path $env:TEMP 'cai.ps1'; iwr -UseBasicParsing https://raw.githubusercontent.com/giacatduan87/xuong-video-remotion/main/cai.ps1 -OutFile $p; powershell -NoProfile -ExecutionPolicy Bypass -File $p
```

Rồi trả lời 4 câu như trên.

> Dán **nguyên dòng**, đừng cắt bớt phần `-ExecutionPolicy Bypass`. Windows mặc định **chặn chạy file script**, thiếu phần đó sẽ báo
> `cai.ps1 cannot be loaded because running scripts is disabled on this system`.

### Nhờ Claude Code cài hộ

Nếu bạn đã có Claude Code, có thể nhờ nó cài thay vì tự gõ. Mở Claude Code và nói đại ý:

> *Cài bộ này cho tôi: https://github.com/giacatduan87/xuong-video-remotion — mật khẩu khóa học là `…`*

Đưa luôn mật khẩu trong câu nói thì Claude chạy được một mạch, không phải hỏi lại bạn giữa đường.

### Chạy không cần trả lời câu nào

Truyền mật khẩu vào thẳng lệnh, nó lấy hết giá trị mặc định:

```powershell
$p = Join-Path $env:TEMP 'cai.ps1'; iwr -UseBasicParsing https://raw.githubusercontent.com/giacatduan87/xuong-video-remotion/main/cai.ps1 -OutFile $p; powershell -NoProfile -ExecutionPolicy Bypass -File $p -MatKhau 'MAT-KHAU-CUA-BAN' -KhongHoi
```

Các tham số có thể thêm:

| Tham số | Tác dụng |
|---|---|
| `-ThuMuc 'D:\REMOTION'` | Cài vào thư mục khác (phải **không dấu**) |
| `-Bo '1,2'` | Chỉ cài bộ 1 và 2 |
| `-BoQuaWhisper` | Không tải Whisper (~1,6 GB) — lần đầu tách phụ đề sẽ tự tải |
| `-BoQuaMoHinhGiongDoc` | Không tải mô hình giọng đọc (~600 MB) — lần đầu đọc sẽ tự tải |
| `-KhongHoi` | Không hỏi gì, lấy hết giá trị mặc định |

---

## Kiểm tra đã cài xong chưa

Bấm đúp **`KIEM-TRA.bat`** (nằm cùng chỗ với `CAI-DAT.bat`). Nó in ra bảng rồi kết luận:

```
SKILL CHO CLAUDE CODE
  [ DU   ] remotion-cinematic-editor
  [ DU   ] remotion-keyword-phong-cach
  [ DU   ] remotion-giong-doc
  [ DU   ] remotion-truoc-sau
======================================================================
  CAI THANH CONG. Remotion 4.0.530
```

Cách đọc bảng:

| Dấu | Nghĩa |
|---|---|
| `[ DU   ]` | Xong |
| `[ chua ]` | Phần tải nặng chưa về — **không sao**, lần đầu dùng nó tự tải |
| `[THIEU ]` | Thiếu thật, nó ghi kèm cách sửa ngay bên cạnh |

Thiếu nhiều thì cách nhanh nhất là đổi tên `C:\REMOTION` thành `C:\REMOTION-cu` rồi chạy lại `CAI-DAT.bat`.

Nếu thấy `KHONG THAY DU AN` mà bạn đã cài vào thư mục khác, chạy `KIEM-TRA.bat -ThuMuc D:\duong-dan-cua-ban`.

**Cách kiểm nhanh không cần file nào:** bấm đúp `C:\REMOTION\MO-STUDIO.bat`. Chờ khoảng 30 giây, một cửa sổ trình duyệt mở ra, bên trái có danh sách video mẫu → xong.

---

## Cài xong thì dùng thế nào

Dự án nằm ở `C:\REMOTION`:

| Việc | Cách làm |
|---|---|
| Xem / tua video | Bấm đúp `MO-STUDIO.bat` |
| Tách phụ đề từ video | Kéo thả file video vào `PHIEN-AM.bat` |
| Đọc kịch bản thành giọng nói | Kéo thả file `.txt` vào `DOC-GIONG.bat` |
| Xuất video | Bấm đúp `XUAT-VIDEO.bat` |

**Cách nhanh nhất là nói với Claude Code.** Mở Claude Code tại `C:\REMOTION` rồi gõ:

> *dựng Reels dọc 60 giây từ các clip trong `public/nguon`, keyword dùng PC05 cho con số*

> *đọc kịch bản này bằng giọng Ngọc Huyền*

> *làm video trước và sau: gốc là `D:\quay\tho.mp4`, bản đã edit là `D:\quay\da-edit.mp4`*

4 skill nằm ở `C:\Users\<tên bạn>\.claude\skills\` nên Claude tự biết dùng, không cần nhắc tên skill. **Khởi động lại Claude Code** sau khi cài để nó nhận skill mới.

---

## Gặp lỗi?

| Thông báo | Cách xử lý |
|---|---|
| `running scripts is disabled on this system` | Windows chặn chạy script. Dùng **Cách 1** (tải ZIP, bấm đúp `CAI-DAT.bat`), hoặc dán lại lệnh ở Cách 2 cho đủ cả phần `-ExecutionPolicy Bypass`. |
| `MAT KHAU SAI` | Mật khẩu khóa học chưa đúng. Chú ý chữ hoa chữ thường và dấu gạch ngang. Hỏi lại nơi bạn mua khóa học. |
| `Chua nhap mat khau khoa hoc` | Bạn bấm Enter khi nó hỏi mật khẩu, hoặc đang chạy tự động. Chạy lại và nhập mật khẩu, hoặc thêm `-MatKhau 'mat-khau' -KhongHoi` vào lệnh. |
| `Khong tai duoc goi cai` | Mất mạng hoặc GitHub chặn tạm. Chờ vài phút rồi chạy lại. |
| `Duong dan co dau tieng Viet` | Thư mục cài phải không dấu. Dùng `C:\REMOTION`. |
| `Thu muc C:\REMOTION da co du lieu` | Đã cài lần trước. Đổi tên thư mục cũ thành `C:\REMOTION-cu` rồi chạy lại. |
| `Van chua thay Node.js` / `Van chua thay FFmpeg` | Đóng cửa sổ PowerShell, mở lại rồi chạy lại lệnh (để Windows nhận đường dẫn mới). |
| `May chua co winget` | Cập nhật *App Installer* trong Microsoft Store, hoặc tự cài Node.js tại [nodejs.org](https://nodejs.org) rồi chạy lại. |
| `WinError 206` / `too long` | Đường dẫn dự án quá dài. Cài lại vào `C:\REMOTION`. |

Trình cài **không ghi đè**: file trùng tên được sao lưu thành `.bak`, `src\Root.tsx` được sao lưu thành `Root.tsx.bak-<ngày giờ>`. Chạy lại nhiều lần không sao.

---

## Trong repo này có gì

| File | Là gì |
|---|---|
| `CAI-DAT.bat` | Bấm đúp là cài. Tự gọi `cai.ps1` với quyền chạy script, nên không vướng chặn của Windows. |
| `KIEM-TRA.bat` | Bấm đúp để xem đã cài xong chưa. Chỉ đọc và báo cáo, không sửa gì. |
| `cai.ps1` | Trình cài: mở khóa gói bằng mật khẩu rồi cài cả 4 bộ. Đọc được, không có gì che giấu. |
| `kiem-tra.ps1` | Phần việc thật của `KIEM-TRA.bat`. |
| `goi.enc` | Ruột gói cài (4 bộ, 225 file), khóa bằng AES-256. Không có mật khẩu thì không mở được. |

---

## Giấy phép

- Mã nguồn và âm thanh trong bộ: dùng tự do trong dự án của bạn. **Không phát lại gói cài hoặc mật khẩu cho người ngoài khóa học.**
- Phông chữ: Google Fonts (giấy phép OFL).
- **Remotion** miễn phí cho cá nhân và công ty từ 3 người trở xuống. Công ty đông hơn cần mua giấy phép Remotion.
- Whisper và mô hình giọng đọc chạy **trên máy bạn**, không gửi dữ liệu ra ngoài.
