# AI Development Pack — Knowledge Base Module

این فولدر برای توسعه ماژول **پایگاه دانش** توسط ابزارهایی مثل Codex / AI Developer آماده شده است.

## هدف پروژه
ساخت یک ماژول مستقل تحت وب برای مدیریت، جستجو، انتشار، نسخه‌بندی، تأیید و مشاهده اسناد دانشی سازمان آموزشی.

این ماژول از نرم‌افزار اصلی جدا است و نرم‌افزار اصلی بعداً از طریق API از این ماژول سرویس می‌گیرد.

## دامنه فعلی
فقط ماژول **پایگاه دانش** در دامنه MVP است. موارد مرتبط با تماس، اپراتور تماس، نرم‌افزار تلفنی و ثبت تماس خارج از دامنه این پکیج هستند؛ مگر جایی که API پایگاه دانش به نرم‌افزار اصلی سرویس می‌دهد.

## اولویت خواندن فایل‌ها برای AI
1. `00_start_here/AI_OPERATING_INSTRUCTIONS.md`
2. `00_start_here/PROJECT_ASSUMPTIONS.md`
3. `01_product/PRD_KNOWLEDGE_BASE.md`
4. `02_analysis/BUSINESS_RULES.md`
5. `02_analysis/ROLES_AND_PERMISSIONS.md`
6. `02_analysis/DOMAIN_MODEL.md`
7. `06_api/openapi.yaml`
8. `07_database/database_schema.sql`
9. `08_backlog/BACKLOG_KANBAN.md`
10. `10_codex_prompts/CODEX_MASTER_PROMPT.md`

## اجرای پیشنهادی
- ابتدا مدل دامنه، migrationها و APIهای پایه Backend پیاده‌سازی شود.
- سپس UIهای دسته‌بندی، اسناد، تأیید، جستجو و پیام‌های روزانه توسعه یابد.
- در هر مرحله قوانین Business Rules و Acceptance Criteria ملاک نهایی هستند.

## نکته مهم
هیچ قانون محصولی خارج از فایل‌های این فولدر اختراع نکن. اگر ابهام وجود دارد، آن را در `OPEN_QUESTIONS.md` ثبت کن و با TODO قابل پیکربندی جلو برو.
