# ============================================================================
#  KIEM TRA DA CAI THANH CONG CHUA
#  Bam dup KIEM-TRA.bat. In ra bang DU / THIEU roi ket luan.
#  Khong sua gi, khong cai gi - chi doc va bao cao.
# ============================================================================
param(
  [string]$ThuMuc = "",
  [switch]$KhongHoi
)
$ErrorActionPreference = "Continue"

$thieu = 0
$canhBao = 0
function Muc($ten, $dieuKien, $batBuoc = $true, $ghiChu = "") {
  if ($dieuKien) {
    Write-Host ("  [ DU   ] " + $ten) -ForegroundColor Green
  } elseif ($batBuoc) {
    Write-Host ("  [THIEU ] " + $ten + $(if ($ghiChu) { "  -> $ghiChu" } else { "" })) -ForegroundColor Red
    $script:thieu++
  } else {
    Write-Host ("  [ chua ] " + $ten + $(if ($ghiChu) { "  -> $ghiChu" } else { "" })) -ForegroundColor Yellow
    $script:canhBao++
  }
}

Write-Host ""
Write-Host "  KIEM TRA XUONG DUNG VIDEO REMOTION" -ForegroundColor Yellow
Write-Host "  ----------------------------------" -ForegroundColor Yellow

# ---------- Tim thu muc du an ----------
if (-not $ThuMuc) {
  foreach ($t in @("C:\REMOTION", "D:\REMOTION", "E:\REMOTION")) {
    if (Test-Path (Join-Path $t "package.json")) { $ThuMuc = $t; break }
  }
}
if (-not $ThuMuc) {
  Write-Host ""
  Write-Host "  KHONG THAY DU AN. Khong co C:\REMOTION." -ForegroundColor Red
  Write-Host "  => Chua cai, hoac da cai vao thu muc khac." -ForegroundColor Red
  Write-Host "     Cai vao thu muc khac thi chay: KIEM-TRA.bat -ThuMuc D:\duong-dan-cua-ban"
  Write-Host ""
  if (-not $KhongHoi) { Read-Host "Bam Enter de dong" }
  exit 1
}
Write-Host "  Du an: $ThuMuc"
Write-Host ""

# ---------- 1. Bo nen ----------
Write-Host "BO 1 - Du an Remotion" -ForegroundColor Cyan
Muc "package.json"              (Test-Path (Join-Path $ThuMuc "package.json"))
Muc "Thu vien da cai (node_modules\remotion)" (Test-Path (Join-Path $ThuMuc "node_modules\remotion\package.json")) $true "mo thu muc du an, chay: npm install"
$verRemotion = "?"
$pr = Join-Path $ThuMuc "node_modules\remotion\package.json"
if (Test-Path $pr) { $verRemotion = (Get-Content $pr -Raw | ConvertFrom-Json).version }
Muc "4 file bam dup (MO-STUDIO / PHIEN-AM / DOC-GIONG / XUAT-VIDEO)" (
  (Test-Path (Join-Path $ThuMuc "MO-STUDIO.bat")) -and
  (Test-Path (Join-Path $ThuMuc "PHIEN-AM.bat")) -and
  (Test-Path (Join-Path $ThuMuc "DOC-GIONG.bat")) -and
  (Test-Path (Join-Path $ThuMuc "XUAT-VIDEO.bat")))
$soAm = 0
$duongAm = Join-Path $ThuMuc "public\audio"
if (Test-Path $duongAm) { $soAm = (Get-ChildItem $duongAm -Recurse -Filter *.wav -ErrorAction SilentlyContinue).Count }
Muc "Thu vien am hieu ung ($soAm file)" ($soAm -ge 100)
Muc "Whisper tach phu de" (Test-Path (Join-Path $ThuMuc "whisper.cpp")) $false "lan dau keo tha video vao PHIEN-AM.bat se tu tai (~1,6 GB)"

# ---------- 2. Keyword ----------
Write-Host ""
Write-Host "BO 2 - 40 keyword phong cach" -ForegroundColor Cyan
Muc "Ma 40 phong cach (src\keyword-mix)" (Test-Path (Join-Path $ThuMuc "src\keyword-mix\phong-cach.tsx"))
Muc "Am keyword hien dai (public\audio\sfx-hien-dai)" (Test-Path (Join-Path $ThuMuc "public\audio\sfx-hien-dai\catalog.json"))
Muc "Goi @remotion/media" (Test-Path (Join-Path $ThuMuc "node_modules\@remotion\media")) $true "mo thu muc du an, chay: npm install @remotion/media@$verRemotion --save-exact"

