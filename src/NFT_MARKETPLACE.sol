// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NFT is ERC721URIStorage {
    address public owner;
    uint256 private _tokenIds;
    uint256 public itemsSold;

    struct ListedToken{
        uint256 tokenId;
        address payable owner;
        address payable seller;
        uint256 price;
        bool currentlyListed;
    }
    mapping(uint256 => ListedToken) private idToListedToken;
    uint256 ListPrice= 0.0001 ether;

    constructor() ERC721("NFTMarketplace", "NFT") {
        owner = payable(msg.sender);
    }

   function mint(address to, string memory uri) public returns (uint256) {
        _tokenIds++;
        uint256 newId = _tokenIds;
        
        _safeMint(to, newId);         // Mint the token
        _setTokenURI(newId, uri);     // Set the metadata URI

        itemsSold++;  // Increment the itemsSold counter

        return newId;
    }

    // Optional: Function to get the number of items sold
    function getItemsSold() public view returns (uint256) {
        return itemsSold;
    }
    modifier OnlyOwner(){
        require(msg.sender == owner,"You are not the owner");
        _;
    }

    function updateListprice(uint256 _ListPrice) public payable OnlyOwner{
       ListPrice=_ListPrice;
    }
    function getListprice()public view returns(uint256){
        return ListPrice;
    }
    function getLatestidToListedToken() public view returns(ListedToken memory){
       uint256 CurrentTokenId =_tokenIds;
        return idToListedToken[CurrentTokenId];

    }
    function getListedForToken(uint256 tokenid) public view returns(ListedToken memory){
        return idToListedToken[tokenid];
    }
    function getCurrentToken() public view returns(uint256){
        return _tokenIds;
    }
    function createToken(string memory tokenURI, uint256 price) public payable returns(uint256){
        require(msg.value >= ListPrice,"Insuficient amount for Listing");
        require(price > 0,"Price must be greater than zero");
        _tokenIds +=1;
         uint256 CurrentTokenId =_tokenIds;
         _safeMint(msg.sender,CurrentTokenId);
         _setTokenURI(CurrentTokenId,tokenURI);
         CreateListedToken(uint256 CurrentTokenId, price);
         return CurrentTokenId;
    }
    function CreateListedToken(uint256 tokenId, uint256 price) private {
        
    }
}
