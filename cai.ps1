# ============================================================================
#  XUONG DUNG VIDEO REMOTION - TRINH CAI
#  Tai goi cai tu GitHub, mo khoa bang mat khau khoa hoc, roi cai ca 4 bo.
#
#  Hoc vien: mo Claude Code va noi
#      "Cai cai nay cho anh https://github.com/giacatduan87/xuong-video-remotion"
#  Hoac tu chay bang PowerShell:
#      $p="$env:TEMP\cai.ps1"; irm https://raw.githubusercontent.com/giacatduan87/xuong-video-remotion/main/cai.ps1 -OutFile $p; & $p
# ============================================================================
param(
  [string]$MatKhau = "",           # mat khau khoa hoc
  [string]$ThuMuc  = "",           # thu muc cai du an (mac dinh C:\REMOTION)
  [string]$Bo      = "1,2,3,4",    # chon bo can cai
  [switch]$BoQuaWhisper,           # khong tai Whisper (~1,6 GB)
  [switch]$BoQuaMoHinhGiongDoc,    # khong tai mo hinh giong doc (~600 MB)
  [switch]$KhongHoi,               # chay thang, khong hoi gi
  [string]$GoiNoiBo = "",          # dung goi.enc co san tren may thay vi tai ve (de kiem thu)
  [string]$ChiMoKhoa = ""          # chi mo goi ra thu muc nay roi dung, KHONG cai (de kiem thu)
)
$ErrorActionPreference = "Stop"
$REPO  = "giacatduan87/xuong-video-remotion"
$NHANH = "main"

function Loi($chu) {
  Write-Host ""; Write-Host "LOI: $chu" -ForegroundColor Red
  if (-not $KhongHoi) { Read-Host "Bam Enter de dong" }
  exit 1
}

Write-Host ""
Write-Host "  XUONG DUNG VIDEO REMOTION" -ForegroundColor Yellow
Write-Host "  -------------------------" -ForegroundColor Yellow
Write-Host "  Cai 4 bo: dung video Remotion - 40 keyword - giong doc tieng Viet - video truoc & sau"
Write-Host ""

if ($PSVersionTable.PSVersion.Major -lt 5) { Loi "Can Windows PowerShell 5 tro len. Hay cap nhat Windows." }
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}
Add-Type -AssemblyName System.IO.Compression.FileSystem | Out-Null