# ---------- 3. Giong doc ----------
Write-Host ""
Write-Host "BO 3 - Giong doc tu van ban" -ForegroundColor Cyan
Muc "Cong cu doc giong (tts\doc-giong.py)" (Test-Path (Join-Path $ThuMuc "tts\doc-giong.py"))
Muc "Moi truong Python rieng (tts\.venv)"  (Test-Path (Join-Path $ThuMuc "tts\.venv\Scripts\python.exe")) $true "chay lai trinh cai"
$moHinh = Join-Path $env:USERPROFILE ".cache\huggingface\hub"
$coMoHinh = (Test-Path $moHinh) -and ((Get-ChildItem $moHinh -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "VieNeu|neu" }).Count -gt 0)
Muc "Mo hinh giong doc da tai" $coMoHinh $false "lan dau doc giong se tu tai (~600 MB)"

# ---------- 4. Truoc & sau ----------
Write-Host ""
Write-Host "BO 4 - Video truoc & sau" -ForegroundColor Cyan
Muc "Ma video truoc & sau (src\truoc-sau)" (Test-Path (Join-Path $ThuMuc "src\truoc-sau\TruocSauChung.tsx"))
Muc "Thu muc de video (public\truoc-sau)" (Test-Path (Join-Path $ThuMuc "public\truoc-sau"))

# ---------- 5. Dang ky vao Studio ----------
Write-Host ""
Write-Host "DANG KY VAO STUDIO (src\Root.tsx)" -ForegroundColor Cyan
$root = Join-Path $ThuMuc "src\Root.tsx"
$noiRoot = ""
if (Test-Path $root) { $noiRoot = [IO.File]::ReadAllText($root, [Text.Encoding]::UTF8) }
Muc "Muc PhongCach-BoSuuTap" ($noiRoot -match "PhongCach-BoSuuTap") $false "noi voi Claude: 'dang ky bo suu tap keyword vao Root'"
Muc "Muc TruocSau"           ($noiRoot -match 'id="TruocSau"') $false "noi voi Claude: 'dang ky video truoc sau vao Root'"

# ---------- 6. Skill cho Claude Code ----------
Write-Host ""
Write-Host "SKILL CHO CLAUDE CODE" -ForegroundColor Cyan
$goc = Join-Path $env:USERPROFILE ".claude\skills"
foreach ($s in @("remotion-cinematic-editor", "remotion-keyword-phong-cach", "remotion-giong-doc", "remotion-truoc-sau")) {
  Muc $s (Test-Path (Join-Path $goc "$s\SKILL.md"))
}
$soChinhChu = 0
if (Test-Path $goc) { $soChinhChu = (Get-ChildItem $goc -Directory | Where-Object { $_.Name -match "^remotion-" -and $_.Name -notmatch "cinematic-editor|keyword-phong-cach|giong-doc|truoc-sau" }).Count }
Muc "Skill chinh chu Remotion ($soChinhChu cai)" ($soChinhChu -ge 8) $false "mo thu muc du an, chay: npx skills add remotion-dev/skills -g -a claude-code --copy -y"

# ---------- 7. Cong cu ngoai ----------
Write-Host ""
Write-Host "CONG CU TREN MAY" -ForegroundColor Cyan
foreach ($c in @(@("node", "Node.js"), @("npm", "npm"), @("ffmpeg", "FFmpeg"))) {
  Muc $c[1] ([bool](Get-Command $c[0] -ErrorAction SilentlyContinue)) $true "dong cua so nay roi mo lai"
}

# ---------- Ket luan ----------
Write-Host ""
Write-Host ("=" * 70) -ForegroundColor DarkGray
if ($thieu -eq 0) {
  Write-Host "  CAI THANH CONG. Remotion $verRemotion" -ForegroundColor Green
  if ($canhBao -gt 0) { Write-Host "  ($canhBao muc chua tai - khong sao, lan dau dung se tu tai)" -ForegroundColor Yellow }
  Write-Host ""
  Write-Host "  Thu ngay: bam dup $ThuMuc\MO-STUDIO.bat"
  Write-Host "  Cua so trinh duyet mo ra, ben trai co danh sach video mau." -ForegroundColor Gray
} else {
  Write-Host "  CHUA XONG - thieu $thieu muc (danh dau THIEU o tren)." -ForegroundColor Red
  Write-Host ""
  Write-Host "  Cach sua nhanh nhat: doi ten $ThuMuc thanh ${ThuMuc}-cu" -ForegroundColor Yellow
  Write-Host "  roi chay lai CAI-DAT.bat." -ForegroundColor Yellow
}
Write-Host ("=" * 70) -ForegroundColor DarkGray
Write-Host ""
if (-not $KhongHoi) { Read-Host "Bam Enter de dong" }
if ($thieu -gt 0) { exit 1 } else { exit 0 }
