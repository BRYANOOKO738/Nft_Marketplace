// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {NFT} from "../src/NFT_MARKETPLACE.sol";

contract NFTTest is Test {
    NFT public nft;
    address public user1 = address(1);
    address public user2 = address(2);

    function setUp() public {
        nft = new NFT();
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }

    function testMint() public {
        vm.prank(user1);
        uint256 tokenId = nft.mint(user1, "ipfs://example");

        assertEq(nft.ownerOf(tokenId), user1);
        assertEq(nft.getItemsSold(), 1);
    }

    function testCreateTokenAndList() public {
        vm.prank(user1);
        uint256 price = 1 ether;
        uint256 listPrice = nft.getListprice();
        uint256 tokenId;

        vm.prank(user1);
        vm.deal(user1, 10 ether);
        tokenId = nft.createToken{value: listPrice}("ipfs://uri", price);

        NFT.ListedToken memory listed = nft.getListedForToken(tokenId);
        assertEq(listed.price, price);
        assertTrue(listed.currentlyListed);
        assertEq(listed.tokenId, tokenId);
        
    }

    function testFailExecuteSale() public {
        uint256 price = 1 ether;
        uint256 listPrice = nft.getListprice();

        // user1 creates a token
        vm.startPrank(user1);
        uint256 tokenId = nft.createToken{value: listPrice}("ipfs://uri", price);
        vm.stopPrank();
    
        vm.startPrank(user2);
        nft.executeSale{value: price}(tokenId);
        vm.stopPrank();

        assertEq(nft.ownerOf(tokenId), user2);
        assertEq(nft.getItemsSold(), 2); // 1 from mint, 1 from sale
    }
   

receive() external payable {
    
}

}

