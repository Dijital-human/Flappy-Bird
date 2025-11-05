# 🎵 Background Musiqi Əlavə Etmək Üçün Bələdçi

## 📋 Ümumi Məlumat

Flappy Bird oyunu üçün background musiqi əlavə etmək üçün bir neçə yol var. Bu bələdçi sizə ən yaxşı seçimləri göstərir.

---

## 🎯 Variant 1: Pulsuz Musiqi Saytları (Ən Asan)

### 1.1 Freesound.org
**URL:** https://freesound.org/

**Necə istifadə etmək:**
1. Sayta daxil olun
2. "Flappy Bird" və ya "game music" axtarın
3. CC0 və ya CC BY lisenziyalı musiqiləri seçin (kommersiya üçün pulsuz)
4. Download edin
5. `.mp3` formatında saxlayın

**Ən yaxşı axtarış sorğuları:**
- "game background music"
- "flappy bird style"
- "chill game music"
- "arcade music"

---

### 1.2 Incompetech (Kevin MacLeod)
**URL:** https://incompetech.com/music/

**Necə istifadə etmək:**
1. Sayta daxil olun
2. "Royalty Free Music" bölməsinə keçin
3. "Game Music" və ya "Chiptune" kateqoriyalarını seçin
4. Bəyəndiyiniz musiqini seçin və download edin
5. **Vacib:** Kevin MacLeod-a credit verməyi unutmayın (oyunun Credits bölməsində)

**Tövsiyə olunan musiqilər:**
- "Chiptune" - retro oyun üçün
- "Light" - yüngül, xoşagələn
- "Happy" - əyləncəli

---

### 1.3 Pixabay Music
**URL:** https://pixabay.com/music/

**Necə istifadə etmək:**
1. Sayta daxil olun
2. "Game Music" və ya "Arcade" axtarın
3. Pulsuz download edin (hesab yaratmaq lazımdır)
4. Kommersiya üçün tam pulsuz, credit lazım deyil

**Üstünlükləri:**
- ✅ Kommersiya üçün pulsuz
- ✅ Credit lazım deyil
- ✅ Yüksək keyfiyyət

---

### 1.4 OpenGameArt.org
**URL:** https://opengameart.org/

**Necə istifadə etmək:**
1. Sayta daxil olun
2. "Music" kateqoriyasına keçin
3. "CC0" və ya "CC BY" lisenziyalı musiqiləri seçin
4. Download edin

---

## 🎯 Variant 2: AI ilə Musiqi Generasiyası

### 2.1 Suno AI
**URL:** https://suno.ai/

**Necə istifadə etmək:**
1. Sayta daxil olun və hesab yaradın
2. "Create" düyməsinə basın
3. Prompt yazın: "Flappy Bird style game background music, cheerful, loopable"
4. Musiqini generasiya edin
5. Download edin

**Tövsiyə olunan prompt-lar:**
- "Flappy Bird style game background music, cheerful, 8-bit, loopable"
- "Arcade game background music, retro style, happy"
- "Game background music, chiptune style, continuous loop"

---

### 2.2 Udio AI
**URL:** https://udio.com/

**Necə istifadə etmək:**
1. Sayta daxil olun
2. Hesab yaradın
3. Musiqi generasiya edin
4. Download edin

---

## 🎯 Variant 3: Sadə Musiqi Yaradıcıları

### 3.1 BeepBox
**URL:** https://www.beepbox.co/

**Necə istifadə etmək:**
1. Sayta daxil olun
2. Sadə interface ilə musiqini yaradın
3. "File" → "Download Song" seçin
4. `.wav` formatında download edin
5. `.mp3`-ə konvert edin

**Üstünlükləri:**
- ✅ Pulsuz
- ✅ 8-bit retro style
- ✅ Loop asanlıqla edilir

---

### 3.2 Audacity (Musiqi Redaktəsi)
**URL:** https://www.audacityteam.org/

**Necə istifadə etmək:**
1. Audacity-ni download edin
2. Musiqini redaktə edin
3. Loop etmək üçün: `Effect` → `Repeat`
4. Export edin: `File` → `Export` → `Export as MP3`

---

## 🎯 Variant 4: Sadə Test Musiqisi (Kod İlə)

Əgər test üçün sadə musiqi lazımdırsa, aşağıdakı kodu istifadə edə bilərsiniz. Bu sadə bir beep səsi yaradır (real musiqi deyil, test üçün).

---

## 📁 Xcode-da Musiqi Faylını Əlavə Etmək

### Addım 1: Assets-də Fayl Əlavə Etmək

