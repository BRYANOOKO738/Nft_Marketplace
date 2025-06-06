

# 🖼️ NFT Marketplace Smart Contract

This is a simple yet functional **NFT Marketplace** smart contract built using Solidity and OpenZeppelin's ERC-721 implementation. It allows users to mint NFTs, list them for sale, view listings, and execute purchases — all within a decentralized environment.

---

## 🔧 Features

* ✅ ERC-721 NFT Minting with Metadata
* 💰 Listing NFTs for sale with a fixed listing fee
* 🛒 Purchase NFTs directly using `executeSale`
* 🗂️ View all listed NFTs or NFTs owned by a specific user
* 🔐 Only the contract owner can update listing fees
* 📥 Accepts ETH directly via `receive()` fallback

---

## 🧱 Built With Foundry

### 📦 Requirements

* [Foundry](https://book.getfoundry.sh/getting-started/installation) (install via `curl -L https://foundry.paradigm.xyz | bash`)
* [Node.js](https://nodejs.org/) (optional, for frontend integration)
* Git

### 🛠 Setup & Installation

```bash
# Clone the project
git clone https://github.com/BRYANOOKO738/Nft_Marketplace.git
cd Nft_Marketplace

# Install dependencies
forge install

# Build the contracts
forge build

# Run tests
forge test -vv
```

### 🧪 Writing and Running Tests

Add your tests in `test/NFT.t.sol`. Example:

```solidity
function testCanMint() public {
    NFT nft = new NFT();
    uint256 tokenId = nft.mint(address(this), "ipfs://sample");
    assertEq(nft.ownerOf(tokenId), address(this));
}
```

Then run:

```bash
forge test
```

---

## 🧩 Core Contract Summary

### Contract: `NFT`

Inherits from:

* `ERC721`
* `ERC721URIStorage`

... *(rest of the summary continues as before)*

---

## 📦 Directory Structure (Suggested)

```
Nft_Marketplace/
├── src/
│   └── NFT_MARKETPLACE.sol          # main contract
├── test/
│   └── NFT_MARKETPLACE.t.sol        # test file
├── foundry.toml         # Foundry config
└── README.md
```

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).


