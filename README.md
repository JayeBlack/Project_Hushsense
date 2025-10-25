# 🌊 HushSense Platform

> **The World's Largest Decentralized Urban Noise Mapping Platform**

[![Flutter](https://img.shields.io/badge/Flutter-3.24.3-blue.svg)](https://flutter.dev)
[![Hedera](https://img.shields.io/badge/Hedera-Blockchain-blue.svg)](https://hedera.com)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](LICENSE)

HushSense is a revolutionary **DePIN (Decentralized Physical Infrastructure Network)** platform that transforms smartphones into sophisticated urban noise sensors while leveraging blockchain technology for data integrity and user incentivization.

<p align="center">
  <img src="mobile/assets/images/logo.jpeg" alt="HushSense Logo" width="200"/>
</p>

## 🔗 Live Assets on Hedera Mainnet
- HTS Fungible Token (HUSH): [0.0.10048362](https://hashscan.io/mainnet/token/0.0.10048362)  
- Manager Smart Contract: [0.0.10047928](https://hashscan.io/mainnet/contract/0.0.10047928)  
- HTS NFT Collection: [0.0.10050668](https://hashscan.io/mainnet/token/0.0.10050668)

## 🎯 Vision & Mission

### **Vision**
To build the world's largest, most accurate, real-time urban noise map, empowering communities and organizations to create quieter, healthier, and more livable cities.

### **Mission**
Transform urban noise monitoring through community participation, turning every smartphone user into a citizen scientist contributing to a global noise pollution database.

### **Core Innovation**
- **Software DePIN Model**: No proprietary hardware required - leverages existing smartphones
- **Gamified Contribution**: Engaging user experience that rewards data collection
- **Privacy-First Architecture**: Users own and control their data through "Honest Data Approach"
- **Dual-Sided Marketplace**: Connects data contributors with data consumers (businesses, municipalities)

## 📦 Repository Structure

```
project-root/
├── mobile/                 # Flutter-based mobile application
│   ├── lib/               # Core application code
│   ├── assets/           # Application assets
│   └── test/             # Application tests
│
├── hushsense-smart-contract/    # Hedera smart contracts
│   ├── contracts/        # Smart contract source code
│   ├── scripts/          # Deployment and management scripts
│   └── test/            # Contract tests
│
└── hushsense-token-nft/  # Token and NFT management
    ├── hush-token/      # HUSH token creation and management
    └── hush-nft/        # NFT creation and management
```

## 🚀 Components

### 1. Mobile Application (Flutter)
- Cross-platform mobile app built with Flutter 3.24+
- Material Design 3 with custom theming
- Real-time noise measurement and visualization
- Blockchain wallet integration via HashConnect SDK
- Offline-first architecture with Hive database

### 2. Smart Contracts (Solidity)
- HushSense Manager Contract for ecosystem governance
- Token gating and reward distribution logic
- Upgradeable contract architecture
- Full mainnet deployment support

### 3. Token & NFT System
- HUSH Token (HTS) for ecosystem incentives
- NFT collection for achievement badges
- IPFS-based metadata storage
- Automated minting and distribution

## 🛠️ Development Setup

### Prerequisites
- Node.js v18 or later
- Flutter 3.24+
- Hedera account with HBAR
- VS Code or preferred IDE

### Quick Start
1. Clone the repository:
```bash
git clone https://github.com/JayeBlack/Project_Hushsense.git
cd Project_Hushsense
```

2. Set up the mobile app:
```bash
cd mobile
flutter pub get
```

3. Set up smart contracts:
```bash
cd ../hushsense-smart-contract
npm install
```

4. Set up token management:
```bash
cd ../hushsense-token-nft
npm install
```

## 📜 License
This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## 📬 Contact
For questions and support, please open an issue in the repository.