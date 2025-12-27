<p align="center">
  <img src="https://github.com/user-attachments/assets/8199bca1-d858-41b8-ad39-f622250da041" width="300" />
  <img src="https://github.com/user-attachments/assets/1826422a-0051-4bc8-b22f-67807a88ca64" width="300" />
</p>

# 📸 PhotoCaro - Next Gen AI Image Editor

A professional-grade mobile image editing application built with **Flutter**, featuring advanced color science, high-performance background processing, and **Generative AI** powered by Google Gemini.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/State_Management-Riverpod-purple?style=for-the-badge)
![Gemini](https://img.shields.io/badge/AI-Gemini_Pro_Vision-blue?style=for-the-badge)

## 🚀 Key Features

### 🤖 AI Intelligence (Gemini Powered)
- **Smart Auto-Enhance**: Analyzes image histograms and content to intelligently adjust brightness, contrast, and saturation.
- **Generative Styles**: Apply creative looks via prompt engineering (e.g., "Cyberpunk", "Vintage", "Cinematic") interpreted by the LLM into precise edit parameters.

### 🎨 Professional Editing Tools
- **RGB Histogram**: Real-time color distribution visualization using custom painters.
- **Tone Curves**: Advanced spline-based curve editing for precise tonal control.
- **Non-Destructive Editing**: Full edit history stack with undo/redo/delete capabilities.
- **Selective Tools**: Brush and Healing tools utilizing efficient pixel manipulation.

### ⚡ Performance Engineering
- **Isolate-Based Processing**: All heavy image decoding, filtering, and encoding logic runs on background isolates via `compute`, ensuring the UI thread never drops frames.
- **Custom Rendering**: built-from-scratch widgets for the Curve Editor and Histogram to minimize dependency overhead.

### 📱 Modern UI/UX
- **Glassmorphism**: Premium frosted glass aesthetics.
- **Haptic Feedback**: Tactile responses for slider snaps and tool selection.
- **Lottie Animations**: Fluid loading states and onboarding experiences.

## 🛠️ Tech Stack

- **Framework**: Flutter & Dart 3
- **State Management**: [Flutter Riverpod](https://riverpod.dev/) (2.x)
- **Architecture**: Domain-Driven Design (Clean Architecture)
- **AI/ML**: `google_generative_ai` (Gemini 1.5 Pro)
- **Image Processing**: `image` (Dart native library) running in Isolates.
- **Animations**: `lottie` & `flutter_animate`.
- **Navigation**: `go_router`.

## 📦 Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/mayurchouhan0111/Flutter-SnapSeed.git
    cd Flutter-SnapSeed
    ```

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Configure AI**:
    *   Open `lib/core/ai/ai_service.dart`.
    *   Add your Google Gemini API Key.

4.  **Run the App**:
    ```bash
    flutter run
    ```

## 🤝 Contribution

Contributions are welcome! Please verify that any image processing logic is properly offloaded to isolates before submitting a PR.

## 📄 License

MIT License.
