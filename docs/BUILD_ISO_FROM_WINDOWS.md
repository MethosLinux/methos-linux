# 🏗️ بناء ISO من الصفر على Windows

**الشرح الكامل خطوة بخطوة - من git إلى ISO جاهز**

نحن على **Windows** ولا يمكننا بناء ISO مباشرة. الحل: نستخدم **GitHub** لبناء الـ ISO في السحابة مجاناً.

---

## 📝 المتطلبات الأساسية

ما تحتاجه:
- ✅ **حساب GitHub مجاني** ← [github.com/signup](https://github.com/signup)
- ✅ **Git مثبت على Windows** (موجود عندك: `git version 2.54.0`)
- ✅ **اتصال بالإنترنت**

---

## 🎯 الخطة - 4 خطوات فقط

```
PC (Windows)                    GitHub.com (cloud)             النتيجة
      │                               │
      ├─ 1. git push ──────────────►  │
      │                               ├─ 2. GitHub Actions
      │                               │    تشغل المخدم
      │                               │    (Arch Linux)
      │                               │
      │                               ├─ 3. make iso
      │                               │    يبني الـ ISO
      │                               │
      │  ◄────── 4. Download ISO ─────┤
      │                               │
      ▼                               ▼
   VirtualBox ← iso جاهز
```

---

## 🔴 الخطوة 1: أنشئ حساب GitHub (إذا ما عندك)

### بالعربي خطوة بخطوة:

```
1. افتح https://github.com/signup
2. أدخل بريدك الإلكتروني
3. أنشئ كلمة مرور
4. اختر username (مثلاً: methos-linux)
5. تحقق بالبريد الإلكتروني
6. تم ✅
```

---

## 🟢 الخطوة 2: أنشئ مستودعاً (Repository) على GitHub

```
1. سجل دخولك على github.com
2. اضغط الزر الأخضر "New" (أو افتح https://github.com/new)
3. املأ الحقول:
   ┌─────────────────────────────────────┐
   │ Repository name: methos-linux       │
   │ Description: (اختياري)              │
   │ Public أو Private (اختيارك)         │
   │ ☐ Add a README file (لا تختارها)   │
   │ ☐ Add .gitignore (لا تختارها)       │
   │ ☐ Choose a license (لا تختارها)     │
   └─────────────────────────────────────┘
4. اضغط "Create repository"
5. ستظهر صفحة بها أوامر. انسخ الأمر الأول فقط:
   
   git remote add origin https://github.com/your-name/methos-linux.git
   
   (استبدل your-name باسم مستخدمك)
```

---

## 🟡 الخطوة 3: ارفع المشروع إلى GitHub

### على Windows (Command Prompt):

```bash
# 1. تأكد أنك في مجلد المشروع
cd C:\Users\Admin\Documents\MethosLinux

# 2. اربط المستودع المحلي بالمستودع على GitHub
git remote add origin https://github.com/your-name/methos-linux.git

# 3. ارفع الكود إلى GitHub
git push -u origin master
```

**ماذا سيحدث؟**
```
Enumerating objects: ... done
Writing objects: ... done
 → 61 ملفاً، 4189 سطر كود
 → تم الرفع ✅
```

---

## 🔵 الخطوة 4: GitHub Actions يبني الـ ISO تلقائياً

### بعد الرفع مباشرة:

```
1. افتح github.com ← مستودعك methos-linux
2. اضغط على تبويب "Actions" (أعلى الصفحة)
3. ستجد "Build Methos Linux ISO" شغال:
   ⏳ قيد التشغيل (دائرة صفراء تدور)
   
4. انتظر 10-20 دقيقة

5. ستظهر علامة ✅ خضراء (نجاح)
   أو ❌ حمراء (فشل - نادر)

6. اضغط على اسم الـ workflow ("Build Methos Linux ISO")

7. ابحث عن قسم "Artifacts" (أسفل الصفحة)

8. اضغط على "methos-linux-iso" ← يبدأ التحميل

9. الملف: methos-linux-iso.zip

10. فك الضغط:
    - Windows: كلك يمين ← Extract All
    - سترى ملف: methos-linux-0.1.0-alpha-YYYY.MM.DD-x86_64.iso
```

---

## 🟣 الخطوة 5: استخدم الـ ISO في VirtualBox

### تثبيت النظام:

```
1. افتح VirtualBox
2. اضغط "New"
   ┌─────────────────────────────────────┐
   │ Name: Methos Linux                  │
   │ Type: Linux                         │
   │ Version: Arch Linux (64-bit)        │
   │ Memory: 4096 MB                     │
   │ Hard disk: 25 GB                    │
   └─────────────────────────────────────┘
3. اضغط "Create"

4. Settings → System → Processor: 2 CPUs
5. Settings → Display → Video Memory: 128 MB
6. Settings → Display → ☑ Enable 3D Acceleration

7. Settings → Storage:
   → Controller: IDE → Empty CD/DVD
   → اضغط على الأيقونة ○ (القرص)
   → اختر ملف ISO ← "Choose a disk file"
   → اختر: methos-linux-0.1.0-alpha-*.iso

8. Settings → System → Motherboard:
   ☑ Enable EFI (خاص بالأنظمة الحديثة)

9. اضغط "Start"

10. GRUB يظهر ← اختر "Boot Methos Linux (Live System)"
11. انتظر التحميل (30-60 ثانية)
12. سطح المكتب KDE يظهر ✅
13. افتح "Install Methos Linux" ← Calamares
14. اتبع التعليمات ← ثبته
15. Restart ← استمتع بـ Methos Linux 🐧
```

---

## 🆘 لو صارت مشكلة

### ❌ "git remote add origin فشل"
```
الحل: المستودع موجود مسبقاً على GitHub أو الـ URL خطأ.
تأكد من اسم المستخدم: https://github.com/your-name/methos-linux.git
```

### ❌ "git push فشل"
```
الحل:
  1. تأكد أن المستودع على GitHub فارغ (لا يحتوي README.md)
  2. استخدم: git push origin master --force
```

### ❌ GitHub Actions فشل
```
- افتح الـ workflow ← اضغط على job ← شوف الـ log الأحمر
- المرة الأولى قد تفشل بسبب مصادقة GitHub
- الحل: Settings → Actions → General → Allow all actions
```

### ❌ شاشة سوداء في VirtualBox
```
- أعد تشغيل VM
- في GRUB اختر "Boot Methos Linux (nomodeset - Safe Graphics)"
```

### ❌ ما يشتغل UEFI
```
Settings → System → Motherboard → ☐ Enable EFI (أزلها)
جرب مرة أخرى في وضع BIOS Legacy
```

---

## 📝 خلاصة - 3 أوامر في Windows

```bash
cd C:\Users\Admin\Documents\MethosLinux
git remote add origin https://github.com/your-name/methos-linux.git
git push -u origin master
```

ثم افتح GitHub ← Actions ← انتظر ← حمل الـ ISO.

**أي مساعدة تحتاجها في أي خطوة؟**