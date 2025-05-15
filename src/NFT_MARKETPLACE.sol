// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";



contract NFT is ERC721URIStorage {
    address public owner;
    uint256 private _tokenIds;
    uint256 public itemsSold;

    struct ListedToken {
        uint256 tokenId;
        address payable owner;
        address payable seller;
        uint256 price;
        bool currentlyListed;
    }
    
receive() external payable {}

    mapping(uint256 => ListedToken) private idToListedToken;
    uint256 ListPrice = 0.0001 ether;

    constructor() ERC721("NFTMarketplace", "NFT") {
        owner = payable(msg.sender);
    }

    function mint(address to, string memory uri) public returns (uint256) {
        _tokenIds++;
        uint256 newId = _tokenIds;

        _safeMint(to, newId); // Mint the token
        _setTokenURI(newId, uri); // Set the metadata URI

        itemsSold++; // Increment the itemsSold counter

        return newId;
    }

    // Optional: Function to get the number of items sold
    function getItemsSold() public view returns (uint256) {
        return itemsSold;
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function updateListprice(uint256 _ListPrice) public payable OnlyOwner {
        ListPrice = _ListPrice;
    }

    function getListprice() public view returns (uint256) {
        return ListPrice;
    }

    function getLatestidToListedToken() public view returns (ListedToken memory) {
        uint256 CurrentTokenId = _tokenIds;
        return idToListedToken[CurrentTokenId];
    }

    function getListedForToken(uint256 tokenid) public view returns (ListedToken memory) {
        return idToListedToken[tokenid];
    }

    function getCurrentToken() public view returns (uint256) {
        return _tokenIds;
    }

    function createToken(string memory tokenURI, uint256 price) public payable returns (uint256) {
        require(msg.value >= ListPrice, "Insuficient amount for Listing");
        require(price > 0, "Price must be greater than zero");
        _tokenIds += 1;
        uint256 _tokenId = _tokenIds;
        _safeMint(msg.sender, _tokenId);
        _setTokenURI(_tokenId, tokenURI);
        CreateListedToken(_tokenId, price);
        return _tokenId;
    }

    function CreateListedToken(uint256 _tokenId, uint256 price) private {
        idToListedToken[_tokenId] = ListedToken({
            tokenId: _tokenId,
            owner: payable(address(this)),
            seller: payable(msg.sender),
            price: price,
            currentlyListed: true
        });
        _transfer(msg.sender, address(this), _tokenId);
    }

    function getAllNfts() public view returns (ListedToken[] memory) {
        uint256 nftCount = _tokenIds;
        ListedToken[] memory tokens = new ListedToken[](nftCount);
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < nftCount; i++) {
            uint256 currentId = i + 1;
            ListedToken storage currentItem = idToListedToken[currentId];
            tokens[currentIndex] = currentItem;
            currentIndex += 1;
        }
        return tokens;
    }

    function getMyNft() public view returns (ListedToken[] memory) {
        uint256 totalItemCount = _tokenIds;
        uint256 itemCount = 0;
        uint256 currentIndex = 0;
        uint256 currentId;
        //Important to get a count of all the NFTs that belong to the user before we can make an array for them
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToListedToken[i + 1].owner == msg.sender || idToListedToken[i + 1].seller == msg.sender) {
                itemCount += 1;
            }
        }

        //Once you have the count of relevant NFTs, create an array then store all the NFTs in it
        ListedToken[] memory items = new ListedToken[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToListedToken[i + 1].owner == msg.sender || idToListedToken[i + 1].seller == msg.sender) {
                currentId = i + 1;
                ListedToken storage currentItem = idToListedToken[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    function executeSale(uint256 tokenId) public payable {
        uint256 price = idToListedToken[tokenId].price;
        address seller = idToListedToken[tokenId].seller;
        require(msg.value == price, "Please submit the asking price in order to complete the purchase");

        //update the details of the token
        idToListedToken[tokenId].currentlyListed = true;
        idToListedToken[tokenId].seller = payable(msg.sender);
        itemsSold += 1;

        //Actually transfer the token to the new owner
        _transfer(address(this), msg.sender, tokenId);
        //approve the marketplace to sell NFTs on your behalf
        approve(address(this), tokenId);

        //Transfer the listing fee to the marketplace creator
        payable(owner).transfer(ListPrice);
        //Transfer the proceeds from the sale to the seller of the NFT
        payable(seller).transfer(msg.value);
    }
}
