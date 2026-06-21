# Roles and Permissions

## Roles
- `Manager`: مدیر / ادمین ارشد
- `Supervisor`: سرپرست
- `Operator`: اپراتور / کاربر مشاهده‌کننده
- `ExternalApp`: نرم‌افزار اصلی مصرف‌کننده API

## Permission Matrix

| Capability | Manager | Supervisor | Operator | ExternalApp |
|---|---:|---:|---:|---:|
| مشاهده اسناد منتشرشده | Yes | Yes | Yes | Yes, via API |
| مشاهده اسناد قدیمی/آرشیوی | Yes | Yes | Yes | Optional/Controlled |
| ثبت آیین‌نامه/بخشنامه/روال | Direct Publish | Needs Approval | No | No |
| ویرایش سند رسمی | Direct Apply | Needs Approval | No | No |
| افزودن نسخه جدید | Direct Publish | Needs Approval | No | No |
| تأیید/رد درخواست | Yes | No | No | No |
| ثبت پیام روزانه | Yes | Yes | No | No |
| مشاهده پیام روزانه | Yes | Yes | Yes | Optional |
| مدیریت معاونت/بخش/موضوع/زیرموضوع | Yes | Yes | No | No |
| جستجو و فیلتر | Yes | Yes | Yes | Yes, via API |
| ثبت مطالعه شد | Yes | Yes | Yes | Yes, via API |
| مشاهده لاگ‌ها / گزارش‌ها | Yes | Limited | No | No |

## Backend Enforcement
- فقط UI کافی نیست؛ Permission باید در Backend enforce شود.
- هر endpoint باید Role Requirement واضح داشته باشد.
- API نرم‌افزار اصلی باید scope جداگانه داشته باشد.