# ---------- 1. Lay goi cai ----------
$tam = Join-Path $env:TEMP ("xuong-video-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
New-Item -ItemType Directory -Force $tam | Out-Null
$enc = Join-Path $tam "goi.enc"

if ($GoiNoiBo) {
  if (-not (Test-Path $GoiNoiBo)) { Loi "Khong thay $GoiNoiBo" }
  Copy-Item $GoiNoiBo $enc -Force
  Write-Host "Dung goi co san: $GoiNoiBo"
} else {
  $url = "https://raw.githubusercontent.com/$REPO/$NHANH/goi.enc"
  Write-Host "Dang tai goi cai (khoang 15 MB)..."
  try {
    $cu = $ProgressPreference; $ProgressPreference = "SilentlyContinue"
    Invoke-WebRequest -Uri $url -OutFile $enc -UseBasicParsing
    $ProgressPreference = $cu
  } catch {
    Loi "Khong tai duoc goi cai tu $url`n       Kiem tra ket noi Internet roi chay lai. ($($_.Exception.Message))"
  }
}
$kichThuoc = (Get-Item $enc).Length
if ($kichThuoc -lt 100000) { Loi "Goi cai tai ve bi loi (chi $kichThuoc byte). Chay lai sau it phut." }
Write-Host ("Da tai: {0:N1} MB" -f ($kichThuoc / 1MB)) -ForegroundColor Green

# ---------- 2. Mat khau ----------
$du = [IO.File]::ReadAllBytes($enc)
$magic = [Text.Encoding]::ASCII.GetString($du, 0, 9)
if ($magic -ne "GCDVIDEO1") { Loi "Goi cai khong dung khuon dang. Hay tai lai." }
$soVong = [BitConverter]::ToInt32($du, 9)
if ($soVong -lt 1000 -or $soVong -gt 10000000) { Loi "Goi cai bi hong (so vong lap = $soVong)." }
$salt = New-Object byte[] 16; [Array]::Copy($du, 13, $salt, 0, 16)
$iv   = New-Object byte[] 16; [Array]::Copy($du, 29, $iv, 0, 16)
$dai  = $du.Length - 45 - 32
if ($dai -le 0) { Loi "Goi cai bi hong (thieu du lieu)." }
$bomat = New-Object byte[] $dai; [Array]::Copy($du, 45, $bomat, 0, $dai)
$theGoc = New-Object byte[] 32; [Array]::Copy($du, $du.Length - 32, $theGoc, 0, 32)
$than = New-Object byte[] ($du.Length - 32); [Array]::Copy($du, 0, $than, 0, $than.Length)

$lanThu = 0
while ($true) {
  $lanThu++
  if (-not $MatKhau) {
    if ($KhongHoi) { Loi "Chua co mat khau khoa hoc. Chay lai voi tham so -MatKhau 'mat-khau-cua-ban'." }
    Write-Host ""
    $MatKhau = Read-Host "Nhap MAT KHAU KHOA HOC de mo goi cai"
    if (-not $MatKhau) {
      Loi ("Chua nhap mat khau khoa hoc.`n" +
           "       Neu dang chay tu dong (khong go tay duoc), hay truyen mat khau vao lenh:`n" +
           "         -MatKhau 'mat-khau-khoa-hoc' -KhongHoi")
    }
  }

  Write-Host "Dang mo khoa..."
  $kdf  = New-Object Security.Cryptography.Rfc2898DeriveBytes($MatKhau, $salt, $soVong)
  $khoa = $kdf.GetBytes(64)
  $khoaAes = New-Object byte[] 32; [Array]::Copy($khoa, 0,  $khoaAes, 0, 32)
  $khoaMac = New-Object byte[] 32; [Array]::Copy($khoa, 32, $khoaMac, 0, 32)

  $hmac = New-Object Security.Cryptography.HMACSHA256(, $khoaMac)
  $the  = $hmac.ComputeHash($than)
  $hmac.Dispose()
  $khop = $true
  for ($i = 0; $i -lt 32; $i++) { if ($the[$i] -ne $theGoc[$i]) { $khop = $false } }

  if ($khop) { break }
  Write-Host "MAT KHAU SAI." -ForegroundColor Red
  if ($KhongHoi) { Loi "Mat khau khoa hoc khong dung." }
  if ($lanThu -ge 3) { Loi "Sai mat khau 3 lan. Hoi lai noi ban mua khoa hoc roi chay lai." }
  $MatKhau = ""
}
Write-Host "Mat khau dung - da mo khoa" -ForegroundColor Green

# ---------- 3. Giai ma + giai nen ----------
$aes = [Security.Cryptography.Aes]::Create()
$aes.KeySize = 256
$aes.Mode    = [Security.Cryptography.CipherMode]::CBC
$aes.Padding = [Security.Cryptography.PaddingMode]::PKCS7
$aes.Key     = $khoaAes
$aes.IV      = $iv
try { $zipByte = $aes.CreateDecryptor().TransformFinalBlock($bomat, 0, $bomat.Length) }
catch { Loi "Khong giai ma duoc goi cai. Hay tai lai." }
finally { $aes.Dispose() }

$zip = Join-Path $tam "goi.zip"
[IO.File]::WriteAllBytes($zip, $zipByte)
$ruot = Join-Path $tam "goi"
New-Item -ItemType Directory -Force $ruot | Out-Null
try { [IO.Compression.ZipFile]::ExtractToDirectory($zip, $ruot) }
catch { Loi "Khong giai nen duoc goi cai: $($_.Exception.Message)" }
Remove-Item $zip -Force
Remove-Item $enc -Force

$trinhCai = Join-Path $ruot "cai-dat-tat-ca.ps1"
if (-not (Test-Path $trinhCai)) { Loi "Goi cai thieu cai-dat-tat-ca.ps1." }
Write-Host ("Da mo goi: {0} file" -f (Get-ChildItem $ruot -Recurse -File).Count) -ForegroundColor Green

if ($ChiMoKhoa) {
  New-Item -ItemType Directory -Force $ChiMoKhoa | Out-Null
  Copy-Item (Join-Path $ruot "*") $ChiMoKhoa -Recurse -Force
  Remove-Item $tam -Recurse -Force -ErrorAction SilentlyContinue
  Write-Host "Da mo goi ra: $ChiMoKhoa (khong cai gi ca)" -ForegroundColor Green
  exit 0
}

# ---------- 4. Cai ----------
$tv = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $trinhCai, "-Bo", $Bo)
if ($ThuMuc)               { $tv += @("-ThuMuc", $ThuMuc) }
if ($BoQuaWhisper)         { $tv += "-BoQuaWhisper" }
if ($BoQuaMoHinhGiongDoc)  { $tv += "-BoQuaMoHinhGiongDoc" }
if ($KhongHoi)             { $tv += "-KhongHoi" }
& (Get-Process -Id $PID).Path @tv
$ketQua = $LASTEXITCODE

# ---------- 5. Don ----------
Remove-Item $tam -Recurse -Force -ErrorAction SilentlyContinue
exit $ketQua
