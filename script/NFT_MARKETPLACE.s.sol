// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {NFT} from "../src/NFT_MARKETPLACE.sol";
import "forge-std/console2.sol";


contract DeployNFT is Script {
    function setUp() public {}

    function run() public {
        // Begin broadcasting from the deployer's private key
        vm.startBroadcast();

        NFT nft = new NFT();

        console2.log("NFT contract deployed at:", address(nft));

        vm.stopBroadcast();
    }
}

