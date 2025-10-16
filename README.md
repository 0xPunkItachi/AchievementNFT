# AchievementNFT
🏅 AchievementNFT — Tradeable Achievement Tokens

Contract Address: 0x79dfb127BdE60E6bDB945bD1eceAEC553b40a99b
Network: (Add your network — e.g. Sepolia / Polygon / BSC Testnet)
Symbol: ACHV
Standard: Minimal ERC-721 (No imports, No constructor)

📖 Overview

AchievementNFT is a minimal, tradeable NFT contract designed to reward user achievements on-chain.
Each NFT represents a specific milestone or recognition and can be freely traded, transferred, or burned.

It uses a simple admin-based minting model — the admin can mint new NFTs to any address.
No libraries, no constructors, and no imports — fully self-contained and lightweight.

⚙️ Contract Features
Feature	Description
🎨 ERC-721 Core	Implements all key functions like balanceOf, ownerOf, approve, transferFrom, etc.
👑 Admin Controlled	Only admin can mint or batch mint new achievements.
🏗️ No Constructor / Imports	Designed to be compatible with environments disallowing external imports.
💸 Tradeable NFTs	Fully transferable via standard ERC-721 calls.
🔥 Burn Function	Token owners or approved users can burn achievements.
🧩 Metadata URI Support	Each NFT stores a custom tokenURI (e.g. IPFS link).
🛡️ Safe Transfers	Implements minimal onERC721Received checks for contract recipients.
🚀 Deployment & Initialization

Step 1: Deploy the contract on Remix (no inputs needed).
Step 2: After deployment, call:

initializeAdmin(<your_wallet_address>)


This sets the admin who can mint achievements.

⚠️ initializeAdmin can only be called once.

🧱 Core Functions
1️⃣ mintAchievement(address to, uint256 tokenId, string uri)

Mint a new achievement NFT to a user.
Only the admin can call this function.

Example:

mintAchievement(0x1234..., 1, "ipfs://achievement1-metadata")

2️⃣ batchMintAchievements(address[] tos, uint256[] tokenIds, string[] uris)

Mint multiple achievements at once to different users.

Example:

batchMintAchievements(
  [0x1111..., 0x2222...],
  [1, 2],
  ["ipfs://achv1", "ipfs://achv2"]
)

3️⃣ transferFrom(address from, address to, uint256 tokenId)

Transfer ownership of a token to another user (standard ERC-721).

Example:

transferFrom(0x1111..., 0x2222..., 1)

4️⃣ burn(uint256 tokenId)

Allows the owner or approved address to destroy (burn) an achievement NFT.

5️⃣ changeAdmin(address newAdmin)

Admin-only function to change the admin address.

🧾 Read Functions
Function	Description
balanceOf(address owner)	Returns number of NFTs owned.
ownerOf(uint256 tokenId)	Returns current owner of token.
tokenURI(uint256 tokenId)	Returns metadata URI.
getApproved(uint256 tokenId)	Shows approved address for a token.
isApprovedForAll(address owner, address operator)	Checks operator approvals.
exists(uint256 tokenId)	Returns if a token exists.
📡 Example Interaction Flow

Initialize Admin

initializeAdmin(0xYourAdminAddress)


Mint New Achievement

mintAchievement(0xUserAddress, 1, "ipfs://achievement-metadata")


Transfer Between Users

transferFrom(0xUserAddress, 0xAnotherUser, 1)


Burn (Optional)

burn(1)

🔍 Verification Info
Field	Value
Contract Address	0x79dfb127BdE60E6bDB945bD1eceAEC553b40a99b
Token Name	Achievements
Symbol	ACHV
Version	v1.0
Verified Source	✅ Solidity 0.8.20
License	MIT
🧠 Notes

Tokens are fully tradeable (not soulbound).

Each achievement can have a unique metadata URI (IPFS, Arweave, HTTPS).

Gas usage is optimized for simplicity and transparency.

No external libraries — works entirely on Solidity core.

🛠 Example Metadata (IPFS JSON)
{
  "name": "Top Performer Badge",
  "description": "Awarded for outstanding performance.",
  "image": "ipfs://QmExampleImage",
  "attributes": [
    { "trait_type": "Level", "value": "Gold" },
    { "trait_type": "Category", "value": "Productivity" }
  ]
}

👨‍💻 Developer

Project: AchievementNFT

Maintainer: Admin wallet set via initializeAdmin

Version: 1.0

Network Address: 0x79dfb127BdE60E6bDB945bD1eceAEC553b40a99b
