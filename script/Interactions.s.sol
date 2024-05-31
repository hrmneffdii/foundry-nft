// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {BasicNft} from "../src/BasicNft.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintBasicNft is Script{
    
    string public constant PUG_URI = "https://ipfs.io/ipfs/QmbhqHABY5vtTTDEsyNGgZf6gxbjRBi2S3Vki3a7hgcFKZ?filename=BasicNft.json";    
    function run() external {   
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);
        console.log("mostRecentlyDeployed", mostRecentlyDeployed);
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address nftContract) public {
        vm.startBroadcast();
        BasicNft(nftContract).mintNft(PUG_URI);
        vm.stopBroadcast();
    }
}

contract MintMoodNft is Script{
    
    function run() external {   
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);
        console.log("mostRecentlyDeployed", mostRecentlyDeployed);
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address nftContract) public {
        vm.startBroadcast();
        MoodNft(nftContract).mintNft();
        vm.stopBroadcast();
    }
}

contract FlipMoodNft is Script{
    function run() external {   
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);
        console.log("mostRecentlyDeployed", mostRecentlyDeployed);
        flipNftOnContract(mostRecentlyDeployed);
    }

    function flipNftOnContract(address nftContract) public {
        vm.startBroadcast();
        MoodNft(nftContract).flipMood(0);
        vm.stopBroadcast();
    }
}