1. Xcode-da proyektinizi açın
2. Sol panel-də `Flappy Bird` folder-ına sağ klik edin
3. `New File...` seçin
4. `Resource` → `Empty` seçin
5. Fayl adını `background_music.mp3` yazın
6. `Create` basın

**Və ya:**

1. Finder-də musiqi faylını tapın
2. Xcode-da `Flappy Bird` folder-ına sürükləyin (drag & drop)
3. Dialog-da "Copy items if needed" seçin
4. "Add to targets: Flappy Bird" seçin
5. `Finish` basın

---

### Addım 2: Bundle-də Yoxlamaq

Musiqi faylının Bundle-də olduğunu yoxlamaq üçün:

```swift
// Test kodu
if let musicURL = Bundle.main.url(forResource: "background_music", withExtension: "mp3") {
    print("✅ Musiqi faylı tapıldı: \(musicURL)")
} else {
    print("❌ Musiqi faylı tapılmadı!")
}
```

---

### Addım 3: AudioManager Kodu Aktivləşdirmək

`AudioManager.swift` faylında comment olunmuş kodu aktivləşdirin:

```swift
func playBackgroundMusic() {
    guard isMusicEnabled else { return }
    
    if backgroundMusicPlayer?.isPlaying == true {
        return
    }
    
    // Bu kodu aktivləşdirin:
    if let musicURL = Bundle.main.url(forResource: "background_music", withExtension: "mp3") {
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
            backgroundMusicPlayer?.numberOfLoops = -1  // Sonsuz loop
            backgroundMusicPlayer?.volume = 0.5  // Volume 50%
            backgroundMusicPlayer?.play()
        } catch {
            print("Background musiqi yüklənə bilmədi: \(error.localizedDescription)")
        }
    }
}
```

---

## 🎵 Tövsiyə Olunan Musiqi Xüsusiyyətləri

### Oyun üçün ideal musiqi:
- ✅ **Loop olmalıdır** - Musiqi bitdikdə yenidən başlamalıdır
- ✅ **Sakit** - Oyunçunun diqqətini dağıtmamalıdır (volume 30-50%)
- ✅ **Xoşagələn** - Uzun müddət dinləmək üçün xoşagələn olmalıdır
- ✅ **Qısa** - 30-60 saniyə arası ideal (loop üçün)
- ✅ **Format** - MP3 və ya WAV (iOS dəstəkləyir)

---

## 🔧 Format Konvertasiyası

Əgər musiqi faylı `.wav` və ya başqa formatdadırsa, `.mp3`-ə konvert edin:

### Online Konverter:
- **CloudConvert:** https://cloudconvert.com/
- **Zamzar:** https://www.zamzar.com/

### Desktop Proqram:
- **VLC Media Player:** Musiqini açın → `Media` → `Convert/Save` → MP3 formatını seçin

---

## 📝 Lisenziya Qeydləri

### CC0 (Public Domain):
- ✅ Kommersiya üçün pulsuz
- ✅ Credit lazım deyil
- ✅ İstədiyiniz kimi istifadə edə bilərsiniz

### CC BY (Creative Commons Attribution):
- ✅ Kommersiya üçün pulsuz
- ⚠️ Credit verməlisiniz (oyunun Credits bölməsində)

### Royalty-Free (Pixabay):
- ✅ Kommersiya üçün pulsuz
- ✅ Credit lazım deyil

---

## 🚀 Sürətli Test Üçün

Əgər dərhal test etmək istəyirsiniz:

1. **Pixabay Music**-dən bir musiqi download edin (ən asan)
2. Faylı Xcode-da `Flappy Bird` folder-ına əlavə edin
3. `AudioManager.swift`-də kodu aktivləşdirin
4. Test edin!

---

## ❓ Problem Gidərən

### Musiqi çalınmır:
- ✅ Fayl adını yoxlayın: `background_music.mp3` (dəqiq)
- ✅ Fayl Bundle-dədir? (Xcode-da folder-ın yanında görünür)
- ✅ Target-a əlavə olunub? (File inspector-da yoxlayın)
- ✅ Extension düzgündür? (`.mp3`)

### Musiqi çox səslidir/yavaşdır:
- ✅ Volume tənzimləyin: `backgroundMusicPlayer?.volume = 0.3` (30%)

### Loop işləmir:
- ✅ `numberOfLoops = -1` təyin edin (sonsuz loop)

---

## 🎮 Tövsiyə Olunan Musiqi Stil

Flappy Bird üçün:
- Chiptune (8-bit retro)
- Happy/Cheerful (xoşagələn)
- Loopable (sonsuz loop)
- 30-60 saniyə uzunluğunda

**Ən yaxşı seçim:** Pixabay Music-dən "game music" və ya "arcade music" axtarın!

---

**Uğurlar! 🎉**

